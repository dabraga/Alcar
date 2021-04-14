#include "totvs.ch"

User Function DigEAN(cString)
/*
Função		DigEAN
Descrição	Calcula Digito verificador para EAN13 ou EAN14 
Parâmetro	String com 13 ou 14 digitos 
Retorno		String contendo dígito verificador
*/
 
Local nOdd := 0
Local nEven := 0 
Local nI
Local nDig  
Local nMul := 10 

For nI := 1 to Len(cString)
	If (nI%2) == 0
		nEven += val(substr(cString,nI,1))
	Else
		nOdd += val(substr(cString,nI,1))
	Endif
Next

If Len(cString)%2 == 0 // EAN13
	nDig := (nEven*3) + nOdd
Else // EAN14
	nDig := nEven + (nOdd*3)
Endif

While nMul<nDig
	nMul += 10 
Enddo

Return strzero(nMul-nDig,1)