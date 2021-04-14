#Include 'Protheus.ch'
#Include 'TopConn.ch'

/**
* Rotina		:	ALRPCP01
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Relatório de Ordem de Produção - Novo Calculo
* Módulo		:  	PCP
**/

User Function ALRPCP09()

	Local oReport := Nil
	
	Private cPerg := "ALRPCP01"

	//AjustaSX1()	

	Pergunte(cPerg, .F.)

	oReport:= ReportDef()
	oReport:PrintDialog()

Return Nil

/**
* Rotina		:	ReportDef
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Relatório de Ordem de Produção
**/
Static Function ReportDef()

	Local oReport	:= Nil
	Local oOrdem	:= Nil
	Local cTitulo 	:= "Ordem de Produção"
	Local cAjuda  	:= "Permite imprimir a Ordem de Produção da Alcar."

	oReport := TReport():New("ALRPCP01", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cAjuda)

	//Define o formato retrato 
	oReport:SetPortrait(.T.)

	//Oculta página de parâmetros
	oReport:HideParamPage()

	//Oculta o cabeçalho do relatório
	oReport:HideHeader()

	//Oculta o rodapé do relatório
	oReport:HideFooter()

	//Define o tamanho do papel - 5 (Letter)
	oReport:oPage:SetPaperSize(5)

	//Seção somente para permitir a seleção da ordem de impressão
	oOrdem := TRSection():New(oReport, "Ordem", {}, {"Ordem de Produção", "Emissão"})   

Return oReport

