#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE CRLF CHR(13)+CHR(10) // FINAL DE LINHA

/**
 * Rotina		:	ALRPCP03
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data			:	18/10/2013
 * Descrição	:	Etiqueta de Produto
 * Modulo		:  	PCP
**/
User Function ALRPCP03()
    Local xyz := IIf(Type("cFilAnt")=="U",RpcSetEnv("01","01"),Nil)
	Local aSays	:= {}
	Local aButtons:= {}
	Local lImprime:= .F.
	Private cPerg	:= "ALRPCP03"
	
	//AjustaSX1()
	
	Aadd(aSays, "Rotina responsável por imprimir etiquetas de ordem de produção")
	Aadd(aSays, "Clique no botão Imprimir para continuar")
	
	Aadd(aButtons, {5, 	.T., {|| Pergunte(cPerg, .T.)}})
	Aadd(aButtons, {6, 	.T., {|o| lImprime := .T., o:oWnd:End()}})
	Aadd(aButtons, {2, 	.T., {|o| o:oWnd:End()}})
	
	FormBatch("Impressão de Etiquetas", aSays, aButtons,, 200, 400)
	
	If lImprime
		Processa({|| ImpEtq()}, "Aguarde", "Imprimindo etiquetas", .F.)
	Endif
	
Return

/**
 * Rotina		:	ImpEtq
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	18/10/2013
 * Descrição	:	Função responsável pela impressão da etiqueta
**/
Static Function ImpEtq()

Local cTipoEtq	:= ""
Local cQuery 		:= ""
Local cEtiq		:= ""
Local cValid		:= ""
Local cQtdProd	:= ""
Local cCodBar		:= ""
Local cTipoProd	:= ""
Local cDirEtq		:= "C:\Protheus"
Local cArqEtq		:= cDirEtq + "\Etiqueta.txt"
Local cArqBatEtq	:= cDirEtq + "\ImprimirEtiqueta.bat"
Local cSeq			:= ""
Local cOp 			:= MV_PAR02
Local cCliente	:= MV_PAR03
Local cLoja		:= MV_PAR04
Local cProduto	:= MV_PAR05
Local nQuant		:= MV_PAR06
Local nQtdEtq 	:= MV_PAR07
Local nArq			:= 0
Local nX 			:= 0
Local nPosTxt1	:= 0
Local nPosTxt2	:= 0
Local nPosTxt3	:= 0

If MV_PAR01 == 1
	cTipoEtq := "OP"
ElseIf MV_PAR01 == 2
	cTipoEtq := "ESTOQUE"
ElseIf MV_PAR01 == 3
	cTipoEtq := "LIXA"
ElseIf MV_PAR01 == 4
	cTipoEtq := "CLIENTE"
EndIf

