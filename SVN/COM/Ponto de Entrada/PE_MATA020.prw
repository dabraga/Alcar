#Include "Protheus.ch"
#Include "Parmtype.ch"
#Include "FWMvcDef.ch"

/*/{Protheus.doc} MATA020

Ponto de entrada responsável pelos eventos do cadastro de fornecedor

@author Ectore Cecato
@since 	12/12/2019

/*/

User Function CUSTOMERVENDOR()

	Local aParam    := ParamIXB
	Local xRet      := .T.
	Local oObj      := ""
	Local cIdPonto  := ""
	Local cIdModel  := ""
	Local lIsGrid   := .F.
	Local nOperac	:= 0

	If aParam <> Nil

		oObj 		:= aParam[1]
		cIdPonto 	:= aParam[2]
		cIdModel 	:= aParam[3]
		lIsGrid 	:= (Len(aParam) > 3)
		nOperac		:= oObj:GetOperation() 

		If cIdPonto == "MODELCOMMITNTTS"

			If nOperac == MODEL_OPERATION_INSERT
				
				If ExistBlock("ALACOM01") 
					ExecBlock("ALACOM01", .F., .F., {oObj:GetModel("SA2MASTER")})
				EndIf
				
			EndIf

		EndIf

	EndIf

Return xRet