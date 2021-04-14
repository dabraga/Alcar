#Include 'Protheus.ch'
#Include 'TopConn.ch'

/**
 * Rotina		:	MntSX521
 * Autor		:	Rodrigo Furtado - Totvs Campinas
 * Data		:	27/08/2014
 * Descrição	:	Rotina para inclusão de novos grupos de tributação - Tabela 21 da SX5
 * Módulo		:  	Fiscal
**/
User Function MntSX521()

Local aArea := GetArea()
Local aTabela := FWGetSX5("21")

//dbselectarea("SX5")
//dbSetOrder(1)

Set filter to aTabela//X5_TABELA = "21"


AxCadastro("SX5","Cadastro de Grupos de Tributação")

Set Filter to

RestArea(aArea)

Return
			
User Function ProxSX521()

Local aArea := GetArea()
Local cCodigo := ''

cSql := "SELECT MAX(X5_CHAVE) AS CODIGO FROM "+RetSqlName("SX5")
cSql += " WHERE D_E_L_E_T_<>'*' "
cSql += " AND X5_TABELA = '21' "

TcQuery cSql NEW ALIAS "_QRY"

If Empty(_QRY->CODIGO)
	cCodigo := '001'
Else
	cCodigo := Soma1(Alltrim(_QRY->CODIGO))
Endif

_QRY->(dbclosearea())

M->X5_CHAVE := cCodigo

RestArea(aArea)

Return .T.

//INCLUIR NO X3_WHEN DOS CAMPOS X5_TABELA E X5_CHAVE
//!(FUNNAME()=="MNTSX521")
//INCLUIR NO X3_RELACAO DO CAMPO X5_TABELA
//IIF(FUNNAME()=="MNTSX521","21",.T.)
//INCLUIR NO X3_VLDUSER DO CAMPO X5_DESCRI
//IIF(FUNNAME()=="MNTSX521",U_ProxSX521(),.T.)