If cTipoEtq == "OP"
			
	cQuery := "SELECT "
	cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN AS OP, C2_PRODUTO AS PRODUTO, C2_PEDIDO AS PEDIDO, C2_ITEMPV AS ITEM_PEDIDO, "
	//cQuery += "	B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_ZZCBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, "
	cQuery += "	B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_CODBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, "
	cQuery += "	ISNULL(B5_QE1, 0) AS QTD_EMB, " 
	cQuery += "	ISNULL(A1_NOME, '') AS NOME_CLIENTE, "
	cQuery += "	ISNULL(A7_CODCLI, '') AS PROD_CLIENTE, ISNULL(A7_ZZDESCL, '') AS DESENHO, "
	cQuery += "	ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "
	cQuery += ", CASE WHEN B1_ZZCOMPO = ' ' THEN ISNULL(BM_ZZCOMPO,'') ELSE B1_ZZCOMPO END COMPOSICAO "
	cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "
	cQuery += "	INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery += "		ON 	SB1.D_E_L_E_T_ = ' ' "
	cQuery += "			AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
	cQuery += "			AND B1_COD = C2_PRODUTO "
	cQuery += "	LEFT JOIN "+ RetSqlName("SB5") +" SB5 "
	cQuery += "		ON 	SB5.D_E_L_E_T_ = ' ' "
	cQuery += "			AND B5_FILIAL = '"+ FWFilial("SB5") +"' "
	cQuery += "			AND B5_COD = B1_COD "
	cQuery += "	LEFT JOIN "+ RetSqlName("SC5") +" SC5 "
	cQuery += "		ON 	SC5.D_E_L_E_T_ = ' ' "
	cQuery += "			AND C5_FILIAL = C2_FILIAL "
	cQuery += "			AND C5_NUM = C2_PEDIDO "
	cQuery += "	LEFT JOIN "+ RetSqlName("SC6") +" SC6 "
	cQuery += "		ON 	SC6.D_E_L_E_T_ = ' ' "
	cQuery += "			AND C6_FILIAL = C5_FILIAL "
	cQuery += "			AND C6_NUM = C5_NUM "
	cQuery += "			AND C6_CLI = C5_CLIENTE "
	cQuery += "			AND C6_LOJA = C5_LOJACLI "
	cQuery += "			AND C6_ITEM = C2_ITEMPV "
	cQuery += "	LEFT JOIN "+ RetSqlName("SA1") +" SA1 "
	cQuery += "		ON 	SA1.D_E_L_E_T_ = ' ' "
	cQuery += "			AND A1_FILIAL = '"+ FWFilial("SA1") +"' "
	cQuery += "			AND A1_COD = C5_CLIENTE "
	cQuery += "			AND A1_LOJA = C5_LOJACLI "
	cQuery += "	LEFT JOIN "+ RetSqlName("SA7") +" SA7 "
	cQuery += "		ON 	SA7.D_E_L_E_T_ = ' ' "
	cQuery += "			AND A7_FILIAL = '"+ FWFilial("SA7") +"' "
	cQuery += "			AND A7_CLIENTE = C5_CLIENTE "
	cQuery += "			AND A7_LOJA = C5_LOJACLI "
	cQuery += "			AND A7_PRODUTO = C6_PRODUTO "
	cQuery += "	LEFT JOIN "+ RetSqlName("SBM") +" SBM "
	cQuery += "		ON 	SBM.D_E_L_E_T_ = ' ' "
	cQuery += "			AND BM_FILIAL = '"+ FWFilial("SBM") +"' "
	cQuery += "			AND BM_GRUPO = B1_GRUPO "
	cQuery += "WHERE "
	cQuery += "	SC2.D_E_L_E_T_ = ' ' "
	cQuery += "	AND C2_FILIAL = '"+ FWFilial("SC2") +"' "
	cQuery += "	AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+ cOp +"' "

ElseIf cTipoEtq == "ESTOQUE" .Or. cTipoEtq == "CLIENTE" 

	cQuery := "SELECT "
	cQuery += "	'' AS OP, B1_COD AS PRODUTO, '' AS PEDIDO, '' AS ITEM_PEDIDO, "
	//cQuery += "	B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_ZZCBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, "
	cQuery += "	B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_CODBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, " 
	cQuery += "	ISNULL(B5_QE1, 0) AS QTD_EMB, "
	cQuery += "	'"+ IIF(cTipoEtq == "ESTOQUE", "ESTOQUE", Posicione("SA1", 1, xFilial("SA1")+cCliente+cLoja, "SA1->A1_NREDUZ")) +"' AS NOME_CLIENTE, "
	If cTipoEtq == "CLIENTE" .and. !Empty(cCliente) .and. !Empty(cLoja)
		cQuery += "	ISNULL(A7_CODCLI, '') AS PROD_CLIENTE, ISNULL(A7_ZZDESCL, '') AS DESENHO, "
	Else
		cQuery += "	'' AS PROD_CLIENTE, '' AS DESENHO, "
	Endif
	cQuery += "	ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "
	cQuery += ", CASE WHEN B1_ZZCOMPO = ' ' THEN ISNULL(BM_ZZCOMPO,'') ELSE B1_ZZCOMPO END COMPOSICAO "
	cQuery += "FROM "+ RetSqlName("SB1") +" SB1 "
	cQuery += "	LEFT JOIN "+ RetSqlName("SB5") +" SB5 "
	cQuery += "		ON 	SB5.D_E_L_E_T_ = ' ' "
	cQuery += "			AND B5_FILIAL = '"+ FWFilial("SB5") +"' "
	cQuery += "			AND B5_COD = B1_COD "
	cQuery += "	LEFT JOIN "+ RetSqlName("SBM") +" SBM "
	cQuery += "		ON 	SBM.D_E_L_E_T_ = ' ' "
	cQuery += "			AND BM_FILIAL = '"+ FWFilial("SBM") +"' "
	cQuery += "			AND BM_GRUPO = B1_GRUPO "
	If cTipoEtq == "CLIENTE" .and. !Empty(cCliente) .and. !Empty(cLoja)
		cQuery += "	LEFT JOIN "+ RetSqlName("SA7") +" SA7 "
		cQuery += "		ON 	SA7.D_E_L_E_T_ = ' ' "
		cQuery += "			AND A7_FILIAL = '"+ FWFilial("SA7") +"' "
		cQuery += "			AND A7_CLIENTE = '"+ cCliente +"' "
		cQuery += "			AND A7_LOJA = '"+ cLoja +"' "
		cQuery += "			AND A7_PRODUTO = B1_COD "
	Endif
	cQuery += "WHERE "
	cQuery += "	SB1.D_E_L_E_T_ = ' ' "
	cQuery += "	AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
	cQuery += "	AND B1_COD = '"+ cProduto +"' " 	

