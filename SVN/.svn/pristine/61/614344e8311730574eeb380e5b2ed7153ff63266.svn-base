#Include "Protheus.ch"

/*/{Protheus.doc} SendEmail

Classe para envio de email

@author 	Ectore Cecato - Totvs IP
@since 		26/06/2016
@version 	1.0

/*/

User Function SendEmail Return //Dummy

Class SendEmail 
	
	Data lAuth			As Logical 	//Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor necessita de Autenticacao
	Data lUseSSL  		As Logical 	//Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao segura (SSL)
	Data lUseTLS  		As Logical	//Informe se o servidor de SMTP possui conexao do tipo segura (SSL/TLS)
	Data cServer  		As String 	//Nome do Servidor de Envio de E-Mail utilizado nos relatorios
	Data cEmail   		As String	//Conta a ser utilizada no envio de E-Mail para os relatorios
	Data cUser			As String	//Usuario para Autenticacao no Servidor de E-Mail
	Data cEmailFrom		As String	//E-Mail utilizado no campo FROM no envio de relatorios por E-Mail
	Data cPass    		As String	//Senha da Conta de E-Mail para envio de relatorios
	Data cAuditEmail 	As String	//Conta oculta de auditoria utilizada no envio de E-Mail para os relatorios
	Data nTimeout 		As Integer 	//Timeout no Envio de E-Mail
	Data nPort  		As Integer	//Porta Default
		
	Method New(cServe, nPort, cEmail, cUser, cPass, lAuth, lUseSSL, lUseTLS, nTimeOut, cEmailFrom, cAuditEmail) Constructor 
	Method Send(cTo, cCc, cBCC, cTitle, cMessage, aAttach, lAudit) Constructor
	
EndClass

/*/{Protheus.doc} New
Método construtor

@author Ectore Cecato - Totvs IP
@since 26/06/2016

@param [cServer], caracter, Nome do servidor de SMTP
@param [nPort], numérico, Porta default do servidor de SMTP
@param [cEmail], caracter, Conta a ser utilizada no envio de email
@param [cUser], caracter, Usuário para autenticação no servidor de SMTP
@param [cPass], caracter, Senha da conta de email
@param [lAuth], lógico, Define se o servidor de STMP precisa de autenticação
@param [lUseSSL], lógico, Define seo servidor de SMTP utilizará conexão segura {SSL)
@param [lUseTLS], lógico, Define se o servior de SMTP possui conexão do tipo segura (SSL/TLS)
@param [cTimeout], numérico, Define o timeout no envio de email
@param [cEmailFrom], caracter, Email utilizado no campo FROM no envio de email
@param [cEmailAudit], caracter, Email para auditoria


/*/

Method New(cServer, nPort, cEmail, cUser, cPass, lAuth, lUseSSL, lUseTLS, nTimeOut, cEmailFrom, cAuditEmail) Class SendEmail

	Default cServer  	:= GetMV("MV_RELSERV")	
	Default nPort  		:= 25
	Default cEmail   	:= GetMV("MV_RELACNT")
	Default cUser  		:= GetMV("MV_RELAUSR")
	Default cPass    	:= GetMV("MV_RELPSW")
	Default lAuth    	:= GetMv("MV_RELAUTH")
	Default lUseSSL  	:= GetMv("MV_RELSSL")	
	Default lUseTLS  	:= GetMv("MV_RELTLS")	
	Default nTimeout 	:= GetMV("MV_RELTIME")
	Default cEmailFrom 	:= GetMV("MV_RELFROM")	
	Default cAuditEmail	:= GetMv("MV_MAILADT")	
	
	//Verifica se a porta está informada no endereço do server
	If(At(":", cServer) > 0)
	
		::cServer := Substr(cServer, 0, At(":", cServer) - 1)
		::nPort   := Val(Substr(cServer, At(":", cServer) + 1, Len(cServer)))
	
	Else
	
		::cServer 	:= cServer
		::nPort		:= nPort
	
	EndIf			

	::cEmail		:= cEmail
	::cUser			:= cUser
	::cPass			:= cPass
	::lAuth			:= lAuth
	::lUseSSL		:= lUseSSL
	::lUseTLS		:= lUseTLS
	::nTimeOut		:= nTimeOut
	::cEmailFrom	:= cEmailFrom
	::cAuditEmail	:= cAuditEmail

Return Nil

/*/{Protheus.doc} Send
Método para envio de emaili

@author Ectore Cecato - Totvs IP
@since 26/06/2016

@param [cTo], caracter, Email de envio
@param [cCc], caracter, Email para envio da cópia de email
@param [cBCC], caracter, Email para envio da cópia oculta de email
@param [cTitle], caracter, Título do email
@param [cMessage], caracter, Corpo do email
@param [aAttach], array, Anexo do email
@param [lAudit], lógico, Define se envia email de auditoria
 
@return lógico, Indica se o email foi enviado com sucesso

/*/

