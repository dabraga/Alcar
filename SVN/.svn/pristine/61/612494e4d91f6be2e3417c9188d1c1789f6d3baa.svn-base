#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "TbiConn.ch"

#Define NOTA	1
#Define SERIE	2
#Define	CLIFOR	3
#Define LOJA	4
#Define NOME	5
#Define ITEM	6
#Define VALOR	7
#Define EMISSAO	8

/*/{Protheus.doc} ALAPCP03

Rotina responsável pela geração do custo das esruturas de produto

@author Ectore Cecato - Totvs IP Jundiaí
@since 24/11/2016
@version Protheus 12 - PCP

/*/

User Function ALAPCP03(aEmpFil)
	
	Local aSays		:= {}
	Local aButtons	:= {}
	Local lProcess	:= .F.
	Local cFile 	:= ""
	Local cPerg		:= "ALAPCP03"
	
	Private cCodPA	:= ""
	Private cDescPA	:= ""
	Private nValue	:= 0
	Private nTotal	:= 0
	
	Default aEmpFil := {"01", "01"}
	
	If IsBlind()
		
		RpcClearEnv()
		RpcSetType(3)    	
    	
	   	PREPARE ENVIRONMENT EMPRESA aEmpFil[1] FILIAL aEmpFil[2]
	    	
	    	MV_PAR01 := Space(15)
	    	MV_PAR02 := "ZZZZZZZZZZZZZZZ"
	    	
	    	ConOut("[Custo Produto] - Inicio: "+ DToC(dDataBase) +" - "+ Time())
	    	
	   		GenerateCostPS(.T.)
	    	
	    	ConOut("[Custo Produto] Fim: "+ DToC(dDataBase) +" - "+ Time())
	    	
	   	RESET ENVIRONMENT
	   		
	Else
	
		AjustaSX1(cPerg)
		
		Pergunte(cPerg, .F.)
		
		Aadd(aSays, "Rotina responsável por gerar as informações de custo das estruturas ")
		Aadd(aSays, "de produtos da Alcar")
		
		Aadd(aButtons, {5, 	.T., {|| Pergunte(cPerg, .T.)}})
		Aadd(aButtons, {1, 	.T., {|o| lProcess := .T., o:oWnd:End()}})
		Aadd(aButtons, {2, 	.T., {|o| lProcess := .F., o:oWnd:End()}})
		
		FormBatch("Custo da Estrutura de Produto", aSays, aButtons)
			
		If lProcess
			Processa({|| GenerateCostPS(.F.)}, "Gerando custo da(s) estrutura(s)") 
		EndIf
	
	EndIf
		
Return Nil

/*
	Função responsável pela geração do custo da estrutura
*/
Static Function GenerateCostPS(lJob)
	
	ProcRegua(0)
	
	ProdWithStructure(lJob)
	
	ProdWithoutStructure(lJob)
	
Return Nil

