#Include "protheus.ch"
#Include "topconn.ch"
#Define cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} PCPC0001

Movimentacao da Producao
	
@author Ademar Junior
@since 03/07/2015
/*/

User Function PCPC0001()
Local cPerg		:= "PCPC0001"	// Grupo de perguntas

	// Chamada ValidPerg
	ValidPerg(cPerg,1)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf               
	
	Processa({|| RunBrow()},"Processando registros para browse.")
Return


/****************************************************************************************************/


Static Function RunBrow()	                
Local cQry		:= ""			// Query
Local aDados	:= {}			// Dados
Local oDlg		:= Nil			// Tela
Local oBrowse	:= Nil			// Browse
Local nCount	:= 0			// Contador
Local nRegs		:= 0			// Total de registros
	
	cQry :=	"SELECT " + cEOL
	cQry +=		"C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,C2_QUANT,C2_EMISSAO,"
	cQry +=		"H6_OPERAC,H6_DATAINI,H6_HORAINI,H6_DATAFIN,H6_HORAFIN,H6_QTDPROD,H6_QTDPERD,H6_ZZDCOPE," + cEOL
	cQry +=		"B1_DESC " + cEOL
	
	cQry +=	"FROM " + cEOL
	cQry +=		RetSQLName("SC2") + " C2 " + cEOL

	cQry +=	"LEFT JOIN " + cEOL
	cQry +=		RetSQLName("SH6") + " H6 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"H6_FILIAL = '" + xFilial("SC2") + "' AND " + cEOL
	cQry +=		"H6_OP = C2_NUM + C2_ITEM + C2_SEQUEN AND " + cEOL
	cQry +=		"H6.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SB1") + " B1 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"B1_FILIAL = '" + xFilial("SB1") + "' AND " + cEOL
	cQry +=		"B1_COD = C2_PRODUTO AND " + cEOL
	cQry +=		"B1.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"WHERE " + cEOL
	cQry +=		"C2_FILIAL = '" + xFilial("SC2") + "' AND " + cEOL
	cQry +=		"C2_PRODUTO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND " + cEOL
	cQry +=		"C2_NUM + C2_ITEM + C2_SEQUEN BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND " + cEOL
	cQry +=		"C2_DATRF = ' ' AND " + cEOL
	cQry +=		"C2.D_E_L_E_T_ = ' ' " + cEOL
	
	cQry +=	"ORDER BY " + cEOL
	cQry +=		"C2_NUM,C2_ITEM,C2_SEQUEN,H6_OPERAC,H6_DATAINI,H6_HORAINI"
	
	TcQuery cQry Alias TSH6 New
	
	If TSH6->(EOF())
		Aviso("Aviso","Não foram encontrados registros para os parametros informados. Verifique.",{"OK"})
		
		TSH6->(DbCloseArea())
		Return
	EndIf

	Count to nRegs

	ProcRegua(nRegs)
	
	TSH6->(DbGoTop())
	
	While TSH6->(!EOF())
		AADD(aDados,{	TSH6->C2_PRODUTO,;									// Produto
						TSH6->B1_DESC,;										// Desc
						TSH6->C2_NUM + TSH6->C2_ITEM + TSH6->C2_SEQUEN,;	// OP
						TSH6->C2_QUANT,;									// Quantidade
						DtoC(StoD(TSH6->C2_EMISSAO)),;						// Emissao
						TSH6->H6_OPERAC,;									// Operação
						TSH6->H6_ZZDCOPE,;									// Desc
						DtoC(StoD(TSH6->H6_DATAINI)),;						// Data Inicial
						TSH6->H6_HORAINI,;									// Hora Inicial
						DtoC(StoD(TSH6->H6_DATAFIN)),;						// Data Final
						TSH6->H6_HORAFIN,;									// Hora Final
						TSH6->H6_QTDPROD,;									// Qtd.Produzida
						TSH6->H6_QTDPERD})									// Qtd.Perdida



		nCount ++
		
		IncProc("Registro " + AllTrim(Str(nCount)) + " de "  + AllTrim(Str(nRegs)) + ".")
		TSH6->(DbSkip())
	EndDo
	
	TSH6->(DbCloseArea())
	
	If Len(aDados) > 0
		oDlg	:= MSDialog():New(	050,;							// nTop
									050,;							// nLeft
									550,;							// nBottom 
									1070,;                     		// nRight
									"Movimentacao da Producao",;	// cCaption 
									,;                        		// uParam6
									,;                         		// uParam7
									.F.,;                     		// uParam8
									,;                         		// uParam9
									,;                         		// nClrText
									,;                       		// nClrBack
									,;                     			// uParam12
									,;                        		// oWnd
									.T.,;                   		// lPixel
									,;                   			// uParam15
									oMainWnd,;             			// uParam16
									.T.,;                    		// uParam17
									,;                      		// uParam18
									,)           					// uParam19
		
		// Adicionar botoes
		oDlg:bInit 		:= {||EnchoiceBar(oDlg,{|| AtDados(oDlg,aDados[oBrowse:nAt,01],aDados[oBrowse:nAt,02],aDados[oBrowse:nAt,03],aDados[oBrowse:nAt,04])},{||oDlg:End()})}
		
		// Centralizar                       `
		oDlg:lCentered		:= .T.
		
		// Criar browse
		oBrowse := 	TCBrowse():New(05,05,500,230,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		
		// Adicionar colunas
		oBrowse:AddColumn(TCColumn():New("Produto",{|| aDados[oBrowse:nAt,01]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Descrição",{|| aDados[oBrowse:nAt,02]},,,,"LEFT",100,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("OP",{|| aDados[oBrowse:nAt,03]},,,,"LEFT",030,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Quant.",{|| aDados[oBrowse:nAt,04]},,,,"LEFT",030,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Emissão",{|| aDados[oBrowse:nAt,05]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Oper.",{|| aDados[oBrowse:nAt,06]},,,,"LEFT",010,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Descrição",{|| aDados[oBrowse:nAt,07]},,,,"LEFT",050,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Dt.Ini.",{|| aDados[oBrowse:nAt,08]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Hr.Ini.",{|| aDados[oBrowse:nAt,09]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Dt.Fin.",{|| aDados[oBrowse:nAt,10]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Hr.Fin.",{|| aDados[oBrowse:nAt,11]},,,,"LEFT",020,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Qtd.Prod.",{|| aDados[oBrowse:nAt,12]},,,,"LEFT",030,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New("Qtd.Perd.",{|| aDados[oBrowse:nAt,13]},,,,"LEFT",030,.F.,.F.,,,,.F.,))

		// Setar array
		oBrowse:SetArray(aDados)
		
		oDlg:Activate()
	EndIf
Return


/****************************************************************************************************/


Static Function ValidPerg(cPerg)
	Local aAlias := Alias()
	Local aRegs := {}
	Local i,j  
	Local aCposSX1 := FWSX1Util():GetGroup(cPerg)                                                                                                                              
	
	SX1->(DbSelectArea("SX1"))
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))
	
	// Grupo - Ordem - Pergunta - Variavel - Tipo - Tamanho - Decimal - Presel - GSC - Valid - Var01 - Def01 - Cnt01 - Var02 - Def02 - Cnt02 - Var03 - Def03 - Cnt03 - Var04 - Def04 - Cnt04 - Var05 - Def05 - Cnt05
	AADD(aRegs,{cPerg,"01","Produto de ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"02","Produto ate","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"03","OP de "		,"","","mv_ch3","C",11,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
	AADD(aRegs,{cPerg,"04","OP ate"		,"","","mv_ch4","C",11,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
	
	For i := 1 To Len(aRegs)
		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
			RecLock("SX1",.T.)
			For j := 1 To FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			SX1->(MsUnlock())
		EndIf
	Next
	
	DbSelectArea(aAlias)
Return