/**
* Rotina		:	ReportPrint
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Função responsável pela impressão da OP
**/
Static Function ReportPrint(oReport)

	Local cOpDe			:= MV_PAR01
	Local cOpAte		:= MV_PAR02
	Local cEmissaoDe	:= DTOS(MV_PAR03)
	Local cEmissaoAte	:= DTOS(MV_PAR04)
	Local cGrupo 		:= MV_PAR05
	Local cQuery 		:= ""
	Local nI			:= 0
	Local nX			:= 0
	Local nLin			:= 0
	Local nTotEsp		:= 0
	Local nTotVol		:= 0
	Local nTotPeso		:= 0
	Local aTotPeso		:= {}
	Local aOpAglut		:= {}
	Local aMistura		:= {}
	Local aMaterial 	:= {}
	Local aDescMaterial	:= {}
	Local aInstPrensa	:= {}
	Local aInstQueima	:= {}
	Local aInstQuali	:= {}
	Local aInstAcab		:= {}
	Local aInstInsp		:= {}
	Local aInstEmb		:= {}
	Local oFont10 		:= TFont():New("Arial",, 10,, .F.,,,, .F., .F.)
	Local oFont12 		:= TFont():New("Arial",, 12,, .F.,,,, .F., .F.)
	Local oFont13 		:= TFont():New("Arial",, 13,, .F.,,,, .F., .F.)
	Local oFont13N		:= TFont():New("Arial",, 13,, .T.,,,, .F., .F.)
	//Local oFont15 	:= TFont():New("Arial",, 15,, .F.,,,, .F., .F.)

	//Define o tamanho do papel - 5 (Letter)
	oReport:oPage:SetPaperSize(5)

	cQuery := "SELECT "+ CRLF
	cQuery += "		C2_NUM, C2_ITEM, C2_SEQUEN, C2_EMISSAO, C2_DATPRF, C2_PRODUTO, C2_QUANT, C2_ZZIMP, "+ CRLF
	cQuery += "		B1_DESC, B1_UM, B1_ZZMC, B1_PESO, B1_PESBRU, B1_ZZCODRM, B1_ZZDTPES, "+ CRLF
	cQuery += "		B5_ZZDGPOS, B5_ZZDGNEG, B5_ZZEQCUR, B5_ZZEQTEM, B5_ZZSETEM, B5_ZZSETPO, B5_ZZFOCUR, "+ CRLF
	cQuery += "		B5_ZZFOTEM, B5_ZZDENSQ, B5_ZZDGPES, B5_ZZDGNES, B5_ZZDUDE1, B5_ZZDUDE2, B5_ZZDUDE3, "+ CRLF
	cQuery += "		B5_ZZFUFI1, B5_ZZFUFI2, B5_ZZTOLDP, B5_ZZTOLDN, B5_ZZTOLEP, B5_ZZTOLEN, "+ CRLF
	cQuery += "		B5_ZZTOLFP, B5_ZZTOLFN, B5_ZZBALAN, B5_ZZOSRAD, B5_ZZOSAXI, B5_ZZRPMUS, "+ CRLF
	cQuery += "		B5_ZZRPM, B5_ZZRPMTS, B5_ZZPRENS, "+ CRLF
	cQuery += "		B5_ZZMIST1, B5_ZZMIST2, B5_ZZMIST3, B5_ZZMIST4, "+ CRLF
	cQuery += "		B5_ZZTPMI1, B5_ZZTPMI2, B5_ZZTPMI3, B5_ZZTPMI4, "+ CRLF
	cQuery += "		B5_ZZMOMI1, B5_ZZMOMI2, B5_ZZMOMI3, B5_ZZMOMI4, "+ CRLF
	cQuery += "		B5_ZZESMI1, B5_ZZESMI2, B5_ZZESMI3, B5_ZZESMI4, "+ CRLF
	cQuery += "		B5_ZZFUMI1, B5_ZZFUMI2, B5_ZZFUMI3, B5_ZZFUMI4, "+ CRLF
	cQuery += "		B5_ZZVOMI1, B5_ZZVOMI2, B5_ZZVOMI3, B5_ZZVOMI4, "+ CRLF
	cQuery += "		B5_ZZDVMI1, B5_ZZDVMI2, B5_ZZDVMI3, B5_ZZDVMI4, "+ CRLF
	cQuery += "		B5_ZZPEMI1, B5_ZZPEMI2, B5_ZZPEMI3, B5_ZZPEMI4, "+ CRLF
	cQuery += "		B5_ZZCPMI1, B5_ZZCPMI2, B5_ZZCPMI3, B5_ZZCPMI4, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZIMP)), '') AS B5_ZZIMP, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZINACA)), '') AS B5_ZZINACA, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZINQUA)), '') AS B5_ZZINQUA, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZININS)), '') AS B5_ZZININS, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZINEMB)), '') AS B5_ZZINEMB, "+ CRLF
	cQuery += "		ISNULL(CONVERT(VARCHAR(8000), CONVERT(BINARY(8000), B5_ZZINQUE)), '') AS B5_ZZINQUE, "+ CRLF
	cQuery += "		C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_VEND1, C5_ZZOBSOP, "+ CRLF
	cQuery += "		C6_ZZOBSOP, "+ CRLF
	cQuery += "		A1_NOME, A1_EST, "+ CRLF
	cQuery += "		A3_NOME, "+ CRLF
	cQuery += "		A7_CODCLI, A7_ZZDESCL, A7_ZZDESAL "+ CRLF
	cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlName("SB1") +" SB1 "+ CRLF
	cQuery += "			ON	SB1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND B1_FILIAL = '"+ FWFilial("SB1") +"' "+ CRLF
	cQuery += "				AND B1_COD = C2_PRODUTO "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SB5") +" SB5 "+ CRLF
	cQuery += "			ON 	SB5.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND B5_FILIAL = '"+ FWFilial("SB5") +"' "+ CRLF
	cQuery += "				AND B5_COD = B1_COD "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SC5") +" SC5 "+ CRLF
	cQuery += "			ON 	SC5.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND C5_FILIAL = C2_FILIAL "+ CRLF
	cQuery += "				AND C5_NUM = C2_PEDIDO "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SC6") +" SC6 "+ CRLF
	cQuery += "			ON	SC6.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND C5_FILIAL = C2_FILIAL "+ CRLF
	cQuery += "				AND C6_NUM = C2_PEDIDO "+ CRLF
	cQuery += "				AND C6_ITEM = C2_ITEMPV "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SA7") +" SA7 "+ CRLF
	cQuery += "			ON 	SA7.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND A7_FILIAL = '"+ FWFilial("SA7") +"' "+ CRLF
	cQuery += "				AND A7_CLIENTE = C5_CLIENTE "+ CRLF
	cQuery += "				AND A7_LOJA = C5_LOJACLI "+ CRLF
	cQuery += "				AND A7_PRODUTO = C6_PRODUTO "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SA1") +" SA1 "+ CRLF
	cQuery += "			ON 	SA1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND A1_FILIAL = '"+ FWFilial("SB1") +"' "+ CRLF
	cQuery += "				AND A1_COD = C5_CLIENTE "+ CRLF
	cQuery += "				AND A1_LOJA = C5_LOJACLI "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlName("SA3") +" SA3 "+ CRLF
	cQuery += "			ON 	SA3.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "				AND A3_FILIAL = '"+ FWFilial("SA3") +"' "+ CRLF
	cQuery += "				AND A1_COD = C5_VEND1 "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		SC2.D_E_L_E_T_ = '' "+ CRLF
	cQuery += "		AND C2_FILIAL = '"+ FWFilial("SC2") +"' "+ CRLF
	cQuery += "		AND C2_NUM+C2_ITEM+C2_SEQUEN BETWEEN '"+ cOpDe +"' AND '"+ cOpAte +"' "+ CRLF
	cQuery += "		AND C2_EMISSAO BETWEEN '"+ cEmissaoDe +"' AND '"+ cEmissaoAte +"' "+ CRLF
	cQuery += "		AND B1_TIPO = 'PA' "

	If !Empty(cGrupo)
		cQuery += "	AND B1_GRUPO = '"+ cGrupo +"' "+ CRLF
	EndIf

	cQuery += "ORDER BY "+ CRLF

	If oReport:Section(1):GetOrder() == 1
		cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN "
	Else
		cQuery += "	C2_EMISSAO, C2_NUM+C2_ITEM+C2_SEQUEN "
	Endif

	If Select("ALRPCP01") <> 0
		ALRPCP01->(dbCloseArea())
	Endif

	TcQuery cQuery Alias "ALRPCP01" New

	oReport:SetMeter(ALRPCP01->(LastRec()))

	ALRPCP01->(dbGoTop())

	While !ALRPCP01->(Eof())

		If !Empty(ALRPCP01->C2_ZZIMP)

			If !MsgYesNo("OP "+ ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN +" já impressa. Deseja imprimí-la novamente ?")
				ALRPCP01->(DbSkip())
				Loop
			EndIf 

		Endif

		//Pesquisa as OP de mistura aglutinadas	
		aOpAglut := MontaOpAglut()  
		
		//Pesquisa movimentação de mistura
		aMistura := MontaMistura() 
		
		//Pesquisa movimentação de materiais diferente de mistura
		aMaterial := MontaMaterial() 

		//Data de Emissão (Impressão da OP)
		oReport:Say(0150, 2100, DTOC(dDataBase), oFont13)

		//Emissão do Pedido de Vendas
		If !Empty(ALRPCP01->C5_EMISSAO)
		
			oReport:Say(0190, 1200, "EMISSÃO PEDIDO:", oFont13)
			oReport:Say(0190, 1600, DTOC(STOD(ALRPCP01->C5_EMISSAO)), oFont13)
		
		Endif

		//Ordem de serviço
		oReport:Say(0270, 1700, ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN, oFont13)
		
		oReport:IncRow(140)

		//Cliente
		If !Empty(ALRPCP01->C5_CLIENTE)
		
			oReport:Say(0410, 0010, ALRPCP01->C5_CLIENTE +"/"+ ALRPCP01->C5_LOJACLI, oFont13)
			oReport:Say(0460, 0010, ALRPCP01->A1_NOME, oFont13)
		
		Else
			oReport:Say(0410, 0050, "ESTOQUE", oFont13)
		Endif

		//Vendedor
		If !Empty(ALRPCP01->C5_VEND1)
			oReport:Say(0410, 0820, ALRPCP01->C5_VEND1, oFont13)
		Endif

		//UF
		If !Empty(ALRPCP01->A1_EST)
			oReport:Say(0410, 1360, ALRPCP01->A1_EST, oFont13)
		Endif

		//Data de Emissão da OP
		oReport:Say(0410, 1620, DTOC(STOD(ALRPCP01->C2_EMISSAO)), oFont13)

		//Data de Entrega da OP
		oReport:Say(0410, 2130, DTOC(STOD(ALRPCP01->C2_DATPRF)), oFont13)

		//Pedido de Vendas
		If !Empty(ALRPCP01->C5_NUM)
			oReport:Say(0490, 2130, "PV: "+ ALRPCP01->C5_NUM, oFont13)
		Endif

		//Produto Acabado
		oReport:Say(0610, 0130, AllTrim(ALRPCP01->C2_PRODUTO) + ;
		IIF(!Empty(ALRPCP01->B1_ZZCODRM), " | Cód. RM: " + AllTrim(ALRPCP01->B1_ZZCODRM), ""), oFont13)
		oReport:Say(0660, 0130, ALRPCP01->B1_DESC, oFont13)

		nLin := -50

		//Misturas Aglutinadas
		For nI := 1 To Len(aOpAglut)

			oReport:Say(0610+nLin, 1100, aOpAglut[nI], oFont13)
			
			nLin += 50 	

		Next nI

		//Peças (Quantidade)
		oReport:Say(0650, 0010, AllTrim(STR(ALRPCP01->C2_QUANT)), oFont13)

		//Unidade
		oReport:Say(0730, 0010, ALRPCP01->B1_UM, oFont13)

		//Medidas Complementares
		oReport:Say(0770, 0200, ALRPCP01->B1_ZZMC, oFont13)

		//Código do Produto no Cliente
		If !Empty(ALRPCP01->A7_CODCLI)
			oReport:Say(0560, 1650, ALRPCP01->A7_CODCLI, oFont13)
		Endif		

		//Desenho do Produto no Cliente
		If !Empty(ALRPCP01->A7_ZZDESCL)
			oReport:Say(0655, 1650, ALRPCP01->A7_ZZDESCL, oFont13)
		Endif			

		//Desenho do Produto na Alcar
		If !Empty(ALRPCP01->A7_ZZDESAL)
			oReport:Say(0660, 1650, ALRPCP01->A7_ZZDESAL, oFont13)
		Endif			

		nLin := 0

		aTotPeso := {}

		//Informações Misturas
		For nI := 1 To Len(aMistura)

			//Prensa
			oReport:Say(0895+nLin, 0020, aMistura[nI][1], oFont13N)
			//Quantidade
			oReport:Say(0895+nLin, 0235, aMistura[nI][2], oFont10)		
			//Tipo
			oReport:Say(0895+nLin, 0425, aMistura[nI][3], oFont13N)
			//Molde
			oReport:Say(0895+nLin, 0685, aMistura[nI][4], oFont13N)
			//Espessura
			oReport:Say(0895+nLin, 1055, IIF(!Empty(aMistura[nI][5]), AllTrim(Transform(GetdToVal(aMistura[nI][5]), "@E 999,999.999")), ""), oFont13N)
			//Furo
			oReport:Say(0895+nLin, 1290, aMistura[nI][6], oFont13N)
			//Volume
			oReport:Say(0895+nLin, 1570, IIF(!Empty(aMistura[nI][7]), AllTrim(Transform(GetdToVal(aMistura[nI][7]), "@E 999,999.999")), ""), oFont13N)
			//Peso
			oReport:Say(0895+nLin, 1870, AllTrim(cValToChar(IIF(aMistura[nI][8] > 0, IIF(aMistura[nI, 11] == "S", ; 
			Transform(aMistura[nI][8], "@E 999,999.999"), ""), Transform(aMistura[nI][9], "@E 999,999.999")))), oFont13N)
			//Dens. V
			oReport:Say(0895+nLin, 2110, aMistura[nI][10], oFont13N)

			nTotEsp += GetdToVal(aMistura[nI][5])
			nTotVol += GetdToVal(aMistura[nI][7])

			If aScan(aTotPeso, {|x| x[1] == aMistura[nI, 2]}) == 0
				aAdd(aTotPeso, {aMistura[nI,2], aMistura[nI,9]})
			EndIf

			nLin += 35		

		Next nI

		//Total de Peso
		nTotPeso := 0

		For nI := 1 To Len(aTotPeso)
			nTotPeso += aTotPeso[nI, 2]	
		Next nI

		oReport:Say(0920, 2340, IIF(!Empty(ALRPCP01->B5_ZZDGPOS), "+ "+ AllTrim(ALRPCP01->B5_ZZDGPOS), ""), oFont13N)
		oReport:Say(1010, 2340, IIF(!Empty(ALRPCP01->B5_ZZDGNEG), "- "+ AllTrim(ALRPCP01->B5_ZZDGNEG), ""), oFont13N)

		//Total das misturas
		If nTotVol > 0 .Or. nTotPeso > 0

			oReport:Say(1060, 0425, "Total : ", oFont12)
			oReport:Say(1060, 1055, AllTrim(Transform(nTotEsp, "@E 999,999.999")), oFont13N)
			oReport:Say(1060, 1570, AllTrim(Transform(nTotVol, "@E 999,999.999")), oFont13N)
			oReport:Say(1060, 1870, AllTrim(Transform(nTotPeso, "@E 999,999.999")), oFont13N)

		Endif

		//Informações Materiais

		//Instruções Prensa
		aInstPrensa := ConvInst(AllTrim(ALRPCP01->B5_ZZIMP), 60)

		nLin := 50

		For nI := 1 To Len(aInstPrensa)

			oReport:Say(1110+nLin, 0950, aInstPrensa[nI], oFont13)
			nLin += 50

		Next nI

		nLin := 50

		//Material
		For nI := 1 To Len(aMaterial)

			aDescMaterial := ConvInst(AllTrim(cValToChar(aMaterial[nI, 1])) +"   "+ aMaterial[nI, 2], 55) 

			For nX := 1 To Len(aDescMaterial) 

				oReport:Say(1110+nLin, 0005, aDescMaterial[nX], oFont10)
				
				nLin += 30

			Next nX

		Next nI

		//Outras informações

		//Estufa Queima - Curva
		oReport:Say(1650, 0040, ALRPCP01->B5_ZZEQCUR, oFont13)

		//Estufa Queima - Temperatura
		oReport:Say(1650, 0260, ALRPCP01->B5_ZZEQTEM, oFont13)

		//Secagem - Temperatura
		oReport:Say(1650, 0480, ALRPCP01->B5_ZZSETEM, oFont13)

		//Secagem - Tempo
		oReport:Say(1650, 0730, ALRPCP01->B5_ZZSETPO, oFont13)

		//Forno - Curva
		oReport:Say(1650, 0960, ALRPCP01->B5_ZZFOCUR, oFont13)

		//Forno - Temperatura
		oReport:Say(1650, 1190, ALRPCP01->B5_ZZFOTEM, oFont13)

		//Instruções A (Instruções Queima)
		aObsQueima := ConvInst(AllTrim(ALRPCP01->B5_ZZINQUE), 40)

		nLin := -100

		For nI := 1 To Len(aObsQueima)

			oReport:Say(1650+nLin, 1415, aObsQueima[nI], oFont13)
			nLin += 50

		Next nI

		//Densidade Q
		oReport:Say(1860, 0370, ALRPCP01->B5_ZZDENSQ, oFont13)

		//Densidade G+
		oReport:Say(1830, 0620, IIF(!Empty(ALRPCP01->B5_ZZDGPES), "+"+ALRPCP01->B5_ZZDGPES, ""), oFont13)

		//Densidade G-
		oReport:Say(1890, 0620, IIF(!Empty(ALRPCP01->B5_ZZDGNES), "- "+ALRPCP01->B5_ZZDGNES, ""), oFont13)

		//Dureza Determinada 1
		oReport:Say(1900, 0850, ALRPCP01->B5_ZZDUDE1, oFont13)

		//Dureza Determinada 2
		oReport:Say(1900, 1080, ALRPCP01->B5_ZZDUDE2, oFont13)

		//Dureza Determinada 3
		oReport:Say(1900, 1270, ALRPCP01->B5_ZZDUDE3, oFont13)

		//Instruções B (Instruções Qualidade)
		aObsQuali := ConvInst(AllTrim(ALRPCP01->B5_ZZINQUA), 40)

		nLin := -50

		For nI := 1 To Len(aObsQuali)

			oReport:Say(1870+nLin, 1400, aObsQuali[nI], oFont13)
			nLin += 50

		Next nI

		//Furo Final 1
		oReport:Say(2150, 0370, ALRPCP01->B5_ZZFUFI1, oFont13)

		//Furo Final 2
		oReport:Say(2150, 0555, ALRPCP01->B5_ZZFUFI2, oFont13)

		//Tolerância D +
		oReport:Say(2120, 0800, ALRPCP01->B5_ZZTOLDP, oFont13)

		//Tolerância D -
		oReport:Say(2170, 0800, ALRPCP01->B5_ZZTOLDN, oFont13)

		//Tolerância E +
		oReport:Say(2120, 1050, ALRPCP01->B5_ZZTOLEP, oFont13)

		//Tolerância E -
		oReport:Say(2170, 1050, ALRPCP01->B5_ZZTOLEN, oFont13)

		//Tolerância F +
		oReport:Say(2120, 1250, ALRPCP01->B5_ZZTOLFP, oFont13)

		//Tolerância F -
		oReport:Say(2170, 1250, ALRPCP01->B5_ZZTOLFN, oFont13)

		//Instruções C (Instruções Acabado)
		aObsAcab := ConvInst(AllTrim(ALRPCP01->B5_ZZINACA), 40)

		nLin := -110

		For nI := 1 To Len(aObsAcab)

			oReport:Say(2150+nLin, 1415, aObsAcab[nI], oFont13)
			nLin += 50

		Next nI	

		//Balanceamento (Balanc.)
		oReport:Say(2350, 350, ALRPCP01->B5_ZZBALAN, oFont13)


		//Oscilações Radial
		oReport:Say(2400, 550, ALRPCP01->B5_ZZOSRAD, oFont13)

		//Oscilações Axial
		oReport:Say(2400, 750, ALRPCP01->B5_ZZOSAXI, oFont13)

		//RPM
		oReport:Say(2270, 1150, ALRPCP01->B5_ZZRPM, oFont13)

		//RPM Uso
		oReport:Say(2400, 1000, ALRPCP01->B5_ZZRPMUS, oFont13)

		//M/S Teste
		oReport:Say(2400, 1200, ALRPCP01->B5_ZZRPMTS, oFont13)

		//Instruções D (Instruções Inspeção)
		aObsInsp := ConvInst(AllTrim(ALRPCP01->B5_ZZININS), 40)

		nLin := -70

		For nI := 1 To Len(aObsInsp)

			oReport:Say(2350+nLin, 1415, aObsInsp[nI], oFont13)
			nLin += 50

		Next nI	

		//Peso Líquido
		oReport:Say(2650, 1000, cValToChar(ALRPCP01->B1_PESO), oFont13)

		//Peso Bruto
		oReport:Say(2650, 1200, cValToChar(ALRPCP01->B1_PESBRU), oFont13)
		
		//Data de revisão peso
		If !Empty(ALRPCP01->B1_ZZDTPES)
			oReport:Say(2500, 1415, DToC(SToD(ALRPCP01->B1_ZZDTPES)), oFont13)
		EndIf
			
		//oReport:Say(2500, 1500,dtoc(ddatabase), oFont13)	

		//Instruções E (Instruções Embalagem)
		If !Empty(ALRPCP01->C5_NUM)

			If !Empty(ALRPCP01->C6_ZZOBSOP)
				aObsEmb := ConvInst(AllTrim(ALRPCP01->B5_ZZINEMB+ALRPCP01->C6_ZZOBSOP), 40)
			Else
				aObsEmb := ConvInst(AllTrim(ALRPCP01->B5_ZZINEMB+ALRPCP01->C5_ZZOBSOP), 40)
			Endif

		Else
			aObsEmb := ConvInst(AllTrim(ALRPCP01->B5_ZZINEMB), 40)
		Endif
				
		nLin := -90

		For nI := 1 To Len(aObsEmb)

			oReport:Say(2650+nLin, 1415, aObsEmb[nI], oFont13)
			
			nLin += 50

		Next nI		

		//Atualiza campo C2_ZZIMP com S (Indica que a OP já foi impressa)
		GravaImp(ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN)

		ALRPCP01->(DbSkip())

		If !ALRPCP01->(Eof())

			//Limpa as variáveis
			nTotEsp		:= 0
			nTotVol		:= 0
			nTotPeso	:= 0
			aOpAglut	:= {}
			aMistura	:= {}
			aMaterial 	:= {}
			aInstPrensa	:= {}
			aInstQueima	:= {}
			aInstQuali	:= {}
			aInstAcab	:= {}
			aInstInsp	:= {}
			aInstEmb	:= {}

			oReport:EndPage()
			oReport:StartPage()

		Endif	

	Enddo

	ALRPCP01->(dbCloseArea())

