#Include "Protheus.ch"
#Include "ParmType.ch"

#Define IMP_SPOOL 		2
#Define IMP_PDF 		6
#Define QTD_ITENS		22
#Define INICIO_ITEM		670
#dEFINE BOX_LATERAL		2500
#Define HALIGN_LEFT		0
#Define HALIGN_RIGHT	1
#Define HALIGN_CENTER	2

/*/{Protheus.doc} ALRFAT01

Relatório Pedido de Vendas

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		27/08/2018
@version 	Protheus 12 - Faturamento

@param cPedVen, Caracter, Número do Pedido de Venda

/*/

User Function ALRFAT01(cPedVend)

	Local cPerg 	:= "ALRFAT01"
	Local cReport	:= ""

	Default cPedVend := ""

	If Empty(cPedVend)

		If Pergunte(cPerg, .T.)
			cPedVend := MV_PAR01
		Else
			Return Nil
		EndIf

	EndIf

	Processa({|| cReport := PrintReport(cPedVend)}, "Aguarde", "Gerando relatório", .F.)

Return cReport

Static Function PrintReport(cPedVend)

	Local cDirFile	:= GetTempPath()
	Local cDirServ	:= GETMV("MV_RELT")
	Local cFilePDF	:= "pv_"+ AllTrim(cPedVend) +"_"+ DToS(dDataBase) + StrTran(Time(), ":", "")
	Local nQtdReg	:= 0
	Local nQtdLin	:= 1
	Local nTotal	:= 0
		
	Private cAliasQry	:= ""
	Private	cCliente	:= ""
	Private	cNomeCli	:= ""
	Private	cCNPJ		:= ""
	Private	cMun		:= ""
	Private	cUF			:= ""
	Private	cSuframa	:= ""
	Private	cNumPed		:= ""
	Private	cEmissao	:= ""
	Private	cVend		:= ""
	Private	cPedVen		:= ""
	Private	cCondPagto	:= ""
	Private	cTransp		:= ""
	Private	cTES		:= ""
	Private	cPedCli		:= ""	
	Private	cObs		:= ""
	Private cContato	:= ""
	Private cTelefone	:= ""
	Private	nCofFin		:= 0
	Private	nLin 		:= INICIO_ITEM
	Private nPageHeight	:= 0
	Private nPageWidth	:= 0

	Private oFont10 	:= TFont():New("Arial",, 10,, .F.,,,,.F., .F.)
	Private oFont10N 	:= TFont():New("Arial",, 10,, .T.,,,,.F., .F.)
	Private oFont12 	:= TFont():New("Arial",, 12,, .F.,,,,.F., .F.)
	Private oFont12N 	:= TFont():New("Arial",, 12,, .T.,,,,.F., .F.)
	Private oFont14N 	:= TFont():New("Arial",, 14,, .T.,,,,.F., .F.)
	Private oFont16N 	:= TFont():New("Arial",, 16,, .T.,,,,.F., .F.)
	Private oFont18N 	:= TFont():New("Arial",, 18,, .T.,,,,.F., .F.)
	Private oPrinter	:= FWMSPrinter():New(cFilePDF, IMP_PDF, .T., cDirServ, .T., .F.,,, .T.,,, .T.)
						   						   
	oPrinter:SetResolution(72)
	oPrinter:SetLandscape()
	oPrinter:SetPaperSize(9)
	oPrinter:cPathPDF := cDirFile

	nPageHeight := oPrinter:nPageHeight
	nPageWidth  := oPrinter:nPageWidth - 200
	cReportDest	:= cDirServ + cFilePDF +".pdf"

	ReportQuery(cPedVend)

	Count To nQtdReg

	ProcRegua(nQtdReg)

	(cAliasQry)->(DbGoTop())

	If !(cAliasQry)->(Eof())
		
		cCliente	:= AllTrim((cAliasQry)->A1_COD)
		cNomeCli	:= AllTrim((cAliasQry)->A1_NREDUZ)
		cCNPJ		:= (cAliasQry)->A1_CGC
		cMun		:= AllTrim((cAliasQry)->A1_MUN)
		cUF			:= AllTrim((cAliasQry)->A1_EST)
		cSuframa	:= (cAliasQry)->A1_SUFRAMA
		cNumPed		:= (cAliasQry)->C5_NUM
		cEmissao	:= DToC((cAliasQry)->C5_EMISSAO)
		cVend		:= AllTrim((cAliasQry)->C5_VEND1)
		cPedVen		:= AllTrim((cAliasQry)->C5_ZZPDVEN)
		cCondPagto	:= AllTrim((cAliasQry)->E4_DESCRI)
		nCofFin		:= (cAliasQry)->E4_ZZCOFIN
		cTransp		:= AllTrim((cAliasQry)->A4_NREDUZ)
		cTES		:= AllTrim((cAliasQry)->C6_TES)
		cPedCli		:= AllTrim((cAliasQry)->C6_PEDCLI)
		cObs 		:= AllTrim((cAliasQry)->C5_ZZOBSPD)
		cContato	:= AllTrim((cAliasQry)->C5_ZZCONT)
		cTelefone	:= AllTrim((cAliasQry)->C5_ZZTEL)

		oPrinter:StartPage()

		PrintHeader()

		While !(cAliasQry)->(Eof())

			IncProc()

			PrintItems()

			nTotal += (cAliasQry)->C6_VALOR

			nQtdLin++			

			(cAliasQry)->(DbSkip())

		EndDo

		PrintFooter(nTotal)

		oPrinter:EndPage()

		oPrinter:Print()

	Else
		MsgAlert("Pedido "+ MV_PAR01 +" não encontrado", "Atenção")
	EndIf

	(cAliasQry)->(DbCloseArea())

