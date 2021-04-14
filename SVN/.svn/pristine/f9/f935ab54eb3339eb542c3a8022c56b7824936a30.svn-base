#include "totvs.ch"
#include "apvt100.ch"
#include "topconn.ch"

//-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CBRETEAN

Ponto de entrada utilizado na leitura de produtos nos modulos ACD.                    

@param   Nao há.                                        

@return  aEtiqueta - Vetor - Retorna Vetor contendo informacoes da etiqueta lida.

@author  Guilherme Ricci - TOTVS IP
@version P12
@since   06/09/2018

/*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Static nX_ACDV040 // Variavel criada para tratar problema gerado no fonte padrao acdv040

User Function CbRetEan

	Local cID 		:= PARAMIXB[1]
	Local aAreaAtu 	:= GetArea()
	Local aAreaSB1 	:= SB1->(GetArea())
	Local cProd		:= ""
	Local nIndSB1	:= 0
	Local aRet		:= {}                      
	Local cLote		:= CriaVar("D3_LOTECTL",.F.)
	Local cSubLote	:= CriaVar("D3_NUMLOTE",.F.)
	Local dDtValid	:= CriaVar("B8_DTVALID",.F.)
	Local aTela		:= VtSave()
	Local nTamQtd	:= 4
	Local nQtd		:= 1
	
	Private aProdutos := {}
		
	nIndSB1 := SB1->(IndexOrd())
	SB1->( dbSetOrder(1) )
	SLK->( dbSetOrder(1) )
	
	If !Empty(cID)
		nX_ACDV040 	:= 1
		
		// Codigo de barras atual - PPPPPPPPPSSSSQQQQ - P=Produto(9) / S=Sequencial(4) / Q=Quantidade(4) = 17
		SB1->( dbSetOrder(1) )
		If Len(Alltrim(cID)) == 17 .and. SB1->( dbSeek( xFilial("SB1") + Substr(cID, 1, Len(Alltrim(cID))-8) ) ) .and. !Empty(Right(Alltrim(cID),nTamQtd))
			cProd := SB1->B1_COD
			nQtd  := Val(Right(Alltrim(cID),nTamQtd))
		Endif
		
		//EAN 14
		If Empty(cProd)
			SLK->( dbSetOrder(1) )
			If SLK->( dbSeek( FwxFilial("SLK") + Alltrim(cID) ) )
				If MultiCod("SLK",SLK->LK_CODBAR) 
					If IsInCallStack("U_ALACDA01") .and. !IsInCallStack("ACDV110")
						CodBarNF( @cProd, @nQtd, CB7->CB7_NOTA, CB7->CB7_SERIE, CB7->CB7_CLIENT, CB7->CB7_LOJA)
					Else
						ListaProds( @cProd, @nQtd, aProdutos )
					Endif
				Else
					cProd 	:= SLK->LK_CODIGO
					nQtd	:= SLK->LK_QUANT
				Endif
			Endif
		Endif
		
		// EAN 13
		If Empty(cProd)
			SB1->( dbSetOrder(5) )
			If SB1->( dbSeek( xFilial("SB1") + Alltrim(cID) ) )
				If MultiCod("SB1",SB1->B1_CODBAR) 
					If IsInCallStack("U_ALACDA01") .and. !IsInCallStack("ACDV110")
						CodBarNF( @cProd, @nQtd, CB7->CB7_NOTA, CB7->CB7_SERIE, CB7->CB7_CLIENT, CB7->CB7_LOJA)
					Else
						ListaProds( @cProd, @nQtd, aProdutos )
					Endif
				Else
					cProd	:= SB1->B1_COD
				Endif
			Endif
		Endif
		
		// Codigo do produto 
		SB1->( dbSetOrder(1) )
		If SB1->( dbSeek( xFilial("SB1") + Alltrim(cID) ))
			cProd := SB1->B1_COD
		Endif
		
	Else
		If IsInCallStack("ACDV040X")
			aRet := { aHisEti[nX_ACDV040,1], aHisEti[nX_ACDV040,3], Padr(aHisEti[nX_ACDV040,4], TamSx3("DB_LOTECTL")[1]), StoD(""), CriaVar("DB_NUMSERI", .F.),CriaVar("DB_NUMLOTE",.F.)  }
			nX_ACDV040++
		Endif
	Endif
	
	If !Empty(cProd)		
		
		Posicione("SB5",1, xFilial("SB5") + cProd, "")
		
		aRet := { cProd, nQtd, Padr(cLote, TamSx3("DB_LOTECTL")[1]),dDtValid , CriaVar("DB_NUMSERI", .F.), Padr(cSublote,TamSx3("DB_NUMLOTE")[1]) }
		
	Endif
	
	//RestArea(aAreaSB1)
	SB1->( dbSetOrder( nIndSB1 ) )
	RestArea(aAreaAtu)

Return aRet

// Função para verificar se o código de barras possui vários produtos
Static Function MultiCod( cTabela, cCodBar)

	Local lRet 		:= .F.
	Local cQuery 	:= ""
	
	If cTabela == "SLK"
	
		cQuery := "	SELECT LK_CODIGO COD, LK_QUANT QTD" + CRLF
		cQuery += " FROM "+ RetSqlName("SLK") +" LK" + CRLF
		cQuery += " WHERE LK_FILIAL = '"+ FwXFilial("SLK")+"'" + CRLF
		cQuery += " AND LK.D_E_L_E_T_=' '" + CRLF
		cQuery += " AND LK_CODBAR = '"+ cCodBar +"'
	
	Elseif cTabela == "SB1"
		
		cQuery := "	SELECT B1_COD COD, 1 QTD" + CRLF
		cQuery += " FROM "+ RetSqlName("SB1") +" B1" + CRLF
		cQuery += " WHERE B1_FILIAL = '"+ FwXFilial("SB1")+"'" + CRLF
		cQuery += " AND B1.D_E_L_E_T_=' '" + CRLF
		cQuery += " AND B1_CODBAR = '"+ cCodBar +"'
		
	Endif

	If Select("QCODBAR") > 0
		QCODBAR->(dbCloseArea())
	Endif
	
	tcQuery cQuery New Alias "QCODBAR"
	
	While QCODBAR->(!eof())
		aAdd( aProdutos, {QCODBAR->COD, QCODBAR->QTD})
		QCODBAR->(dbSkip())
	EndDo
	
	QCODBAR->(dbCloseArea())
	
	lRet := Len(aProdutos) > 1
	
Return lRet

// Função que tenta buscar os produtos da NF que pertencem ao código de barras múltiplo
Static Function CodBarNF( cProd, nQtd, cNF, cSerie, cCliente, cLoja)

	Local aAreaAtu 	:= GetArea()
	Local aAreaSD2	:= SD2->(GetArea())
	Local nX		:= 0
	Local aProdOK	:= {}
	
	SD2->(dbSetOrder(3))
	
	For nX := 1 To Len(aProdutos)
		If SD2->(dbSeek(FwXFilial("SD2") + cNF + cSerie + cCliente + cLoja + aProdutos[nX,1]))
			aAdd( aProdOK, aProdutos[nX] )
		Endif
	Next nX

	If Len(aProdOK) > 1
		ListaProds(@cProd, @nQtd, aProdOK)
	Elseif Len(aProdOK) == 1
		cProd 	:= aProdOK[1,1]
		nQtd	:= aProdOK[1,2]
	Endif

	RestArea(aAreaSD2)
	RestArea(aAreaAtu)
	
Return

Static Function ListaProds( cProd, nQtd, aProdTemp)

	Local nLin 		:= 0
	Local aTela 	:= VtSave()
	Local nSelect 	:= 0
	Local aProd		:= {}
	Local nX		:= 0
	
	For nX := 1 To Len(aProdTemp)
		aAdd(aProd, aProdTemp[nX,1])
	Next nX
	
	@ nLin++, 0 VTSAY "Selecione o cod:"
	nSelect := VTaChoice(nLin,0,6,VTMaxCol(),aProd)
	
	If nSelect > 0
		cProd	:= aProdTemp[nSelect,1]
		nQtd	:= aProdTemp[nSelect,2]
	Endif
				
	VtRestore(,,,,aTela)

Return