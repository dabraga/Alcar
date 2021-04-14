#Include 'Protheus.ch'

/**
 * Rotina		:	ALAPCP01
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	28/11/2013
 * Descrição	:	Rotina responsável pela sepação manual de mercadorias
 * Módulo		:  	PCP
**/

User Function ALAPCP01()

Local aCores		:= {{"SF2->F2_ZZSTSEP = 'F'", "BR_VERMELHO"},;
						{"SF2->F2_ZZSTSEP = 'I'", "BR_AMARELO"},;
						{"SF2->F2_ZZSTSEP = 'N' .OR. Empty(SF2->F2_ZZSTSEP)", "BR_VERDE"}} 

Private cAliasSF2	:= "SF2"
Private cAliasSD2	:= "SD2"						
Private cCadastro	:= "Separação de Mercadorias"
Private aRotina 	:= {{"Separação"	,"U_LANCSEP", 0, 4},;
						{"Legenda"		,"U_LEGSEP", 0, 6}}
          
dbSelectArea(cAliasSF2)
dbSetOrder(1)
	
mBrowse(,,,, cAliasSF2,,,,,, aCores)

Return

User Function LANCSEP(cAlias, nReg, nOpc)

Local cLinok 		:= "U_ValQtdSep"
Local cTudook 	:= "AllwaysTrue"
Local nOpce 		:= nOpc
Local nOpcg 		:= nOpc
Local cFieldok 	:= "AllwaysTrue"
Local lVirtual 	:= .T.
Local nLinhas 	:= 0
Local nFreeze 	:= 0
Local lRet 		:= .T.
 
Private aCols 		:= {}
Private aHeader 		:= {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
//Private aAlt 		:= {}

Regtomemory(cAliasSF2, .F.)
 
CriaHeader()
 
CriaCols(@nLinhas)
 
lRet := Modelo3(cCadastro, cAliasSF2, cAliasSD2, aCpoEnchoice, cLinok, cTudook, nOpce, nOpcg, cFieldok, ; 
					lVirtual, nLinhas, aAltenchoice, nFreeze)
 
If lRet
	GravaSep()
Endif

Return Nil

Static Function CriaHeader()
Local aCposSD2 := FWSX3Util():GetAllFields("SD2")
Local aCposSF2 := FWSX3Util():GetAllFields("SF2")
Local nI := 1
Local I := 1
aHeader		:= {}
aCpoEnchoice 	:= {}
aAltEnchoice 	:= {}
 
dbselectarea("SX3")
dbsetorder(1)
dbseek(cAliasSD2)

For nI := 1 to Len(aCposSD2) 
//While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAliasSD2

	If X3USO(GetSX3Cache(aCposSD2[nI], "X3_USADO")/*SX3->X3_USADO*/) .And. cNivel >= GetSX3Cache(aCposSD2[nI], "X3_NIVEL")/*SX3->X3_NIVEL*/ .And. (AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_COD" .Or. AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_ITEM" .Or. ;
		AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_QUANT" .Or. AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_UM" .Or. AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_LOCALIZ" .Or. ; 
		AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_ZZQTSEP")

		aAdd(aHeader, {Trim(GetSX3Cache(aCposSD2[nI], "X3_TITULO")/*SX3->X3_TITULO*/), ; 
						 GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_PICTURE")/*SX3->X3_PICTURE*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_TAMANHO")/*SX3->X3_TAMANHO*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_DECIMAL")/*SX3->X3_DECIMAL*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_VALID")/*SX3->X3_VALID*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_USADO")/*SX3->X3_USADO*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_TIPO")/*SX3->X3_TIPO*/, ;
						 GetSX3Cache(aCposSD2[nI], "X3_ARQUIVO")/*SX3->X3_ARQUIVO*/, ; 
						 GetSX3Cache(aCposSD2[nI], "X3_CONTEXT")/*SX3->X3_CONTEXT*/})
		
		If AllTrim(GetSX3Cache(aCposSD2[nI], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "D2_COD"
			aAdd(aHeader, {"Descricao", ; 
						 	 "B1_DESC", ;
						 	 "@!", ;
						 	 30, ;
						 	 0, ;
						 	 "texto()", ;
						 	 "€€€€€€€€€€€€€€", ;
						 	 "C", ;
						 	 "SB1", ; 
						 	 ""})
		Endif
		
	Endif
Next nI 
	//SX3->(DbSkip())
	
//Enddo
 
Dbseek(cAliasSF2)
 
//While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAliasSF2
For I := 1 to Len(aCposSF2)
	
	If X3USO(GetSX3Cache(aCposSF2[I], "X3_USADO")/*SX3->X3_USADO*/) .And. cNivel >= GetSX3Cache(aCposSF2[I], "X3_NIVEL")/*SX3->X3_NIVEL*/ .And. (AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "F2_DOC" .Or. ;
		AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "F2_SERIE" .Or. AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) == "F2_CLIENTE" .Or. ;
		AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) = "F2_LOJA" .Or. AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) = "F2_EMISSAO" .Or. AllTrim(GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/) = "F2_NOMCLI") 
	
		aAdd(aCpoEnchoice, GetSX3Cache(aCposSF2[I], "X3_CAMPO")/*SX3->X3_CAMPO*/)
	
	Endif
