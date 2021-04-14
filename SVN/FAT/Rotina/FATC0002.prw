#Include "protheus.ch"

#Define cEOL CHR(13) + CHR(10)

/*	
	Função		:	FATC0002
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	11/05/2015
	Descricao	:	Rotina de liberacao de pedidos Alcar
*/

User Function FATC0002()

	Local aCores 		:= {}	// Array cores            
	Local cAuxFil		:= ""	// Filtro
	
	Private	cCadastro 	:= "Liberação Pedido Alcar"
	Private aRotina     := { {"Pesquisar",  	  "AxPesqui",     0, 1}, ;
							 {"Visualizar", 	  "AxVisual",     0, 2}, ;
							 {"Legenda", 		  "U_FATL0002",   0, 3}, ;
							 {"Liberar estoque",  "U_FATA0004()", 0, 4}, ;
							 {"Alterar Pedido",	  "U_FATA0006()", 0, 5}}
							 
							 //Retirado por Ectore Cecato em 24/09/15 pois o fonte FATA0006 foi alterado para corrigir a liberação
							 //{"Liberação Pedido", "U_FATA0008()", 0, 6}} - 

	cAuxFil := "(C9_FILIAL = '" + xFilial("SC9") + "') AND "															// Filtrar filial
	cAuxFil += "((C9_ZZBLOQ = 'S') OR "																					// Bloqueio preco
	cAuxFil += "(C9_BLCRED <> '  ' AND C9_BLCRED <> '09' AND C9_BLCRED <> '10' AND C9_BLCRED <> 'ZZ') OR "				// Bloqueio credito
	cAuxFil += "(C9_BLEST <> '  ' AND C9_BLCRED <> '09' AND C9_BLEST <> '10' AND C9_BLEST <> 'ZZ'))"					// Bloqueio estoque
	
	AADD(aCores,{"C9_ZZBLOQ == 'S'","BR_VERMELHO"})																		// Bloqueio preco
	AADD(aCores,{"C9_BLCRED <> '  ' .And. C9_BLCRED <> '09'.And. C9_BLCRED <> '10' .And. C9_BLCRED <> 'ZZ'","BR_AZUL"})	// Bloqueio credito
	AADD(aCores,{"(C9_BLEST <> '  ' .And. C9_BLCRED <> '09'.And. C9_BLEST <> '10' .And. C9_BLEST <> 'ZZ') .And. (C9_BLCRED == '  ' .Or. C9_BLCRED == '09' .Or. C9_BLCRED == '10' .Or. C9_BLCRED == 'ZZ')","BR_PRETO"})	// Bloqueio estoque

	mBrowse(6,1,22,75,"SC9",,,,,,aCores,,,,,,,,cAuxFil)
	
Return Nil


/****************************************************************************************************/


// Função 	: FATL0002
// Desc.	: Legenda
User Function FATL0002()
           
	Local aCores := {{"BR_VERMELHO","Bloqueio preço"}, {"BR_AZUL","Bloqueio crédito"}, {"BR_PRETO","Bloqueio estoque"}}
	
	BrwLegenda("Legenda do Browse", "Liberação pedido", aCores)
	
Return Nil