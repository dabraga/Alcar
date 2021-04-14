#Include "Protheus.ch"
#Include "Parmtype.ch"
#Include "FWMvcDef.ch"

/*/{Protheus.doc} ALACOM01

Rotina responsável pela gravação da conta contábil

@author Ectore Cecato
@since 	12/12/2019

/*/

User Function ALACOM01()

	Local oModel	:= ParamIXB[1]
	Local cCtaSint	:= "210401"
	Local cCtaCtb	:= cCtaSint + AllTrim(oModel:GetValue("A2_COD"))
	Local cCtaRef	:= If(oModel:GetValue("A2_EST") <> "EX", "2.01.01.03.01", "2.01.01.03.02")
	
	// Contas referenciais novas (ECF)
	// 2.01.01.03.01	FORNECEDORES - OPERACOES COM PARTES NAO RELACIONADAS - NO PAIS – CIRCULANTE
	// 2.01.01.03.02	FORNECEDORES - OPERACOES COM PARTES NAO RELACIONADAS - NO EXTERIOR – CIRCULANTE

	CT1->(DbSelectArea("CT1"))

	If CT1->(RecLock("CT1",.T.))
		CT1->CT1_FILIAL := xFilial("CT1")
		CT1->CT1_CONTA  := cCtaCtb
		CT1->CT1_DESC01 := oModel:GetValue("A2_NOME") 
		CT1->CT1_CLASSE := "2"
		CT1->CT1_NORMAL := "2"
		CT1->CT1_RES    := "F" + AllTrim(oModel:GetValue("A2_COD")) + AllTrim(oModel:GetValue("A2_LOJA"))
		CT1->CT1_BLOQ   := "2"
		CT1->CT1_DC     := CtbDigCont(cCtaCtb)
		CT1->CT1_CVD02  := "1"
		CT1->CT1_CVD03  := "1"
		CT1->CT1_CVD04  := "1"
		CT1->CT1_CVD05  := "1"
		CT1->CT1_CVC02  := "1"
		CT1->CT1_CVC03  := "1"
		CT1->CT1_CVC04  := "1"
		CT1->CT1_CVC05  := "1"
		CT1->CT1_CTASUP := CtbCtaSup(cCtaCtb)
		CT1->CT1_ACITEM := "2"
		CT1->CT1_ACCUST := "2"
		CT1->CT1_ACCLVL := "2"
		CT1->CT1_DTEXIS := CTOD("01/01/1980")
		CT1->CT1_BOOK	:= "001/002/003/004/005"
		CT1->CT1_AGLSLD	:= "2"
		CT1->CT1_CCOBRG := "2"
		CT1->CT1_ITOBRG := "2"
		CT1->CT1_CLOBRG := "2"
		CT1->CT1_LALUR  := "0"
		CT1->CT1_CTLALU	:= cCtaCtb
		CT1->CT1_ACATIV := "2"
		CT1->CT1_ATOBRG := "2"
		CT1->CT1_ACET05 := "2"
		CT1->CT1_05OBRG := "2"
		CT1->CT1_NTSPED := "02"
		CT1->(MsUnLock())

		// Gravacao da conta contabil no cadastro de Fornecedor (SA2)
		cQuery := "UPDATE "+ RetSqlName("SA2") +" "+ CRLF
		cQuery += "SET "
		cQuery += "		A2_CONTA = '"+ cCtaCtb +"' " 
		cQuery += "WHERE "
		cQuery += "		D_E_L_E_T_ = '' "
		cQuery += "		AND A2_FILIAL = '"+ oModel:GetValue("A2_FILIAL") +"' "
		cQuery += "		AND A2_COD = '"+ oModel:GetValue("A2_COD") +"' "
		cQuery += "		AND A2_LOJA = '"+ oModel:GetValue("A2_LOJA") +"' "
		
		If TcSqlExec(cQuery) != 0
			UserException(TCSQLError())
		Endif
		/*		
		SA2->(DbSelectarea("SA2"))
		
		If RecLock("SA2",.F.)
			SA2->A2_CONTA := cCtaCtb
			SA2->(MsUnLock())
		EndIf
		*/
		// Amarração Plano de Contas x Referência (SPED Contabil e ECF)
		CVD->(DbSelectarea("CVD"))
		
		If RecLock("CVD",.T.)
			CVD->CVD_FILIAL	:= 	xFilial("CVD")
			CVD->CVD_CONTA  :=	cCtaCtb
			CVD->CVD_CTAREF	:=	cCtaRef
			CVD->CVD_ENTREF	:=	"10"
			CVD->CVD_CODPLA	:=	"PJGE15"
			CVD->CVD_CUSTO 	:= 	""
			CVD->CVD_TPUTIL	:= 	"A"
			CVD->CVD_CLASSE	:= 	"2"
			CVD->CVD_NATCTA	:= 	"02"
			CVD->CVD_CTASUP	:= 	"2.01.01.03"
			CVD->(MsUnLock())
		EndIf
	Else
		Help(,, "HELP",, "Atenção!!! Erro na inclusão da conta contábil!!!", 1, 0)
	EndIf
	
Return Nil