Return Nil

/**
* Rotina	:	MontaOpAglut
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Compõe as OP's aglutinadas
**/
Static Function MontaOpAglut()

	Local aOpAglut		:= {}

	If !Empty(ALRPCP01->B5_ZZMIST1)
		aADD(aOpAglut, BuscaOpMistura(ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN, ALRPCP01->B5_ZZMIST1))
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST2)
		aADD(aOpAglut, BuscaOpMistura(ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN, ALRPCP01->B5_ZZMIST2))
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST3)
		aADD(aOpAglut, BuscaOpMistura(ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN, ALRPCP01->B5_ZZMIST3))
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST4)
		aADD(aOpAglut, BuscaOpMistura(ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN, ALRPCP01->B5_ZZMIST4))
	Endif

Return aOpAglut

/**
* Rotina		:	MontaMistura
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Compõe as informações de mistura do produto (PA)
**/
Static Function MontaMistura()

	Local aMistura 	:= {}

	If !Empty(ALRPCP01->B5_ZZMIST1)
	
		aAdd(aMistura, {ALRPCP01->B5_ZZPRENS, ALRPCP01->B5_ZZMIST1, ALRPCP01->B5_ZZTPMI1, ALRPCP01->B5_ZZMOMI1, ;
						ALRPCP01->B5_ZZESMI1, ALRPCP01->B5_ZZFUMI1, ALRPCP01->B5_ZZVOMI1, ;
						ALRPCP01->B5_ZZPEMI1, BuscaQtd(ALRPCP01->C2_PRODUTO, ALRPCP01->B5_ZZMIST1), ; 
						ALRPCP01->B5_ZZDVMI1, ALRPCP01->B5_ZZCPMI1})
						
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST2)
	
		aAdd(aMistura, {ALRPCP01->B5_ZZPRENS, ALRPCP01->B5_ZZMIST2, ALRPCP01->B5_ZZTPMI2, ALRPCP01->B5_ZZMOMI2, ; 
						ALRPCP01->B5_ZZESMI2, ALRPCP01->B5_ZZFUMI2, ALRPCP01->B5_ZZVOMI2, ;
						ALRPCP01->B5_ZZPEMI2, BuscaQtd(ALRPCP01->C2_PRODUTO, ALRPCP01->B5_ZZMIST2), ; 
						ALRPCP01->B5_ZZDVMI2, ALRPCP01->B5_ZZCPMI2})
		 
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST3)
	
		aAdd(aMistura, {ALRPCP01->B5_ZZPRENS, ALRPCP01->B5_ZZMIST3, ALRPCP01->B5_ZZTPMI3, ALRPCP01->B5_ZZMOMI3, ;
						ALRPCP01->B5_ZZESMI3, ALRPCP01->B5_ZZFUMI3, ALRPCP01->B5_ZZVOMI3, ;
						ALRPCP01->B5_ZZPEMI3, BuscaQtd(ALRPCP01->C2_PRODUTO, ALRPCP01->B5_ZZMIST3), ;
						ALRPCP01->B5_ZZDVMI3, ALRPCP01->B5_ZZCPMI3}) 
	
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST4)
	
		aAdd(aMistura, {ALRPCP01->B5_ZZPRENS, ALRPCP01->B5_ZZMIST4, ALRPCP01->B5_ZZTPMI4, ALRPCP01->B5_ZZMOMI4, ;
						ALRPCP01->B5_ZZESMI4, ALRPCP01->B5_ZZFUMI4, ALRPCP01->B5_ZZVOMI4, ;
						ALRPCP01->B5_ZZPEMI4, BuscaQtd(ALRPCP01->C2_PRODUTO, ALRPCP01->B5_ZZMIST4), ;
						ALRPCP01->B5_ZZDVMI4, ALRPCP01->B5_ZZCPMI4}) 
	
	Endif

