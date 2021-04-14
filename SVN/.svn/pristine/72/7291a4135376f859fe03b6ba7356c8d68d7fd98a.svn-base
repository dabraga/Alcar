#include "protheus.ch"
#include "apwebsrv.ch"

User Function _WsPortalAlcar; Return                                                       
wsService WsPortalAlcar description "WebService com Funcionalidades do Portal Alcar"

	wsData DadosUsuario As WsPortalAlcarDadosUsuario
	wsData DadosEmpresa As Array of WsPortalAlcarDadosEmpresa
	wsData DadosFilial As Array of WsPortalAlcarDadosFilial
	wsData Empresa As String
	wsData UsuarioValido As Boolean

	wsMethod validaUsuario description "Valida usuário no Protheus"
	wsMethod getEmpresa description "Retorna as empresas do Protheus"
	wsMethod getFilial description "Retorna as filiais do Protheus"  

endWsService

WsMethod validaUsuario wsReceive DadosUsuario wsSend UsuarioValido wsService WsPortalAlcar

	Local lRet := .F. 

	PswOrder(2)

	If PswSeek(::DadosUsuario:login, .T.)

		If PswName(::DadosUsuario:senha)
			lRet := .T.
		Endif

	Endif

	::UsuarioValido := lRet

Return .T.

WsMethod getEmpresa wsReceive NULLPARAM wsSend DadosEmpresa wsService WsPortalAlcar

	Local aInfSM0 		:= FWLoadSM0() 
	Local aEmpresa		:= {}
	Local nI			:= 0
	Local nEmp			:= 1

	For nI := 1 To Len(aInfSM0)

		If aScan(aEmpresa,  {|x| x == aInfSM0[nI, 1]}) == 0

			aAdd(::DadosEmpresa, WSClassNew("WsPortalAlcarDadosEmpresa"))

			::DadosEmpresa[nEmp]:empresa := aInfSM0[nI, 1]
			::DadosEmpresa[nEmp]:nome 	 := aInfSM0[nI, 6]	

			nEmp++

			aAdd(aEmpresa, aInfSM0[nI, 1])

		Endif

	Next nI
	
Return .T.

WsMethod getFilial wsReceive Empresa wsSend DadosFilial wsService WsPortalAlcar

	Local aInfSM0 		:= FWLoadSM0() 
	Local aFilial		:= {}
	Local nI			:= 0
	Local nFil			:= 1

	For nI := 1 To Len(aInfSM0)

		If aInfSM0[nI, 1] == ::Empresa

			If aScan(aFilial,  {|x| x == aInfSM0[nI, 2]} ) == 0

				aAdd(::DadosFilial, WSClassNew("WsPortalAlcarDadosFilial"))

				::DadosFilial[nFil]:filial 	:= aInfSM0[nI, 2]
				::DadosFilial[nFil]:nome 	:= aInfSM0[nI, 7]

				nFil++

				aAdd(aFilial, aInfSM0[nI, 2])

			Endif	

		Endif

	Next nI

Return .T.