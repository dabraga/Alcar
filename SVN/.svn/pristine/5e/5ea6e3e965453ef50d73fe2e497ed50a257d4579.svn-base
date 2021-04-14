#include "totvs.ch"
#include "apvt100.ch"
#include "topconn.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ALACDA02

Rotina para exibir as ordens de separação por NF que estão pendentes.                    

@param   Nao há.                                        

@return  Não há

@author  Guilherme Ricci - TOTVS IP
@version P12
@since   03/12/2018

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function ALACDA02

Local cQuery 	:= ""
Local aCab		:= {"Dt. Emis. ", "Num. Nota", "Qtd It"}
Local aDados	:= {}
Local aSize		:= {10, TamSX3("CB7_NOTA")[1], 6}

cQuery := " SELECT CB7_DTEMIS, CB7_NOTA, CB7_SERIE, COUNT(*) NUMITEM" + CRLF
cQuery += " FROM "+ RetSqlName("CB7") +" CB7" + CRLF
cQuery += " INNER JOIN " + RetSqlName("CB8") + " CB8 ON CB8.D_E_L_E_T_=' ' AND CB7_ORDSEP = CB8_ORDSEP"
cQuery += " WHERE CB7_FILIAL = '"+ FwXfilial("CB7")+"'" + CRLF
cQuery += " AND CB7_STATUS <> '9'" + CRLF
cQuery += " AND CB7_NOTA <> ' '" + CRLF
cQuery += " AND CB7_PEDIDO = ' '" + CRLF
cQuery += " AND CB7.D_E_L_E_T_=' '" + CRLF
cQuery += " GROUP BY CB7_DTEMIS, CB7_NOTA, CB7_SERIE"
cQuery += " ORDER BY CB7_NOTA"

If Select("QTEMP") > 0
	QTEMP->(dbCloseArea())
Endif

tcQuery cQuery New Alias "QTEMP"

While QTEMP->(!eof())
	aAdd(aDados, { StoD(QTEMP->CB7_DTEMIS), QTEMP->CB7_NOTA, QTEMP->NUMITEM })
	QTEMP->(dbSkip())
EndDo

QTEMP->(dbCloseArea())

VTABrowse(0,0, VtMaxRow(), VtMaxCol(), aCab, aDados, aSize)

Return