/*
	Função responsável pela geração do custo dos produtos PA com estrutura
*/
Static Function ProdWithStructure(lJob)
	
	Local aArea			:= Lj7GetArea({"SG1", "SB1"})
	Local aSale			:= {}
	Local cProduct 		:= ""
	Local nLevel   		:= 0
	Local lContinue 	:= .T.
	Local cCOdUsu       := UsrRetName(RetCodUsr())
	
	Private lNegEstr := GETMV("MV_NEGESTR")
	
	DbSelectArea("SG1")
	
	DbSetOrder(1)
	
	MsSeek(xFilial("SG1")+MV_PAR01, .T.)
	
	If !lJob
		ProcRegua(0)
	EndIf
	
	While !Eof() .And. SG1->G1_FILIAL == xFilial("SG1") .And. SG1->G1_COD >= MV_PAR01 .And. SG1->G1_COD <= MV_PAR02 
		
		cProduct  	:= SG1->G1_COD
		nLevel    	:= 2
	    lContinue 	:= .T.
	    nTotal		:= 0
	    
	    DbSelectArea("SB1")
	    
	    MsSeek(xFilial("SB1")+cProduct)
		
	    If Eof() .Or. SB1->B1_TIPO != "PA"
		
			DbSelectArea("SG1")
			
			While !Eof() .And. xFilial("SG1")+cProduct == SG1->G1_FILIAL+SG1->G1_COD
				
				DbSkip()
				
			EndDo
			
			lContinua := .F.
			
		EndIf
				
		If lContinue
			
			cCodPA  := SG1->G1_COD
			cDescPA := AllTrim(SB1->B1_DESC)
			 
			DeleteProductStructure(cProduct)
			
			SaleComponent(@aSale, SG1->G1_COD)
			
			//Grava informações do nível 1 - PA
			RecLock("Z04", .T.)
				Z04->Z04_FILIAL := xFilial("Z04")
				Z04->Z04_PROD 	:= cCodPA
				Z04->Z04_DESCPR := cDescPA
				Z04->Z04_TIPO 	:= SB1->B1_TIPO
				Z04->Z04_UM 	:= SB1->B1_UM
				Z04->Z04_NIVEL 	:= "001"
				Z04->Z04_QUANT 	:= 1
				Z04->Z04_USER	:= cCodUsu//UsrRetName(RetCodUsr())
				Z04->Z04_DATA	:= dDataBase
				Z04->Z04_GRUPO	:= SB1->B1_GRUPO
				Z04->Z04_NFSAI	:= aSale[NOTA]
				Z04->Z04_SERIES	:= aSale[SERIE]
				Z04->Z04_EMINFS	:= aSale[EMISSAO]
				Z04->Z04_CLIENT := aSale[CLIFOR]
				Z04->Z04_LOJACL	:= aSale[LOJA]
				Z04->Z04_NOMCLI	:= aSale[NOME]
				Z04->Z04_ITNFS	:= aSale[ITEM]
				Z04->Z04_VENDA	:= aSale[VALOR]					
			Z04->(MsUnlock())
			
			//Grava informações dos outros níveis
			ExplSG1(cProduct, IIf(RetFldProd(SB1->B1_COD, "B1_QB") == 0, 1, RetFldProd(SB1->B1_COD, "B1_QB")), nLevel, ;
					RetFldProd(SB1->B1_COD, "B1_OPC"), IIf(RetFldProd(SB1->B1_COD, "B1_QB") == 0, 1, RetFldProd(SB1->B1_COD, "B1_QB")), ;
					SB1->B1_REVATU)
	
		EndIf
		
		UpdatePA(cCodPA)
		
		DbSelectArea("SG1")

	EndDo

	Lj7RestArea(aArea)
	
Return Nil

/*
	Função responsável pela geração do custo dos produtos PA sem estrutura
*/
Static Function ProdWithoutStructure(lJob)
	
	Local aCost		:= {}
	Local aSale		:= {}
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local cCodUsu   := UsrRetName(RetCodUsr())
	
	cQuery := "SELECT "
	cQuery += "		B1_COD, B1_DESC, B1_GRUPO, B1_UM, B1_TIPO "
	cQuery += "FROM "+ RetSqlName("SB1") +" SB1 "
	cQuery += "		LEFT JOIN "+ RetSqlName("SG1") +" SG1 "
	cQuery += "			ON 	SG1.D_E_L_E_T_ = ' ' "
	cQuery += "				AND G1_FILIAL = '"+ xFilial("SG1") +"' "
	cQuery += "				AND G1_COD = B1_COD "
	cQuery += "WHERE "
	cQuery += "		SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		AND B1_FILIAL = '"+ xFilial("SB1") +"' "
	cQuery += "		AND B1_TIPO = 'PA' "
	cQuery += "		AND B1_COD BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
	cQuery += "		AND G1_COD IS NULL "
	
 
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())
 		
 		DeleteProductStructure((cAliasQry)->B1_COD)
 		
 		CostComponent(@aCost, (cAliasQry)->B1_COD)
		
		SaleComponent(@aSale, (cAliasQry)->B1_COD)
			
		//Grava nível 
		RecLock("Z04", .T.)
			Z04->Z04_FILIAL := xFilial("Z04")
			Z04->Z04_PROD 	:= (cAliasQry)->B1_COD
			Z04->Z04_DESCPR := AllTrim((cAliasQry)->B1_DESC)
			Z04->Z04_TIPO 	:= (cAliasQry)->B1_TIPO
			Z04->Z04_UM 	:= (cAliasQry)->B1_UM
			Z04->Z04_NIVEL 	:= "001"
			Z04->Z04_QUANT 	:= 1
			Z04->Z04_USER	:= cCodUsu//UsrRetName(RetCodUsr())
			Z04->Z04_DATA	:= dDataBase
			Z04->Z04_GRUPO	:= (cAliasQry)->B1_GRUPO
			Z04->Z04_NFENT	:= aCost[NOTA]
			Z04->Z04_SERIEE	:= aCost[SERIE]
			Z04->Z04_EMINFE	:= aCost[EMISSAO]
			Z04->Z04_FORNEC	:= aCost[CLIFOR]
			Z04->Z04_LOJAFO	:= aCost[LOJA]
			Z04->Z04_NOMFOR	:= aCost[NOME]
			Z04->Z04_ITNFE	:= aCost[ITEM]
			Z04->Z04_VALOR	:= aCost[VALOR]
			Z04->Z04_CUSTO	:= aCost[VALOR]
			Z04->Z04_NFSAI	:= aSale[NOTA]
			Z04->Z04_SERIES	:= aSale[SERIE]
			Z04->Z04_EMINFS	:= aSale[EMISSAO]
			Z04->Z04_CLIENT := aSale[CLIFOR]
			Z04->Z04_LOJACL	:= aSale[LOJA]
			Z04->Z04_NOMCLI	:= aSale[NOME]
			Z04->Z04_ITNFS	:= aSale[ITEM]
			Z04->Z04_VENDA	:= aSale[VALOR]			
		Z04->(MsUnlock())
					
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbSkip())