Else 
	
	cQuery := "SELECT "
	cQuery += "	B1_COD AS PRODUTO, B1_ZZDCETQ AS DESC_PROD, B1_ZZCONT AS CONTADOR, B1_ZZTAMFL AS TAM_LIXA, B1_ZZQTDFL AS QTD_LIXA, "
	cQuery += "	ISNULL(B5_QE1, 0) AS QTD_EMB, "
	cQuery += "	ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "
	cQuery += ", CASE WHEN B1_ZZCOMPO = ' ' THEN ISNULL(BM_ZZCOMPO,'') ELSE B1_ZZCOMPO END COMPOSICAO "
	cQuery += "FROM "+ RetSqlName("SB1") +" SB1 "
	cQuery += "	LEFT JOIN "+ RetSqlName("SB5") +" SB5 "
	cQuery += "		ON 	SB5.D_E_L_E_T_ = ' ' "
	cQuery += "			AND B5_FILIAL = '"+ FWFilial("SB5") +"' "
	cQuery += "			AND B5_COD = B1_COD "
	cQuery += "	LEFT JOIN "+ RetSqlName("SBM") +" SBM "
	cQuery += "		ON 	SBM.D_E_L_E_T_ = ' ' "
	cQuery += "			AND BM_FILIAL = '"+ FWFilial("SBM") +"' "
	cQuery += "			AND BM_GRUPO = B1_GRUPO "
	cQuery += "WHERE "
	cQuery += "	SB1.D_E_L_E_T_ = ' ' "
	cQuery += "	AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
	cQuery += "	AND B1_COD = '"+ cProduto +"' " 
	
EndIf

If Select("ALRPCP03") <> 0
	ALRPCP03->(dbCloseArea())
Endif

TcQuery cQuery Alias "ALRPCP03" New

ALRPCP03->(dbGoTop())

