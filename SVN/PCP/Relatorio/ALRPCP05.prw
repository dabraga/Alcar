#Include 'Protheus.ch'

/*/{Protheus.doc} ALRPCP05

Função responsável geração da OP de lixa

@author Ectore Cecato - Totvs IP (Jundiaí)
@since 07/01/2015
@version Protheus 11 - PCP

/*/

User Function ALRPCP05()

	Local cPerg := "ALRPCP05"
	Local oReport

	AjustaSX1(cPerg)	

	Pergunte(cPerg, .F.)

	oReport:= ReportDef(cPerg)
	oReport:PrintDialog()

Return Nil

/*/{Protheus.doc} ReportDef

Ponto de entrada responsável por acrescentar filtro de vendedor na geração do documento de entrada

@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/01/2015
@version Protheus 11 - Faturamento

@param [nBaseMenor], numérico, Medida da base menor (trapézios)

@return caracter, Filtro para tabela SC9

/*/
Static Function ReportDef(cPerg)

	Local oReport
	Local cTitulo := "Ordem de Produção de Lixa"
	Local cAjuda  := "Permite imprimir a ordem de produção de lixa"

	oReport := TReport():New("ALRPCP05", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cAjuda)

	//Define o formato retrato 
	oReport:SetPortrait(.T.)

	//Oculta página de parâmetros
	oReport:HideParamPage()

	//Oculta o cabeçalho do relatório
	oReport:HideHeader()

	//Oculta o rodapé do relatório
	oReport:HideFooter()

	//Define o tamanho do papel - 9 (A4)
	//oReport:oPage:SetPaperSize(9)
	oReport:oPage:SetPaperSize(5)

Return oReport