Return Nil

/*
	Função responsável por percorrer a estrutura do produto
*/
Static Function ExplSG1(cProduct, nQtdMaster, nLevel, cOptional, nQtdBase, cReview)

	Local aCost		:= {}
	Local nReg 		:= 0
	Local nQtdItem  := 0
	Local cCodUsu   := UsrRetName(RetCodUsr())
	
	DbSelectArea("SG1")
	
	While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduct
	
		nReg     := Recno()
		nQtdItem := ExplEstr(nQtdMaster,, cOptional, cReview)
		
		DbSelectArea("SG1")
	
		If (lNegEstr .Or. (!lNegEstr .And. QtdComp(nQtdItem, .T.) > QtdComp(0) )) .And. (QtdComp(nQtdItem, .T.) # QtdComp(0, .T.))
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			
			MsSeek(xFilial("SB1")+SG1->G1_COMP)
			
			CostComponent(@aCost, SB1->B1_COD)
			
			//Grava nível 
			RecLock("Z04", .T.)
				Z04->Z04_FILIAL := xFilial("Z04")
				Z04->Z04_PROD 	:= cCodPA
				Z04->Z04_DESCPR := cDescPA
				Z04->Z04_COMP	:= SB1->B1_COD
				Z04->Z04_DESCCO	:= AllTrim(SB1->B1_DESC)
				Z04->Z04_TIPO 	:= SB1->B1_TIPO
				Z04->Z04_UM 	:= SB1->B1_UM
				Z04->Z04_NIVEL 	:= StrZero(nLevel, 3)
				Z04->Z04_QUANT 	:= nQtdItem
				Z04->Z04_USER	:= cCodUsu//UsrRetName(RetCodUsr())
				Z04->Z04_DATA	:= dDataBase
				Z04->Z04_GRUPO	:= SB1->B1_GRUPO
				Z04->Z04_NFENT	:= aCost[NOTA]
				Z04->Z04_SERIEE	:= aCost[SERIE]
				Z04->Z04_EMINFE	:= aCost[EMISSAO]
				Z04->Z04_FORNEC	:= aCost[CLIFOR]
				Z04->Z04_LOJAFO	:= aCost[LOJA]
				Z04->Z04_NOMFOR	:= aCost[NOME]
				Z04->Z04_ITNFE	:= aCost[ITEM]
				Z04->Z04_VALOR	:= aCost[VALOR]
				Z04->Z04_CUSTO	:= nQtdItem * aCost[VALOR]
			Z04->(MsUnlock())
						
			DbSelectArea("SG1")
			
			MsSeek(xFilial("SG1")+SG1->G1_COMP)
			
			If Found()
				
				nValue := 0
				
				ExplSG1(SG1->G1_COD, nQtdItem, nLevel+1, cOptional, IIf(RetFldProd(SB1->B1_COD, "B1_QB") == 0, 1, RetFldProd(SB1->B1_COD, "B1_QB")), ;
						   SB1->B1_REVATU, 0)
						   
			Else
				
				nValue += nQtdItem * aCost[VALOR]
				
			EndIf
							
			DbGoto(nReg)
			
			If nQtdItem * aCost[VALOR] == 0
				UpdatePI(cCodPA, SG1->G1_COMP, nValue)
			EndIf
			
		EndIf
		
		DbSkip()
		
	EndDo

Return Nil

/*
	Função responsável por excluir os resgistro da estrutura do produto
*/
Static Function DeleteProductStructure(cProduct)
	
	Local cQuery := ""
	
	cQuery := "DELETE "+ RetSqlName("Z04") +" "
	cQuery += "WHERE "
	cQuery += "		Z04_FILIAL = '"+ xFilial("Z04") +"' "
	cQuery += "		AND Z04_PROD = '"+ cProduct +"' "
	
	If TcSqlExec(cQuery) <> 0
		UserException(TCSQLError())
	Endif
		
Return Nil

/*
	Função responsável por buscar o valor da última compra do componente
*/
Static Function CostComponent(aCost, cComponent)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	aCost := {}
	
	cQuery := "SELECT TOP 1 "
	cQuery += "		D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, A2_NREDUZ, D1_ITEM, D1_VUNIT, D1_EMISSAO " 
	cQuery += "FROM "+ RetSqlName("SD1") +" SD1 "
	cQuery += "		INNER JOIN "+ RetSqlName("SA2") +" SA2 "
	cQuery += "			ON 	SA2.D_E_L_E_T_ = ' ' "
	cQuery += "				AND A2_FILIAL = '"+ xFilial("SA2") +"' "
	cQuery += "				AND A2_COD = D1_FORNECE "
	cQuery += "				AND A2_LOJA = D1_LOJA " 
	cQuery += "WHERE "
	cQuery += "		SD1.D_E_L_E_T_ = ' ' "
	cQuery += "		AND D1_FILIAL = '"+ xFilial("SD1") +"' "
	cQuery += "		AND D1_COD = '"+ cComponent +"' "
	cQuery += "ORDER BY "
	cQuery += "		D1_EMISSAO DESC "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	TcSetField(cAliasQry, "D1_EMISSAO", "D", 08, 00)
	
	If !(cAliasQry)->(Eof())
		
		aAdd(aCost, (cAliasQry)->D1_DOC)
		aAdd(aCost, (cAliasQry)->D1_SERIE)
		aAdd(aCost, (cAliasQry)->D1_FORNECE)
		aAdd(aCost, (cAliasQry)->D1_LOJA)
		aAdd(aCost, (cAliasQry)->A2_NREDUZ)
		aAdd(aCost, (cAliasQry)->D1_ITEM)
		aAdd(aCost, (cAliasQry)->D1_VUNIT)
		aAdd(aCost, (cAliasQry)->D1_EMISSAO)
		
	Else

		aAdd(aCost, "")
		aAdd(aCost, "")
		aAdd(aCost, "")
		aAdd(aCost, "")
		aAdd(aCost, "")
		aAdd(aCost, "")
		aAdd(aCost, 0)
		aAdd(aCost, SToD(""))
		
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return Nil

/*
	Função responsável por buscar o valor da última venda do componente
*/
Static Function SaleComponent(aSale, cComponent)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()

	aSale := {}
	
	cQuery := "SELECT TOP 1 "
	cQuery += "		D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, A1_NREDUZ, D2_ITEM, D2_PRCVEN, D2_EMISSAO " 
	cQuery += "FROM "+ RetSqlName("SD2") +" SD2 "
	cQuery += "		INNER JOIN "+ RetSqlName("SA1") +" SA1 "
	cQuery += "			ON 	SA1.D_E_L_E_T_ = ' ' "
	cQuery += "				AND A1_FILIAL = '"+ xFilial("SA1") +"' "
	cQuery += "				AND A1_COD = D2_CLIENTE "
	cQuery += "				AND A1_LOJA = D2_LOJA " 
	cQuery += "WHERE "
	cQuery += "		SD2.D_E_L_E_T_ = ' ' "
	cQuery += "		AND D2_FILIAL = '"+ xFilial("SD2") +"' "
	cQuery += "		AND D2_COD = '"+ cComponent +"' "
	cQuery += "ORDER BY "
	cQuery += "		D2_EMISSAO DESC "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	TcSetField(cAliasQry, "D2_EMISSAO", "D", 08, 00)
	
	If !(cAliasQry)->(Eof())
		
		aAdd(aSale, (cAliasQry)->D2_DOC)
		aAdd(aSale, (cAliasQry)->D2_SERIE)
		aAdd(aSale, (cAliasQry)->D2_CLIENTE)
		aAdd(aSale, (cAliasQry)->D2_LOJA)
		aAdd(aSale, (cAliasQry)->A1_NREDUZ)
		aAdd(aSale, (cAliasQry)->D2_ITEM)
		aAdd(aSale, (cAliasQry)->D2_PRCVEN)
		aAdd(aSale, (cAliasQry)->D2_EMISSAO)
		
	Else

		aAdd(aSale, "")
		aAdd(aSale, "")
		aAdd(aSale, "")
		aAdd(aSale, "")
		aAdd(aSale, "")
		aAdd(aSale, "")
		aAdd(aSale, 0)
		aAdd(aSale, SToD(""))
		
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return Nil

/*
	Função responsável pela atualização do custo do produto PA
*/
Static Function UpdatePA(cProduct)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "
	cQuery += "		SUM(Z04_CUSTO) AS TOTAL " 
	cQuery += "FROM "+ RetSqlName("Z04") +" "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND Z04_FILIAL = '"+ xFilial("Z04") +"' "
	cQuery += "		AND Z04_PROD = '"+ cProduct +"' "
	cQuery += "		AND Z04_NIVEL = '002' "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
	
		cQuery := "UPDATE "+ RetSqlName("Z04") +" "
		cQuery += "SET "
		cQuery += "		Z04_CUSTO = "+ AllTrim(Transform((cAliasQry)->TOTAL, "99999999999.999999")) +" "
		cQuery += "WHERE "
		cQuery += "		D_E_L_E_T_ = ' ' "
		cQuery += "		AND Z04_FILIAL = '"+ xFilial("Z04") +"' "
		cQuery += "		AND Z04_PROD = '"+ cProduct +"' "
		cQuery += "		AND Z04_NIVEL = '001' "
				
		If TcSqlExec(cQuery) <> 0
			UserException(TCSQLError())
		Endif

	EndIf
	
	(cAliasQry)->(DbCloseArea())
			
Return Nil

/*
	Função responsável pela atualização do custo do produto PI
*/
Static Function UpdatePI(cPAProduct, cPIProduct, nValue)
	
	Local cQuery := ""
	
	cQuery := "UPDATE "+ RetSqlName("Z04") +" "
	cQuery += "SET "
	cQuery += "		Z04_CUSTO = "+ AllTrim(Transform(nValue, "99999999999.999999")) +" "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND Z04_FILIAL = '"+ xFilial("Z04") +"' "
	cQuery += "		AND Z04_PROD = '"+ cPAProduct +"' "
	cQuery += "		AND Z04_COMP = '"+ cPIProduct +"' "
	cQuery += "		AND Z04_CUSTO = 0 "
	
	If TcSqlExec(cQuery) <> 0
		UserException(TCSQLError())
	Endif
			
Return Nil

/*
	Função responsável por criar as perguntas da rotina
*/
Static Function AjustaSX1(cPerg)

	/*PutSX1(cPerg, "01", "Produto de:",	"Produto de:",	"Produto de:",	"MV_PAR01", "C", TamSX3("B1_COD")[1], 0, 0, "G",, "SB1",,, "MV_PAR01",,,,,,,,,,,,,,,,, {"Informe o produto inicial"}, {"Informe o produto inicial"}, {"Informe o produto inicial"})
	PutSX1(cPerg, "02", "Produto até:",	"Produto até:",	"Produto até:",	"MV_PAR02", "C", TamSX3("B1_COD")[1], 0, 0, "G",, "SB1",,, "MV_PAR02",,,,,,,,,,,,,,,,, {"Informe o produto final"},   {"Informe o produto final"}, 	 {"Informe o produto final"})*/
	
	Local aParBox := {}
	
	aAdd(aParBox, {1, "Produto de:", Space(TamSX3("B1_COD")[1]), "@!", "", "SB1", "", 120, .T.})
	aAdd(aParBox, {1, "Produto até:", Space(TamSX3("B1_COD")[1]), "@!", "", "SB1", "", 120, .T.})
	

Return ParamBox(aParBox, "Custo das Esruturas de Produto",,,,,,,,cPerg, .T., .T.)