If !ALRPCP03->(Eof())

	ProcRegua(nQtdEtq)

	cSeq := ALRPCP03->CONTADOR
	
	If !File(cDirEtq)
	
		If MakeDir(cDirEtq) <> 0
			Aviso("Atenção", "Não foi possível criar o diretório de impressão", {"Ok"})
			Return 		
		EndIf
	
	EndIf

	nArq := FCreate(cArqEtq)	
	
	If nArq >= 0
		
		For nX := 1 To nQtdEtq

			If nQuant > 0
				cQtdProd := AllTrim(cValToChar(nQuant))
			Else
				cQtdProd := AllTrim(cValToChar(ALRPCP03->QTD_EMB))
			Endif
			
			If cTipoEtq == "LIXA"
			
				nPosTxt1 := PosicaoTexto(AllTrim(ALRPCP03->DESC_PROD))
				nPosTxt2 := PosicaoTexto("CONTEM "+ AllTrim(ALRPCP03->QTD_LIXA) +" FOLHAS")
				nPosTxt3 := PosicaoTexto(AllTrim(ALRPCP03->TAM_LIXA))
				
				/*
				cEtiq := "^XA"+ CRLF
				cEtiq += "^MMT"+ CRLF
				cEtiq += "^PW500"+ CRLF
				cEtiq += "^LL0350"+ CRLF
				cEtiq += "^LS0"+ CRLF
				cEtiq += "^FT220,"+ cValToChar(nPosTxt1) +"^A0B,34,34,^FH\^FD"+ AllTrim(ALRPCP03->DESC_PROD) +"^FS"+ CRLF
				cEtiq += "^FT260,"+ cValToChar(nPosTxt2) +"^A0B,34,34^FH\^FDCONTEM "+ AllTrim(ALRPCP03->QTD_LIXA) +" FOLHAS^FS"+ CRLF
				cEtiq += "^FT300,"+ cValToChar(nPosTxt3) +"^A0B,34,34^FH\^FD"+ AllTrim(ALRPCP03->TAM_LIXA) +"^FS"+ CRLF
				cEtiq += "^BY2,3,50^FT360,420^BCB,,Y,N"+ CRLF
				cEtiq += "^FD>CODIGOBARRAS^FS"+ CRLF
				cEtiq += "^PQ1,0,1,Y^XZ"+ CRLF
				*/
				
				cEtiq := "^XA"+ CRLF
				cEtiq += "^MMT"+ CRLF
				cEtiq += "^PW500"+ CRLF
				cEtiq += "^LL0350"+ CRLF
				cEtiq += "^LS0"+ CRLF
				cEtiq += "^FT220,"+ cValToChar(nPosTxt1) +"^A0B,28,28,^FH\^FD"+ AllTrim(ALRPCP03->DESC_PROD) +"^FS"+ CRLF
				cEtiq += "^FT260,"+ cValToChar(nPosTxt2) +"^A0B,28,28^FH\^FDCONTEM "+ AllTrim(ALRPCP03->QTD_LIXA) +" FOLHAS^FS"+ CRLF
				cEtiq += "^FT300,"+ cValToChar(nPosTxt3) +"^A0B,28,28^FH\^FD"+ AllTrim(ALRPCP03->TAM_LIXA) +"^FS"+ CRLF
				cEtiq += "^BY2,3,82^FT360,420^BCB,,Y,N"+ CRLF
				cEtiq += "^FD>CODIGOBARRAS^FS"+ CRLF
				cEtiq += "^PQ1,0,1,Y^XZ"+ CRLF
				
				/*
				cEtiq := "^XA"+ CRLF
				cEtiq += "^MMT"+ CRLF
				cEtiq += "^PW280"+ CRLF
				cEtiq += "^LL0440"+ CRLF
				cEtiq += "^LS0"+ CRLF
				cEtiq += "^BY2,3,99^FT245,387^BCB,,Y,N"+ CRLF
				cEtiq += "^FD>CODIGOBARRAS^FS"+ CRLF
				cEtiq += "^FT44,"+ cValToChar(nPosTxt1) +"^A0B,28,28^FH\^FD"+ AllTrim(ALRPCP03->DESC_PROD) +"^FS"+ CRLF
				cEtiq += "^FT85,"+ cValToChar(nPosTxt2) +"^A0B,28,28^FH\^FDCONTEM "+ AllTrim(ALRPCP03->QTD_LIXA) +" FOLHAS^FS"+ CRLF
				cEtiq += "^FT127,"+ cValToChar(nPosTxt3) +"^A0B,28,28^FH\^FD"+ AllTrim(ALRPCP03->TAM_LIXA) +"^FS"+ CRLF
				cEtiq += "^PQ1,0,1,Y^XZ"+ CRLF
				*/
			Else
			
				If ALRPCP03->TIPO_MAT == "L"
					//cValid := StrZero(Month(dDataBase), 2)+"/"+ AllTrim(Str(Year(dDataBase)+5))
					cValid := Left(Upper(MesExtenso( dDataBase )),3) + "/" + AllTrim(Str(Year(dDataBase)+5))
				Elseif ALRPCP03->TIPO_MAT == "R"
					//cValid := StrZero(Month(dDataBase), 2)+"/"+ AllTrim(Str(Year(dDataBase)+3))
					cValid := Left(Upper(MesExtenso( dDataBase )),3) + "/" + AllTrim(Str(Year(dDataBase)+3))
				Else
					cValid := "S/ VALID."
				Endif
				
				If ALRPCP03->GRUPO == "0512" .Or. "PADRAO" $ ALRPCP03->DESCGRP .Or. "PAD." $ ALRPCP03->DESCGRP 
					cTipoProd := "P-"
				ElseIf "INDUSTRIAL" $ ALRPCP03->DESCGRP .Or. "IND." $ ALRPCP03->DESCGRP
					cTipoProd := "I-"
				Else
					cTipoProd := " -"
				EndIf
				
				cEtiq := "^XA"+ CRLF
				cEtiq += "^MMT"+ CRLF
				cEtiq += "^PW1200"+ CRLF
				cEtiq += "^LL1300"+ CRLF 
				cEtiq += "^FT364,423^A0B,20,19^FH\^FDOS No.^FS"+ CRLF
				cEtiq += "^FT364,668^A0B,20,19^FH\^FDPEDIDO / ORDER^FS"+ CRLF
				cEtiq += "^FT364,930^A0B,20,19^FH\^FDEMBALADO / PACKED^FS"+ CRLF
				cEtiq += "^FT290,668^A0B,20,19^FH\^FDC\E3D. DESENHO / DRAW CODE^FS"+ CRLF
				cEtiq += "^FT290,940^A0B,20,19^FH\^FDQTDE. / QUANTITY^FS#$D"+ CRLF
				//cEtiq += "^FT479,209^A0B,39,38^FH\^FDVALIDADE:^FS"+ CRLF
				cEtiq += "^FT364,190^A0B,20,19^FH\^FDVALIDADE:^FS"+ CRLF
				cEtiq += "^FT403,190^A0B,39,38^FH\^FD"+ AllTrim(cValid) +"^FS"
				cEtiq += "^FT218,930^A0B,20,19^FH\^FDPRODUTO / PRODUCT^FS"+ CRLF
				cEtiq += "^FT114,930^A0B,20,19^FH\^FDC\E3DIGO / CODE^FS"+ CRLF
				cEtiq += "^FT190,930^A0B,70,70^FH\^FD"+ cTipoProd + AllTrim(ALRPCP03->PRODUTO) +"^FS"+ CRLF
				cEtiq += "^FT403,423^A0B,39,38^FH\^FD"+ AllTrim(ALRPCP03->OP)+ "^FS"+ CRLF
				cEtiq += "^FT403,668^A0B,39,38^FH\^FD"+ IIF(!Empty(ALRPCP03->PEDIDO+ALRPCP03->ITEM_PEDIDO), AllTrim(ALRPCP03->PEDIDO) +"/"+ AllTrim(ALRPCP03->ITEM_PEDIDO), "") +"^FS"+ CRLF
				//cEtiq += "^FT403,930^A0B,39,38^FH\^FD"+ DtoC(dDataBase) +"^FS"+ CRLF
				cEtiq += "^FT403,930^A0B,39,38^FH\^FD"+ Left(Upper(MesExtenso( dDataBase )),3) + "/" + AllTrim(Str(Year(dDataBase))) +"^FS"+ CRLF
				cEtiq += "^FT331,668^A0B,39,38^FH\^FD"+ IIF(!Empty(ALRPCP03->PROD_CLIENTE), AllTrim(ALRPCP03->PROD_CLIENTE) +" - "+ AllTrim(ALRPCP03->DESENHO), "ESTOQUE") +"^FS"+ CRLF
				cEtiq += "^FT331,930^A0B,39,38^FH\^FD"+ AllTrim(cQtdProd)+ "  "+ AllTrim(ALRPCP03->UM_PROD) +"^FS"+ CRLF
				cEtiq += "^FT257,930^A0B,39,38^FH\^FD"+ AllTrim(ALRPCP03->DESC_PROD) +"^FS"+ CRLF
				cEtiq += "^FT83,930^A0B,51,50^FH\^FD"+ AllTrim(ALRPCP03->NOME_CLIENTE) +"^FS"+ CRLF
				cEtiq += "^FT39,930^A0B,20,19^FH\^FDCLIENTE / CUSTOMER^FS"+ CRLF
				cEtiq += "^FO343,200^GB67,0,4^FS"+ CRLF
				cEtiq += "^FO343,429^GB67,0,4^FS"+ CRLF
				cEtiq += "^FO268,674^GB146,0,4^FS"+ CRLF
				cEtiq += "^FO412,8^GB0,944,4^FS"+ CRLF
				cEtiq += "^FO340,8^GB0,944,5^FS"+ CRLF
				cEtiq += "^FO266,8^GB0,944,4^FS"+ CRLF
				cEtiq += "^FO193,8^GB0,944,4^FS"+ CRLF
				cEtiq += "^FO91,8^GB0,944,4^FS"+ CRLF
				cEtiq += "^FO440,8^GB0,944,4^FS"+ CRLF
				//cEtiq += "^BY2,2,100^FT524,650^BCB,,Y,N"+ CRLF
				cEtiq += "^BY2,2,70^FT170,485^BCB,,Y,N" + CRLF
				cEtiq += "^FDCODIGOBARRAS^FS"+ CRLF
				//cEtiq += "^BY2,2,75^FT172,270^BCB,,Y,N"+ CRLF
				//cEtiq += "^FD>;"+ AllTrim(ALRPCP03->CODBAR) +"^FS"+ CRLF
				
				cEtiq += "^FT435,930^A0B,20,19^FH\^FDCOMPOSI\80\C7O: " + Alltrim(ALRPCP03->COMPOSICAO)+"^FS" + CRLF
				
				// Logo
				cEtiq += "^FO430,600^GFA,06400,06400,00020,:Z64:"+chr(10)+"eJztl89rG0cUx0ddyh7aeC1cxYf1ei/9AwKuHLuyvS5Y+Nb2oIkJSJEvvbsHURdZ0RgffCktOvXQQvsn5BhYE+/BIrdAwGovhQqa3mVagWDtbN8bHzTvzUIdSG4ejMEff/ftm3k/5q0Qt+t23a7b9W5X4bXNnEwxsiFcmTC2qbx0yJhSgdxl7KfNMBsx9vFmSe4J8eHEYL9u+vETIRYuDXYKui+FWDeZUNre+gsDfSa0vSWTLQo/Bt3S9+TN4F+gKpR5WRKq6IQw2G+gwjXCnEz4KlyhW3ktAiVmKcsy6wTDLBvnsFS59GxKUkoVTrguU+GlrVuj/vlxHKuVGVvHmLaXq1tk9tJYRTnvZb5oe97E1rG9af+EsHX3KNP2NpgOzy9KqE6IioroOz6CECuX+ge7CpWgiX4XdWKR6z7gOmCe8qg9vSKe08iUzdYsUhD3LObZD+YyX0RWwYY3ZPdt5qWWc1dXA85ciIcQe/RJKXdo/cLhQXxFQM8qQB2tXxGhvdUXhJVRt0RZBfKP1y/opIh+tu2x+m2hPVa/bfRvZsXWsdXV+32P66Rg+dLWusdUd9EYiwLdb/doFAlWMy13L+Q5VHGf+GqDJsd9dy/gbMMdhTzvl98HHesbG97IVw6N+fKdelmJA8IWPexXtB/cvQN1yc6g4mH9UlZG3Qx9NjrGfkULuHwMOpZ/leM0Fay/lA/hnFfp3qIjzJeEskP5gDNRiJ/ZOT6o26w7sVk4spnLXvCGa2bfZmFeL8ljfzDgDMUqrYXw0hlxVjoo7IvV77juku+tVHMeceafONb5BXXnN868kci4u8FQtHjNVBT+0NyA5LPyL8L+zPL0GzCZsL7bBhcTlvfw0mCT1UcX7CVrlEEyl3bZs+1EVIasZiTsY9dh9Qv7HbI6lwfuYJf3g9MsTtgZyJ2x3BR0YX9JGMP+whn2P8UY9j/Oopx5I8jpa9Cfn3EG5fuAM+j3VkI6A2klcyFN7UuwY20DL3QLwfyYw268whsyP4cFN3w2T1ehf87OwuhXpgyjkWU5jN2rlTRNY3b/YnTxnvk/e3m6SozrbdpL8f59t/7lnIu+N7qULWsxZZ/iLxbfT/AXi5u2x+K7nK+LJla+QC38yRnseMJZ1t/mSe6CiE2sInxZLM6zokEH+Q1wuVXbatKOWMDH/B+UyRwwVwx+JC/xUBEeDslrq7AaffJiPRtVFKnqb8FcsdwjY5N+KFOk1f0L7u0Mzpume+hEGCvXcFC715G9OYPh/x3oVwXDaRe8+0LKftVwGq+NLvY/g3lgbixlr2jMogv4/Yb9z2RbtQ7k31nN2ByMfan+/jDmv9Xi/ECivYUp29OfH2DPYK3qFeZzv/rI0DkpLnK/XQQ673tF47CG3ezanqF7hd1ejs+3pi26kOB0egr+uVP2EnWNUq84b+jQ3iQkuj5OsQ3wb5vYS08nvhIOtdd5GPSK04Boe39hOjtTdt6Szd/rta3atjLtnThPqQ7sXcw9hKBQe4nD7PVb3ep2A4JM7I3Etc7076pYRHt0v9c6Y79nreb5dh1zcHqmw3Y80v5NdeKiJTtz1J6Oh7ZnxOOrltx5jv59PmV77TT9B8/Z0H3dGl+fn5Eb+4+j63gYbO2gKXfqjbNafcpWDpw0fuqT/As6UB0NsGfk6cLB9fevmc9ep7o92Bn3q0YBezBD6fwbTpkLW13H/EumDMOA871jsrOtWnUsz6fhgENFO22oX2GsCzAYyh6pffTVZf1gHfvLoE/GOi1o0/6CBVxs9Ugf0g0jOhqazHkFwW09VyYrYND8XwRZHex/rHdCLASb6oT3d7XaHFKGE2dXUSa6V01r9oF4WHNOgV95t+utrv8AaxmMhg==:7596"
				
				// Dados da empresa
				cEtiq += "^FT470,620^A0B,30,29^FB590,1,0,C^FH\^FD"+ Alltrim(SM0->M0_ENDENT) +" - "+ Alltrim(SM0->M0_CIDENT) +"/"+ Alltrim(SM0->M0_ESTENT) +" - BRASIL^FS" + CRLF
				cEtiq += "^FT500,620^A0B,30,29^FB590,1,0,C^FH\^FDCEP "+ Alltrim(SM0->M0_CEPENT) +" - SAC: (19) 3876 - 7900^FS" + CRLF
				cEtiq += "^FT530,620^A0B,30,29^FB590,1,0,C^FH\^FDCNPJ: "+ Transform(Alltrim(SM0->M0_CGC), "@R 99.999.999/9999-99") +" - www.alcar.com.br^FS" + CRLF
				cEtiq += "^FT560,620^A0B,30,29^FB590,1,0,C^FH\^FDMADE IN BRASIL^FS"	
				
				cEtiq += "^PQ1,0,1,Y"+ CRLF
				cEtiq += "^XZ"+ CRLF
				
			EndIf
			
			//Quebra para novas etiquetas
			If nX < nQtdEtq
				cEtiq += CRLF
			EndIf
			
			If cQtdProd == "1" .and. !Empty(ALRPCP03->CODBAR)
				cCodBar := ALRPCP03->CODBAR
			Else
			
				SLK->(dbSetOrder(2)) // LK_FILIAL + LK_CODIGO + LK_CODBAR
				SLK->(dbSeek(xFilial("SLK")+ALRPCP03->PRODUTO))
				
				While SLK->(LK_FILIAL + LK_CODIGO) == xFilial("SLK")+ALRPCP03->PRODUTO
					If cValToChar(SLK->LK_QUANT) == cQtdProd
						cCodBar := Alltrim(SLK->LK_CODBAR)
					Endif
					SLK->(DbSkip())
				EndDo
				
			Endif
			
			If Empty(cCodBar)
				//cCodBar := ">:"+ SubStr(ALRPCP03->PRODUTO, 1, 5) +">5"+  SubStr(ALRPCP03->PRODUTO, 6, 4) + ;
				//			NumSeq(@cSeq) + PADL(cQtdProd, 4, "0")
				
				cCodBar := Padr(AllTrim(ALRPCP03->PRODUTO),9) + NumSeq(@cSeq) + PADL(cQtdProd, 4, "0")
			Endif
				
			cEtiq := StrTran(cEtiq, "CODIGOBARRAS", cCodBar)
			
			IncProc()
	
			FWrite(nArq, cEtiq)
			
		Next nX
		
	Else		
		Aviso("Atenção", "Não foi possível imprimir etiqueta de produto", {"Ok"})
	Endif
	
	FClose(nArq)
	
	AtualizaContador(ALRPCP03->PRODUTO, cSeq)
	
