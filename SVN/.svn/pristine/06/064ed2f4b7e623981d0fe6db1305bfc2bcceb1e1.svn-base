#include "totvs.ch"
#include "apvt100.ch"
#include "topconn.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} A166Tela

Ponto de entrada para alterar a tela durante a separação no fonte ACDV166.                    

@param   PARAMIXB[1] - N - Qtd a separar
@param   PARAMIXB[2] - A - Vetor com tamanhos da tela                                     

@return  Não há

@author  Guilherme Ricci - TOTVS IP
@version P12
@since   06/09/2018

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function A166Tela

Local nQtdSep 	:= PARAMIXB[1]
Local aTam		:= PARAMIXB[2]
Local cUM		:= SB1->B1_UM
Local c2UM		:= SB1->B1_SEGUM
Local nConv		:= SB1->B1_CONV
Local cTipoConv := SB1->B1_TIPCONV
Local cEnder	:= SB1->B1_ZZPRAT
Local nQtdSep2	:= 0

If !Empty(c2UM) .and. !Empty(nConv) .and. !Empty(cTipoConv)
	If cTipoConv == "D"
		nQtdSep2 := nQtdSep / nConv
	Elseif cTipoConv == "M"
		nQtdSep2 := nQtdSep * nConv
	Endif
Endif

@ 0,0 VtSay "NF: " + CB7->CB7_NOTA
@ 1,0 VtSay "Separe " +cValToChar(nQtdSep) + " " + cUM + IIf( nQtdSep2 > 0, " / " + cValToChar(nQtdSep2) + " " + c2UM,"") 
@ 2,0 VtSay Alltrim(SB1->B1_COD) + IIf(!Empty(cEnder), " - " + cEnder, "")
@ 3,0 VtSay Substr(SB1->B1_DESC,1,VtMaxCol())

Return