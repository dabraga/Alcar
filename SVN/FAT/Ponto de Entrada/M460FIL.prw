#Include 'Protheus.ch'

/*/{Protheus.doc} M460FIL

Ponto de entrada responsável por acrescentar filtro de vendedor na geração do documento de entrada [Pergunta MTA461A]
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 01/09/2014
@version Protheus 11 - Faturamento
 
@return caracter, Filtro para tabela SC9

/*/
User Function M460FIL()

	Local cFiltroSC9 := ""
	
	cFiltroSC9 := " C9_ZZVEND1 >= '"+ MV_PAR19 +"' .And. C9_ZZVEND1 <= '"+ MV_PAR20 +"' " 

Return cFiltroSC9

