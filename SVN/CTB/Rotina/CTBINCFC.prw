#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBINCFC º Autor ³ J.DONIZETE R.SILVA º Data ³  14/02/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para carga de clientes e fornecedores no plano de º±±
±±º          ³ contas.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado pelos pontos de entrada M020INC/M030INC/Outros.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºData      ³ Alterações                                                 º±±
±±º          ³                                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBINCFC(_cCad)

// Parâmetros
//	_cCad
//		1 = Clientes
//		2 = Fornecedores

// Declaração das Variáveis.
Local _xAreaCF 	:= Iif(_cCad=="1",SA1->(GetArea()),SA2->(GetArea()))
Local _xAreaCT1		:= {}
Local _xAreaSM0		:= {}
Local _xAreaSX2 	:= {}

Local _cNome		:= Iif(_cCad=="1",SA1->A1_NOME,SA2->A2_NOME)
Local _cCod			:= Iif(_cCad=="1",SUBS(SA1->A1_COD,2,5),SUBS(SA2->A2_COD,2,5))
Local _cEst			:= Iif(_cCad=="1",SA1->A1_EST,SA2->A2_EST)
Local _cConta		:= ""
Local _cCtaSint		:= ""

Local _aCad		  	:= {}
Local _lCria		:= .f. // Esta variável define se será criado ou não conta analítica. A alteração da mesma
Local lMsErroAuto   := .F.
Local lMsHelpAuto   := .T.

Local _cAlias		:= Iif(_cCad=="1","SA1","SA2")
Local _cModoSA1SA2 	:= ""
Local _cModoCT1 	:= ""
Local _cTipo		:= SubStr(Iif(_cCad=="1",SA1->A1_COD,SA2->A2_COD),1,1)
Local _cFilial		:= ""
Local _cEmpAnt		:= cEmpAnt // Guardar a empresa atual
Local _cFilAnt		:= cFilAnt // Guardar a filial atual
Local _lCriaEmp		:= .f.
Local _lSA1SA2C		:= .f.
Local _lProc		:= .t.

// Não processa se não houver parâmetros.
If !_cCad $ "1,2"
	Return(.f.)
EndIf