Method Send(cTo, cCc, cBCC, cTitle, cMessage, aAttach, lAudit) Class SendEmail
	
	Local nRet		:= .F.
	Local nAttach	:= 0
	Local oMail		:= Nil
	Local oMessage	:= Nil
	
	Default aAttach := {}
	Default lAudit 	:= .F.
	
	If Empty(::cServer) .Or. Empty(::cEmail) .Or. Empty(::cUser) .Or. Empty(::cPass)
		
		Aviso("Atenção", "Verifique os parâmetros cServer(MV_RELSERV), cEmail(MV_RELACNT), cUser(MV_RELAUSR) ou cUser(MV_RELPSW)", {"Ok"})
		
		Return .F.
		
	EndIf

	If Empty(cTo)
		
		Aviso("Atenção", "Parâmetro 'Para'(cTo) tem preenchimento obrigatório", {"Ok"})
		
		Return .F.
		
	EndIf

	oMail := TMailManager():New()

	If ::lUseSSL
		oMail:SetUseSSL(::lUseSSL)
	EndIf
	
	If ::lUseTLS
		oMail:SetUseTLS(::lUseTLS)
	EndIf

	oMail:Init("", ::cServer, ::cEmail, ::cPass, 0, ::nPort)

	If ::nTimeout > 0
	
		nRet := oMail:SetSmtpTimeOut(::nTimeout)

		If nRet != 0
		
			ConOut("[TIMEOUT][ERROR] " + Str(nRet, 6), oMail:GetErrorString(nRet))
			
			Aviso("Atenção", "[TIMEOUT][ERROR] "+ Str(nRet, 6) +" - "+ oMail:GetErrorString(nRet), "Ok")
						
			oMail:SMTPDisconnect()
			
			Return .F.
		
		EndIf
		
	EndIf

	nRet := oMail:SmtpConnect()

	If nRet != 0
	
		ConOut("[SMTPCONNECT][ERROR] " + Str(nRet,6) +" - "+ AllTrim(oMail:GetErrorString(nRet)))
		
		Aviso("Atenção", "[SMTPCONNECT][ERROR] "+ Str(nRet,6) +" - "+ AllTrim(oMail:GetErrorString(nRet)), {"Ok"})
		
		oMail:SMTPDisconnect()
	
		Return .F.
		
	Else
		ConOut("[SMTPCONNECT] Sucess to connect smtp")		
	EndIf

	If ::lAuth
		
		ConOut("[AUTH] ENABLE")
		ConOut("[AUTH] TRY with ACCOUNT() and PASS()")
		
		nRet := oMail:SMTPAuth(::cUser, ::cPass)

		If nRet != 0
		
			ConOut("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			ConOut("[AUTH][ERROR] " + Str(nRet, 6), oMail:GetErrorString(nRet))
			
			Aviso("Atenção", "[AUTH][ERROR] "+ Str(nRet, 6) +" - "+ oMail:GetErrorString(nRet))
			
			ConOut("[AUTH] TRY with USER() and PASS()")
			
			nRet := oMail:SMTPAuth(::cUser, ::cPass)

			If nRet != 0
			
				ConOut("[AUTH] FAIL TRY with USER() and PASS()")
				ConOut("[AUTH][ERROR] " + Str(nRet,6), oMail:GetErrorString(nRet))

				Aviso("Atenção", "[AUTH][ERROR] "+ Str(nRet, 6) +" - "+ oMail:GetErrorString(nRet), {"Ok"})
			
				oMail:SMTPDisconnect()
			
				Return .F.
				
			Else
				ConOut("[AUTH] SUCEEDED TRY with USER() and PASS()")
			EndIf
			
		Else
			ConOut("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
		EndIf
		
	Else
		ConOut("[AUTH] DISABLE")
	EndIf
	
	oMessage := TMailMessage():New()

	oMessage:Clear()
	oMessage:cFrom    := ::cEmailFrom
	oMessage:cTo      := cTo
	oMessage:cCc      := cCc
	oMessage:cBCC     := If(lAudit, ::cEmailAudit, "") + If(!Empty(cBCC), (";" + cBCC),"")
	oMessage:cSubject := cTitle
	oMessage:cBody    := cMessage

	For nAttach := 1 To Len(aAttach)
		
		If !Empty(aAttach[nAttach][01])
			oMessage:AddAttHTag("Content-ID: <" + aAttach[nAttach][01] + ">")	//Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
		EndIf
		
		If !Empty(aAttach[nAttach][02]) .And. File(aAttach[nAttach][02])
			oMessage:AttachFile(aAttach[nAttach][02])							//Adiciona um anexo, nesse caso a imagem esta no root
		EndIf
		
	Next nAttach
	
	oMessage:MsgBodyType("text/html")

	ConOut("[SEND] Sending email")
	
	nRet := oMessage:Send(oMail)
	
	If nRet != 0
	
		ConOut("[SEND] Fail to send message")
		ConOut("[SEND][ERROR] " + Str(nRet, 6), oMail:GetErrorString(nRet))
		
		Aviso("Atenção", "[SEND][ERROR] "+ Str(nRet, 6) +" - "+ oMail:GetErrorString(nRet), {"Ok"})
	
		oMail:SMTPDisconnect()
	
		Return .F.
	
	Else
		ConOut("[SEND] Success to send message")
	EndIf

	oMail:SMTPDisconnect()
	
	If nRet != 0
	
		ConOut("[DISCONNECT] Fail smtp disconnecting")
		ConOut("[DISCONNECT][ERROR] "+ Str(nRet, 6) ,oMail:GetErrorString(nRet))
		
		Aviso("Atenção", "[DISCONNECT][ERROR] "+ Str(nRet, 6) +" - "+ oMail:GetErrorString(nRet), {"Ok"})
	
	Else
		ConOut("[DISCONNECT] Success smtp disconnecting")
	EndIf
	
Return .T.