Next I
	//SX3->(DbSkip())
	
//Enddo
 
Return

Static function CriaCols(nLinhas)
 
Local nQtdCpo 	:= 0
Local nI		:= 0
Local nCols 	:= 0

nQtdCpo:= Len(aHeader)
aCols	:= {}
 
DbSelectArea(cAliasSD2)
DbSetOrder(3)
DbSeek((cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
	 
While !(cAliasSD2)->(Eof()) .And. (cAliasSD2)->D2_FILIAL == (cAliasSF2)->F2_FILIAL .And. (cAliasSD2)->D2_DOC == (cAliasSF2)->F2_DOC .And. ;
		(cAliasSD2)->D2_SERIE == (cAliasSF2)->F2_SERIE .And. (cAliasSD2)->D2_CLIENTE == (cAliasSF2)->F2_CLIENTE .And. ;
		(cAliasSD2)->D2_LOJA == (cAliasSF2)->F2_LOJA
		
	aAdd(aCols, Array(nQtdcpo+1))
	
	nLinhas++
	 
	For nI := 1 To nQtdCpo
	
		If aHeader[nI, 2] == "B1_DESC"
			aCols[nLinhas, nI] := Posicione("SB1", 1, xFilial("SB1")+ FieldGet(FieldPos("D2_COD")), "SB1->B1_DESC")
		Else
	
			If aHeader[nI, 10] <> "V"
				aCols[nLinhas, nI] := FieldGet(FieldPos(aHeader[nI, 2]))
			Else
				aCols[nLinhas, nI] := Criavar(aHeader[nI, 2], .T.)
			Endif
	
		Endif
	
	Next nI
		 
	aCols[nLinhas, nQtdcpo+1] := .F.
		 
	(cAliasSD2)->(DbSkip()) 
	
Enddo

Return

Static Function GravaSep()

Local nI 			:= 0
Local nTotQtd 		:= 0
Local nTotSep 		:= 0
Local nPosItem 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_ITEM"})
Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_COD"})
Local nPosQtd		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_QUANT"}) 
Local nPosQtdSep 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_ZZQTSEP"}) 

DbSelectArea(cAliasSD2)
DbSetOrder(3)

For nI := 1 To Len(aCols)

	If DbSeek(M->F2_FILIAL+M->F2_DOC+M->F2_SERIE+M->F2_CLIENTE+M->F2_LOJA+aCols[nI, nPosProd]+aCols[nI, nPosItem])
	
		RecLock(cAliasSD2, .F.)
			(cAliasSD2)->D2_ZZQTSEP := aCols[nI, nPosQtdSep] 
		(cAliasSD2)->(MsUnlock())
		
		nTotQtd += aCols[nI, nPosQtd] 
		nTotSep += aCols[nI, nPosQtdSep]
	
	Endif
	 
Next nI 

DbSelectArea(cAliasSF2)
DbSetOrder(1)
DbSeek(M->F2_FILIAL+M->F2_DOC+M->F2_SERIE+M->F2_CLIENTE+M->F2_LOJA)

RecLock(cAliasSF2, .F.)
	(cAliasSF2)->F2_ZZSTSEP := IIF(nTotSep == 0, "N", IIF(nTotSep == nTotQtd, "F", "I")) 
(cAliasSF2)->(MsUnlock())

Return

User Function ValQtdSep()

Local nPosQtd		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_QUANT"}) 
Local nPosQtdSep 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D2_ZZQTSEP"}) 
Local lValidOK		:= .T.

If aCols[n, nPosQtdSep] > aCols[n, nPosQtd]

	lValidOK := .F.
	Aviso("Atenção", "Quantidade de separação não pode ser maior que a quantidade do produto", {"Ok"})

Endif
 
Return lValidOK

User Function LEGSEP()

aLegenda := {	{"BR_VERDE", "NF não separada"},;
				{"BR_AMARELO", "NF em separação"},;
			 	{"BR_VERMELHO", "NF separada"} }
                 
BrwLegenda("Separação de Mercadorias", "Legenda", aLegenda)
   
Return Nil