Return aMistura

/**
* Rotina		:	MontaMaterial
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Compõe o quadro "Material" da OP, conforme layout da Alcar
**/
Static Function MontaMaterial()

	Local cQueryMat	:= ""
	Local cMisturas	:= ""
	Local aMaterial 	:= {}

	If !Empty(ALRPCP01->B5_ZZMIST1)
		cMisturas := "'"+ ALRPCP01->B5_ZZMIST1 +"'"
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST2)
	
		If !Empty(cMisturas)
			cMisturas += ",'"+ ALRPCP01->B5_ZZMIST2 +"'"
		Else
			cMisturas := "'"+ ALRPCP01->B5_ZZMIST2 +"'"
		Endif
	
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST3)
	
		If !Empty(cMisturas)
			cMisturas += ",'"+ ALRPCP01->B5_ZZMIST3 +"'"
		Else
			cMisturas := "'"+ ALRPCP01->B5_ZZMIST3 +"'"
		Endif
	
	Endif

	If !Empty(ALRPCP01->B5_ZZMIST4)
	
		If !Empty(cMisturas)
			cMisturas += ",'"+ ALRPCP01->B5_ZZMIST4 +"'"
		Else
			cMisturas := "'"+ ALRPCP01->B5_ZZMIST4 +"'"
		Endif
	
	Endif

	If Empty(cMisturas)
		cMisturas := "''"
	Endif

	cQueryMat := "SELECT "+ CRLF
	cQueryMat += "	D4_COD, B1_DESC "+ CRLF
	cQueryMat += "FROM "+ RetSqlName("SD4") +" SD4 "+ CRLF
	cQueryMat += "	INNER JOIN "+ RetSqlName("SB1") +" SB1 "+ CRLF
	cQueryMat += "		ON 	SB1.D_E_L_E_T_ = ' ' "+ CRLF
	cQueryMat += "			AND B1_FILIAL = '"+ FWFilial("SB1") +"' "+ CRLF
	cQueryMat += "			AND B1_COD = D4_COD "+ CRLF
	cQueryMat += "WHERE "+ CRLF
	cQueryMat += "	SD4.D_E_L_E_T_ = '' "+ CRLF
	cQueryMat += "	AND D4_OP = '"+ ALRPCP01->C2_NUM+ALRPCP01->C2_ITEM+ALRPCP01->C2_SEQUEN +"' "+ CRLF
	cQueryMat += "	AND D4_COD NOT IN ("+ cMisturas +") "

	If Select("QRYMAT") <> 0
		QRYMAT->(dbCloseArea())
	Endif

	TcQuery cQueryMat Alias "QRYMAT" New

	While !QRYMAT->(Eof())

		aADD(aMaterial, {BuscaQtd(ALRPCP01->C2_PRODUTO, QRYMAT->D4_COD), AllTrim(QRYMAT->D4_COD) +"   "+ AllTrim(QRYMAT->B1_DESC)})

		QRYMAT->(DbSkip())

	Enddo

	QRYMAT->(DbCloseArea())

