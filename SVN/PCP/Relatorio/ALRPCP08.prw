#Include "Protheus.ch"

/*/{Protheus.doc} ALRPCP08

Impressão de etiqueta, baseado na rotina ALRPCP03

@author Ectore Cecato - Totvs IP Jundiaí
@since 17/01/2017
@version Protheus 12 - Estoque

/*/

User Function ALRPCP08()

	Local aSays		:= {}
	Local aButtons	:= {}
	Local lImprime	:= .F.
	Local cPerg		:= "ALRPCP08"

	AjustaSX1(cPerg)

	Aadd(aSays, "Rotina responsável por imprimir etiquetas de ordem de produção")
	Aadd(aSays, "Clique no botão Imprimir para continuar")

	Aadd(aButtons, {5, 	.T., {|| Pergunte(cPerg, .T.)}})
	Aadd(aButtons, {6, 	.T., {|o| lImprime := .T., o:oWnd:End()}})
	Aadd(aButtons, {2, 	.T., {|o| o:oWnd:End()}})

	FormBatch("Impressão de Etiquetas (Sem Logo)", aSays, aButtons,, 200, 400)

	If lImprime
		Processa({|| ImpEtq()}, "Aguarde", "Imprimindo etiquetas", .F.)
	Endif

Return

/*
	Função responsável pela impressão da etiqueta
*/

