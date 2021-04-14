#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.Doc} getLote

Função disparada no Campo H6_LOTECTL (X3_CBOX)

@author Gustavo Luiz
@since 06/03/2018
/*/
user function getLote()

	local cListLote := 'ALCAR=01;TIGRE=02'
	local aLotesSX5	:= {}

	aLotesSX5 := getSX5Lotes()
	cListLote := converArrayToString(aLotesSX5)

return cListLote

/**
* converte o array em string
**/
static function converArrayToString(aLotesSX5)

	local nI 		:= 0
	local cListLote	:= ""

	for nI := 1 to len(aLotesSX5)

		cListLote += aLotesSX5[nI]

	next nI

return cListLote

/**
* Obtém os lotes na SX5
**/
static function getSX5Lotes()

	local aArea		:= getArea()
	local aAreaSX5  := SX5->(getArea())
	//local cChave	:= xFilial("SX5") + "ZA"
	local aLotes	:= {}
	Local aGrupo    := FWGetSX5("ZA")

	//SX5->(dbSetOrder(1))

	//if SX5->(dbSeek(cChave))

	while SX5->(!eof()) /*.and. (SX5->X5_FILIAL + SX5->X5_TABELA) == cChave*/

		aAdd(aLotes,  allTrim(aGrupo[4]/*SX5->X5_DESCRI*/)  + "=" + (allTrim(aGrupo[3]/*SX5->X5_CHAVE*/)))
		//SX5->(dbSkip())	
	endDo

	//endIf

	restArea(aArea)
	restArea(aAreaSX5)
	
	aLotes := trataLotes(aLotes)

retur aLotes

/**
* Trata os lotes com o ;
**/
static function trataLotes(aLotes)
	
	local nI := 1
	
	for nI := 1 to len(aLotes)
		
		if len(aLotes) > 1 .and. nI < len(aLotes)
			
			aLotes[nI] := aLotes[nI] + ";"
			
		endIf
	
	next nI
	
return aLotes