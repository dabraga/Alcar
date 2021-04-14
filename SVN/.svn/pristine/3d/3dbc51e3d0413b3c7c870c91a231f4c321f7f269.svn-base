#Include "topconn.ch"
#Include "protheus.ch"

/* Rotina		:	M030EXC	
 * Autor		:	Marcos Wey da Mata
 * Data			:	05/06/2015
 * Descricao	:	Ponto de Entrada apos Exclusao de Cliente, deleta a conta contabil no CT1
 */                                              

User Function M030EXC()
        
&& Declaração das Variáveis
Local cQuery	:=	""
Local aArea 	:= 	GetArea()

&& Verifica se a conta contabil está preenchida no cadastro do cliente
If !Empty(SA1->A1_CONTA)
	&& Localica a conta contabil e deleta
	cQuery	:=	"UPDATE " + RetSQLName("CT1") + " "
	cQuery	+=	"SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery	+=	"WHERE CT1_CONTA = '" + SA1->A1_CONTA + "' AND CT1_FILIAL = '" + xFilial("CT1") + "' "
 	                                                
 	TcSqlExec(cQuery)
EndIf	

&& Verifica se a conta contabil está preenchida no cadastro do cliente
If	!Empty(SA1->A1_CONTA)
	&& Localica a conta contabil e deleta
	cQuery	:=	"UPDATE " + RetSQLName("CVD") + " "
	cQuery	+=	"SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery	+=	"WHERE CVD_CONTA = '" + SA1->A1_CONTA + "' AND CVD_FILIAL = '" + xFilial("CVD") + "' "
 	                                                
 	TcSqlExec(cQuery)
EndIf	
 
RestArea(aArea)	
Return Nil