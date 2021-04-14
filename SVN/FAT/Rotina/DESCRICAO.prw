#Include 'Protheus.ch'
 
/**
 * Rotina		:	DESCRICAO
 * Autor		:	Ectore Cecato - Totvs Jundia�
 * Data		:	27/08/2014
 * Descri��o	:	Rotina respons�vel por retornar a descri��o do produto na documento de saida (MATA460)
 * M�dulo		:  	Faturamento
**/
User Function DESCRICAO(cProduto)

Local cDesc := ""

cDesc := Posicione("SB1", 1, xFilial("SB1")+cProduto, "SB1->B1_DESC")

Return cDesc

