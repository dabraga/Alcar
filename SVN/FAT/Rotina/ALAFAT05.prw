#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} ALAFAT05

Rotina responsável pelo cálculo do valor Alcar do produto

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		12/09/2018
@version 	Protheus 12 - Faturamento

@param cCliente, Caracter, Cliente
@param cLoja, Caracter, Loja do cliente
@param cCondPag, Caracter, Condição de pagamento
@param cProduto, Caracter, Produto
@param nCoef, Numérico, Coeficiente 

@return numérico, Valor do produto

/*/

User Function ALAFAT05(cCliente, cLoja, cCondPag, cProduto, nCoef)
	
	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSE4	:= SE4->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local cAuxICM	:= GetMv("ZZ_ESTICM")
	Local cAuxEst   := ""
	Local nAuxICM	:= 0
	//Local nAuxVal	:= 0
	Local nICMEst	:= 0
	Local nICMSP	:= 0
	Local nAuxPos	:= 0
	Local nCoefFin	:= 0
	Local nValor 	:= 0
	
	DbSelectArea("SA1")

	SA1->(DbSetOrder(1))

	// Posiciona cliente
	If SA1->(DbSeek(xFilial("SA1") + cCliente + cLoja))

		cAuxEst := SA1->A1_EST
		nAuxPos	:= At(cAuxEst,cAuxICM)
		nICMEst := Val(SubStr(cAuxICM,nAuxPos + 2,2))

		nAuxPos := At("SP",cAuxICM)
		nICMSP	:= Val(SubStr(cAuxICM,nAuxPos + 2,2))

		nAuxICM := nICMSP - nICMEst

	EndIf
	
	// Posiciona condição de pagamento
	DbSelectArea("SE4")

	SE4->(DbSetOrder(1))

	If SE4->(DbSeek(xFilial("SE4") + cCondPag))
		nCoefFin := SE4->E4_ZZCOFIN
	EndIf

	DbSelectArea("SB1")

	SB1->(DbSetOrder(1))
	
	If SB1->(DbSeek(xFilial("SB1") + cProduto))   
		
//		If nCoef == Nil
//			nCoef := SB1->B1_ZZCOEF
//		EndIf
		 
		nAuxCof := nCoef * If((1 - (nAuxICM / 100)) > 0, (1 - (nAuxICM / 100)), 1)	// Desconto Coeficiente * ICM
		
		nValor := (SB1->B1_ZZVALBA * nAuxCof)												
		nValor += ((nValor * nCoefFin) / 100)		
		nValor := Round(nValor, 2)
			
	EndIf
	
	RestArea(aAreaSB1)
	RestArea(aAreaSE4)
	RestArea(aAreaSA1)
	RestArea(aArea)
	
Return nValor