Static Function ReportPrint(oReport)

	Local nQtdReg		:= 0
	Local nPagOp		:= 1
	Local nLin			:= 0
	//Local nEspLin		:= 50
	Local cOp			:= ""
	Local cDtEntreg		:= ""
	Local cOpDe			:= MV_PAR01
	Local cOpAte		:= MV_PAR02
	Local cEmissaoDe	:= DTOS(MV_PAR03)
	Local cEmissaoAte	:= DTOS(MV_PAR04)
	Local cGrupo		:= MV_PAR05
	Local cAliasSC2		:= GetNextAlias()
	Local cLogoAlcar	:= GetSrvProfString("Startpath", "") + "logo_alcar.jpg"
	Local oFont10 		:= TFont():New("Arial",, 10,, .F.,,,, .F., .F.)
	Local oFont11N 		:= TFont():New("Arial",, 11,, .T.,,,, .F., .F.)
	Local oFont13 		:= TFont():New("Arial",, 15,, .F.,,,, .F., .F.)
	Local oFont13N 		:= TFont():New("Arial",, 15,, .T.,,,, .F., .F.)
	Local oFont13NS 	:= TFont():New("Arial",, 15,, .T.,,,, .F., .T.)

	cQuery := "SELECT "
	cQuery += "		C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_DATPRI, C2_EMISSAO, "
	cQuery += "		C2_PRODUTO, B1_DESC, C2_QUANT, C2_UM, "
	cQuery += "		C2_PEDIDO, C2_ITEMPV, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, A1_NOME,  "
	cQuery += "		C5_VEND1, A3_NOME, G2_OPERAC, G2_DESCRI, C2_ZZIMP, C6_ENTREG, C2_DATPRF, "
	cQuery += "		B1_PESO, B1_PESBRU, B1_ZZDTPES "
	cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "
	cQuery += "		INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery += "			ON 	SB1.D_E_L_E_T_ = ' ' "
	cQuery += "				AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
	cQuery += "				AND B1_COD = C2_PRODUTO "
	cQuery += "		INNER JOIN "+ RetSqlName("SBM") +" SBM "
	cQuery += "			ON	SBM.D_E_L_E_T_ = ' ' "
	cQuery += "				AND BM_FILIAL = '"+ FWFilial("SBM") +"' "
	cQuery += "				AND BM_GRUPO = B1_GRUPO "
	cQuery += "				AND BM_DESC LIKE '%LIXA%' "
	cQuery += "		LEFT JOIN "+ RetSqlName("SG2") +" SG2 "
	cQuery += "			ON 	SG2.D_E_L_E_T_ = ' ' "
	cQuery += "				AND G2_FILIAL = '"+ FWFilial("SG2") +"' "
	cQuery += "				AND G2_CODIGO = C2_ROTEIRO "
	cQuery += "				AND G2_PRODUTO = C2_PRODUTO "
	cQuery += "		LEFT JOIN "+ RetSqlName("SC5") +" SC5 "
	cQuery += "			ON 	SC5.D_E_L_E_T_ = ' ' "
	cQuery += "				AND C5_FILIAL = C2_FILIAL "
	cQuery += "				AND C5_NUM = C2_PEDIDO "
	cQuery += "		LEFT JOIN "+ RetSqlName("SC6") +" SC6 "
	cQuery += "			ON 	SC6.D_E_L_E_T_ = ' ' "
	cQuery += "				AND C6_FILIAL = C5_FILIAL "
	cQuery += "				AND C6_NUM = C5_NUM "
	cQuery += "				AND C6_ITEM = C2_ITEMPV "
	cQuery += "				AND C6_PRODUTO = C2_PRODUTO "
	cQuery += "		LEFT JOIN "+ RetSqlName("SA1") +" SA1 "
	cQuery += "			ON 	SA1.D_E_L_E_T_ = ' ' "
	cQuery += "				AND A1_FILIAL = '"+ FWFilial("SA1") +"' "
	cQuery += "				AND A1_COD = C5_CLIENTE "
	cQuery += "				AND A1_LOJA = C5_LOJACLI " 
	cQuery += "		LEFT JOIN "+ RetSqlName("SA3") +" SA3 "
	cQuery += "			ON	SA3.D_E_L_E_T_ = ' ' "
	cQuery += "				AND A3_FILIAL = '"+ FWFilial("SA3") +"' "
	cQuery += "				AND A3_COD = C5_VEND1 "
	cQuery += "WHERE "
	cQuery += "		SC2.D_E_L_E_T_ = ' ' "
	cQuery += "		AND C2_FILIAL = '"+ FWFilial("SC2") +"' "
	cQuery += "		AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+ cOpDe +"' AND '"+ cOpAte +"' "
	cQuery += "		AND C2_EMISSAO BETWEEN '"+ cEmissaoDe +"' AND '"+ cEmissaoAte +"' "

	If !Empty(cGrupo)
		cQuery += "	AND SB1.B1_GRUPO = '"+ cGrupo +"' "
	EndIf

	cQuery += "ORDER BY "
	cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN "

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasSC2, .F., .T.)

	Count To nQtdReg

	(cAliasSC2)->(DbGoTop())

	oReport:SetMeter(nQtdReg)

	While !(cAliasSC2)->(Eof())

		cOp := (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN)

		If !Empty((cAliasSC2)->C2_ZZIMP)

			If !MsgYesNo("OP "+ cOp +" já impressa. Deseja imprimí-la novamente ?")

				While !(cAliasSC2)->(Eof()) .And. cOp == (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN)
					(cAliasSC2)->(DbSkip())
				EndDo

				Loop

			EndIf 

		Endif

		If nPagOp == 1
			nLin := 30		//Metade superior da página
		Else
			nLin := 1550 	//Metade inferior da página 
		EndIf

		cDtEntreg := If(!Empty((cAliasSC2)->C6_ENTREG), DToC(SToD((cAliasSC2)->C6_ENTREG)), DToC(SToD((cAliasSC2)->C2_DATPRF))) 

		//Cabeçalho
		oReport:Box(nLin, 0020, nLin+1450, 2350)
		
		oReport:SayBitmap(nLin + 020, 0050, cLogoAlcar, 0400, 0180)
		
		oReport:Say(nLin+020, 0800, "ORDEM DE PRODUÇÃO: "+ (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN),	oFont13NS)		
		oReport:Say(nLin+010, 1900, "GERADA SISTEMA: "+ DToC(SToD((cAliasSC2)->C2_EMISSAO)),		oFont10)
		oReport:Say(nLin+040, 2007, "IMPRESSA: "+ DToC(Date()),										oFont10)
		oReport:Say(nLin+100, 1940, "RELATÓRIO DE CORTE Nº",										oFont10)
		
		oReport:Line(nLin + 100, 1900, nLin + 100, 2350)
		oReport:Line(nLin + 100, 1900, nLin + 250, 1900)
		
		oReport:Say(nLin + 100, 0650, "PEDIDO DE VENDA: "+ (cAliasSC2)->C2_PEDIDO +" EMITIDO EM: "+ DToC(SToD((cAliasSC2)->C5_EMISSAO)),	oFont13N)
		oReport:Say(nLin + 200, 0055, "CONVERSÃO DE LIXAS", 																				oFont11N)
		oReport:Say(nLin + 170, 0850, "ITEM: "+ (cAliasSC2)->C2_ITEMPV +" / ENTREGA: "+ cDtEntreg, 											oFont13N)
		
		oReport:Line(nLin + 250, 0020, nLin + 250, 2350)
		
		oReport:Say(nLin + 270, 0040, "CLIENTE: "+ (cAliasSC2)->C5_CLIENTE +"/"+ (cAliasSC2)->C5_LOJACLI +" - "+ AllTrim((cAliasSC2)->A1_NOME), oFont13N)
		oReport:Say(nLin + 340, 0040, "REPRESENTANTE: "+ (cAliasSC2)->C5_VEND1 +" - "+ AllTrim((cAliasSC2)->A3_NOME), 							oFont13)
		
		oReport:Line(nLin + 410, 0020, nLin + 410, 2350)
		
		oReport:Say(nLin + 430, 0040, "QUANTIDADE", oFont13NS)
		oReport:Say(nLin + 430, 0370, "CÓDIGO", 	oFont13NS)
		oReport:Say(nLin + 430, 0670, "DESCRIÇÃO",	oFont13NS)
		
		If !Empty((cAliasSC2)->B1_ZZDTPES)
			oReport:Say(nLin + 430, 2140, DToC(SToD((cAliasSC2)->B1_ZZDTPES)), oFont13NS)
		EndIf
		
		oReport:Say(nLin + 500, 0090, cValToChar((cAliasSC2)->C2_QUANT) +" "+ (cAliasSC2)->C2_UM,	oFont13N)
		oReport:Say(nLin + 500, 0370, AllTrim((cAliasSC2)->C2_PRODUTO),								oFont13N)
		oReport:Say(nLin + 500, 0670, AllTrim((cAliasSC2)->B1_DESC), 								oFont13N)
		
		oReport:Line(nLin + 570, 0020, nLin + 570, 2350)
		
		oReport:Say(nLin + 590, 0040, "QTDA. FINAL", 	oFont13)
		oReport:Say(nLin + 590, 0430, "VOLUMES", 		oFont13)
		oReport:Say(nLin + 590, 0730, "PESO LIQUIDO", 	oFont13)
		oReport:Say(nLin + 590, 1070, "PESO BRUTO", 	oFont13)
		oReport:Say(nLin + 590, 1390, "OBS: PEDIDO", 	oFont13)
		oReport:Say(nLin + 660, 1390, "OBS: ITEM", 		oFont13)
		
		If !Empty((cAliasSC2)->B1_ZZDTPES)
			
			oReport:Say(nLin + 660, 0730, AllTrim(Transform((cAliasSC2)->B1_PESO * (cAliasSC2)->C2_QUANT ,  PesqPict("SC6", "C6_ZZCOEF"))), oFont13N)
			oReport:Say(nLin + 660, 1070, AllTrim(Transform((cAliasSC2)->B1_PESBRU * (cAliasSC2)->C2_QUANT, PesqPict("SC6", "C6_ZZCOEF"))), oFont13N)
			
		EndIf
		
		oReport:Line(nLin + 750, 0020, nLin + 750, 2350)
		
		oReport:Say(nLin + 770, 0060, "OPE.", 			oFont13)
		oReport:Say(nLin + 770, 0210, "ATIVIDADE", 		oFont13)
		oReport:Say(nLin + 770, 0615, "DATA INICIAL", 	oFont13)
		oReport:Say(nLin + 770, 0952, "HORA INICIAL", 	oFont13)
		oReport:Say(nLin + 770, 1322, "HORA FINAL", 	oFont13)
		oReport:Say(nLin + 770, 1675, "OPERADOR", 		oFont13)
		oReport:Say(nLin + 770, 2038, "PRODUZIDO", 		oFont13)
		
		oReport:Line(nLin + 410, 0350, nLin + 750, 0350)
		oReport:Line(nLin + 570, 0720, nLin + 750, 0720)
		oReport:Line(nLin + 570, 1060, nLin + 750, 1060)
		oReport:Line(nLin + 570, 1380, nLin + 750, 1380)

		nLin := nLin + 830

		//Itens
		While !(cAliasSC2)->(Eof()) .And. cOp == (cAliasSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN)

			//Linha 1
			oReport:Say(nLin, 0075, AllTrim((cAliasSC2)->G2_OPERAC),					oFont13)
			oReport:Say(nLin, 0210, SubStr(AllTrim((cAliasSC2)->G2_DESCRI), 1, 12),	oFont13)
			oReport:Say(nLin, 0600, "____/____/____", 									oFont13)
			oReport:Say(nLin, 0950, "______:______", 										oFont13)
			oReport:Say(nLin, 1300, "______:______", 										oFont13)
			oReport:Say(nLin, 1650, "_____________", 										oFont13)
			oReport:Say(nLin, 2000, "_____________", 										oFont13)

			//Linha 2
			oReport:Say(nLin + 60, 0600, "____/____/____",	oFont13)
			oReport:Say(nLin + 60, 0950, "______:______", 	oFont13)
			oReport:Say(nLin + 60, 1300, "______:______", 	oFont13)
			oReport:Say(nLin + 60, 1650, "_____________", 	oFont13)
			oReport:Say(nLin + 60, 2000, "_____________", 	oFont13)

			nLin += 130

			(cAliasSC2)->(DbSkip())

		EndDo

		//Atualiza OP como impressa
		GravaImp(cOp)

		If !(cAliasSC2)->(Eof()) 

			If nPagOp == 2 

				nPagOp := 1

				oReport:EndPage()
				oReport:StartPage()

			Else
				nPagOp := 2
			EndIf

		Endif

	Enddo

	(cAliasSC2)->(dbCloseArea())

