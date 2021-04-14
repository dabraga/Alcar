#include "protheus.ch"
#include "apwebsrv.ch"

/**
  Cont�m os dados do usu�rio
**/         
                              
wsStruct WsPortalAlcarDadosUsuario

	wsData login as string
	wsData senha as string
	
endWsStruct

/**
  Cont�m os dados da empresa (c�digo e nome)
**/

wsStruct WsPortalAlcarDadosEmpresa

	wsData empresa As String
	wsData nome As String
		
endWsStruct

/**
  Cont�m os dados da filial (c�digo e nome)
**/

wsStruct WsPortalAlcarDadosFilial

	wsData filial As String
	wsData nome As String
		
endWsStruct