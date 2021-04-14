#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} OM010LOK

Ponto de entrada responsável pela validação de item duplicado na tabela de preço (Venda)

@type 		function
@author 	Ectore Cecato - Totvs Jundiaí
@since 		13/04/2017
@version 	Protheus 12 - Faturamento

@return lógico, Linha válida

/*/

User Function OM010LOK()

	Local lRet	:= .T.
	Local cMsg	:= ""
	Local nItem	:= 0

	For nItem := 1 To Len(aCols)

		If nItem != n .And. !aCols[nItem, Len(aHeader)+1] .And. !aCols[n, Len(aHeader)+1]

			If aCols[n, GdFieldPos("DA1_CODPRO")] == aCols[nItem, GdFieldPos("DA1_CODPRO")]

				lRet := .F.
				
				cMsg := "O produto "+ AllTrim(aCols[nK, GdFieldPos("DA1_CODPRO")])+" já cadastrado no item "
				cMsg += aCols[nK, GdFieldPos("DA1_ITEM")] +" desta tabela, com o preço de venda de R$ "
				cMsg += AllTrim(Transform(aCols[nItem, GdFieldPos("DA1_PRCVEN")], PesqPict("DA1", "DA1_PRCVEN")))
				
				Help(,, "HELP",, cMsg, 1, 0,,,,,, {"Informe outro produto"})
								
			EndIf

		EndIf

	Next nItem

Return lRet