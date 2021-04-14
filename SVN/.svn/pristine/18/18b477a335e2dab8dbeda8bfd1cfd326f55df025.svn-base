#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} ALRPCP04

Programa responsável pela impressão da carta de mistura 2, com base no programa ALRPCP02.
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/11/2014
@version Protheus 11 - PCP

/*/
User Function ALRPCP04()

Local oReport
Local cPerg := "ALRPCP04"

Private oFont13 := TFont():New("Arial",, 13,, .F.,,,, .F., .F.)

AjustaSX1(cPerg)	
	
Pergunte(cPerg, .F.)
	
oReport:= ReportDef(cPerg)
oReport:PrintDialog()
	
Return

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function ReportDef(cPerg)

Local oReport
Local oOrdem
Local cTitulo 	:= "Carta de Mistura 2"
Local cAjuda  	:= "Permite imprimir a Carta de Mistura 2 da Alcar."

oReport := TReport():New("ALRPCP04", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cAjuda)

//Define o formato retrato 
oReport:SetPortrait(.T.)

//Oculta página de parâmetros
oReport:HideParamPage()

//Oculta o cabeçalho do relatório
oReport:HideHeader()

//Oculta o rodapé do relatório
oReport:HideFooter()

//Define o tamanho do papel - 9 (A4)
oReport:oPage:SetPaperSize(9)

//Seção somente para permitir a seleção da ordem de impressão
oOrdem := TRSection():New(oReport, "Ordem", {}, {"Ordem de Produção", "Emissão"})   

Return oReport

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function ReportPrint(oReport)

Local cOpDe		:= MV_PAR01
Local cOpAte		:= MV_PAR02
Local cEmissaoDe	:= DTOS(MV_PAR03)
Local cEmissaoAte	:= DTOS(MV_PAR04)
Local cGrupo		:= MV_PAR05
Local nKG			:= MV_PAR06
Local nQtdInf		:= MV_PAR07
Local cQuery 		:= ""
Local cOp			:= ""
Local cQtdMist	:= ""
Local nLin			:= 0
Local nFator		:= 0
Local aOpPai 		:= {}
Local aInstMist	:= {}

cQuery := "SELECT "
cQuery += "	C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, SB1A.B1_DESC AS DESCMIST, SB1A.B1_ZZCODRM AS CODIGO_RM, "
cQuery += "	C2_EMISSAO, C2_QUANT, SB1A.B1_ZZPENEI, SB1A.B1_ZZOBS, SB1A.B1_ZZCAPAC, D4_COD, "
cQuery += "	SB1B.B1_DESC AS DESCMP, D4_QTDEORI, C2_ZZIMP, ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), SB1A.B1_ZZINSTM)), '') AS B1_ZZINSTM "
cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "
cQuery += "	INNER JOIN "+ RetSqlName("SB1") +" SB1A "
cQuery += "		ON 	SB1A.D_E_L_E_T_ = ' ' "
cQuery += "			AND SB1A.B1_FILIAL = '"+ FWFilial("SB1") +"' "
cQuery += "			AND SB1A.B1_COD = C2_PRODUTO "
cQuery += "	INNER JOIN "+ RetSqlName("SD4") +" SD4 "
cQuery += "		ON 	SD4.D_E_L_E_T_ = ' ' "
cQuery += "			AND D4_FILIAL = C2_FILIAL "
cQuery += "			AND D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "	INNER JOIN "+ RetSqlName("SB1") +" SB1B "
cQuery += "		ON 	SB1B.D_E_L_E_T_ = ' ' "
cQuery += "			AND SB1B.B1_FILIAL = '"+ FWFilial("SB1") +"' "
cQuery += "			AND SB1B.B1_COD = D4_COD "
cQuery += "WHERE "
cQuery += "	SC2.D_E_L_E_T_ = ' ' "
cQuery += "	AND C2_FILIAL = '"+ FWFilial("SC2") +"' "
cQuery += "	AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+ cOpDe +"' AND '"+ cOpAte +"' "
cQuery += "	AND C2_EMISSAO BETWEEN '"+ cEmissaoDe +"' AND '"+ cEmissaoAte +"' "
cQuery += "	AND SB1A.B1_ZZMIST = 'S' "

If !Empty(cGrupo)
	cQuery += "	AND SB1A.B1_GRUPO = '"+ cGrupo +"' "
EndIf

cQuery += "ORDER BY "
cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN "

If Select("ALRPCP04") <> 0
	ALRPCP04->(dbCloseArea())
Endif

TcQuery cQuery Alias "ALRPCP04" New

oReport:SetMeter(ALRPCP04->(LastRec()))

ALRPCP04->(dbGoTop())

While !ALRPCP04->(Eof())
	
	If !Empty(ALRPCP04->C2_ZZIMP)
	
		If !MsgYesNo("OP "+ ALRPCP04->C2_NUM+ALRPCP04->C2_ITEM+ALRPCP04->C2_SEQUEN +" já impressa. Deseja imprimí-la novamente ?")
			ALRPCP04->(DbSkip())
			Loop
		EndIf 
	
	Endif
	
	cOp			:= ALRPCP04->C2_NUM+ALRPCP04->C2_ITEM+ALRPCP04->C2_SEQUEN
	aOpPai 	:= PesqOpPai(cOp, ALRPCP04->C2_PRODUTO)
	aInstMist	:= ConvInst(AllTrim(ALRPCP04->B1_ZZINSTM), 145) //145
	cQtdMist 	:= CalcMist(ALRPCP04->C2_QUANT, ALRPCP04->B1_ZZCAPAC, nKg, nQtdInf, @nFator)
	
	ImpCabec(oReport, @nLin, cQtdMist)
	
	ImpItem(oReport, @nLin, cOp, nKg, nFator, cQtdMist)
	
	ImpRodape(oReport, @nLin, aOpPai, aInstMist)
		
	If !ALRPCP04->(Eof())
	
		nLin := 0
	
		oReport:EndPage()
		oReport:StartPage()
		
	Endif
	
Enddo

ALRPCP04->(DbCloseArea())

Return

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function PesqOpPai(cOp, cProduto)

Local aOP 		:= {}
Local aOpAglut:= {}
Local cQuery 	:= ""

cQuery := "WITH OPPAI AS " 
cQuery += "( "
cQuery += "	SELECT "
cQuery += "		Z01_FILIAL, Z01_PRODUT, Z01_OPPAI, Z01_OPORIG, Z01_OPAGLU " 
cQuery += "	FROM "+ RetSqlName("Z01") +" "
cQuery += "	WHERE "
cQuery += "	 	D_E_L_E_T_ = '' " 
cQuery += "		AND Z01_FILIAL = '"+ FwFilial("Z01") +"' "
cQuery += "		AND Z01_OPAGLU = '"+ cOp +"' " 
cQuery += "		AND Z01_PRODUT = '"+ cProduto +"' "
cQuery += "	UNION ALL "
cQuery += "	SELECT "
cQuery += "		Z.Z01_FILIAL, Z.Z01_PRODUT, Z.Z01_OPPAI, Z.Z01_OPORIG, Z.Z01_OPAGLU " 
cQuery += "	FROM "+ RetSqlName("Z01") +" Z, OPPAI M " 
cQuery += "	WHERE "
cQuery += "	 	D_E_L_E_T_ = '' "
cQuery += "		AND M.Z01_OPPAI = Z.Z01_OPAGLU " 
cQuery += "		AND M.Z01_FILIAL = Z.Z01_FILIAL "
cQuery += ") "
cQuery += "SELECT Z01_OPPAI, Z01_OPAGLU FROM OPPAI " 

If Select("QRYOPPAI") <> 0
	QRYOPPAI->(dbCloseArea())
Endif

TcQuery cQuery Alias "QRYOPPAI" New

QRYOPPAI->(dbGoTop())

If !QRYOPPAI->(Eof())

	While !QRYOPPAI->(Eof())
	
		aADD(aOpAglut, QRYOPPAI->Z01_OPAGLU) 
		
		QRYOPPAI->(DbSkip())
		
	Enddo
	
	QRYOPPAI->(dbGoTop())
	
	While !QRYOPPAI->(Eof())
	
		If aScan(aOpAglut, {|x| x == QRYOPPAI->Z01_OPPAI}) == 0
			aADD(aOp, QRYOPPAI->Z01_OPPAI)
		Endif
		
		QRYOPPAI->(DbSkip())
		
	Enddo
	
Else

	cQuery := "SELECT "
	cQuery += "	C2_NUM, C2_ITEM, C2_SEQUEN "
	cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "
	cQuery += "	INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery += "		ON 	SB1.D_E_L_E_T_ = ' ' "
	cQuery += "			AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
	cQuery += "			AND B1_COD = C2_PRODUTO "
	cQuery += "WHERE "
	cQuery += "	SC2.D_E_L_E_T_ = '' "
	cQuery += "	AND C2_FILIAL = '"+ xFilial("SC2") +"' "
	cQuery += "	AND C2_NUM+C2_ITEM = '"+ SubStr(cOp, 1, 8) +"' "
	cQuery += "	AND B1_TIPO = 'PA' "
	cQuery += "	AND B1_ZZMIST <> 'S'"

	If Select("QRYOPPAI2") <> 0
		QRYOPPAI2->(dbCloseArea())
	Endif
	
	TcQuery cQuery Alias "QRYOPPAI2" New
	
	QRYOPPAI2->(dbGoTop())
	
	If !QRYOPPAI2->(Eof())
		aADD(aOp, QRYOPPAI2->C2_NUM+QRYOPPAI2->C2_ITEM+QRYOPPAI2->C2_SEQUEN)
	Endif
	
	QRYOPPAI2->(DbCloseArea())
		
Endif

QRYOPPAI->(DbCloseArea())

Return aOp

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function CalcMist(nQuant, nCapac, nKgInf, nQtdInf, nFator)

Local cQuant := "" 

If nKgInf > 0 .And. nQtdInf > 0

	nFator := Round(nKgInf / nQuant, 6)
	cQuant := AllTrim(Transform(nKgInf, "@E 999,999.999999")) +" X "+ AllTrim(cValToChar(nQtdInf)) 
	
Else

	nFator := IIF(nCapac == 0, 0, IIF(nQuant % nCapac == 0, nQuant / nCapac, INT(nQuant / nCapac)+1))
	cQuant := IIF(nFator == 0, "0 X 0", AllTrim(Transform(Round(nQuant / nFator, 6), "@E 999,999.999999")) +" X "+ AllTrim(cValToChar(nFator)))
		
Endif

Return cQuant

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function ConvDesc(cDescricao)

Local aDescricao := {}

If Len(cDescricao) > 0

	While .T.
	
		If Len(cDescricao) > 40 
		
			Aadd(aDescricao, SubStr(cDescricao, 1, 40))
			cDescricao := SubStr(cDescricao, 41, Len(cDescricao))
			
		Else
		
			Aadd(aDescricao, cDescricao)
			Exit
			
		Endif
		
	Enddo
	
Endif

Return aDescricao


Static Function ImpCabec(oReport, nLin, cQtdMist)

Local lImpCab := IIF(nLin == 0, .T., .F.)	 

If nLin == 0 		
	nLin := 50		
EndIf

oReport:Box(nLin, 20, nLin+310, 2350)

nLin += 30
	
oReport:Say(nLin, 0050, "CARTA DE MISTURA", 														oFont13)
oReport:Say(nLin, 0900, "EMISSÃO: "+ DTOC(STOD(ALRPCP04->C2_EMISSAO)), 						oFont13)
oReport:Say(nLin, 1900, "ORDEM: "+ ALRPCP04->C2_NUM+ALRPCP04->C2_ITEM+ALRPCP04->C2_SEQUEN, oFont13)
	
nLin += 70
	
oReport:Say(nLin, 0050, "PENEIRA: "+ ALRPCP04->B1_ZZPENEI, oFont13)
		
//Quantidade da Mistura
oReport:Say(nLin+40, 1900, cQtdMist,	oFont13)
	
nLin += 70
	
oReport:Say(nLin, 0050, "OBS: "+ ALRPCP04->B1_ZZOBS, oFont13)
	
nLin += 70
	
oReport:Say(nLin, 0050, "CÓD. ESTRUTURA: "+ AllTrim(ALRPCP04->C2_PRODUTO) +" "+ ;
	IIF(!Empty(ALRPCP04->CODIGO_RM), "| Cód. RM: "+ ALRPCP04->CODIGO_RM, "") + Space(5) +"DESCRIÇÃO: "+ AllTrim(ALRPCP04->DESCMIST), oFont13)
	
Return Nil


Static Function ImpItem(oReport, nLin, cOp, nKg, nFator, cQtdMist)

Local aDescricao	:= {}
Local nItem 		:= 1
Local nLin2		:= 0

nLin += 100	

oReport:Say(nLin, 0050, "SQ", 			oFont13)
oReport:Say(nLin, 0150, "CÓDIGO", 		oFont13)
oReport:Say(nLin, 0500, "INSUMOS", 	oFont13)
oReport:Say(nLin, 1450, "QTD EM KG", 	oFont13)
oReport:Say(nLin, 1750, "LOTE", 		oFont13)
oReport:Say(nLin, 2000, "FORNECEDOR", 	oFont13)

nLin += 50

While !ALRPCP04->(Eof()) .And. ALRPCP04->C2_NUM+ALRPCP04->C2_ITEM+ALRPCP04->C2_SEQUEN == cOp

	oReport:Box(nLin, 0020, nLin+50, 2350)
	oReport:Line(nLin, 1700, nLin+50, 1700)
	oReport:Line(nLin, 1900, nLin+50, 1900)
	
	oReport:Say(nLin, 060, AllTrim(Str(nItem)), oFont13)
		
	oReport:Say(nLin, 0150, ALRPCP04->D4_COD, oFont13)

	nLin2		:= 0
	aDescricao	:= ConvDesc(AllTrim(ALRPCP04->DESCMP))
				
	For nI := 1 To Len(aDescricao)
		
		oReport:Say(nLin+nLin2, 0500, aDescricao[nI], oFont13)
		nLin2 += 50
			
	Next nI
		
	If nKg > 0
		oReport:Say(nLin, 1450, Transform(Round(ALRPCP04->D4_QTDEORI * nFator, 3), "@E 999,999.999"), oFont13)
	Else
		oReport:Say(nLin, 1450, Transform(Round(ALRPCP04->D4_QTDEORI / nFator, 3), "@E 999,999.999"), oFont13)
	Endif
	
	nLin += nLin2	

	nItem++

	//Atualiza campo C2_ZZIMP com S (Indica que a OP já foi impressa)
	GravaImp(ALRPCP04->C2_NUM+ALRPCP04->C2_ITEM+ALRPCP04->C2_SEQUEN)
		
	ALRPCP04->(DbSkip())

Enddo

Return Nil

Static Function ImpRodape(oReport, nLin, aOpPai, aInstMist)

Local nCol := 0
Local nI	
nLin += 50

If Len(aOpPai) > 0
	
	oReport:Say(nLin, 0030, "OBSERVAÇÕES:", oFont13)
		
	nLin += 50

	oReport:Box(nLin, 0020, nLin+50, 2350)

	nCol := 50

	For nI := 1 To Len(aOpPai)
		
		If nCol > 2150
			
			nLin += 50
			
			oReport:Box(nLin, 0020, nLin+50, 2350)
							
			nCol := 50 
				
		Endif
			
		oReport:Say(nlin, nCol, aOpPai[nI], oFont13)
			
		If nCol < 2000 .And. Len(aOpPai) > 1
			oReport:Line(nLin, nCol+230, nLin+50, nCol+230)
		Endif
			
		nCol += 250
			
	Next nI
		
Endif
	
nLin += 100

oReport:Say(nLin, 0020, "MISTURADOR: _____________________", 		oFont13)
oReport:Say(nLin, 0800, "LOTE NÚMERO: ____________________",	 	oFont13)
oReport:Say(nLin, 1600, "DATA DA MISTURA: ____ / ____ / ________",	oFont13)

nLin += 100

oReport:Say(nLin, 0020, "INSTRUÇOES:",	oFont13)

nLin += 60

oReport:Box(nLin, 20, nLin+(50 * Len(aInstMist) + 30), 2350)

nLin += 10
	
For nI := 1 To Len(aInstMist)
	
	oReport:Say(nLin, 0050, aInstMist[nI], oFont13)
	
	nLin += 50
	
Next nI

Return

/**
 * Rotina		:	GravaImp
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	04/10/2013
 * Descrição	:	Grava que a OP já foi impressa
**/
Static Function GravaImp(cOp)

