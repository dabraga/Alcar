
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIM  ºAutor  ³Deivid A. C. de Limaº Data ³  19/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no final da geracao da NF Saida, utilizadoº±±
±±º          ³ para gravacao de dados adicionais.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M460FIM()

Local aArea		:= GetArea()
Local aAreaSF2	:= SF2->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
Local oTMsg  		:= FswTemplMsg():TemplMsg("S", SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
Local nPLiqui		:= 0
Local nPBruto		:= 0

// Variaveis para inclusão automática da ordem de separação
Private nEmbSimuNF := 0
Private nEmbalagNF := 0
Private nEmbalagem := 0
Private nImpNotaNF := 0
Private nImpVolNF := 0
Private nEmbarqNF := 0
Private cSeparador := ""

&& inicio calculo do peso liquido
SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

Do While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	
	nPLiqui += SD2->D2_QUANT * Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "B1_PESO")
	nPBruto += SD2->D2_QUANT * Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "B1_PESBRU")

	//Atualiza informações do cliente
	SC9->(DbSetOrder(7)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_PRODUTO+C9_NFISCAL+C9_SERIENF
	
	If SC9->(DbSeek(xFilial("SC9")+SD2->(D2_COD+D2_LOCAL+D2_NUMSEQ)))
	    
	    
		SD2->(RecLock("SD2", .F.))
			SD2->D2_ZZNUMPC 	:= SC9->C9_ZZNUMPC
			SD2->D2_ZZITEMP 	:= SC9->C9_ZZITEMP
			SD2->D2_ZZPEDCL 	:= SC9->C9_ZZPEDCL
			SD2->D2_ZZPRDCL 	:= SC9->C9_ZZPRDCL
			SD2->D2_ZZDES 	:= SC9->C9_ZZDES
			SD2->D2_ZZREQ 	:= SC9->C9_ZZREQ	
		SD2->(MsUnlock())
	
	EndIf
		
	SD2->(dbSkip())
	
Enddo
&& fim

&& inicio template mensagens da NF
SD2->(dbSetOrder(3)) ////D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

SC5->(dbSetOrder(1)) //C5_FILIAL+C5_NUM
SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

aAdd(oTMsg:aCampos,{"F2_TRANSP" , SC5->C5_TRANSP})
aAdd(oTMsg:aCampos,{"F2_REDESP" , SC5->C5_REDESP})
aAdd(oTMsg:aCampos,{"F2_PLIQUI" , nPLiqui})
aAdd(oTMsg:aCampos,{"F2_PBRUTO" , nPBruto})
aAdd(oTMsg:aCampos,{"F2_VOLUME1", SF2->F2_VOLUME1})
aAdd(oTMsg:aCampos,{"F2_ESPECI1", SC5->C5_ESPECI1})
aAdd(oTMsg:aCampos,{"F2_ZZPLACA", CriaVar("F2_ZZPLACA")})
aAdd(oTMsg:aCampos,{"F2_ZZUFPLA", CriaVar("F2_ZZUFPLA")})
aAdd(oTMsg:aCampos,{"F2_ZZDTSAI", dDatabase})
aAdd(oTMsg:aCampos,{"F2_ZZHRSAI", Time()})
aAdd(oTMsg:aCampos,{"F2_ZZMARCA", CriaVar("F2_ZZMARCA")})
aAdd(oTMsg:aCampos,{"F2_ZZNUMER", CriaVar("F2_ZZNUMER")})
aAdd(oTMsg:aCampos,{"F2_ZZOBSIN", CriaVar("F2_ZZOBSIN")})
aAdd(oTMsg:aCampos,{"F2_ZZTIPO", CriaVar("F2_ZZTIPO")})

oTMsg:Processa()

RecLock("SC5",.F.)
	SC5->C5_TRANSP := SF2->F2_TRANSP
	SC5->C5_REDESP := SF2->F2_REDESP
MsUnlock()

&& fim template mensagens da NF

//Trativa para complemento da nota de exportação
If SF2->F2_EST == "EX"
	InfComplExp()
EndIf

// Adicionado por Guilherme Ricci - 23/11/2018 - Geracao de ordem de separação automática
If GetMV("MV_INTACD",,"0") == "1" .and. VldRegra()
	Processa({|| GeraOSepNota(,,SF2->(F2_DOC+F2_SERIE))}, "Gerando Ordem de Separação...")
Endif

RestArea(aAreaSC9)
RestArea(aAreaSC5)
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aArea)

Return

