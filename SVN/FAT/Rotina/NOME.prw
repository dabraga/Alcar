#Include 'Protheus.ch'

/**
 * Rotina		:	NOME
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data			:	27/08/2014
 * Descrição	:	Rotina responsável por retornar a descrição do cliente/fornecedor no pedido de vendas
 * Módulo		:  	Faturamento
**/
User Function NOME(cTipo, cCliFor, cLoja)

	Local cNome := ""

	If cTipo $ "B|D|"
		cNome := Posicione("SA2", 1, xFilial("SA2")+cCliFor+cLoja, "SA2->A2_NOME") 
	Else
		cNome := Posicione("SA1", 1, xFilial("SA1")+cCliFor+cLoja, "SA1->A1_NOME")
	EndIf
 
Return cNome

