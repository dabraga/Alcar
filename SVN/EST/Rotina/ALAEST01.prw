#INCLUDE 'PROTHEUS.CH'

#DEFINE TM			1
#DEFINE CCUSTO		2
#DEFINE EMISSAO		3
#DEFINE PRODUTO		4
#DEFINE ARMAZEM		5
#DEFINE QUANTIDADE	6
#DEFINE CUSTO		7
#DEFINE OBSERVACAO	8

/*/{Protheus.doc} ALAEST01

Rotina responsável pela inclusão de movimentação interna MOD2 através de importação de arquivo CSV

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 22/10/2015
@version Protheus 11 - Estoque

/*/

User Function ALAEST01()

	Local aSays		:= {}
	Local aButtons	:= {}
	Local lImport	:= .F.
	Local cFile 	:= ""
	
	Aadd(aSays, "Rotina responsável pela importação de arquivo CSV para movimentação interna mod. 2")
		
	Aadd(aButtons, {5, 	.T., {|| GetImportFile(@cFile)}})
	Aadd(aButtons, {1, 	.T., {|o| lImport := .T., o:oWnd:End()}})
	Aadd(aButtons, {2, 	.T., {|o| o:oWnd:End()}})
	
	FormBatch("Importação Movimentação Interna", aSays, aButtons)
	
	If lImport

		If !Empty(cFile)
			
			If Upper(Subst(AllTrim(cFile), -3)) == Upper(AllTrim("CSV"))
				Processa({|| ImportFile(cFile)}, "Aguarde", "Importando arquivo", .F.)
			Else
				Aviso("Totvs", "Arquivo inválido", {"Ok"})
			EndIf
			
		Else
			Aviso("Totvs", "Nenhum arquivo selecionado", {"Ok"})
		EndIf
	
	EndIf

Return Nil

Static Function GetImportFile(cFile)

	cFile := cGetFile("Comma Separated Values(*.CSV)|*.CSV", "Selecione o arquivo",,, .T., GETF_LOCALHARD + GETF_NETWORKDRIVE, .F.)
	
Return Nil

Static Function ImportFile(cFile)
	
	Local nI		:= 0
	Local aDataSD3	:= {}
	Local aCabec	:= {}
	Local aItem		:= {}
	Local aItens	:= {}
	Local aDataFile	:= FileToArr(cFile)
	
	Private lMsHelpAuto := .T. 
	Private lMsErroAuto := .F. 
	
	ProcRegua(Len(aDataFile))

	If Len(aDataFile) >= 2
		
		aDataSD3 := StrTokArr(aDataFile[2], ";")
			
		aCabec := { {"D3_TM",		aDataSD3[TM], 			 Nil},;
					{"D3_CC",		aDataSD3[CCUSTO], 		 Nil},;
					{"D3_EMISSAO",	CToD(aDataSD3[EMISSAO]), Nil}} 

		For nI:= 2 To Len(aDataFile)
		
			IncProc("Carregando informações")
		
			aDataSD3 := StrTokArr(aDataFile[nI], ";")
				
			aItem := {{"D3_COD",	aDataSD3[PRODUTO],	 							Nil},;
					  {"D3_QUANT",	Val(StrTran(aDataSD3[QUANTIDADE], ",", ".")),	NIl},;
					  {"D3_LOCAL",	aDataSD3[ARMAZEM],								Nil},;
					  {"D3_CUSTO1",	Val(StrTran(aDataSD3[CUSTO], ",", ".")),		Nil},;
					  {"D3_ZZOBS",	aDataSD3[OBSERVACAO],							Nil}}
						 
			aadd(aItens, aItem) 
			
		Next nI
		
		IncProc("Importando movimentação")

		Begin Transaction
					
			MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCabec, aItens, 3)
			
			If lMsErroAuto 
				MostraErro() 
			EndIf
			
		End Transaction
		
	Else
		Aviso("Totvs", "Arquivo sem dados para serem importados.", {"Ok"})
	EndIf
	
Return Nil