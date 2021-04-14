#Include "Protheus.ch"
#Include "RWMAKE.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GQREENTR º Autor ³ Zabotto            º Data ³  10/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada apos Gravacao dos Documentos de Entrada   º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103 - Documento de Entrada							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GQREENTR() 
	local aAreaATU	:= getArea()
	local aAreaSD1	:= SD1->(getArea())
	local aArea := getArea()
	
	getInfImport()
	
	restArea(aArea)

	// Gravacao das Informacoes Adicionais
	if Type("_cTpFrete") == "C" .AND. Type("_cMsgAdic") == "C"
		RecLock("SF1", .F.)
			SF1->F1_ZZTPFRE	:= _cTpFrete
			SF1->F1_ZZMSGAD := _cMsgAdic
		SF1->(MsUnlock())
	endIf	

	// Tratamento para notas de importacao Acerto do Custo.
	// Waldir - 11/11/2009
	SD1->(dbSetOrder(1))			// D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM
	SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
	do while SD1->(!Eof()) .And. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == (xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA))
		if left(allTrim(SD1->D1_CF), 1) == "3"
			SD1->D1_CUSTO := SD1->D1_CUSTO - SD1->D1_DESPESA
		endIf

		SD1->(dbSkip())
	endDo
	
	restArea(aAreaSD1)
	restArea(aAreaATU)
	
	InfCompl()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INFCOMPL  ºAutor  ³Zabotto             º Data ³  05/10/
11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para inclusao de informacoes complementares. Template.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Carel                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InfCompl()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa as Variaveis       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea    := {}
Local _cMarca   := space(20)
Local _cPlaca   := space(08)
LOcal _cUf		:= space(02)
Local _cEspecie := space(10)
Local _cNumero  := space(20)
Local _cTransp  := space(06)
Local _nVolume  := 0
Local _nPBruto  := 0
Local _nPLiqui  := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SALVA A AREA DE TRABALHO      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aArea  := GetArea ()

If SF1->F1_FORMUL == "S"
   _cDoc    := SF1->F1_DOC
   _cSerie  := SF1->F1_SERIE
   _cMarca  := space(10)
   _cPlaca  := space(08)
   _cUf		:= space(02)
   _cEspecie:= space(10)
   _cNumero := space(20)
   _cTransp := space(6)
   _nVolume := _nPBruto := _nPLiqui := 0

   DEFINE MSDIALOG JANELANF STYLE 128 FROM 105,080 TO 330,465 TITLE "Complementacao de Dados da Nota Fiscal de Entrada" PIXEL OF oMainWnd
	JANELANF:lEscClose := .F.
   @ 020,010 Say "Marca"
   @ 020,090 Say "Volumes"
   @ 040,010 Say "Especie"                                   
   @ 040,090 Say "Transp."
   @ 060,010 Say "P. Bruto"
   @ 060,090 Say "P. Liquido"
   @ 080,010 Say "Placa"  
   @ 080,090 Say "UF"
   @ 100,010 Say "N.Container"  

   @ 020,040 Get _cMarca   Picture "@!"             SIZE 20,10 Pixel OF JANELANF
   @ 020,120 Get _nVolume  Picture "99999"          SIZE 20,10 Pixel OF JANELANF
   @ 040,040 Get _cEspecie Picture "@!"             SIZE 40,10 Pixel OF JANELANF
   @ 040,120 Get _cTransp  Picture "@!" F3 "SA4"    SIZE 20,10
   @ 060,040 Get _nPBruto  Picture "@E 999,999.999" SIZE 40,10 Pixel OF JANELANF
   @ 060,120 Get _nPLiqui  Picture "@E 999,999.999" SIZE 40,10 Pixel OF JANELANF
   @ 080,040 Get _cPlaca   Picture "@!"             SIZE 40,10 Pixel OF JANELANF 
   @ 080,120 Get _cUf      Picture "@!"             SIZE 20,10 Pixel OF JANELANF  
   @ 100,040 Get _cNumero  Picture "@!"             SIZE 60,10 Pixel of JanelaNF
   @ 100,140 BmpButton Type 1 Action Close(JANELANF)
   Activate Dialog JANELANF CENTERED

   dbSelectArea("SF1")
   dbSeek(xFilial("SF1") + _cDoc + _cSerie)

   RecLock("SF1",.F.)
	   SF1->F1_ESPECI1  := _cEspecie
	   SF1->F1_PBRUTO   := _nPBruto
	   SF1->F1_PLIQUI   := _nPLiqui
	   SF1->F1_ZZMARCA  := _cMarca          
	   SF1->F1_ZZNUMER  := _cNumero
	   SF1->F1_VOLUME1  := _nVolume
	   SF1->F1_TRANSP   := _cTransp
	   SF1->F1_ZZPLACA  := _cPlaca                                     
	   SF1->F1_ZZUF	 	:= _cUf             
   MsUnlock()
   
EndIf

