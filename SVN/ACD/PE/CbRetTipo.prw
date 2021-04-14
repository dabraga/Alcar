#include "totvs.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CBRETTIPO

Ponto de entrada utilizado na leitura de produtos nos modulos ACD e WMS. Utilizado em complemento ao ponto de entrada CBRETEAN.

@param   Nao há.                                        

@return  lRet - Lógico - Retorna se a etiqueta lida é de um tipo válido ou nao.

@author  Guilherme Ricci
@version P12
@since   19/11/2018
/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function CbRetTipo

Local cID 			:= PARAMIXB[1]
Local aAreaAtu 		:= GetArea()
Local aAreaSB1 		:= SB1->(GetARea())
Local lRet 			:= .F.
Local nTamProd		:= 9
Local nTamQtd		:= 4

If !Empty(cID)

	// Codigo de barras atual - PPPPPPPPPSSSSQQQQ - P=Produto(9) / S=Sequencial(4) / Q=Quantidade(4) = 17
	SB1->( dbSetOrder(1) )
	If Len(Alltrim(cID)) == 17 .and. SB1->( dbSeek( xFilial("SB1") + Substr(cID, 1, Len(Alltrim(cID))-8) ) ) .and. !Empty(Right(Alltrim(cID),nTamQtd))
		lRet := .T.
	Endif
	
	//EAN 14
	If !lRet
		SLK->( dbSetOrder(1) )
		If SLK->( dbSeek( xFilial("SLK") + Alltrim(cID) ) )
			lRet := .T.
		Endif
	Endif
	
	// EAN 13
	If !lRet
		SB1->( dbSetOrder(5) )
		If SB1->( dbSeek( xFilial("SB1") + Alltrim(cID) ) )
			lRet := .T.
		Endif
	Endif
	
	// Codigo do produto
	If !lRet 
		SB1->( dbSetOrder(1) )
		If SB1->( dbSeek( xFilial("SB1") + Alltrim(cID) ))
			lRet := .T.
		Endif
	Endif
Endif

RestArea(aAreaSB1)
RestArea(aAreaAtu)

Return lRet