Return aMaterial

/**
* Rotina		:	BuscaOpMistura
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Busca as OP's de mistura que foram aglutinadas
**/
Static Function BuscaOpMistura(cOp, cMistura)

	Local cOpMistura 	:= ""
	Local cQueryOp		:= ""

	cQueryOp := "WITH OPMISTURA AS "+ CRLF
	cQueryOp += "( "+ CRLF
	cQueryOp += "		SELECT "+ CRLF
	cQueryOp += "			Z01_FILIAL, Z01_PRODUT, Z01_OPPAI, Z01_OPORIG, Z01_OPAGLU, R_E_C_N_O_ "+ CRLF
	cQueryOp += "	 	FROM "+ RetSqlName("Z01") +" "+ CRLF
	cQueryOp += "		WHERE "+ CRLF
	cQueryOp += "			D_E_L_E_T_ = '' "+ CRLF
	cQueryOp += "			AND Z01_FILIAL = '"+ xFilial("Z01") +"' "+ CRLF
	cQueryOp += "			AND Z01_OPPAI = '"+ cOp +"' "+ CRLF
	cQueryOp += "			AND Z01_PRODUT = '"+ cMistura +"' "+ CRLF
	cQueryOp += "		UNION ALL "+ CRLF
	cQueryOp += "		SELECT "+ CRLF
	cQueryOp += "			Z.Z01_FILIAL, Z.Z01_PRODUT, Z.Z01_OPPAI, Z.Z01_OPORIG, Z.Z01_OPAGLU, Z.R_E_C_N_O_ "+ CRLF
	cQueryOp += "		FROM "+ RetSqlName("Z01") +" Z, OPMISTURA M "+ CRLF
	cQueryOp += "		WHERE "+ CRLF
	cQueryOp += "			D_E_L_E_T_ = '' "+ CRLF
	cQueryOp += "			AND M.Z01_OPAGLU = Z.Z01_OPPAI "+ CRLF
	cQueryOp += "			AND M.Z01_FILIAL = Z.Z01_FILIAL "+ CRLF
	cQueryOp += ") "+ CRLF
	cQueryOp += "SELECT "+ CRLF
	cQueryOp += "		TOP 1 Z01_OPAGLU "+ CRLF
	cQueryOp += "FROM OPMISTURA "+ CRLF
	cQueryOp += "ORDER BY "+ CRLF
	cQueryOp += "		R_E_C_N_O_ DESC "

	If Select("QRYMISTURA") <> 0
		QRYMISTURA->(dbCloseArea())
	Endif

	TcQuery cQueryOp Alias "QRYMISTURA" New

	If !QRYMISTURA->(Eof())
		cOpMistura := QRYMISTURA->Z01_OPAGLU 
	Else
	
		cQueryOp := "SELECT "+ CRLF
		cQueryOp += "		C2_NUM, C2_ITEM, C2_SEQUEN "+ CRLF
		cQueryOp += "FROM "+ RetSqlName("SC2") +" SC2 "+ CRLF
		cQueryOp += "WHERE "+ CRLF
		cQueryOp += "		SC2.D_E_L_E_T_ = '' "+ CRLF
		cQueryOp += "		AND C2_FILIAL = '"+ FWFilial("SC2") +"' "+ CRLF
		cQueryOp += "		AND C2_NUM+C2_ITEM = '"+ SubStr(cOp, 1, 8) +"' "+ CRLF
		cQueryOp += "		AND C2_PRODUTO = '"+ cMistura +"' "

		If Select("QRYMISTURA2") <> 0
			QRYMISTURA2->(dbCloseArea())
		Endif

		TcQuery cQueryOp Alias "QRYMISTURA2" New

		If !QRYMISTURA2->(Eof())
			cOpMistura := QRYMISTURA2->C2_NUM+QRYMISTURA2->C2_ITEM+QRYMISTURA2->C2_SEQUEN 
		Endif	

		QRYMISTURA2->(DbCloseArea())

	Endif

	QRYMISTURA->(DbCloseArea())