Static Function ImpEtq()

	Local cAliasQry		:= GetNextAlias()
	Local cTipoEtq		:= ""
	Local cQuery 		:= ""
	Local cEtiq			:= ""
	Local cValid		:= ""
	Local cQtdProd		:= ""
	Local cCodBar		:= ""
	Local cTipoProd		:= ""
	Local cDirEtq		:= "C:\Protheus"
	Local cArqEtq		:= cDirEtq +"\Etiqueta.txt"
	Local cArqBatEtq	:= cDirEtq +"\ImprimirEtiqueta.bat"
	Local cSeq			:= ""
	Local cOp 			:= MV_PAR02
	Local cCliente		:= MV_PAR03
	Local cLoja			:= MV_PAR04
	Local cProduto		:= MV_PAR05
	Local nQuant		:= MV_PAR06
	Local nQtdEtq 		:= MV_PAR07
	Local nArq			:= 0
	Local nX 			:= 0
	Local nPosTxt1		:= 0
	Local nPosTxt2		:= 0
	Local nPosTxt3		:= 0

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

		cQuery := "SELECT "+ CRLF
		cQuery += "		C2_NUM+C2_ITEM+C2_SEQUEN AS OP, C2_PRODUTO AS PRODUTO, C2_PEDIDO AS PEDIDO, C2_ITEMPV AS ITEM_PEDIDO, "+ CRLF
		cQuery += "		B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_ZZCBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, "+ CRLF
		cQuery += "		ISNULL(B5_QE1, 0) AS QTD_EMB, "+ CRLF
		cQuery += "		ISNULL(A1_NOME, '') AS NOME_CLIENTE, "+ CRLF
		cQuery += "		ISNULL(A7_CODCLI, '') AS PROD_CLIENTE, ISNULL(A7_ZZDESCL, '') AS DESENHO, "+ CRLF
		cQuery += "		ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "+ CRLF
		cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "+ CRLF
		cQuery += "		INNER JOIN "+ RetSqlName("SB1") +" SB1 "+ CRLF
		cQuery += "			ON 	SB1.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND B1_FILIAL = '"+ xFilial("SB1") +"' "+ CRLF
		cQuery += "				AND B1_COD = C2_PRODUTO "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SB5") +" SB5 "+ CRLF
		cQuery += "			ON 	SB5.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND B5_FILIAL = '"+ xFilial("SB5") +"' "+ CRLF
		cQuery += "				AND B5_COD = B1_COD "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SC5") +" SC5 "+ CRLF
		cQuery += "			ON 	SC5.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND C5_FILIAL = C2_FILIAL "+ CRLF
		cQuery += "				AND C5_NUM = C2_PEDIDO "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SC6") +" SC6 "+ CRLF
		cQuery += "			ON 	SC6.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND C6_FILIAL = C5_FILIAL "+ CRLF
		cQuery += "				AND C6_NUM = C5_NUM "+ CRLF
		cQuery += "				AND C6_CLI = C5_CLIENTE "+ CRLF
		cQuery += "				AND C6_LOJA = C5_LOJACLI "+ CRLF
		cQuery += "				AND C6_ITEM = C2_ITEMPV "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SA1") +" SA1 "+ CRLF
		cQuery += "			ON 	SA1.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND A1_FILIAL = '"+ xFilial("SA1") +"' "+ CRLF
		cQuery += "				AND A1_COD = C5_CLIENTE "+ CRLF
		cQuery += "				AND A1_LOJA = C5_LOJACLI "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SA7") +" SA7 "+ CRLF
		cQuery += "			ON 	SA7.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND A7_FILIAL = '"+ xFilial("SA7") +"' "+ CRLF
		cQuery += "				AND A7_CLIENTE = C5_CLIENTE "+ CRLF
		cQuery += "				AND A7_LOJA = C5_LOJACLI "+ CRLF
		cQuery += "				AND A7_PRODUTO = C6_PRODUTO "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SBM") +" SBM "+ CRLF
		cQuery += "			ON 	SBM.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND BM_FILIAL = '"+ xFilial("SBM") +"' "+ CRLF
		cQuery += "				AND BM_GRUPO = B1_GRUPO "+ CRLF
		cQuery += "WHERE "+ CRLF
		cQuery += "		SC2.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "		AND C2_FILIAL = '"+ xFilial("SC2") +"' "+ CRLF
		cQuery += "		AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+ cOp +"' "

	ElseIf cTipoEtq == "ESTOQUE" .Or. cTipoEtq == "CLIENTE" 

		cQuery := "SELECT "+ CRLF
		cQuery += "		'' AS OP, B1_COD AS PRODUTO, '' AS PEDIDO, '' AS ITEM_PEDIDO, "+ CRLF
		cQuery += "		B1_DESC AS DESC_PROD, B1_UM AS UM_PROD, B1_ZZCBAR AS CODBAR, B1_ZZCONT AS CONTADOR, B1_ZZTPMAT AS TIPO_MAT, "+ CRLF 
		cQuery += "		ISNULL(B5_QE1, 0) AS QTD_EMB, "+ CRLF
		cQuery += "		'"+ IIF(cTipoEtq == "ESTOQUE", "ESTOQUE", Posicione("SA1", 1, xFilial("SA1") + cCliente + cLoja, "SA1->A1_NREDUZ")) +"' AS NOME_CLIENTE, "+ CRLF
		cQuery += "		'' AS PROD_CLIENTE, '' AS DESENHO, "+ CRLF
		cQuery += "		ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "+ CRLF
		cQuery += "FROM "+ RetSqlName("SB1") +" SB1 "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SB5") +" SB5 "+ CRLF
		cQuery += "			ON 	SB5.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND B5_FILIAL = '"+ xFilial("SB5") +"' "+ CRLF
		cQuery += "				AND B5_COD = B1_COD "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SBM") +" SBM "+ CRLF
		cQuery += "			ON 	SBM.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND BM_FILIAL = '"+ xFilial("SBM") +"' "+ CRLF
		cQuery += "				AND BM_GRUPO = B1_GRUPO "+ CRLF
		cQuery += "WHERE "+ CRLF
		cQuery += "		SB1.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "		AND B1_FILIAL = '"+ xFilial("SB1") +"' "+ CRLF
		cQuery += "		AND B1_COD = '"+ cProduto +"' " 	

	Else 

		cQuery := "SELECT "+ CRLF
		cQuery += "		B1_COD AS PRODUTO, B1_ZZDCETQ AS DESC_PROD, B1_ZZCONT AS CONTADOR, B1_ZZTAMFL AS TAM_LIXA, B1_ZZQTDFL AS QTD_LIXA, "+ CRLF
		cQuery += "		ISNULL(B5_QE1, 0) AS QTD_EMB, "+ CRLF
		cQuery += "		ISNULL(BM_GRUPO, '') AS GRUPO, ISNULL(BM_DESC, '') AS DESCGRP "+ CRLF
		cQuery += "FROM "+ RetSqlName("SB1") +" SB1 "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SB5") +" SB5 "+ CRLF
		cQuery += "			ON 	SB5.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND B5_FILIAL = '"+ xFilial("SB5") +"' "+ CRLF
		cQuery += "				AND B5_COD = B1_COD "+ CRLF
		cQuery += "		LEFT JOIN "+ RetSqlName("SBM") +" SBM "+ CRLF
		cQuery += "			ON 	SBM.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "				AND BM_FILIAL = '"+ xFilial("SBM") +"' "+ CRLF
		cQuery += "				AND BM_GRUPO = B1_GRUPO "+ CRLF
		cQuery += "WHERE "+ CRLF
		cQuery += "		SB1.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "		AND B1_FILIAL = '"+ xFilial("SB1") +"' "+ CRLF
		cQuery += "		AND B1_COD = '"+ cProduto +"' " 

	EndIf

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	If !(cAliasQry)->(Eof())

		ProcRegua(nQtdEtq)

		cSeq := (cAliasQry)->CONTADOR

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
					cQtdProd := AllTrim(cValToChar((cAliasQry)->QTD_EMB))
				Endif

				If cTipoEtq == "LIXA"

					nPosTxt1 := PosicaoTexto(AllTrim((cAliasQry)->DESC_PROD))
					nPosTxt2 := PosicaoTexto("CONTEM "+ AllTrim((cAliasQry)->QTD_LIXA) +" FOLHAS")
					nPosTxt3 := PosicaoTexto(AllTrim((cAliasQry)->TAM_LIXA))

					cEtiq := "^XA"+ CRLF
					cEtiq += "^MMT"+ CRLF
					cEtiq += "^PW500"+ CRLF
					cEtiq += "^LL0350"+ CRLF
					cEtiq += "^LS0"+ CRLF
					cEtiq += "^FT220,"+ cValToChar(nPosTxt1) +"^A0B,28,28,^FH\^FD"+ AllTrim((cAliasQry)->DESC_PROD) +"^FS"+ CRLF
					cEtiq += "^FT260,"+ cValToChar(nPosTxt2) +"^A0B,28,28^FH\^FDCONTEM "+ AllTrim((cAliasQry)->QTD_LIXA) +" FOLHAS^FS"+ CRLF
					cEtiq += "^FT300,"+ cValToChar(nPosTxt3) +"^A0B,28,28^FH\^FD"+ AllTrim((cAliasQry)->TAM_LIXA) +"^FS"+ CRLF
					cEtiq += "^BY2,3,82^FT360,420^BCB,,Y,N"+ CRLF
					cEtiq += "^FD>CODIGOBARRAS^FS"+ CRLF
					cEtiq += "^PQ1,0,1,Y^XZ"+ CRLF

				Else

					If (cAliasQry)->TIPO_MAT == "V"
						cValid := "S/ VALID."
					Elseif (cAliasQry)->TIPO_MAT == "R"
						cValid := StrZero(Month(dDataBase)-5, 2)+"/"+ AllTrim(Str(Year(dDataBase)+3))
					Else
						cValid := ""
					Endif

					If (cAliasQry)->GRUPO == "0512" .Or. "PADRAO" $ (cAliasQry)->DESCGRP .Or. "PAD." $ (cAliasQry)->DESCGRP 
						cTipoProd := "P-"
					ElseIf "INDUSTRIAL" $ (cAliasQry)->DESCGRP .Or. "IND." $ (cAliasQry)->DESCGRP
						cTipoProd := "I-"
					Else
						cTipoProd := " -"
					EndIf

					cEtiq := "^XA"+ CRLF
					cEtiq += "^MMT"+ CRLF
					cEtiq += "^PW559"+ CRLF
					cEtiq += "^LL0959"+ CRLF
					cEtiq += "^LS0"+ CRLF
					cEtiq += "^FT528,937^A0B,26,25^FH\^FD^FS"+ CRLF
					cEtiq += "^FT490,939^A0B,50,49^FH\^FD^FS"+ CRLF
					cEtiq += "^FT371,153^A0B,31,31^FH\^FDMADE IN^FS"+ CRLF
					cEtiq += "^FT409,153^A0B,31,31^FH\^FD BRAZIL^FS"+ CRLF
					cEtiq += "^FT364,423^A0B,20,19^FH\^FDOS No.^FS"+ CRLF
					cEtiq += "^FT364,668^A0B,20,19^FH\^FDPEDIDO / ORDER^FS"+ CRLF
					cEtiq += "^FT364,930^A0B,20,19^FH\^FDEMBALADO / PACKED^FS"+ CRLF
					cEtiq += "^FT290,668^A0B,20,19^FH\^FDC\E3D. DESENHO / DRAW CODE^FS"+ CRLF
					cEtiq += "^FT290,940^A0B,20,19^FH\^FDQTDE. / QUANTITY^FS#$D^FT521,189^A0B,39,38^FH\^FD"+ AllTrim(cValid) +"^FS"+ CRLF
					cEtiq += "^FT479,209^A0B,39,38^FH\^FDVALIDADE:^FS"+ CRLF
					cEtiq += "^FT218,930^A0B,20,19^FH\^FDPRODUTO / PRODUCT^FS"+ CRLF
					cEtiq += "^FT114,930^A0B,20,19^FH\^FDC\E3DIGO / CODE^FS"+ CRLF
					cEtiq += "^FT190,930^A0B,100,100^FH\^FD"+ cTipoProd + AllTrim((cAliasQry)->PRODUTO) +"^FS"+ CRLF
					cEtiq += "^FT403,423^A0B,39,38^FH\^FD"+ AllTrim((cAliasQry)->OP)+ "^FS"+ CRLF
					cEtiq += "^FT403,668^A0B,39,38^FH\^FD"+ IIF(!Empty((cAliasQry)->PEDIDO+(cAliasQry)->ITEM_PEDIDO), AllTrim((cAliasQry)->PEDIDO) +"/"+ AllTrim((cAliasQry)->ITEM_PEDIDO), "") +"^FS"+ CRLF
					cEtiq += "^FT403,930^A0B,39,38^FH\^FD"+ DtoC(dDataBase) +"^FS"+ CRLF
					cEtiq += "^FT331,668^A0B,39,38^FH\^FD"+ IIF(!Empty((cAliasQry)->PROD_CLIENTE), AllTrim((cAliasQry)->PROD_CLIENTE) +" - "+ AllTrim((cAliasQry)->DESENHO), "ESTOQUE") +"^FS"+ CRLF
					cEtiq += "^FT331,930^A0B,39,38^FH\^FD"+ AllTrim(cQtdProd)+ "  "+ AllTrim((cAliasQry)->UM_PROD) +"^FS"+ CRLF
					cEtiq += "^FT257,930^A0B,39,38^FH\^FD"+ AllTrim((cAliasQry)->DESC_PROD) +"^FS"+ CRLF
					cEtiq += "^FT83,930^A0B,51,50^FH\^FD"+ AllTrim((cAliasQry)->NOME_CLIENTE) +"^FS"+ CRLF
					cEtiq += "^FT39,930^A0B,20,19^FH\^FDCLIENTE / CUSTOMER^FS"+ CRLF
					cEtiq += "^FO343,184^GB67,0,4^FS"+ CRLF
					cEtiq += "^FO343,429^GB67,0,4^FS"+ CRLF
					cEtiq += "^FO268,674^GB146,0,4^FS"+ CRLF
					cEtiq += "^FO412,8^GB0,944,4^FS"+ CRLF
					cEtiq += "^FO340,8^GB0,944,5^FS"+ CRLF
					cEtiq += "^FO266,8^GB0,944,4^FS"+ CRLF
					cEtiq += "^FO193,8^GB0,944,4^FS"+ CRLF
					cEtiq += "^FO91,8^GB0,944,4^FS"+ CRLF
					cEtiq += "^BY2,2,100^FT524,650^BCB,,Y,N"+ CRLF
					cEtiq += "^FD>CODIGOBARRAS^FS"+ CRLF
					cEtiq += "^BY2,2,75^FT172,270^BCB,,Y,N"+ CRLF
					cEtiq += "^FD>;"+ AllTrim((cAliasQry)->CODBAR) +"^FS"+ CRLF
					cEtiq += "^PQ1,0,1,Y"+ CRLF
					cEtiq += "^XZ"+ CRLF

				EndIf

				//Quebra para novas etiquetas
				If nX < nQtdEtq
					cEtiq += CRLF
				EndIf

				cCodBar := ":"+ SubStr((cAliasQry)->PRODUTO, 1, 5) +">5"+  SubStr((cAliasQry)->PRODUTO, 6, 4) + ;
						   NumSeq(@cSeq) + PADL(cQtdProd, 4, "0")

				cEtiq := StrTran(cEtiq, "CODIGOBARRAS", cCodBAr)

				IncProc()

				FWrite(nArq, cEtiq)

			Next nX

		Else		
			Aviso("Atenção", "Não foi possível imprimir etiqueta de produto", {"Ok"})
		Endif

		FClose(nArq)

		AtualizaContador((cAliasQry)->PRODUTO, cSeq)

	Else
		Aviso("Atenção", "Nenhuma informação localizada", {"Ok"})
	Endif

	(cAliasQry)->(DbCloseArea())

