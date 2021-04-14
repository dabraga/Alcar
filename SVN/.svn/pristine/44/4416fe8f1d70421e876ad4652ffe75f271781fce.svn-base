#Include 'Protheus.ch'

/**
 * Rotina		:	MA650FIL
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	27/11/2013
 * Descrição	:	Ponto de Entrada responsável para filtrar os pedidos com base no grupo de produto para geração das OP's.
 * Módulo		:  	PCP
**/

User Function MA650FIL()

	Local cFiltro := ""
	
	If !Empty(MV_PAR25)
		cFiltro := "C6_ZZGRUPO = '"+ MV_PAR27 +"'"
	Endif 

Return cFiltro