RestArea (_aArea)
Return

static function getInfImport()

	local cExportador := space(60)
	local cFabricante := space(60)
	local cDI         := space(len(SF1->F1_ZZNUMDI))
	local cLocal      := space(len(SF1->F1_ZZLOCDI))
	local cUF         := space(len(SF1->F1_ZZUFDI))
	local dData       := dDataBase
	local dDtDI       := ctod(" ")
	local nDesconto   := 0
	local aButtons    := {}
	local cMenNota    := ""
	
	if upper(alltrim(SF1->F1_EST)) == "EX"
		
		DEFINE MSDIALOG oDialog FROM 000,000 TO 420,430 TITLE alltrim(oemToAnsi("NF Importação")) PIXEL
		DEFINE FONT oFontWin  NAME 'Arial' 			SIZE 6, 15 BOLD
		DEFINE FONT oFontMemo NAME 'Courier New' 	SIZE 0,15
		
		oDialog:lEscClose := .f.
		
		@ 040,010 SAY oemToAnsi("Exportador:")					OF oDialog PIXEL
		@ 040,060 MSGET cExportador PICTURE "@!"	SIZE 150,10	OF oDialog PIXEL
		
		@ 060,010 SAY oemToAnsi("Fabricante:")					OF oDialog PIXEL
		@ 060,060 MSGET cFabricante PICTURE "@!" SIZE 150,10	OF oDialog PIXEL
		
		@ 080,010 SAY oemToAnsi("D.I.:")						OF oDialog PIXEL
		@ 080,060 MSGET cDI PICTURE "@!" SIZE 70,10				OF oDialog PIXEL VALID !empty(cDI) && F3 "ZA1"
		@ 080,140 SAY oemToAnsi("Data DI:")						OF oDialog PIXEL
		@ 080,170 MSGET dDtDI SIZE 30,10						OF oDialog PIXEL
		
		@ 100,010 SAY oemToAnsi("Local Desemb.:")				OF oDialog PIXEL
		@ 100,060 MSGET cLocal PICTURE "@!" SIZE 150,10			OF oDialog PIXEL
		
		@ 120,010 SAY oemToAnsi("UF:")							OF oDialog PIXEL
		@ 120,060 MSGET cUF PICTURE "@!" F3 "12" SIZE 20,10		OF oDialog PIXEL VALID existCpo("SX5","12"+cUF)
		@ 120,120 SAY oemToAnsi("Data Desemb.:")				OF oDialog PIXEL
		@ 120,170 MSGET dData 		SIZE 30,10					OF oDialog PIXEL
		
		@ 140,010 SAY oemToAnsi("Vlr Desconto:")							OF oDialog PIXEL
		@ 140,060 MSGET nDesconto PICTURE "@E 999,999,999.99" SIZE 40,10	OF oDialog PIXEL
				
		ACTIVATE MSDIALOG oDialog CENTERED ON INIT enchoiceBar(oDialog,{ || oDialog:end()},{ || oDialog:end()},,aButtons)
		
		cMenNota := allTrim(SF1->F1_MENNOTA)
		cMenNota := if(!empty(cMenNota) ,cMenNota + space(1),"")
		
		cMenNota += if(!empty(cDI)			,"DI: "		   		+ allTrim(cDI)	   		+ space(1),"")
		cMenNota += if(!empty(dDtDI)		,"DT DI: "	   		+ dtoc(dDtDI)			+ space(1),"")
		cMenNota += if(!empty(cExportador)	,"EXPORTADOR: "		+ allTrim(cExportador)	+ space(1),"")		
		cMenNota += if(!empty(cFabricante)	,"FABRICANTE: "		+ allTrim(cFabricante)	+ space(1),"")
		cMenNota += if(!empty(cLocal)		,"LOCAL: "	   		+ allTrim(cLocal)		+ space(1),"")
		cMenNota += if(!empty(cUF)			,"UF: "				+ allTrim(cUF)			+ space(1),"")
		cMenNota += if(!empty(dData)		,"DT DESEMBARQUE: "	+ dtoc(dData),"")
		cMenNota += if(!empty(nDesconto)	,"DESCONTO DA DI: "	+ allTrim(transform(nDesconto, "@E 999,999.9999")),"")
		
		SF1->(recLock("SF1",.F.))
			SF1->F1_ZZNUMDI	:= cDI
			SF1->F1_ZZDTDI	:= dDtDI
			SF1->F1_ZZLOCDI	:= cLocal
			SF1->F1_ZZUFDI	:= cUF
			SF1->F1_ZZDTD	:= dData
			//SF1->F1_ZZEXPOR	:= cExportador
			//SF1->F1_ZZFABRI	:= cFabricante
			//SF1->F1_ZZDESDI	:= nDesconto
			SF1->F1_MENNOTA := cMenNota
			SF1->F1_HORA    := SUBSTR(TIME(),1,5)
		SF1->(MsUnLock())
		
		gravaCD5()
	endif