Return Nil

/*
	Função responsável pela soma da numeração sequencial do produto
*/

Static Function NumSeq(cSeq)

	If Empty(cSeq) .Or. cSeq == "9999"
		cSeq := "0001"
	Else
		cSeq := Soma1(cSeq)
	Endif

Return cSeq

/*
	Função responsável pela atualização do contador do produto
*/

Static Function AtualizaContador(cProduto, cContador)

	Local cQuery := ""

	cQuery := "UPDATE "+ RetSqlName("SB1") +" "
	cQuery += "SET "
	cQuery += "		B1_ZZCONT = '"+ cContador +"' "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND B1_FILIAL = '"+ xFilial("SB1") +"' "
	cQuery += "		AND B1_COD = '"+ cProduto +"' "

	If TcSqlExec(cQuery) <> 0
		UserException(TCSQLError())
	Endif

Return Nil

/*
	Função responsável por retornar a posição para centralizar o texto
*/

Static Function PosicaoTexto(cTexto)

	Local nPosTxt := 450

	If Len(cTexto) <= 24
		nPosTxt := 450 - (Int((24 - Len(cTexto)) / 2) * 15)
	EndIf

Return nPosTxt

/*
	Função responsável pela gravação dos parâmetros do relatório
*/

Static Function AjustaSX1(cPerg)

	/*PutSX1(cPerg, "01", "Tipo:",					"Tipo:",					"Tipo:",					"MV_PAR01", "C", 01, 0, 0, "C",,,,, 		"MV_PAR01","OP", "OP", "OP", "Estoque", "Estoque", "Estoque","Lixa","Lixa","Lixa","Cliente","Cliente","Cliente",,,,,	{"Selecione o tipo de etiqueta"},							{"Selecione o tipo de etiqueta"}, 							{"Selecione o tipo de etiqueta"})
	PutSX1(cPerg, "02", "OP:",						"OP:",						"OP:",						"MV_PAR02", "C", 11, 0, 0, "G",, "SC2",,, 	"MV_PAR02",,,,,,,,,,,,,,,,, 																							{"Informe a OP"},											{"Informe a OP"}, 											{"Informe a OP"})
	PutSX1(cPerg, "03", "Cliente:",					"Cliente:",					"Cliente:",					"MV_PAR03", "C", 06, 0, 0, "G",, "SA1",,, 	"MV_PAR03",,,,,,,,,,,,,,,,, 																							{"Informe o cliente da etiqueta"},							{"Informe o cliente da etiqueta"}, 							{"Informe o cliente da etiqueta"})
	PutSX1(cPerg, "04", "Loja:",					"Loja:",					"Loja:",					"MV_PAR04", "C", 02, 0, 0, "G",, ,,, 		"MV_PAR04",,,,,,,,,,,,,,,,, 																							{"Informe a loja do cliente"},								{"Informe a loja do cliente"}, 								{"Informe a loja do cliente"})
	PutSX1(cPerg, "05", "Produto:",					"Produto:",					"Produto:",					"MV_PAR05", "C", 15, 0, 0, "G",, "SB1",,,	"MV_PAR05",,,,,,,,,,,,,,,,, 																							{"Informe o produto da etiqueta"},							{"Informe o produto da etiqueta"}, 							{"Informe o produto da etiqueta"})
	PutSX1(cPerg, "06", "Quantidade:", 				"Quantidade:", 				"Quantidade:", 				"MV_PAR06", "N", 12, 4, 0, "G",,,,, 		"MV_PAR06",,,,,,,,,,,,,,,,, 																							{"Informe a quantidade para produtos do tipo INDUSTRIAL"}, 	{"Informe a quantidade para produtos do tipo INDUSTRIAL"}, 	{"Informe a quantidade para produtos do tipo INDUSTRIAL"})
	PutSX1(cPerg, "07", "Número de Etiqueta(s):",	"Número de Etiqueta(s):",	"Número de Etiqueta(s):",	"MV_PAR07", "N", 04, 0, 0, "G",,,,, 		"MV_PAR07",,,,,,,,,,,,,,,,, 																							{"Informe a quantidade de etiquetas"}, 						{"Informe a quantidade de etiquetas"}, 						{"Informe a quantidade de etiquetas"})*/
	
	
	Local aParBox := {}
	
	aAdd(aParBox, {1, "Tipo:", Space(1), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "OP:", Space(11), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "Cliente:", Space(6),"@!","","","",70, .T. })
	aAdd(aParBox, {1, "Loja:", Space(2), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "Produto:", Space(15), "@E 999999999999999","","","",70, .T. })
	aAdd(aParBox, {1, "Quantidade:", Space(17), "@E 9999.999999999999","","","",70, .T. })
	aAdd(aParBox, {1, "Número de Etiqueta(s):", Space(4), "@E 9999","","","",4, .T. })
	

Return ParamBox(aParBox, "Etiqueta de Produto",,,,,,,,cPerg, .T., .T.)