Return Nil

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

Static Function AjustaSX1(cPerg)

	/*PutSX1(cPerg, "01", "OP de:",		"OP de:",		"OP de:",		"MV_PAR01", "C", 11, 0, 0, "G",, "SC2",,, 	"MV_PAR01",,,,,,,,,,,,,,,,, {"Informe a OP inicial"},		{"Informe a OP inicial"}, 		{"Informe a OP inicial"})
	PutSX1(cPerg, "02", "OP até:",		"OP até:",		"OP até:",		"MV_PAR02", "C", 11, 0, 0, "G",, "SC2",,, 	"MV_PAR02",,,,,,,,,,,,,,,,, {"Informe a OP final"}, 		{"Informe a OP final"}, 		{"Informe a OP final"})
	PutSX1(cPerg, "03", "Emissão de:", 	"Emissão de:", 	"Emissão de:", 	"MV_PAR03", "D", 08, 0, 0, "G",,,,, 		"MV_PAR03",,,,,,,,,,,,,,,,, {"Informe a emissão inicial"}, 	{"Informe a emissão inicial"}, 	{"Informe a emissão inicial"})
	PutSX1(cPerg, "04", "Emissão até:",	"Emissão até:",	"Emissão até:",	"MV_PAR04", "D", 08, 0, 0, "G",,,,, 		"MV_PAR04",,,,,,,,,,,,,,,,, {"Informe a emissão final"}, 	{"Informe a emissão final"}, 	{"Informe a emissão final"})
	PutSX1(cPerg, "05", "Grupo:",		"Grupo:",		"Grupo:",		"MV_PAR05", "C", 04, 0, 0, "G",, "SBM",,,	"MV_PAR05",,,,,,,,,,,,,,,,, {"Informe o grupo do produto"},	{"Informe o grupo do produto"},	{"Informe o grupo do produto"})*/
	
	Local aParBox := {}
	
	aAdd(aParBox, {1, "Op de:", Space(11), "@!",,"SC2","",70, .T. })
	aAdd(aParBox, {1, "Op até:", Space(11), "@!",,"SC2","",70, .T. })
	aAdd(aParBox, {1, "Emissão de:", Space(8), "99/99/99","","","",70, .T. })
	aAdd(aParBox, {1, "Emissão até:", Space(8), "99/99/99","","","",70, .T. })
	aAdd(aParBox, {1, "Grupo:", Space(4), "@!","","SBM","",4, .T. })

Return ParamBox(aParBox, "Ordem de Produção de Lixa",,,,,,,,cPerg, .T., .T.)