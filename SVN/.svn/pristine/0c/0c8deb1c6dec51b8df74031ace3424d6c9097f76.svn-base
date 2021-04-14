#Include "protheus.ch"
#Include "topconn.ch"
#Define cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} FATA0007

Rotina para verificar saldo de produto no armazém de peças soltas.
	
@author Ademar Junior
@since 23/07/2015

/*/

User Function FATA0007(cAuxProd)
Local aArea := GetArea() // Salvar área
	
	// Selecionar área do SB1
	DbSelectArea("SB1")
	// B1_FILIAL + B1_COD
	SB1->(DbSetOrder(1))
	
	// Verificar se posiciona
	If SB1->(DbSeek(xFilial("SB1") + cAuxProd))
		// Verificar se o produto é da linha industrial
		If SB1->B1_ZZLINHA == "I"
		 	// Consulta quantidade disponível no armazém de peças soltas
			cQry :=	"SELECT " + cEOL
			cQry +=		"(B2_QATU - (B2_RESERVA + B2_QEMP)) AS QTDDISP " + cEOL
			cQry +=	"FROM " + cEOL
			cQry +=		RetSQLName("SB2") + " B2 " + cEOL
			cQry +=	"WHERE " + cEOL
			cQry +=		"B2_FILIAL = '" + xFilial("SB2") + "' AND" + cEOL
			cQry += 	"B2_COD = '" + SB1->B1_COD + "' AND " + cEOL
			cQry += 	"B2_LOCAL IN (" + GetMv("ZZ_LOCIND") + ") AND " + cEOL
			cQry += 	"B2.D_E_L_E_T_ = ' '"
			
			// Execução query
			TcQuery cQry Alias TSB2 New
															
			// Verifica se encontrou
			If TSB2->(!EOF())
				// Verifica se o saldo é maior que zero no armazém de 'peças soltas'
				If TSB2->QTDDISP > 0
					// Caso exista avisar
					Aviso("Aviso","O produto " + AllTrim(SB1->B1_COD) + " tem saldo de " + AllTrim(Str(TSB2->QTDDISP)) + " unidades no armazém " + GetMv("ZZ_LOCIND") + ".",{"OK"})
				EndIf 
			EndIf
			
			// Fechar área query
			TSB2->(DbCloseArea())
		EndIf
	EndIf
	
	// Restaurar área
	RestArea(aArea)
Return cAuxProd