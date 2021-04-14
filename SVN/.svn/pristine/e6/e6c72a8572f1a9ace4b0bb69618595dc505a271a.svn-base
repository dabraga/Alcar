#include "totvs.ch"
#include "apvt100.ch"
#include "topconn.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ALACDA01

Rotina para iniciar a separacao das NFs informando o número da chave do DANFE para localizar a NF.                    

@param   Nao há.                                        

@return  Não há

@author  Guilherme Ricci - TOTVS IP
@version P12
@since   03/12/2018

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------


User Function ALACDA01

Private cChvNfe := CriaVar("F2_CHVNFE",.F.)
Private cOrdSep := ""

While .T.
	VtClear()
	cChvNfe := CriaVar("F2_CHVNFE",.F.)
	cOrdSep	:= ""
	
	@ 0,0 VtSay "Leia a chave NFE"
	@ 1,0 VtGet cChvNfe Picture PesqPict("SF2","F2_CHVNFE") Valid VldChave(cChvNfe)
	
	VtClearBuffer()
	VtRead()
	
	If VTLastKey() == 27
		If VTYesNo("Confirma a Saida", "LOCAL" , .t.)
			exit
		Else
			loop
		EndIf			
	EndIf
	
	If !Empty(cOrdSep)
		StaticCall(ACDV166, ACDV166X, 0) // Utiliza variavel private cOrdSep para realizar o processo de separacao padrao
	Endif
	
EndDo

Return

Static Function VldChave(cChvNfe)

Local lRet 		:= .T.
Local cQuery 	:= ""
Local nRegs		:= 0
Local nSelect	:= 0

Private aOpcoes := {"ORDSEP | ARM | STATUS", "-------+--------"}
Private alOpcoes := {.F.,.F.}

If Empty(cChvNfe)
	Return .F.
Endif

cQuery := "SELECT 	DISTINCT CB7_ORDSEP, CB7_LOCAL," + CRLF
cQuery += " 		CASE " + CRLF
cQuery += " 			WHEN CB7_STATUS = '9' THEN 'FINALIZADA'" + CRLF
cQuery += " 			WHEN CB7_STATUS = '1' THEN 'EM ANDAMENTO'" + CRLF
cQuery += " 			WHEN CB7_STATUS = '0' THEN 'NAO INICIADA'" + CRLF
cQuery += " 			ELSE 'NAO DEFINIDO' END STATUS" + CRLF
cQuery += " FROM "+RetSqlName("CB7")+" CB7" + CRLF
cQuery += " INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = CB7_NOTA AND F2_SERIE = CB7_SERIE AND F2.D_E_L_E_T_=' '" + CRLF 
cQuery += " WHERE CB7_FILIAL = '"+xFilial("CB7")+"'" + CRLF
cQuery += " AND F2_CHVNFE = '"+cChvNfe+"'" + CRLF
cQuery += " AND CB7.D_E_L_E_T_=' '" + CRLF
cQuery += " ORDER BY 1"

If Select("QRYCB7") > 0
	QRYCB7->(dbCloseArea())
Endif

tcQuery cQuery New Alias "QRYCB7"

Count To nRegs

QRYCB7->(dbGoTop())

If nRegs == 1

	cOrdSep := QRYCB7->CB7_ORDSEP
	
Elseif nRegs > 1 .and. QRYCB7->(!Eof())

	While QRYCB7->(!Eof())
		aAdd(aOpcoes, QRYCB7->(CB7_ORDSEP + " | " + CB7_LOCAL + "  | " + STATUS))
		aAdd(alOpcoes, .T.)
		QRYCB7->(dbSkip())
	EndDo
	
	nSelect := VtaChoice(0, 0, VtMaxRow(), VtMaxCol(), aOpcoes, alOpcoes)
	
	If nSelect > 0
		cOrdSep := Substr(aOpcoes[nSelect], 1, TamSX3("CB7_ORDSEP")[1])
	Endif
	
Endif

QRYCB7->(dbCloseArea())

If Empty(cOrdSep)
	VtAlert("Nao foram encontradas ordens de separacao para a chave informada.", "ERRO", .T., 0, 2)
Endif

Return