Return cReportDest

Static Function ReportQuery(cPedVend)

	Local cQuery := ""

	cAliasQry := GetNextAlias()

	cQuery := "SELECT "+ CRLF
	cQuery += "		SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_ZZPDVEN, SC5.C5_EMISSAO, SC5.C5_VEND1, SC5.C5_ZZCONT, SC5.C5_ZZTEL, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), SC5.C5_ZZOBSPD)), '') AS C5_ZZOBSPD, "+ CRLF
	cQuery += "		SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ZZCOEF, "
	cQuery += "		SC6.C6_TES, SC6.C6_PEDCLI, SC6.C6_ENTREG, SC6.C6_ITEMPC, SC6.C6_ZZDES, SC6.C6_ZZREQ, SC6.C6_ZZPRDCL, "+ CRLF
	cQuery += "		SB1.B1_CONV, SB1.B1_PE, SB1.B1_TIPCONV, SB1.B1_ZZDESNF, "
	cQuery += "		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST, SA1.A1_CGC, SA1.A1_SUFRAMA, SA1.A1_TIPO, "+ CRLF
	cQuery += "		SE4.E4_DESCRI, SE4.E4_ZZCOFIN, "+ CRLF
	cQuery += "		ISNULL(SA4.A4_NREDUZ, '') AS A4_NREDUZ, "+ CRLF
	cQuery += "		ISNULL(SA7.A7_CODCLI, '') AS A7_CODCLI "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC5") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SC6") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SC6") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SC6") +" "+ CRLF
	cQuery += "				AND SC6.C6_NUM = SC5.C5_NUM "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "				AND SB1.B1_COD = SC6.C6_PRODUTO "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SA1") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SA1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA1") +" "+ CRLF
	cQuery += "				AND SA1.A1_COD = SC5.C5_CLIENTE "+ CRLF
	cQuery += "				AND SA1.A1_LOJA = SC5.C5_LOJACLI "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SE4") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SE4") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SE4") +" "+ CRLF
	cQuery += "				AND SE4.E4_CODIGO = SC5.C5_CONDPAG "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlTab("SA4") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SA4") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA4") +" "+ CRLF
	cQuery += "				AND SA4.A4_COD = SC5.C5_TRANSP "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlTab("SA7") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SA7") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA7") +" "+ CRLF
	cQuery += "				AND SA7.A7_CLIENTE = SC5.C5_CLIENTE "+ CRLF
	cQuery += "				AND SA7.A7_LOJA = SC5.C5_LOJACLI "+ CRLF
	cQuery += "				AND SA7.A7_PRODUTO = SC6.C6_PRODUTO "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC5") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC5") +" "+ CRLF
	cQuery += "		AND SC5.C5_NUM = '"+ cPedVend +"' "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SC6.C6_ITEM "
	
	MemoWrite("\SQL\ALRFAT01.SQL", cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	TcSetField(cAliasQry, "C5_EMISSAO", "D", 08, 00)
	TcSetField(cAliasQry, "C6_ENTREG",  "D", 08, 00)

Return Nil

Static Function PrintHeader()
	
	Local cTpCli := ""
	
	If (cAliasQry)->A1_TIPO == "F"
		cTpCli := "CONS. FINAL"
	ElseIf (cAliasQry)->A1_TIPO == "L"
		cTpCli := "PRODUTO RURAL"
	ElseIf (cAliasQry)->A1_TIPO == "R"
		cTpCli := "REVENDEDOR"
	ElseIf (cAliasQry)->A1_TIPO == "S"
		cTpCli := "SOLIDÁRIO"
	ElseIf (cAliasQry)->A1_TIPO == "X"
		cTpCli := "EXPORTAÇÃO"
	EndIf
	
	oPrinter:Box(0070, 0050, 0635, nPageWidth)

	oPrinter:SayBitmap(0075, 0090, "\system\lgrl"+ cFilAnt +".bmp", 300, 200)

	oPrinter:Line(0070, 0500, 0250, 0500)

	oPrinter:Say(0100, 0600, AllTrim(SM0->M0_ENDCOB) +" - "+ AllTrim(SM0->M0_BAIRCOB) + " - "+ AllTrim(SM0->M0_CIDCOB) +" / "+ AllTrim(SM0->M0_ESTCOB), oFont10n)
	oPrinter:Say(0140, 0600, "Fone: (19) 3876.7900 - Fax: (19) 3876.1904 - 3886.1360", oFont10n)
	oPrinter:Say(0180, 0600, "Email taisse@alcar.com.br", oFont10n)
	oPrinter:Say(0220, 0600, "CNPJ: "+ AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) +" - INSC. ESTADUAL: "+ AllTrim(SM0->M0_INSC), oFont10n)

	oPrinter:Line(0070, 1300, 0250, 1300)

	oPrinter:Say(0140, 1380, "PEDIDO", 		oFont14N)
	oPrinter:Say(0180, 1360, "DE VENDA", 	oFont14N)

	oPrinter:Line(0070, 1600, 0250, 1600)

	oPrinter:Say(0180, 1900, "Nº "+ (cAliasQry)->C5_NUM, oFont18N)

	oPrinter:Line(0070, BOX_LATERAL, 0630, BOX_LATERAL)

	oPrinter:Say(0100, 2510, "Recebimento/Conferência", 		oFont10N)
	oPrinter:Say(0250, 2530, DToC(dDataBase) +" - "+ Time(), 	oFont16N)

	oPrinter:Line(0250, 0050, 0250, BOX_LATERAL)

	oPrinter:Say(0280, 0060, "Código do Cliente", 	oFont10N)
	oPrinter:Say(0330, 0080, cCliente, 				oFont12N)

	oPrinter:Line(0250, 0300, 0350, 0300)

	oPrinter:Say(0280, 0310, "Cliente", oFont10N)
	oPrinter:Say(0330, 0330, cNomeCli,  oFont12N)

	oPrinter:Line(0250, 1300, 0350, 1300)

	oPrinter:Say(0280, 1310, "Substituição Tributária", oFont10N)
	oPrinter:Say(0330, 1360, If((cAliasQry)->A1_TIPO == "F", "NÃO PAGA", "PAGA"), oFont12N)	

	oPrinter:Line(0250, 1600, 0350, 1600)

	oPrinter:Say(0280, 1610, "CNPJ", 												oFont10N)
	oPrinter:Say(0330, 1680, AllTrim(Transform(cCNPJ, "@R 99.999.999/9999-99")), 	oFont12N)

	oPrinter:Line(0250, 2000, 0350, 2000)

	oPrinter:Say(0280, 2010, "Data de Emissão", 			oFont10N)
	oPrinter:Say(0330, 2080, DToC((cAliasQry)->C5_EMISSAO), oFont12N)

	oPrinter:Line(0350, 0050, 0350, nPageWidth)

	oPrinter:Say(0380, 0060, "Cidade", 	oFont10N)
	oPrinter:Say(0430, 0080, cMun, 		oFont12N)

	oPrinter:Line(0350, 0500, 0450, 0500)

	oPrinter:Say(0380, 0510, "Sigla do Estado", oFont10N)
	oPrinter:Say(0430, 0530, cUF, 				oFont12N)

	oPrinter:Line(0350, 0800, 0450, 0800)

	oPrinter:Say(0380, 0810, "Suframa", 							oFont10N)
	oPrinter:Say(0430, 0820, If(!Empty(cSuframa), "SIM", "NÃO"), 	oFont12N)

	oPrinter:Line(0350, 1100, 0450, 1100)

	oPrinter:Say(0380, 1110, "Operação", 	oFont10N)
	oPrinter:Say(0430, 1140, cTES,			oFont12N)

	oPrinter:Line(0350, 1300, 0450, 1300)

	oPrinter:Say(0380, 1310, "Atividade Econômica", oFont10N)
	oPrinter:Say(0430, 1340, cTpCli,	 			oFont12N)

	oPrinter:Line(0350, 1600, 0450, 1600)

	oPrinter:Line(0350, 2000, 0450, 2000)
	
	oPrinter:Line(0450, 0050, 0450, BOX_LATERAL)

	oPrinter:Say(0480, 0060, "Condição de Pagamento", 	oFont10N)
	oPrinter:Say(0530, 0080, cCondPagto,				oFont12N)
	/*
	oPrinter:Line(0450, 0500, 0550, 0500)
	
	oPrinter:Say(0480, 0510, "Descontos", 		oFont10N)
	oPrinter:Say(0530, 0540, "40+20+10+10%", 	oFont12N)
	
	oPrinter:Line(0450, 0800, 0550, 0800)

	oPrinter:Say(0480, 0810, "Custo Financeiro", 											oFont10N)
	oPrinter:Say(0530, 0840, AllTrim(Transform(nCofFin, PesqPict("SE4", "E4_ZZCOFIN"))), 	oFont12N)
	*/
	oPrinter:Line(0450, 1100, 0550, 1100)

	oPrinter:Say(0480, 1110, "Transportadora", 	oFont10N)
	oPrinter:Say(0530, 1140, cTransp, 			oFont12N)

	oPrinter:Line(0450, 2000, 0550, 2000)

	oPrinter:Say(0480, 2010, "Cód. do Vendedor", 	oFont10N)
	oPrinter:Say(0530, 2030, cVend, 				oFont12N)

	oPrinter:Line(0550, 0050, 0550, nPageWidth)

	//Cabeçalho dos itens
	oPrinter:Say(0580, 0060, "Item", oFont10N)

	oPrinter:Line(0550, 0120, 0630, 0120)

	oPrinter:Say(0580, 0140, "Quantidade", oFont10N)

	oPrinter:Line(0550, 0290, 0630, 0290)

	oPrinter:Say(0580, 0360, "Código", oFont10N)
	oPrinter:Say(0620, 0370, "Alcar", oFont10N)

	oPrinter:Line(0550, 0500, 0630, 0500)

	oPrinter:Say(0580, 0570, "Dimensões e Especificações", oFont10N)
	oPrinter:Say(0620, 0510, "Tipo - Desenhho - Medidas Complementares", oFont10N)

	oPrinter:Line(0550, 1000, 0630, 1000)

	oPrinter:Say(0580, 1040, "Coef", oFont10N)

	oPrinter:Line(0550, 1150, 0630, 1150)

	oPrinter:Say(0580, 1250, "Preço Unitário", oFont10N)
	oPrinter:Say(0620, 1280, "Líquido", oFont10N)

	oPrinter:Line(0550, 1500, 0630, 1500)

	oPrinter:Say(0580, 1600, "Preço Total", oFont10N)
	oPrinter:Say(0620, 1610, "Líquido", oFont10N)

	oPrinter:Line(0550, 1850, 0630, 1850)

	oPrinter:Say(0580, 1870, "Programação - Faturamento", oFont10N)

	oPrinter:Line(0590, 1850, 0590, 2200)

	oPrinter:Say(0620, 1880, "Quant", oFont10N)

	oPrinter:Line(0590, 2000, 0630, 2000)

	oPrinter:Say(0620, 2050, "Data", oFont10N)

	oPrinter:Line(0550, 2200, 0630, 2200)

	oPrinter:Say(0580, 2210, "Embalagem", oFont10N)
	oPrinter:Say(0620, 2210, "Itens Padrão", oFont10N)

	oPrinter:Line(0550, 2350, 0630, 2350)

	oPrinter:Say(0580, 2370, "Estoque", oFont10N)

	oPrinter:Line(0590, 2350, 0590, BOX_LATERAL)

	oPrinter:Say(0620, 2360, "Sim", oFont10N)

	oPrinter:Line(0590, 2420, 0630, 2420)

	oPrinter:Say(0620, 2430, "Não", oFont10N)

	oPrinter:Say(0580, 2510, "Ordem de Compra", oFont10N)

