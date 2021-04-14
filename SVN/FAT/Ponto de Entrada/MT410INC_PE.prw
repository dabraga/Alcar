#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} MT410INC

Ponto de entrada após inclusão do pedido de venda

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		27/08/2018
@version 	Protheus 12 - Faturamento

@param cPedVen, Caracter, Número do Pedido de Venda

/*/

User Function MT410INC()
	
	Local aArea		:= GetArea()
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSA3	:= SA3->(GetArea())
	Local lSend		:= .T.
	Local cNEmail	:= AllTrim(GetNewPar("ZZ_NMAILVN", ""))
	Local cMailENF	:= AllTrim(SuperGetMV("ZZ_MAILENF", .F., "malcon@alcar.com.br"))
	Local cTitle	:= ""
	Local cMail	 	:= ""
	Local cBody	 	:= ""
	Local cReport	:= ""
	//Local oMail		:= Nil
		
	If U_ALAFAT06()
		
		cTitle 	:= "Inclusão Pedido de Venda "+ M->C5_NUM
		cMail 	:= MailTo()
		cBody 	:= "Incluso pedido de venda "+ M->C5_NUM
		cReport	:= U_ALRFAT01(M->C5_NUM)
		
		If !(RetCodUsr() $ cNEmail)
		 
			Processa({|| lSend := EnviarEmail(cTitle, cMail, cBody, cReport)}, "Aguarde", "Gerando relatório", .F.)
			
			If !lSend
			
				SC5->(RecLock("SC5", .F.))
					SC5->C5_ZZWF := "E"
				SC5->(MsUnlock())

				EnviarEmail(cTitle + " [Email não enviado]", cMailENF, cBody +" [Email não enviado]", cReport)

			EndIf
			
		Else
			
			SC5->(RecLock("SC5", .F.))
				SC5->C5_ZZWF := "N"
			SC5->(MsUnlock())
		
		EndIf
				
	EndIf
	
	RestArea(aAreaSA3)
	RestArea(aAreaSA1)
	RestArea(aArea)
	
Return Nil

Static Function EnviarEmail(cTitle, cMail, cBody, cReport)
	
	Local lSend := .T.
	Local oMail := SendEmail():New()
	
	ProcRegua(0)
		
	lSend := oMail:Send(cMail, "", "", cTitle, cBody, {{"", cReport}})
		
Return lSend

Static Function MailTo()
	
	Local cEmailAlc	:= AllTrim(GetNewPar("ZZ_MAILVEN", ""))
	Local cEmailVen	:= AllTrim(Posicione("SA3", 1, FWxFilial("SA3") + M->C5_VEND1, "SA3->A3_EMAIL"))
	Local cEmailCli	:= AllTrim(SA1->A1_ZZMAILP) 
	Local cMailTo	:= ""
	
	cMailTo += FormatMail(cEmailAlc)
	cMailTo += FormatMail(cEmailVen)
	cMailTo += FormatMail(cEmailCli)
		
Return cMailTo

Static Function FormatMail(cEmail)
	
	If Right(cEmail, 1) != ";"
		cEmail += ";"
	EndIf
	
Return cEmail
