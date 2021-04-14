#include "Protheus.ch"
#include "Topconn.ch"
 
 /**
 * Rotina		:	ALAPCP02
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	06/11/2013
 * Descrição	:	Programa responsável por retornar as misturas referentes ao produto informado
 * Módulo		:  	PCP
**/

Static cMistura := Space(15) 
 
User Function ALAPCP02()
 	
 	Local aArea		:= GetArea()
	Local cCodigo 	:= Alltrim(M->B5_COD) 
	Local aDadosSB1 := {}
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	Private oDlgSB1		
	Private oLstSB1
	
	cQuery := "SELECT "
	cQuery += "		B1_COD, B1_DESC "
	cQuery += "FROM "+ RetSqlName("SG1") +" SG1 "
	cQuery += "		INNER JOIN "+ RetSqlName("SB1") +" SB1 "
	cQuery += "			ON 	B1_FILIAL = G1_FILIAL AND "
	cQuery += "				B1_COD = G1_COMP "
	cQuery += "WHERE "
	cQuery += "		SG1.D_E_L_E_T_ = ' ' AND "
	cQuery += "		SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "		G1_COD = '"+ cCodigo +"' AND "
	cQuery += "		G1_NIV = '01' AND "
	cQuery += "		B1_ZZMIST = 'S' "
	cQuery += "ORDER BY B1_COD "
	
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .F., .T.)
	 
	(cAliasQry)->(DbGoTop())
	 
	If (cAliasQry)->(Eof())
	
		Aviso( "Cadastro de Produtos", "Não existe dados a consultar", {"Ok"})
		
		RestArea(aArea)
		
	 	Return .F.
	
	Endif
	 
	While !(cAliasQry)->(Eof())
	
		aAdd(aDadosSB1, {(cAliasQry)->B1_COD, (cAliasQry)->B1_DESC})
	
		(cAliasQry)->(DbSkip())
	
	Enddo
	 
	(cAliasQry)->(DbCloseArea())
	
	cMistura := Space(15)
	
	//--Montagem da Tela
	Define MsDialog oDlgSB1 Title "Misturas" From 0,0 To 280, 500 Of oMainWnd Pixel
	 
	@ 5,5 LISTBOX oLstSB1 VAR lVarMat Fields HEADER "Produto", "Descrição" SIZE 245,110 On DblClick (ConfProd(aDadosSB1[oLstSB1:nAt, 1])) OF oDlgSB1 PIXEL
	 
	oLstSB1:SetArray(aDadosSB1)
	 
	oLstSB1:bLine := { || {aDadosSB1[oLstSB1:nAt,1],  aDadosSB1[oLstSB1:nAt, 2]}}
	 
	DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfProd(aDadosSB1[oLstSB1:nAt, 1]) ENABLE OF oDlgSB1
	 
	DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgSB1:End() ENABLE OF oDlgSB1
	 
	Activate MSDialog oDlgSB1 Centered
	
	RestArea(aArea)
	
Return .T.
 
User Function RetMistura()

Return cMistura

Static Function ConfProd(cCodProd)

	cMistura := cCodProd
	
	oDlgSB1:End()

Return