// Processa somente se o módulo for SIGACTB e a opção for de Inclusão.
If Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB"
	
	// Verifica o compartilhamento de arquivos.
	dbSelectArea("SX2")
	_xAreaSX2 := GetArea()
	dbSetOrder(1)
	//If dbSeek(_cAlias)
		_cModoSA1SA2 := FWModeAccess(_cAlias, 3)//SX2->X2_MODO
	/*Else
		MsgStop("Alias "+_cAlias+" não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf*/
	If dbSeek("CT1")
		_cModoCT1 := FWModeAccess("CT1", 3)//SX2->X2_MODO
	Else
		MsgStop("Alias CT1 não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf
	
	If _cModoSA1SA2=="E" .And. _cModoCT1=="C"
		MsgStop("Conflito de compartilhamento: "+_cAlias+"=Exclusivo e CT1=Compartilhado.","CTBIMPFC")
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	Endif
	
	//Restaura SX2.
	RestArea(_xAreaSX2)
	
	dbSelectArea(_cAlias)
	//_xAreaCF := GetArea()
	
	If (_cModoSA1SA2=="E" .And. _cModoCT1=="E") .Or. (_cModoSA1SA2=="C" .And. _cModoCT1=="C")
		_cFilial := Iif(_cCad=="1",SA1->A1_FILIAL,SA2->A2_FILIAL)
		cFilAnt	:= _cFilial
	ElseIf _cModoSA1SA2=="C" .And. _cModoCT1=="E"
		_lSA1SA2C := .t.
	EndIf
	
	// Este escopo deve ser atualizado com as regras definidas pelo Contador.
	If _cCad == "1"
		Do case
			Case _cTipo $ "IE" // Clientes em Geral.
				_cCtaSint	:= "110201"
				_lCria := .t.
			OtherWise // Não cria a conta.
				_cConta := ""
				_lCria := .f.
		EndCase
		
	Else
		Do case       
			Case _cTipo $ "I" // Fornecedores Mercado Interno
				_cCtaSint := "210401"
				_lCria := .t.   
			Case _cTipo $ "E" // Fornecedores Mercado Externo
		   		_cCtaSint := "210401"
				_lCria := .t.	
			/*
			Case _cTipo $ "0123456" // Estoques
				_cCtaSint := "210101001"
				_lCria := .t.
			Case _cTipo $ "7" // Fretes
				_cCtaSint := "210102001"
				_lCria := .t.
			Case _cTipo $ "8" // Servicos
				_cCtaSint :="210103002"
				_lCria := .t.
			Case _cTipo $ "9" // Diversos
				_cCtaSint :="210104001"
				_lCria := .t.
			Case _cTipo $ "F,O" // Funcionários/Contas a Pagar
				_cConta :="210705008"
				_lCria := .f.
			Case _cTipo $ "V" // Vendedores
				_cCtaSint :="210103001"
				_lCria := .t.           
			*/
				
			OtherWise // Não cria a conta.
				_cConta := ""
				_lCria := .f.
		EndCase
	EndIf
	
	If _lCria
		
		_cConta := _cCtaSint + _cCod
		
		dbSelectArea("SM0")
		_xAreaSM0 := GetArea()
		dbSetOrder(1)
		
		While !Eof() .And. _lProc
			
			If _lProc
				If (SM0->M0_CODIGO <> cEmpAnt)
					dbSkip()
					Loop
				EndIf
			EndIf
			
			If _lSA1SA2C
				cFilAnt	 := SM0->M0_CODFIL
				_cFilial := cFilAnt
			Else
				_lProc := .f.
			EndIf
			
			dbSelectArea("CT1")
			_xAreaCT1 := GetArea()
			dbSetOrder(1)
			DbSeek(_cFilial + _cConta)
			// Se encontrar, atualiza a descrição do plano de contas.
			If Found()
				If CT1->CT1_DESC01 <> _cNome
					If RecLock("CT1",.f.) // Atualiza a razão social
						CT1->CT1_DESC01 := _cNome
						msunlock()
					EndIf
				EndIf
				// Caso não encontre a conta no plano de contas, criar a mesma.
			Else
				// Alimenta matriz com os dados do registro a ser criado.
				aAdd( _aCad , { "CT1_FILIAL"  , _cFilial       , Nil } )
				aAdd( _aCad , { "CT1_CONTA "  , _cConta        , Nil } )
				aAdd( _aCad , { "CT1_DESC01"  , _cNome         , Nil } )
				aAdd( _aCad , { "CT1_CLASSE"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_NORMAL"  , _cCad          , Nil } )
				//aAdd( _aCad , { "CT1_RES"     , _cCod          , Nil } )
				//aAdd( _aCad , { "CT1_CTASUP"  , _cConta        , Nil } ) // O próprio sistema cria a cta.superior
				aAdd( _aCad , { "CT1_ACITEM"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_ACCUST"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_ACCLVL"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_CCOBRG"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_ITOBRG"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_CLOBRG"  , "2"            , Nil } )
				aAdd( _aCad , { "CT1_CTAVM "  , ""             , Nil } )
				aAdd( _aCad , { "CT1_NTSPED"  , IIF(_cCad == "1","01","02")		, Nil } )
				aAdd( _aCad , { "CT1_SPEDST"  , "2", 				Nil } )
				aAdd( _aCad , { "CT1_RGNV1 "  , "N"             , Nil } )
				aAdd( _aCad , { "CT1_BOOK  "  , "001/002/003/004/005"           , Nil } )
				
				// Inclui a conta contábil através de rotina automática.
				MSExecAuto({|x,y| CTBA020(x,y)},_aCad,3)
				If lMsErroAuto
					MostraErro()
					Alert("Não foi possível incluir registro.")
				Endif
				
			Endif
			
			dbSelectArea("SM0")
			dbSkip()
			
		EndDo
		
		// Restaura dados da empresa anterior.
		cEmpAnt := _cEmpAnt
		cFilAnt	:= _cFilAnt
		
		// Restaura áreas de trabalho.
		RestArea(_xAreaSM0)
		RestArea(_xAreaCT1)
		
	EndIf
	
	// Restaura áreas de trabalho.
	RestArea(_xAreaCF)
	
	// Atualiza a conta no cadastro do Cliente.
	If _cCad=="1"
		If Empty(SA1->A1_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA1->A1_CONTA	with _cConta
				MsUnlock()
			EndIf
		Endif
	Else
		If Empty(SA2->A2_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA2->A2_CONTA	with _cConta
				MsUnlock()
			EndIf
		EndIf
	Endif
Endif

Return(.t.)