Else
	Aviso("Atenção", "Nenhuma informação localizada", {"Ok"})
Endif

ALRPCP03->(DbCloseArea())

Return

/**
 * Rotina		:	NumSeq
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	18/10/2013
 * Descrição	:	Função responsável pela soma da numeração sequencial do produto
**/
Static Function NumSeq(cSeq)

	If Empty(cSeq) .Or. cSeq == "9999"
		cSeq := "0001"
	Else
		cSeq := Soma1(cSeq)
	Endif
 
Return cSeq

/**
 * Rotina		:	AtualizaContador
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	18/10/2013
 * Descrição	:	Função responsável pela atualização do contador do produto
**/
Static Function AtualizaContador(cProduto, cContador)

	Local cQueryUPD
	
	cQueryUPD := "UPDATE "+ RetSqlName("SB1") +" "
	cQueryUPD += "SET "
	cQueryUPD += "	B1_ZZCONT = '"+ cContador +"' "
	cQueryUPD += "WHERE "
	cQueryUPD += "	D_E_L_E_T_ = ' ' "
	cQueryUPD += "	AND B1_FILIAL = '"+ xFilial("SB1") +"' "
	cQueryUPD += "	AND B1_COD = '"+ cProduto +"' "
	
	If TcSqlExec(cQueryUPD) <> 0
		UserException(TCSQLError())
	Endif
 
