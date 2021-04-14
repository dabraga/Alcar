#Include "Protheus.ch"

/*	
PE			:	M410FSQL
Autor		:	Ademar Pereira da Silva Junior
Data		:	08/04/2015
Descricao	:	Filtro pedido de vendas
*/

User Function M410FSQL()

	Local aArea		:= GetArea()
	Local aAreaSA3	:= SA3->(GetArea())
	Local cCodVend	:= AllTrim(UsrRetName(RetCodUsr()))
	Local cFiltro	:= ""

	DbSelectArea("SA3")
	
	SA3->(DbSetOrder(1))
	
	If SA3->(DbSeek(xFilial("SA3") + cCodVend))
		cFiltro := "C5_VEND1 = '" + cCodVend + "' "
	EndIf                   

	RestArea(aAreaSA3)
	RestArea(aArea)
	
Return cFiltro