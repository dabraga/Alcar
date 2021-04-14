#include 'protheus.ch'
#include 'parmtype.ch'

#define PRODUTO_ESTRUT 	 1
#define ARMAZEM			 3
#define LOTE			 6
#define SIM 			"1"
#define JUMBO			"JUM"


/*{Protheus.Doc} EMP650

PE para tratar os itens do empenho

@author Gustavo Luiz
@since 06/03/2018
/*/
user function EMP650()

	local cProdPai		:= PARAMIXB[1]
	local aAreaSB1 		:= SB1->(getArea())	
	local lIsJumbo		:= isJumbo(allTrim(cProdPai))		

	if lIsJumbo
		preencheArmaz()
	else
		preencheLote(cProdPai)	
	endIf

	restArea(aAreaSB1)

return 

/**
* Preenche o armazém
**/
static function preencheArmaz()

	local nI			:= 0
	local cProdEstrut	:= ""
	Local lIsChangArm	:= .F.

	for nI := 1 to len(aCols)

		cProdEstrut := aCols[nI][1]
		lIsChangArm := isChangArm(cProdEstrut)

		if lIsChangArm
			aCols[nI][ARMAZEM] := "30"
		endIf

	next nI

return

/**
* Preenche o lote
**/
static function preencheLote(cProdPai)

	local nI			:= 1
	local cProdEstrut	:= ""
	local lIsJumbo		:= .F.
	local cLote			:= ""

	for nI := 1 to len(aCols)

		cProdEstrut := aCols[nI][1]
		lIsJumbo := isJumbo(allTrim(cProdEstrut))	

		if lIsJumbo
			cLote := getLote(cProdPai)
			aCols[nI][LOTE] := cLote
		endIf

	next nI

return

/**
* Verifica se o produto vai ser trocado de armazém
**/
static function isChangArm(cProdEstrut)

	local aAreaSB1 		:= SB1->(getArea())
	local lIsChangArm	:= .F.
	local cChave		:= xFilial("SB1") + padr(cProdEstrut, TamSx3("B1_COD")[1], "")

	SB1->(dbSetOrder(1))

	if SB1->(dbSeek(cChave))

		if SB1->B1_ZZARMAZ == SIM

			lIsChangArm := .T.

		endIf

	endIf

	restArea(aAreaSB1)

return lIsChangArm

/**
* Verifica se o produto é JUMBO
**/
static function isJumbo(cProdPai)

	local lIsJumbo := .F.
	local cPrefixo := upper(substr(cProdPai, 1, 3))

	if cPrefixo == JUMBO
		lIsJumbo := .T.
	endIf	

return lIsJumbo

/**
* Obtém o lote B1_ZZLOTE
**/
static function getLote(cProduto)

	local aAreaSB1 		:= SB1->(getArea())	
	local cChave		:= xFilial("SB1") + padr(cProduto, TamSx3("B1_COD")[1], "")
	local cLote			:= ""

	SB1->(dbSetOrder(1))

	if SB1->(dbSeek(cChave))		
		cLote := allTrim(SB1->B1_ZZLOTE)
	endIf

	restArea(aAreaSB1)

return cLote