Return cOpMistura

/**
* Rotina	:	BuscaQtd
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Busca a quantidade do produto (PI) na estrutura do produto (PA)
**/
Static Function BuscaQtd(cProduto, cMistura)

	Local cQueryQtd := ""
	Local nQtdProd	:= 0

	cQueryQtd := "SELECT "+ CRLF
	cQueryQtd += "	G1_QUANT "+ CRLF
	cQueryQtd += "FROM "+ RetSqlName("SG1") +" "+ CRLF
	cQueryQtd += "WHERE "+ CRLF
	cQueryQtd += "	D_E_L_E_T_ = ' ' "+ CRLF
	cQueryQtd += "	AND G1_FILIAL = '"+ xFilial("SG1") +"' "+ CRLF
	cQueryQtd += "	AND G1_COD = '"+ cProduto +"' "+ CRLF
	cQueryQtd += "	AND G1_COMP = '"+ cMistura +"' "

	If Select("QRYQTD") <> 0
		QRYQTD->(dbCloseArea())
	Endif

	TcQuery cQueryQtd Alias "QRYQTD" New

	If !QRYQTD->(Eof())
		nQtdProd := QRYQTD->G1_QUANT
	Endif

	QRYQTD->(DbCloseArea())

Return nQtdProd

/**
* Rotina		:	ConvInst
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Converte a observação em um array no tamanho definido no parâmetro nTam
**/
Static Function ConvInst(cObs, nTam)

	Local aObs := {}

	While Len(cObs) > 0
	
		aAdd(aObs, SubStr(cObs, 1, nTam))
	
		cObs := SubStr(cObs, nTam+1, Len(cObs))
	
	Enddo