/*/{Protheus.doc} InfComplExp

Função responsável por gravar o complemento de exportação
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/11/2014
@version Protheus 11 - Faturamento

/*/
Static Function InfComplExp()

Local cRE         := Space(Len(SF2->F2_ZZNUMRE))
Local cLocal      := Space(Len(SF2->F2_ZZLOCRE))
Local cUF         := Space(Len(SF2->F2_ZZUFRE))
Local dDtRE       := CToD(" ")
Local aButtons    := {}
	
DEFINE MSDIALOG oDialog FROM 000,000 TO 220,430 TITLE alltrim(oemToAnsi("NF Exportação")) PIXEL
DEFINE FONT oFontWin  NAME 'Arial' 		SIZE 6, 15 BOLD
DEFINE FONT oFontMemo NAME 'Courier New' 	SIZE 0,15
		
oDialog:lEscClose := .f.
		
@ 035,010 SAY OemToAnsi("R.E.:")						OF oDialog PIXEL
@ 035,060 MSGET cRE PICTURE "@!" SIZE 70,10			OF oDialog PIXEL VALID !Empty(cRE)

@ 055,010 SAY OemToAnsi("Data RE:")					OF oDialog PIXEL 
@ 055,060 MSGET dDtRE SIZE 40,10						OF oDialog PIXEL 
		
@ 075,010 SAY OemToAnsi("Local Embarc.:")				OF oDialog PIXEL 
@ 075,060 MSGET cLocal PICTURE "@!" SIZE 150,10		OF oDialog PIXEL VALID !Empty(cLocal)
		
@ 095,010 SAY OemToAnsi("UF Embarc.:")					OF oDialog PIXEL
@ 095,060 MSGET cUF PICTURE "@!" F3 "12" SIZE 20,10	OF oDialog PIXEL VALID ExistCpo("SX5", "12"+cUF)
		
ACTIVATE MSDIALOG oDialog CENTERED ON INIT EnchoiceBar(oDialog, {|| oDialog:End()}, {|| oDialog:End()},, aButtons)
	
SF2->(RecLock("SF2", .F.))
	SF2->F2_ZZNUMRE	:= cRE
	SF2->F2_ZZDTRE	:= dDtRE
	SF2->F2_ZZLOCRE	:= cLocal
	SF2->F2_ZZUFRE	:= cUF
SF2->(MsUnLock())
	
GravaCDL()

Return

/*/{Protheus.doc} GravaCDL

Função responsável pela gravação da tabela CDL (Complemento de Exportação)
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/11/2014
@version Protheus 11 - Faturamento

/*/
Static Function GravaCDL()
	
CDL->(DbSetorder(2)) //CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_ITEMNF+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG
CDL->(DbSeek(xFilial("CDL")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	
While !CDL->(Eof()) .And. CDL->(CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENTE+CDL_LOJA) == xFilial("CDL")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	
	RecLock("CDL", .F.)
		CDL->(DbDelete())
	MsUnlock()
	
	CDL->(dbSkip())
	
EndDo
		
SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	
While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	
	If RecLock("CDL", .T.)
	
		CDL->CDL_FILIAL 	:= xFilial("CDL")
		CDL->CDL_DOC 		:= SF2->F2_DOC
		CDL->CDL_SERIE 	:= SF2->F2_SERIE
		CDL->CDL_ESPEC 	:= SF2->F2_ESPECIE
		CDL->CDL_CLIENT 	:= SF2->F2_CLIENTE
		CDL->CDL_LOJA 	:= SF2->F2_LOJA
		CDL->CDL_PRODNF 	:= SD2->D2_COD
		CDL->CDL_ITEMNF 	:= SD2->D2_ITEM
		CDL->CDL_INDDOC 	:= "0"
		CDL->CDL_NATEXP 	:= "0"
		CDL->CDL_NUMDE 	:= SF2->F2_ZZNUMRE
		CDL->CDL_DTDE 	:= SF2->F2_ZZDTRE
		CDL->CDL_PAIS 	:= Posicione("SA1", 1, xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA, "SA1->A1_PAIS")
		CDL->CDL_UFEMB 	:= SF2->F2_ZZUFRE
		CDL->CDL_LOCEMB	:= SF2->F2_ZZLOCRE
				
		CDL->(MsUnlock())
		
	Endif
				
	SD2->(DbSkip())

EndDo		
		
Return

// Função copiada do fonte padrão ACDA100 e ajustado conforme necessidade
Static Function GeraOSepNota( cMarca, lInverte, cNotaSerie)

Local cChaveDB
Local cTipExp
Local nI
Local cCodOpe
Local aRecSD2 := {}
Local aOrdSep := {}
Local lFilItens  := ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
Local lA100CABE := ExistBlock("A100CABE")
Local lACD100GI := ExistBlock("ACD100GI")
Local lACDA100F := ExistBlock("ACDA100F")

Private aLogOS:= {}

// analisar a pergunta '00-Separcao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque'
If nEmbSimuNF == 1
	cTipExp := "01*"
Else
	cTipExp := "00*"
EndIF
If nEmbalagNF == 1
	cTipExp += "02*"
EndIF
If nImpNotaNF == 1
	cTipExp += "04*"
EndIF
If nImpVolNF == 1
	cTipExp += "05*"
EndIF
If nEmbarqNF == 1
	cTipExp += "06*"
EndIF
/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
If	ExistBlock("ACD100VG")
	If ! ExecBlock("ACD100VG",.F.,.F.,)
		Return
	EndIf		
EndIf

SF2->(DbSetOrder(1))
SD2->(DbSetOrder(3))
SD2->( dbGoTop() )

If cNotaSerie == Nil
	ProcRegua( SD2->( LastRec() ), "oook" )
	cCodOpe	 := cSeparador
Else
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+cNotaSerie))
	cCodOpe := Space(06)