Return 

/**
 * Rotina		:	PosTxtCentro
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	28/01/2015
 * Descrição	:	Função responsável por retornar a posição para centralizar o texto
**/

Static Function PosicaoTexto(cTexto)

	Local nPosTxt := 450
	
	If Len(cTexto) <= 24
		nPosTxt := 450 - (Int((24 - Len(cTexto)) / 2) * 15)
	EndIf

Return nPosTxt

/**
 * Rotina		:	AtualizaContador
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	18/10/2013
 * Descrição	:	Função responsável pela gravação dos parâmetros do relatório
**/
Static Function AjustaSX1()

/*PutSX1(cPerg, "01", "Tipo:",					"Tipo:",						"Tipo:",						"MV_PAR01", "C", 01, 0, 0, "C",,,,, 		"MV_PAR01","OP", "OP", "OP", "Estoque", "Estoque", "Estoque","Lixa","Lixa","Lixa","Cliente","Cliente","Cliente",,,,,	{"Selecione o tipo de etiqueta"},								{"Selecione o tipo de etiqueta"}, 								{"Selecione o tipo de etiqueta"})
PutSX1(cPerg, "02", "OP:",						"OP:",							"OP:",							"MV_PAR02", "C", 11, 0, 0, "G",, "SC2",,, "MV_PAR02",,,,,,,,,,,,,,,,, 																										{"Informe a OP"},													{"Informe a OP"}, 												{"Informe a OP"})
PutSX1(cPerg, "03", "Cliente:",					"Cliente:",					"Cliente:",					"MV_PAR03", "C", 06, 0, 0, "G",, "SA1",,, "MV_PAR03",,,,,,,,,,,,,,,,, 																										{"Informe o cliente da etiqueta"},								{"Informe o cliente da etiqueta"}, 							{"Informe o cliente da etiqueta"})
PutSX1(cPerg, "04", "Loja:",					"Loja:",						"Loja:",						"MV_PAR04", "C", 02, 0, 0, "G",, ,,, 		"MV_PAR04",,,,,,,,,,,,,,,,, 																										{"Informe a loja do cliente"},									{"Informe a loja do cliente"}, 									{"Informe a loja do cliente"})
PutSX1(cPerg, "05", "Produto:",					"Produto:",					"Produto:",					"MV_PAR05", "C", 15, 0, 0, "G",, "SB1",,, "MV_PAR05",,,,,,,,,,,,,,,,, 																										{"Informe o produto da etiqueta"},								{"Informe o produto da etiqueta"}, 							{"Informe o produto da etiqueta"})
PutSX1(cPerg, "06", "Quantidade:", 			"Quantidade:", 				"Quantidade:", 				"MV_PAR06", "N", 12, 4, 0, "G",,,,, 		"MV_PAR06",,,,,,,,,,,,,,,,, 																										{"Informe a quantidade para produtos do tipo INDUSTRIAL"}, 	{"Informe a quantidade para produtos do tipo INDUSTRIAL"}, 	{"Informe a quantidade para produtos do tipo INDUSTRIAL"})
PutSX1(cPerg, "07", "Número de Etiqueta(s):",	"Número de Etiqueta(s):",	"Número de Etiqueta(s):",	"MV_PAR07", "N", 04, 0, 0, "G",,,,, 		"MV_PAR07",,,,,,,,,,,,,,,,, 																										{"Informe a quantidade de etiquetas"}, 						{"Informe a quantidade de etiquetas"}, 						{"Informe a quantidade de etiquetas"})*/

	Local aParBox := {}
	
	aAdd(aParBox, {1, "Tipo:", Space(1), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "OP:", Space(11), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "Cliente:", Space(6),"@!","","","",70, .T. })
	aAdd(aParBox, {1, "Loja:", Space(2), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "Produto:", Space(15), "@E 999999999999999","","","",70, .T. })
	aAdd(aParBox, {1, "Quantidade:", Space(17), "@E 9999.999999999999","","","",70, .T. })
	aAdd(aParBox, {1, "Número de Etiqueta(s):", Space(4), "@E 9999","","","",4, .T. })


Return ParamBox(aParBox, "Etiqueta de Produto",,,,,,,,cPerg, .T., .T.)