Return aObs

/**
* Rotina		:	GravaImp
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		:	04/10/2013
* Descrição	:	Grava que a OP já foi impressa
**/
Static Function GravaImp(cOp)

	Local cQueryUpd := ""

	cQueryUpd := "UPDATE "+ RetSqlName("SC2") +" "+ CRLF
	cQueryUpd += "SET C2_ZZIMP = 'S' "+ CRLF
	cQueryUpd += "WHERE "+ CRLF
	cQueryUpd += "	D_E_L_E_T_ = '' "+ CRLF
	cQueryUpd += "	AND C2_FILIAL = '"+ FWFilial("SC2") +"' "+ CRLF
	cQueryUpd += "	AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+ cOp +"' "

	If TcSqlExec(cQueryUpd) <> 0
		UserException(TCSQLError())
	Endif

Return Nil

/**
* Rotina		:	AjustaSX1
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		    : 	04/10/2013
* Descrição	:	Inclusão dos parâmetros do relatório
**/
Static Function AjustaSX1()

	/*PutSX1(cPerg, "01", "OP de:",		"OP de:",			"OP de:",			"MV_PAR01", "C", 11, 0, 0, "G",, "SC2",,,	"MV_PAR01",,,,,,,,,,,,,,,,, {"Informe a OP inicial"},		{"Informe a OP inicial"}, 		{"Informe a OP inicial"})
	PutSX1(cPerg, "02", "OP até:",		"OP até:",			"OP até:",			"MV_PAR02", "C", 11, 0, 0, "G",, "SC2",,,	"MV_PAR02",,,,,,,,,,,,,,,,, {"Informe a OP final"}, 			{"Informe a OP final"}, 			{"Informe a OP final"})
	PutSX1(cPerg, "03", "Emissão de:", "Emissão de:", 	"Emissão de:", 	"MV_PAR03", "D", 08, 0, 0, "G",,,,, 		"MV_PAR03",,,,,,,,,,,,,,,,, {"Informe a emissão inicial"}, 	{"Informe a emissão inicial"}, 	{"Informe a emissão inicial"})
	PutSX1(cPerg, "04", "Emissão até:","Emissão até:",	"Emissão até:",	"MV_PAR04", "D", 08, 0, 0, "G",,,,, 		"MV_PAR04",,,,,,,,,,,,,,,,, {"Informe a emissão final"}, 	{"Informe a emissão final"}, 	{"Informe a emissão final"})
	PutSX1(cPerg, "05", "Grupo:",		"Grupo:",			"Grupo:",			"MV_PAR05", "C", 04, 0, 0, "G",, "SBM",,,	"MV_PAR05",,,,,,,,,,,,,,,,, {"Informe o grupo do produto"},	{"Informe o grupo do produto"},	{"Informe o grupo do produto"})*/
	
	Local aParBox := {}
	
	
	aAdd(aParBox, {1, "OP de:", Space(11), "@!",,"SC2", ,11, .T. })
	aAdd(aParBox, {1, "OP até:", Space(11),"@!",,"SC2", ,11, .T. })
	aAdd(aParBox, {1, "Emissão de:", Space(8), "99/99/99",,, ,8, .T. })
	aAdd(aParBox, {1, "Emissão até:", Space(8), "99/99/99",,, ,8, .T. })
	aAdd(aParBox, {1, "Grupo:", Space(4), "@!",,"SBM", ,4, .T. })
	
	

Return ParamBox(aParBox, "Relatório de Ordem de Produção",,,,,,,,cPerg, .T., .T.)