return

&& Grava novo registro na tabela CD5 a partir dos campos personalizados
Static Function gravaCD5()
	
		Local aAreaSd1 := SD1->(getArea())
	
		CD5->(dbSetorder(1))
		CD5->(dbSeek(xFilial("CD5") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ,.f.))
	
		while CD5->(!Eof()) .and. CD5->(CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA) == xFilial("CD5") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			recLock("CD5",.f.,.t.)
				CD5->(dbDelete())
			msUnlock("CD5")
			CD5->(dbSkip())
		enddo
		
		dbSelectArea("SD1")
		dbSetOrder(1) && D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM
	
		if dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
			while SD1->(!eof()) .and. xFilial("SD1")+SD1->(D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	
				if 	recLock("CD5",.t.)
					CD5->CD5_FILIAL 	:= 	xFilial("CD5")
					CD5->CD5_DOC    	:= 	SF1->F1_DOC
					CD5->CD5_SERIE  	:= 	SF1->F1_SERIE
					CD5->CD5_DOCIMP 	:= 	SF1->F1_ZZNUMDI
					CD5->CD5_TPIMP  	:= 	"0"  
					CD5->CD5_ESPEC  	:= 	SF1->F1_ESPECIE
					CD5->CD5_FORNEC 	:= 	SF1->F1_FORNECE
					CD5->CD5_LOJA   	:= 	SF1->F1_LOJA
					CD5->CD5_DTPPIS 	:= 	SF1->F1_ZZDTDI
					CD5->CD5_DTPCOF 	:= 	SF1->F1_ZZDTDI
					CD5->CD5_DTDI   	:= 	SF1->F1_ZZDTDI
					CD5->CD5_DTDES   	:= 	SF1->F1_ZZDTDI
					CD5->CD5_NDI    	:= 	SF1->F1_ZZNUMDI   
					CD5->CD5_UFDES  	:= 	SF1->F1_ZZUFDI
					CD5->CD5_LOCDES 	:= 	SF1->F1_ZZLOCDI
					CD5->CD5_CODFAB 	:= 	SF1->F1_FORNECE   
					CD5->CD5_LOCAL  	:= 	"0"
					CD5->CD5_BSPIS  	:= 	SD1->D1_BASIMP6
					CD5->CD5_ALPIS  	:= 	SD1->D1_ALQIMP6
					CD5->CD5_VLPIS  	:= 	SD1->D1_VALIMP6
					CD5->CD5_BSCOF  	:= 	SD1->D1_BASIMP5
					CD5->CD5_ALCOF  	:=  SD1->D1_ALQIMP5
					CD5->CD5_VLCOF  	:= 	SD1->D1_VALIMP5
					CD5->CD5_CODEXP		:=	SD1->D1_FORNECE
					CD5->CD5_NADIC		:=	SD1->D1_ZZADIC
					CD5->CD5_SQADIC		:=	SD1->D1_ZZSEQAD
					CD5->CD5_BCIMP		:=	(SF1->F1_VALMERC - SF1->F1_VALIPI - SF1->F1_VALICM)
					CD5->CD5_VLRII		:=	SD1->D1_II
					CD5->CD5_DSPAD		:=	0
					CD5->CD5_VLRIOF		:=	0
					CD5->CD5_VTRANS		:= "1"
					CD5->CD5_INTERM		:= "1"
					CD5->CD5_ITEM		:=	SD1->D1_ITEM
					CD5->(msUnlock("CD5"))
				endif
				
				SD1->(dbSkip())
			enddo		
		endif
		
		restArea(aAreaSd1)
		
Return

/* F O N T E  A N T I G O */
/*#include "protheus.ch"*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GQREENTR ºAutor  ³Deivid A. C. de Limaº Data ³  07/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no final da geracao da NF Entrada,        º±±
±±º          ³ utilizado para gravacao de dados adicionais.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*User Function GQREENTR()

Local oTMsg  := FswTemplMsg():TemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)

&& inicio template mensagens da NF
If SF1->F1_FORMUL == "S"
	aAdd(oTMsg:aCampos,{"F1_VOLUME1",CriaVar("F1_VOLUME1")})
	aAdd(oTMsg:aCampos,{"F1_ESPECI1",CriaVar("F1_ESPECI1")})
	aAdd(oTMsg:aCampos,{"F1_PESOL"  ,CriaVar("F1_PESOL"  )})
	aAdd(oTMsg:aCampos,{"F1_PBRUTO",CriaVar("F1_PBRUTO")})
	aAdd(oTMsg:aCampos,{"F1_TRANSP",CriaVar("F1_TRANSP")})
	aAdd(oTMsg:aCampos,{"F1_PLACA",CriaVar("F1_PLACA")})
	aAdd(oTMsg:aCampos,{"F1_ZZMARCA",CriaVar("F1_ZZMARCA")})

	oTMsg:Processa()
Endif
&& fim template mensagens da NF

Return
*/