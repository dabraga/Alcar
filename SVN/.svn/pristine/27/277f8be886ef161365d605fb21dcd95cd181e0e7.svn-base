#include "totvs.ch"
#include "apvt100.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ACD166FI

Ponto de entrada utilizado no final da ordem de separação. Utilizado para criar loop quando algum item não tiver sido separado.                    

@param   Nao há.                                        

@return  Não há

@author  Guilherme Ricci - TOTVS IP
@version P12
@since   06/09/2018

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

User Function ACD166FI

If FunName() == "U_ALACDA01"
	If !Empty(CB7->CB7_DIVERG) .and. CB7->CB7_STATUS == "1" // Em andamento
		If VtYesNo("Existem itens que nao foram separados. Deseja separar agora?","ATENCAO", .T.)
			StaticCall(ACDV166, ACDV166X, 0)
		Endif
	Endif
Endif

If CB7->CB7_STATUS == "9"
	Reclock("CB7",.F.)
		CB7->CB7_DIVERG := ""
	CB7->(Msunlock())
Endif

Return