EndIf

ProcRegua( SD2->( LastRec() ), "oook" )
cCodOpe := cSeparador

Begin Transaction

While !SD2->( Eof() ) .and. (cNotaSerie == Nil .or. cNotaSerie == SD2->(D2_DOC+D2_SERIE))
	If (cNotaSerie==NIL) .and. ! (SD2->(IsMark("D2_OK",ThisMark(),ThisInv())))
		SD2->( dbSkip() )
		IncProc()
		Loop
	EndIf
	If lFilItens
		If !ExecBlock("ACDA100I",.F.,.F.)
			SD2->(DbSkip())
			IncProc()
			Loop
		Endif
	Endif
	cChaveDB :=xFilial("SDB")+SD2->(D2_COD+D2_LOCAL+D2_NUMSEQ+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
	If Localiza(SD2->D2_COD)
		SDB->(dbSetOrder(1))
		If ! SDB->(dbSeek( cChaveDB ))
			// neste caso nao existe composicao de empenho
			//Grava o historico das geracoes:
			SD2->(DbSkip())
			If cNotaSerie==Nil
				IncProc()
			EndIf
			Loop
		EndIf
	EndIf

	CB7->(DbSetOrder(4))
	If ! CB7->(DbSeek(xFilial("CB7")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_LOCAL+" "))
		CB7->(RecLock( "CB7", .T. ))
		CB7->CB7_FILIAL := xFilial( "CB7" )
		CB7->CB7_ORDSEP := GetSX8Num( "CB7", "CB7_ORDSEP" )
		CB7->CB7_NOTA   := SD2->D2_DOC
		//CB7->CB7_SERIE  := SD2->D2_SERIE
		SerieNfId ("CB7",1,"CB7_SERIE",,,,SD2->D2_SERIE)
		CB7->CB7_CLIENT := SD2->D2_CLIENTE
		CB7->CB7_LOJA   := SD2->D2_LOJA
		CB7->CB7_LOCAL  := SD2->D2_LOCAL
		CB7->CB7_DTEMIS := dDataBase
		CB7->CB7_HREMIS := Time()
		CB7->CB7_STATUS := " "   // gravar STATUS de nao iniciada somente depois do processo
		CB7->CB7_CODOPE := cCodOpe
		CB7->CB7_PRIORI := "1"
		CB7->CB7_ORIGEM := "2"
		CB7->CB7_TIPEXP := cTipExp
		If SF2->(DbSeek(xFilial("SF2")+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
			CB7->CB7_TRANSP := SF2->F2_TRANSP
		EndIf   
		If	lA100CABE
			ExecBlock("A100CABE",.F.,.F.)
		EndIf
		CB7->(MsUnLock())
		ConfirmSX8()
		//Grava o historico das geracoes:
		aadd(aLogOS,{"1","Nota",SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"",CB7->CB7_ORDSEP})
		aadd(aOrdSep,CB7->CB7_ORDSEP)
	EndIf
	If Localiza(SD2->D2_COD)
		While SDB->(!Eof() .And. cChaveDB == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA)
			If SDB->DB_ESTORNO == "S"
				SDB->(dbSkip())
				Loop
			EndIf
			CB8->(DbSetorder(4))
			If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+SDB->DB_LOCALIZ+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
				CB8->(RecLock( "CB8", .T. ))
				CB8->CB8_FILIAL := xFilial( "CB8" )
				CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
				CB8->CB8_ITEM   := SD2->D2_ITEM
				CB8->CB8_PEDIDO := SD2->D2_PEDIDO
				CB8->CB8_NOTA   := SD2->D2_DOC
				//CB8->CB8_SERIE  := SD2->D2_SERIE
				SerieNfId ("CB8",1,"CB8_SERIE",,,,SD2->D2_SERIE)
				CB8->CB8_PROD   := SD2->D2_COD
				CB8->CB8_LOCAL  := SD2->D2_LOCAL
				CB8->CB8_LCALIZ := SDB->DB_LOCALIZ
				CB8->CB8_SEQUEN := SDB->DB_ITEM
				CB8->CB8_LOTECT := SD2->D2_LOTECTL
				CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
				CB8->CB8_NUMSER := SD2->D2_NUMSERI
				CB8->CB8_CFLOTE := "1"
				aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
			Else
				CB8->(RecLock( "CB8", .f. ))
			EndIf
			CB8->CB8_QTDORI += SDB->DB_QUANT
			CB8->CB8_SALDOS += SDB->DB_QUANT
			If nEmbalagem == 1
				CB8->CB8_SALDOE += SDB->DB_QUANT
			EndIf
			If	lACD100GI
				ExecBlock("ACD100GI",.F.,.F.)
			EndIf
			CB8->(MsUnLock())
			SDB->(dbSkip())
		Enddo
	Else
		CB8->(DbSetorder(4))
		If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+Space(15)+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
			CB8->(RecLock( "CB8", .T. ))
			CB8->CB8_FILIAL := xFilial( "CB8" )
			CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
			CB8->CB8_ITEM   := SD2->D2_ITEM
			CB8->CB8_PEDIDO := SD2->D2_PEDIDO
			CB8->CB8_NOTA   := SD2->D2_DOC
			//CB8->CB8_SERIE  := SD2->D2_SERIE
			SerieNfId ("CB8",1,"CB8_SERIE",,,,SD2->D2_SERIE)				
			CB8->CB8_PROD   := SD2->D2_COD
			CB8->CB8_LOCAL  := SD2->D2_LOCAL
			CB8->CB8_LCALIZ := Space(15)
			CB8->CB8_SEQUEN := SD2->D2_ITEM
			CB8->CB8_LOTECT := SD2->D2_LOTECTL
			CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
			CB8->CB8_NUMSER := SD2->D2_NUMSERI
			CB8->CB8_CFLOTE := "1"
			aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
		Else
			CB8->(RecLock( "CB8", .f. ))
		EndIf
		CB8->CB8_QTDORI += SD2->D2_QUANT
		CB8->CB8_SALDOS += SD2->D2_QUANT
		If nEmbalagem == 1
			CB8->CB8_SALDOE += SD2->D2_QUANT
	    EndIf
		If	lACD100GI
			ExecBlock("ACD100GI",.F.,.F.)
		EndIf
		CB8->(MsUnLock())
	EndIf

	If cNotaSerie==Nil
		IncProc()
	EndIf
	SD2->( dbSkip() )
EndDo

CB7->(DbSetOrder(1))
For nI := 1 to len(aOrdSep)
	CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
	CB7->(RecLock("CB7"))
	CB7->CB7_STATUS := "0"  // nao iniciado
	CB7->(MsUnlock())
	If	lACDA100F
		ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
	EndIf
Next
For nI := 1 to len(aRecSD2)
	SD2->(DbGoto(aRecSD2[nI,1]))
	SD2->(RecLock("SD2",.F.))
	SD2->D2_ORDSEP := aRecSD2[nI,2]
	SD2->(MsUnlock())
Next

End Transaction

Return

Static Function VldRegra()

Local lRet := .F.

Local aAreaAtu 	:= GetArea()
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())

SD2->(dbSetOrder(3))
SD2->(dbSeek(FwXFilial("SD2")+ SF2->F2_DOC + SF2->F2_SERIE))

SF4->(dbSetOrder(1))
SF4->(dbSeek(FwXFilial("SF4") + SD2->D2_TES))

If (Left(SD2->D2_CF,1) <> "7" .and. SF4->F4_ESTOQUE == "S" .and. SF4->F4_DUPLIC == "S") .or. SF4->F4_ZZACD == "S"
	lRet := .T.
Endif

RestArea(aAreaSD2)
RestArea(aAreaAtu)

Return lRet