Local cQueryUpd := ""

cQueryUpd := "UPDATE "+ RetSqlName("SC2") +" "
cQueryUpd += "SET C2_ZZIMP = 'S' "
cQueryUpd += "WHERE "
cQueryUpd += "	D_E_L_E_T_ = '' "
cQueryUpd += "	AND C2_FILIAL = '"+ FWFilial("SC2") +"' "
cQueryUpd += "	AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+ cOp +"' "

If TcSqlExec(cQueryUpd) <> 0
	UserException(TCSQLError())
Endif

Return

/**
 * Rotina		:	ConvInst
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	04/10/2013
 * Descrição	:	Converte a observação em um array no tamanho definido no parâmetro nTam
**/
Static Function ConvInst(cObs, nTam)

Local aObs := {}

While Len(cObs) > 0
	aADD(aObs, SubStr(cObs, 1, nTam))
	cObs := SubStr(cObs, nTam+1, Len(cObs))
Enddo

Return aObs

/**
 * Rotina		:	ALRPCP04
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	11/10/2013
 * Descrição	:	Carta de Mistura
**/
Static Function AjustaSX1(cPerg)

/*PutSX1(cPerg, "01", "OP de:",		"OP de:",			"OP de:",			"MV_PAR01", "C", 11, 0, 0, "G",, "SC2",,, "MV_PAR01",,,,,,,,,,,,,,,,, {"Informe a OP inicial"},				{"Informe a OP inicial"}, 				{"Informe a OP inicial"})
PutSX1(cPerg, "02", "OP até:",		"OP até:",			"OP até:",			"MV_PAR02", "C", 11, 0, 0, "G",, "SC2",,, "MV_PAR02",,,,,,,,,,,,,,,,, {"Informe a OP final"}, 					{"Informe a OP final"}, 					{"Informe a OP final"})
PutSX1(cPerg, "03", "Emissão de:", "Emissão de:", 	"Emissão de:", 	"MV_PAR03", "D", 08, 0, 0, "G",,,,, 		"MV_PAR03",,,,,,,,,,,,,,,,, {"Informe a emissão inicial"}, 			{"Informe a emissão inicial"}, 			{"Informe a emissão inicial"})
PutSX1(cPerg, "04", "Emissão até:","Emissão até:",	"Emissão até:",	"MV_PAR04", "D", 08, 0, 0, "G",,,,, 		"MV_PAR04",,,,,,,,,,,,,,,,, {"Informe a emissão final"}, 			{"Informe a emissão final"}, 			{"Informe a emissão final"})
PutSX1(cPerg, "05", "Grupo:",		"Grupo:",			"Grupo:",			"MV_PAR05", "C", 04, 0, 0, "G",, "SBM",,,	"MV_PAR05",,,,,,,,,,,,,,,,, {"Informe o grupo do produto"},			{"Informe o grupo do produto"},			{"Informe o grupo do produto"})
PutSX1(cPerg, "06", "KG:",			"KG:",				"KG:",				"MV_PAR06", "N", 12, 6, 0, "G",,,,, 		"MV_PAR06",,,,,,,,,,,,,,,,, {"Informe o KG da mistura"}, 			{"Informe o KG da mistura"}, 			{"Informe o KG da mistura"})
PutSX1(cPerg, "07", "Quantidade:",	"Quantidade:",	"Quantidade:",	"MV_PAR07", "N", 03, 0, 0, "G",,,,, 		"MV_PAR07",,,,,,,,,,,,,,,,, {"Informe a quantidade da mistura"}, 	{"Informe a quantidade da mistura"}, 	{"Informe a quantidade da mistura"})*/

	Local aParBox := {}
	
	aAdd(aParBox, {1, "Op de:", Space(11), "@!",,"SC2","",70, .T. })
	aAdd(aParBox, {1, "Op até:", Space(11), "@!",,"SC2","",70, .T. })
	aAdd(aParBox, {1, "Emissão de:", Space(8), "99/99/99","","","",70, .T. })
	aAdd(aParBox, {1, "Emissão até:", Space(8), "99/99/99","","","",70, .T. })
	aAdd(aParBox, {1, "Grupo:", Space(4), "@!","","SBM","",4, .T. })
	aAdd(aParBox, {1, "Kg:", Space(18), "@E999999.99999999999","","","",70, .T. })
	aAdd(aParBox, {1, "Quantidade:", Space(3), "@E999","","","",70, .T. })
	

Return ParamBox(aParBox, "carta de mistura 2",,,,,,,,cPerg, .T., .T.)