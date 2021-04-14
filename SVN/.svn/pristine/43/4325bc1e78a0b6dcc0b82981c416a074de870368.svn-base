#include "protheus.ch"
#include "parmtype.ch"
 
User Function ITEM()

    Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
 
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
 
        If cIdPonto == "FORMCOMMITTTSPOS" 
        	If oObj:GetOperation() == 3 .and. !Empty(SB1->B1_CODBAR) .and. Len(Alltrim(SB1->B1_CODBAR)) == 13 // Somente inclusão com o código de barras OK
        		Execblock("GEREAN14",.F.,.F.)
        	Endif
        Endif
	Endif
Return xRet