#Include 'Protheus.ch'

/**
 * Rotina		:	MA650FIL
 * Autor		:	Ectore Cecato - Totvs Jundia�
 * Data		:	27/11/2013
 * Descri��o	:	Ponto de Entrada respons�vel para filtrar os pedidos com base no grupo de produto para gera��o das OP's.
 * M�dulo		:  	PCP
**/

User Function MA650FIL()

	Local cFiltro := ""
	
	If !Empty(MV_PAR25)
		cFiltro := "C6_ZZGRUPO = '"+ MV_PAR27 +"'"
	Endif 

Return cFiltro

