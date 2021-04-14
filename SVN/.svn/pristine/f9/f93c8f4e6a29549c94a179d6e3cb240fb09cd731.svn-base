#Include "protheus.ch"
#Include "topconn.ch"
#Define cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} FATA0004

Rotina de liberacao de pedidos
	
@author Ademar Junior
@since 08/05/2015                      

/*/

User Function FATA0004()
	
	Local cPerg		:= "FATA0004"	// Grupo de perguntas

	// Chamada ValidPerg
	//ValidPerg(cPerg,1) //Comentado por Eduardo Cestari (Totvs IP) 07/11/2019 para funcionamento no P12.1.25
	
	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	// Tela de processamento
	Processa({|| ExecLibPV() },"Executando liberação.")
	
Return Nil


/****************************************************************************************************/


// Função 	: ExcLib
// Desc.	: Executa liberacao
Static Function ExecLibPV()	

	Local nAQtdLib	:= 0			// Auxiliar quantidade liberada
	Local aArea		:= Lj7GetArea({"SC5"})	// Area total
	Local lExeLib	:= .F.			// Executou liberacao
	Local nAuxLib	:= 0			// Quantidade a ser liberada

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	
	// Posicionar pedido
	If SC5->(DbSeek(xFilial("SC5") + mv_par01))
		
		// Percorrer pedidos parametrizados
		While SC5->(!EOF()) .And. SC5->C5_FILIAL == xFilial("SC5") .And. SC5->C5_NUM <= mv_par02
			
			// Executa liberação
			U_FATA0005(SC5->C5_NUM)
			
			SC5->(DbSkip())

		EndDo

	EndIf 
	
	Lj7RestArea(aArea)
	
Return Nil


/****************************************************************************************************/


// Funcao		: ValidPerg(cPerg)
// Descricao	: Verifica a existencia do grupo de perguntas, caso nao exista cria.
Static Function ValidPerg(cPerg)
	
	Local aAlias := Alias()
	Local aRegs := {}
	Local i,j       
	Local aCposSX1 := FWSX1Util():GetGroup(cPerg)                                                                                                                         
	
	SX1->(DbSelectArea("SX1"))
	SX1->(DbSetOrder(1))
	
	cPerg := PADR(cPerg,Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))
	
	//Grupo - Ordem - Pergunta - Variavel - Tipo - Tamanho - Decimal - Presel - GSC - Valid - Var01 - Def01 - Cnt01 - Var02 - Def02 - Cnt02 - Var03 - Def03 - Cnt03 - Var04 - Def04 - Cnt04 - Var05 - Def05 - Cnt05
	AADD(aRegs,{cPerg,"01","Pedido De   ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	AADD(aRegs,{cPerg,"02","Pedido Até  ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	
	For i := 1 To Len(aRegs)
		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
			RecLock("SX1",.T.)
			For j := 1 To FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			SX1->(MsUnlock())
		EndIf
	Next
	
	DbSelectArea(aAlias)
	
Return Nil