Return Nil

Static Function PrintItems()
	
	Local cDescPrd	:= If(!Empty((cAliasQry)->B1_ZZDESNF), (cAliasQry)->B1_ZZDESNF, (cAliasQry)->C6_DESCRI)
	Local aDesc 	:= BreakLine(AllTrim(cDescPrd), 40)
	Local cInfAdic	:= ""
	Local nLine		:= 0
	Local nLinOrig	:= 0
	Local nTamItem	:= nLin + (Len(aDesc) * 40) + 80
	Local lDatEnt	:= ((cAliasQry)->C5_EMISSAO + (cAliasQry)->B1_PE) == (cAliasQry)->C6_ENTREG 
	Local nQtdEmb	:= (cAliasQry)->C6_QTDVEN
	
	If (cAliasQry)->B1_TIPCONV == "D"
		nQtdEmb /= (cAliasQry)->B1_CONV
	ElseIf (cAliasQry)->B1_TIPCONV == "M"
		nQtdEmb *= (cAliasQry)->B1_CONV
	EndIf
	
	EndPage(nTamItem)
	
	nLinOrig := nLin
	
	cInfAdic += If(!Empty((cAliasQry)->A7_CODCLI) .Or. !Empty((cAliasQry)->C6_ZZPRDCL), "Código: "+ AllTrim(If(!Empty((cAliasQry)->A7_CODCLI), (cAliasQry)->A7_CODCLI, (cAliasQry)->C6_ZZPRDCL)), "")
	cInfAdic += If(!Empty((cAliasQry)->C6_ZZDES), " - Des.: "+ AllTrim((cAliasQry)->C6_ZZDES), "")
	cInfAdic += If(!Empty((cAliasQry)->C6_ZZREQ), " - Req.: "+ AllTrim((cAliasQry)->C6_ZZREQ), "")
	
	oPrinter:Say(nLin + 20, 0060, (cAliasQry)->C6_ITEM, oFont12)

	oPrinter:Say(nLinOrig + 20, 0125, ConvText(AllTrim(Transform((cAliasQry)->C6_QTDVEN, "@E 999,999,999")), 15), 	oFont12)
	oPrinter:Say(nLinOrig + 20,	0320, AllTrim((cAliasQry)->C6_PRODUTO), 											oFont12)

	For nLine := 1 To Len(aDesc)

		oPrinter:Say(nLin, 0510, aDesc[nLine], oFont10)

		If nLine < Len(aDesc)
			nLin += 40
		EndIf

	Next nLine

	oPrinter:Line(nLin + 10, 0500, nLin + 10, 1000)

	oPrinter:Say(nLin + 40,		0510, If(!Empty(cInfAdic), cInfAdic, ""), 										oFont10)
	oPrinter:Say(nLinOrig + 20,	1020, AllTrim(Transform((cAliasQry)->C6_ZZCOEF, PesqPict("SC6", "C6_ZZCOEF"))), oFont12)
	oPrinter:Say(nLinOrig + 20,	1180, "R$", 																	oFont12)	
	oPrinter:Say(nLinOrig + 20,	1540, "R$", 																	oFont12)
	
	oPrinter:SayAlign(nLinOrig - 10, 1160, AllTrim(Transform((cAliasQry)->C6_PRCVEN, PesqPict("SC6", "C6_PRCVEN"))), oFont12, 300, 200,, HALIGN_RIGHT)
	oPrinter:SayAlign(nLinOrig - 10, 1500, AllTrim(Transform((cAliasQry)->C6_VALOR, PesqPict("SC6", "C6_VALOR"))), 	 oFont12, 300, 200,, HALIGN_RIGHT)

	oPrinter:Line(nLinOrig + 10, 1850, nLinOrig + 10, nPageWidth)
	
	oPrinter:Say(nLinOrig, 1865, AllTrim(Transform((cAliasQry)->C6_QTDVEN, "@E 999,999,999,999")), 	oFont10)
	oPrinter:Say(nLinOrig, 2015, If(lDatEnt, "ATÉ ", "EM ")+ DToC((cAliasQry)->C6_ENTREG), 			oFont10)
	
	oPrinter:SayAlign(nLinOrig - 25, 1960, AllTrim(Transform(nQtdEmb, "@E 999,999,999,999.99")), oFont10, 300, 200,, HALIGN_RIGHT)
	
	oPrinter:Say(nLinOrig, 2510, If(!Empty((cAliasQry)->C6_PEDCLI + (cAliasQry)->C6_ITEMPC), "RC: "+ AllTrim((cAliasQry)->C6_PEDCLI) +" - "+ AllTrim((cAliasQry)->C6_ITEMPC), ""), 	oFont10)

	//Linha verticais
	oPrinter:Line(nLinOrig - 30, 0050, 			nLin + 50, 0050)
	oPrinter:Line(nLinOrig - 30, 0120, 			nLin + 50, 0120)
	oPrinter:Line(nLinOrig - 30, 0290, 			nLin + 50, 0290)
	oPrinter:Line(nLinOrig - 30, 0500,	 		nLin + 50, 0500)
	oPrinter:Line(nLinOrig - 30, 1000, 			nLin + 50, 1000)
	oPrinter:Line(nLinOrig - 30, 1150, 			nLin + 50, 1150)
	oPrinter:Line(nLinOrig - 30, 1500, 			nLin + 50, 1500)
	oPrinter:Line(nLinOrig - 30, 1850, 			nLin + 50, 1850)
	oPrinter:Line(nLinOrig - 30, 2000, 			nLin + 50, 2000)
	oPrinter:Line(nLinOrig - 30, 2200, 			nLin + 50, 2200)
	oPrinter:Line(nLinOrig - 30, 2350, 			nLin + 50, 2350)
	oPrinter:Line(nLinOrig - 30, 2420, 			nLin + 50, 2420)
	oPrinter:Line(nLinOrig - 30, BOX_LATERAL, 	nLin + 50, BOX_LATERAL)
	oPrinter:Line(nLinOrig - 30, nPageWidth, 	nLin + 50, nPageWidth)

	nLin += 80

	oPrinter:Line(nLin - 30, 0050, nLin - 30, nPageWidth)

