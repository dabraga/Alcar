#Include "Protheus.ch"
#Include "Parmtype.ch"

User Function ALAFAT03()
	
	Local aArea		:= GetArea()
	Local aAreaSA3	:= SA3->(GetArea())
	Local lVend		:= .F.
	Local cCodVend	:= AllTrim(UsrRetName(RetCodUsr()))
	
	DbSelectArea("SA3")
	
	SA3->(DbSetOrder(1))
	
	If SA3->(DbSeek(xFilial("SA3") + cCodVend))
		lVend := .T.
	EndIf 
	
	RestArea(aAreaSA3)
	RestArea(aArea)
	
Return Nil