Return Nil

Static Function PrintFooter(nTotal)

	Local aObs 		:= BreakLine(cObs, 140)
	Local nLine		:= 0
	Local nLinOrig	:= 0
	Local nTamItem	:= nLin + 330 + (Len(aObs) * 50)
	
	EndPage(nTamItem)
	
	nLinOrig := nLin + 120
	
	oPrinter:Box(nLin - 30, 0050, nLin + 330, nPageWidth)

	oPrinter:Say(nLin + 20, 0300, "Observações", oFont12N)
	oPrinter:Say(nLin, 		1160, "Soma Total:", oFont10N)
	oPrinter:Say(nLin + 20, 1870, "Não aceitaremos alterações, devoluções ou", oFont10N)

	oPrinter:Line(nLin - 30, 1150, 			nLin + 080, 1150)
	oPrinter:Line(nLin - 30, 1850, 			nLin + 330, 1850)
	oPrinter:Line(nLin - 30, BOX_LATERAL, 	nLin + 330, BOX_LATERAL)

	nLin += 40

	oPrinter:Line(nLin, 0050, nLin, 1150)

	nLin += 40

	oPrinter:Say(nLin - 10, 1170, "R$", 													oFont10N)
	//oPrinter:Say(nLin - 10, 1700, AllTrim(Transform(nTotal, PesqPict("SC6", "C6_VALOR"))), 	oFont10N)
	oPrinter:Say(nLin - 20, 1870, "cancelamentos, sem prévio entendimento", 				oFont10N)
	oPrinter:Say(nLin + 20, 1870, "com nossa fábrica", 										oFont10N)

	oPrinter:SayAlign(nLin - 35, 1500, AllTrim(Transform(nTotal, PesqPict("SC6", "C6_VALOR"))), oFont10N, 300, 200,, HALIGN_RIGHT)	

	oPrinter:Line(nLin, 0050, nLin, 1850)

	For nLine := 1 To Len(aObs)

		oPrinter:Say(nLinOrig, 0070, aObs[nLine], oFont12N)

		nLinOrig += 50

	Next nLine

	nLin += 50

	oPrinter:Line(nLin, 0050, nLin, BOX_LATERAL)

	nLin += 50

	//oPrinter:Say(nLin - 10, 0070, "", oFont12N)
	oPrinter:Say(nLin - 10, 2140, "Contato", oFont10N)

	oPrinter:Line(nLin, 0050, nLin, 1850)

	nLin += 50

	//oPrinter:Say(nLin - 10, 0070, "", oFont12N)
	//oPrinter:Say(nLin - 10, 2000, cContato, oFont10N)
	oPrinter:SayAlign(nLin - 40, 1870, cContato, oFont10N, 650, 200,, HALIGN_CENTER)
	oPrinter:Line(nLin, 0050, nLin, BOX_LATERAL)

	nLin += 50

	//oPrinter:Say(nLin - 10, 0070, "", oFont12N)
	oPrinter:Say(nLin - 10, 2150, "Telefone", oFont10N)

	oPrinter:Line(nLin, 0050, nLin, 1850)

	nLin += 50

	oPrinter:SayAlign(nLin - 40, 1870, cTelefone, oFont10N, 650, 200,, HALIGN_CENTER)

	//oPrinter:Say(nLin - 10, 2000, cTelefone, oFont10N)	

Return Nil

Static Function BreakLine(cText, nTam)

	Local aText 	:= {}
	Local nLine		:= 0
	Local nTotLine 	:= MLCount(cText, nTam)

	For nLine := 1 To nTotLine
		aAdd(aText, MemoLine(cText, nTam, nLine))
	Next nLine

Return aText

Static Function ConvText(cText, nTam)

	Local nSpace 	:= Abs((nTam - Len(cText)) / 2)
	Local cNewText	:= Space(nSpace) + cText 

Return cNewText

Static Function EndPage(nItem)
	
	If nItem >= nPageHeight

		nQtdLin 	:= 0
		nLin 		:= INICIO_ITEM
		
		oPrinter:EndPage()

		oPrinter:StartPage()

		PrintHeader()

	EndIf
	
Return Nil