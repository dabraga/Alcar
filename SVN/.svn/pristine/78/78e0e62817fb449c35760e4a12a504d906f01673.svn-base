#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F240TIT  ºAutor  ³Cassandra / Damata  º Data ³  05/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada utilizado para passar o codigo de barras  º±±
±±º          ³ dos titulos selecionados em um bordero de pagamentos       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F240TIT()

Private lRet := .T.

U_fCodBarras()

Return lRet

*************************************************************************************************************************
User Function fCodBarras()
*************************************************************************************************************************
                         
Private cAreaAtu   	:= GetArea()
Private nValor     	:= 0
Private nAcrescimo 	:= 0
Private nDecrescim 	:= 0
Private nResultado 	:= 0
Private cAgencia   	:= Space(05)
Private cBanco     	:= Space(03)
Private cCodBarras 	:= Space(47)
Private cConta     	:= Space(10)
Private cFornecedo 	:= Space(40)
Private cLinDigit  	:= Space(47)
Private cPrefixo   	:= Space(03)
Private cTitulo    	:= Space(09)
Private cDescriBco  := Space(20)
Private cModelo     := Space(02)
Private cCodCNAB    := Space(254)
Private bOk      	:= {|| U_GravaBar(cCodBarras, nValor, cLinDigit), oCodBar:End()}
Private bCancel  	:= {|| oCodBar:End()}
Private aBancos 	:= {}
Private oFont1, oFont2, oCodBar
Private oTitulo, oGrp01, oGet01, oGrp02, oGet02, oGrp03, oGet03, oGrp04, oGet04, oGrp05, oGet05, oGrp06, oGet06, oGrp07, oGet07
Private oFornec, oGrp08, oGet08, oGrp09, oGet09, oGrp10, oGet10, oGrp11, oGet11
Private oBoleto, oGrp12, oGet12, oGrp13, oGet13
Private oTribut, oGrp14, oGet14, oGrp15, oGet15
Private oBtn1, oBtn2

If _xCodBarras

	aAdd(aBancos, { "000", "Banco Bankpar S.A."})
	aAdd(aBancos, { "001", "Banco do Brasil S.A."})
	aAdd(aBancos, { "003", "Banco da Amazônia S.A."})
	aAdd(aBancos, { "004", "Banco do Nordeste do Brasil S.A."})
	aAdd(aBancos, { "012", "Banco Standard de Investimentos S.A."})
	aAdd(aBancos, { "021", "BANESTES S.A. Banco do Estado do Espírito Santo"})
	aAdd(aBancos, { "024", "Banco de Pernambuco S.A. - BANDEPE"})
	aAdd(aBancos, { "025", "Banco Alfa S.A."})
	aAdd(aBancos, { "029", "Banco Banerj S.A."})
	aAdd(aBancos, { "031", "Banco Beg S.A."})
	aAdd(aBancos, { "033", "Banco Santander (Brasil) S.A."})
	aAdd(aBancos, { "036", "Banco Bradesco BBI S.A."})
	aAdd(aBancos, { "037", "Banco do Estado do Pará S.A."})
	aAdd(aBancos, { "040", "Banco Cargill S.A."})
	aAdd(aBancos, { "041", "Banco do Estado do Rio Grande do Sul S.A."})
	aAdd(aBancos, { "045", "Banco Opportunity S.A."})
	aAdd(aBancos, { "047", "Banco do Estado de Sergipe S.A."})
	aAdd(aBancos, { "062", "Hipercard Banco Múltiplo S.A."})
	aAdd(aBancos, { "063", "Banco Ibi S.A. Banco Múltiplo"})
	aAdd(aBancos, { "064", "Goldman Sachs do Brasil Banco Múltiplo S.A."})
	aAdd(aBancos, { "065", "Banco Bracce S.A."})
	aAdd(aBancos, { "069", "BPN Brasil Banco Múltiplo S.A."})
	aAdd(aBancos, { "070", "BRB - Banco de Brasília S.A."})
	aAdd(aBancos, { "072", "Banco Rural Mais S.A."})
	aAdd(aBancos, { "073", "BB Banco Popular do Brasil S.A."})
	aAdd(aBancos, { "074", "Banco J. Safra S.A."})
	aAdd(aBancos, { "075", "Banco ABN AMRO S.A."})
	aAdd(aBancos, { "078", "BES Investimento do Brasil S.A.-Banco de Investimento"})
	aAdd(aBancos, { "079", "Banco Original do Agronegócio S.A."})
	aAdd(aBancos, { "095", "Banco Confidence de Câmbio S.A."})
	aAdd(aBancos, { "096", "Banco BM&FBOVESPA de Serviços de Liquidação e Custódia S.A"})
	aAdd(aBancos, { "104", "Caixa Econômica Federal"})
	aAdd(aBancos, { "107", "Banco BBM S.A."})
	aAdd(aBancos, { "119", "Banco Western Union do Brasil S.A."})
	aAdd(aBancos, { "125", "Brasil Plural S.A. - Banco Múltiplo"})
	aAdd(aBancos, { "184", "Banco Itaú BBA S.A."})
	aAdd(aBancos, { "204", "Banco Bradesco Cartões S.A."})
	aAdd(aBancos, { "208", "Banco BTG Pactual S.A."})
	aAdd(aBancos, { "214", "Banco Dibens S.A."})
	aAdd(aBancos, { "215", "Banco Comercial e de Investimento Sudameris S.A."})
	aAdd(aBancos, { "217", "Banco John Deere S.A."})
	aAdd(aBancos, { "218", "Banco Bonsucesso S.A."})
	aAdd(aBancos, { "222", "Banco Credit Agricole Brasil S.A."})
	aAdd(aBancos, { "224", "Banco Fibra S.A."})
	aAdd(aBancos, { "230", "Unicard Banco Múltiplo S.A."})
	aAdd(aBancos, { "233", "Banco Cifra S.A."})
	aAdd(aBancos, { "237", "Banco Bradesco S.A."})
	aAdd(aBancos, { "246", "Banco ABC Brasil S.A."})
	aAdd(aBancos, { "248", "Banco Boavista Interatlântico S.A."})
	aAdd(aBancos, { "249", "Banco Investcred Unibanco S.A."})
	aAdd(aBancos, { "250", "BCV - Banco de Crédito e Varejo S.A."})
	aAdd(aBancos, { "263", "Banco Cacique S.A."})
	aAdd(aBancos, { "265", "Banco Fator S.A."})
	aAdd(aBancos, { "318", "Banco BMG S.A."})
	aAdd(aBancos, { "320", "Banco Industrial e Comercial S.A."})
	aAdd(aBancos, { "341", "Itaú Unibanco S.A."})
	aAdd(aBancos, { "356", "Banco Real S.A."})
	aAdd(aBancos, { "366", "Banco Société Générale Brasil S.A."})
	aAdd(aBancos, { "370", "Banco Mizuho do Brasil S.A."})
	aAdd(aBancos, { "376", "Banco J. P. Morgan S.A."})
	aAdd(aBancos, { "389", "Banco Mercantil do Brasil S.A."})
	aAdd(aBancos, { "394", "Banco Bradesco Financiamentos S.A."})
	aAdd(aBancos, { "394", "Banco Finasa BMC S.A."})
	aAdd(aBancos, { "399", "HSBC Bank Brasil S.A. - Banco Múltiplo"})
	aAdd(aBancos, { "409", "UNIBANCO - União de Bancos Brasileiros S.A."})
	aAdd(aBancos, { "422", "Banco Safra S.A."})
	aAdd(aBancos, { "453", "Banco Rural S.A."})
	aAdd(aBancos, { "456", "Banco de Tokyo-Mitsubishi UFJ Brasil S.A."})
	aAdd(aBancos, { "464", "Banco Sumitomo Mitsui Brasileiro S.A."})
	aAdd(aBancos, { "473", "Banco Caixa Geral - Brasil S.A."})
	aAdd(aBancos, { "477", "Citibank S.A."})
	aAdd(aBancos, { "479", "Banco ItaúBank S.A"})
	aAdd(aBancos, { "487", "Deutsche Bank S.A. - Banco Alemão"})
	aAdd(aBancos, { "488", "JPMorgan Chase Bank"})
	aAdd(aBancos, { "492", "ING Bank N.V."})
	aAdd(aBancos, { "505", "Banco Credit Suisse (Brasil) S.A. "})
	aAdd(aBancos, { "600", "Banco Luso Brasileiro S.A. "})
	aAdd(aBancos, { "604", "Banco Industrial do Brasil S.A. "})
	aAdd(aBancos, { "610", "Banco VR S.A. "})
	aAdd(aBancos, { "611", "Banco Paulista S.A. "})
	aAdd(aBancos, { "612", "Banco Guanabara S.A. "})
	aAdd(aBancos, { "623", "Banco Panamericano S.A. "})
	aAdd(aBancos, { "626", "Banco Ficsa S.A. "})
	aAdd(aBancos, { "633", "Banco Rendimento S.A. "})
	aAdd(aBancos, { "634", "Banco Triângulo S.A. "})
	aAdd(aBancos, { "641", "Banco Alvorada S.A. "})
	aAdd(aBancos, { "643", "Banco Pine S.A. "})
	aAdd(aBancos, { "652", "Itaú Unibanco Holding S.A. "})
	aAdd(aBancos, { "653", "Banco Indusval S.A. "})
	aAdd(aBancos, { "655", "Banco Votorantim S.A. "})
	aAdd(aBancos, { "707", "Banco Daycoval S.A. "})
	aAdd(aBancos, { "719", "Banif-Banco Internacional do Funchal (Brasil)S.A. "})
	aAdd(aBancos, { "739", "Banco BGN S.A. "})
	aAdd(aBancos, { "740", "Banco Barclays S.A. "})
	aAdd(aBancos, { "745", "Banco Citibank S.A. "})
	aAdd(aBancos, { "746", "Banco Modal S.A. "})
	aAdd(aBancos, { "747", "Banco Rabobank International Brasil S.A. "})
	aAdd(aBancos, { "748", "Banco Cooperativo Sicredi S.A. "})
	aAdd(aBancos, { "749", "Banco Simples S.A. "})
	aAdd(aBancos, { "751", "Scotiabank Brasil S.A. Banco Múltiplo "})
	aAdd(aBancos, { "752", "Banco BNP Paribas Brasil S.A. "})
	aAdd(aBancos, { "755", "Bank of America Merrill Lynch Banco Múltiplo S.A. "})
	aAdd(aBancos, { "756", "Banco Cooperativo do Brasil S.A. - BANCOOB "})
	aAdd(aBancos, { "081-7", "Concórdia Banco S.A. "})
	aAdd(aBancos, { "082-5", "Banco Topázio S.A. "})
	aAdd(aBancos, { "083-3", "Banco da China Brasil S.A. "})
	aAdd(aBancos, { "M03", "Banco Fiat S.A. "})
	aAdd(aBancos, { "M06", "Banco de Lage Landen Brasil S.A. "})
	aAdd(aBancos, { "M07", "Banco GMAC S.A. "})
	aAdd(aBancos, { "M08", "Banco Citicard S.A. "})
	aAdd(aBancos, { "M09", "Banco Itaucred Financiamentos S.A. "})
	aAdd(aBancos, { "M11", "Banco IBM S.A. "})
	aAdd(aBancos, { "M14", "Banco Volkswagen S.A. "})
	aAdd(aBancos, { "M16", "Banco Rodobens S.A. "})
	aAdd(aBancos, { "M18", "Banco Ford S.A. "})
	aAdd(aBancos, { "M19", "Banco CNH Capital S.A. "})
	aAdd(aBancos, { "M20", "Banco Toyota do Brasil S.A. "})
	aAdd(aBancos, { "M22", "Banco Honda S.A. "})
	aAdd(aBancos, { "M23", "Banco Volvo (Brasil) S.A. "})
	aAdd(aBancos, { "M24", "Banco PSA Finance Brasil S.A. "})
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))
	
	cCodBarras 	:= SE2->E2_CODBAR
	nValor     	:= SE2->E2_SALDO
	cTitulo 	:= SE2->E2_NUM
	cPrefixo	:= SE2->E2_PREFIXO
	cFornecedo	:= SE2->E2_NOMFOR
	nAcrescimo	:= SE2->E2_ACRESC
	nDecrescim	:= SE2->E2_DECRESC
	nResultado	:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC
	cBanco      := SA2->A2_BANCO
	cAgencia    := SA2->A2_AGENCIA
	cConta      := SA2->A2_NUMCON
	
	nPos := Ascan(aBancos, {|x| x[1] == cBanco})       
	If nPos > 0          
		cDescriBco := Upper(aBancos[nPos,02])
	Endif	
	
	oFont1 := TFont():New( "MS Sans Serif",0,-11,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2 := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	
	oCodBar  := MSDialog():New( 099,316,660,969,"Código de Barras do Título",,,.F.,,,,,,.T.,,,.T. )
	
	oTitulo:= TGroup():New( 000,008,080,312,"D A D O S      D O      T Í T U L O:",oCodBar,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oGrp01 := TGroup():New( 012,020,041,072,"Título:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet01 := TGet():New( 024,025,{|u| If(PCount()>0,cTitulo:=u,cTitulo)},oGrp01,040,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTitulo",,)
	oGrp02 := TGroup():New( 012,080,041,112,"Prefixo:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet02 := TGet():New( 024,085,{|u| If(PCount()>0,cPrefixo:=u,cPrefixo)},oGrp02,010,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrefixo",,)
	oGrp03 := TGroup():New( 012,120,041,304,"Fornecedor:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet03 := TGet():New( 024,125,{|u| If(PCount()>0,cFornecedor:=u,cFornecedor)},oGrp03,172,008,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFornecedor",,)
	oGrp04 := TGroup():New( 044,020,073,085,"Valor (R$):",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet04 := TGet():New( 056,025,{|u| If(PCount()>0,nValor:=u,nValor)},oGrp04,055,008,'@e 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValor",,)
	oGrp05 := TGroup():New( 044,093,073,157,"Acréscimo:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet05 := TGet():New( 056,098,{|u| If(PCount()>0,nAcrescimo:=u,nAcrescimo)},oGrp05,055,008,'@e 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcrescimo",,)
	oGrp06 := TGroup():New( 044,167,073,232,"Decréscimo:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet06 := TGet():New( 056,172,{|u| If(PCount()>0,nDecrescimo:=u,nDecrescimo)},oGrp06,055,008,'@e 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDecrescimo",,)
	oGrp07 := TGroup():New( 044,240,073,304,"Resultado:",oTitulo,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet07 := TGet():New( 056,245,{|u| If(PCount()>0,nResultado:=u,nResultado)},oGrp07,055,008,'@e 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nResultado",,)
	
	oFornec:= TGroup():New( 088,008,130,312,"F O R N E C E D O R:",oCodBar,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oGrp08 := TGroup():New( 096,016,124,048,"Banco:",oFornec,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet08 := TGet():New( 108,019,{|u| If(PCount()>0,cBanco:=u,cBanco)},oGrp08,024,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBanco",,)
	oGet08:bValid:= {|| U_fDescBco() }	
	oGrp09 := TGroup():New( 096,056,125,144,"Descrição Bco:",oFornec,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet09 := TGet():New( 108,059,{|u| If(PCount()>0,cDescriBco:=u,cDescriBco)},oGrp09,081,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescriBco",,)
	oGrp10 := TGroup():New( 096,152,125,224,"Agência:",oFornec,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet10 := TGet():New( 108,155,{|u| If(PCount()>0,cAgencia:=u,cAgencia)},oGrp10,065,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAgencia",,)
	oGrp11 := TGroup():New( 096,232,125,304,"Conta:",oFornec,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet11 := TGet():New( 108,235,{|u| If(PCount()>0,cConta:=u,cConta)},oGrp11,065,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cConta",,)
	
	oBoleto:= TGroup():New( 136,008,216,312,"B O L E T O S:",oCodBar,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oGrp12 := TGroup():New( 148,016,177,304,"Código de Barras:",oBoleto,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet12 := TGet():New( 160,020,{|u| If(PCount()>0,cCodBarras:=u,cCodBarras)},oGrp12,280,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodBarras",,)
	oGrp13 := TGroup():New( 180,016,209,304,"Linha Digitável:",oBoleto,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet13 := TGet():New( 192,020,{|u| If(PCount()>0,cLinDigit:=u,cLinDigit)},oGrp13,280,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,{|x| U_fLinDigit(@cCodBarras, nValor, cLinDigit)},.F.,.F.,"","cLinDigit",,)
	
	oTribut:= TGroup():New( 224,008,270,264,"T R I B U T O S:",oCodBar,CLR_BLUE,CLR_WHITE,.T.,.F. )
	oGrp14 := TGroup():New( 236,012,265,044,"Modelo:",oTribut,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet14 := TGet():New( 248,016,{|u| If(PCount()>0,cModelo:=u,cModelo)},oGrp14,024,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"58","cModelo",,)
	oGet14:bValid:= {|| If( Empty(cCodBarras), U_PagTrib2(2,cModelo, @cCodCNAB), .T.), oGet15:Refresh(), oGrp15:Refresh() }	
	oGrp15 := TGroup():New( 236,052,265,244,"Código CNAB:",oTribut,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet15 := TGet():New( 248,056,{|u| If(PCount()>0,cCodCNAB:=u,cCodCNAB)},oGrp15,184,008,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodCNAB",,)
	oGet15:Disable()
	oBtn1  := TButton():New( 228,268,"Confirmar",oCodBar,{|| U_GravaBar(cCodBarras, nValor, cLinDigit, cModelo, cCodCNAB), oCodBar:End()},045,015,,oFont2,,.T.,,"",,,,.F. )
	oBtn2  := TButton():New( 252,268,"Cancelar ",oCodBar,{|| oCodBar:End()},045,015,,oFont2,,.T.,,"",,,,.F. )
	
	oGet01:Disable()
	oGet02:Disable()
	oGet03:Disable()
	oGet04:Disable()
	oGet05:Disable()
	oGet06:Disable()
	oGet07:Disable()
	oGet09:Disable()
	
	oCodBar:Activate(,,,.T.)
	
Endif

RestArea(cAreaAtu)

Return lRet


*************************************************************************************************************************
User Function fDescBco()                                                                               
*************************************************************************************************************************
Local nPos := 0

nPos := Ascan(aBancos, {|x| x[1] == cBanco})       
If nPos > 0          
	cDescriBco := Upper(aBancos[nPos,02])
Else
	cDescriBco := Space(20)
Endif
oGet09:Refresh()
oGrp09:Refresh()
oFornec:Refresh()

Return Nil


*************************************************************************************************************************
User Function GravaBar(cCodBarras, nValor, cLinhaDig, cModelo, cCodCNAB)
*************************************************************************************************************************

Local cStr := " "

cStr := cCodBarras

If Len(Alltrim(cCodBarras)) # 44
	&& Tamanho < 44 -> Completa com zeros até 47 dígitos. Isso é para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	cStr := If(Len(cStr)<44,cStr+REPL("0",47-Len(cStr)),cStr)
	
	If Len(Alltrim(cCodBarras)) == 47
		cStr := Substr(cStr,1,3)+Substr(cStr,4,1)+Substr(cStr,33,1)+Substr(cStr,34,4)+Substr(cStr,38,10)+Substr(cStr,5,5)+Substr(cStr,11,10)+Substr(cStr,22,10)
	Endif
Endif

RecLock("SE2",.F.)
SE2->E2_CODBAR  := cStr

If !Empty(cModelo)
	SE2->E2_ZZMODPG := cModelo
Endif
                   
If !Empty(cCodCNAB)
	SE2->E2_ZZPG341 := cCodCNAB
Endif

If Round(nValor,2) < Round(SE2->E2_valor,2) 	&& Atualiza Campo de desconto caso o valor seja alterado
	SE2->E2_DESCONT  := SE2->E2_VALOR - nValor
	SE2->E2_SALDO    := SE2->E2_VALOR - SE2->E2_DESCONT
	
ElseIf Round(nValor,2) > Round(SE2->E2_valor,2) && Atualiza Campo de Multa, caso o valor seja alterado
	SE2->E2_ACRESC   := nValor - SE2->E2_VALOR
	SE2->E2_SALDO    := SE2->E2_VALOR + SE2->E2_ACRESC
Endif
SE2->(MsUnlock())

SA2->(dbSetOrder(1))
If SA2->(dbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))
	RecLock("SA2",.F.)
	SA2->A2_BANCO 	:= cBanco
	SA2->A2_AGENCIA	:= cAgencia
	SA2->A2_NUMCON	:= cConta
	SA2->(MsUnLock())
Endif

Return Nil

*************************************************************************************************************************
User Function fLinDigit(cCodBarras, nValor, cLinhaDig)
*************************************************************************************************************************

Local lRet    := .F.
Local i       := 0
Local nVal    := 0
Local nMult   := 0
Local nModulo := 0
Local cStr    := ""
Local cCodVld := ""
Local cChar   := ""
Local cDigito := ""
Local cDV1    := ""
Local cDV2    := ""
Local cDV3    := ""
Local cCampo1 := ""
Local cCampo2 := ""
Local cCampo3 := ""

cStr := cLinhaDig

If Len(AllTrim(cStr)) < 44 .or. Len(AllTrim(cStr)) == 47
	
	cDV1    := Substr(cStr,10, 1)
	cDV2    := Substr(cStr,21, 1)
	cDV3    := Substr(cStr,32, 1)
	
	cCampo1 := Substr(cStr, 1, 9)
	cCampo2 := Substr(cStr,11,10)
	cCampo3 := Substr(cStr,22,10)
	
	/*/
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------------------------------------------------------------------+¦¦
	¦¦¦Descriçào ¦ Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ¦¦¦
	¦¦¦          ¦ somente e utilizada como validacao do campo E2_IPTE.     ¦¦¦
	¦¦¦          ¦ Verifica a digitacao do codigo de barras                   ¦¦¦
	¦¦+-----------------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	/*/
	
	&&&&&&&&&&&&&&&&&&&&&&&&&& Calcula DV1:
	nMult   := 2
	nModulo := 0
	nVal    := 0
	
	For i := Len(cCampo1) to 1 Step -1
		cChar := Substr(cCampo1,i,1)
		If isAlpha(cChar)
			Help(" ", 1, "ONLYNUM")
			Return(.F.)
		Endif
		nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := NVAL + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo
		EndIf
		nMult:= if(nMult==2,1,2)
	Next
	
	nCalc_DV1 := 10 - (nVal % 10)
	nCalc_DV1 := IIF(nCalc_DV1==10,0,nCalc_DV1)
	
	&&&&&&&&&&&&&&&&&&&&&&&&&& Calcula DV2:
	nMult   := 2
	nModulo := 0
	nVal    := 0
	
	For i := Len(cCampo2) to 1 Step -1
		cChar := Substr(cCampo2,i,1)
		If isAlpha(cChar)
			Help(" ", 1, "ONLYNUM")
			Return(.F.)
		Endif
		nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := nVal + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo
		EndIf
		nMult:= if(nMult==2,1,2)
	Next
	nCalc_DV2 := 10 - (nVal % 10)
	nCalc_DV2 := IIF(nCalc_DV2==10,0,nCalc_DV2)
	
	&&&&&&&&&&&&&&&&&&&&&&&&&& Calcula DV3:
	nMult   := 2
	nModulo := 0
	nVal    := 0
	
	For i := Len(cCampo3) to 1 Step -1
		cChar := Substr(cCampo3,i,1)
		If isAlpha(cChar)
			Help(" ", 1, "ONLYNUM")
			Return(.F.)
		Endif
		nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := nVal + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo
		EndIf
		nMult:= if(nMult==2,1,2)
	Next
	nCalc_DV3 := 10 - (nVal % 10)
	nCalc_DV3 := IIF(nCalc_DV3==10,0,nCalc_DV3)
	
	If !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
		Help(" ",1,"INVALcCodBarras")
		lRet := .f.
	Else
		lRet := .t.
	Endif
	
Else
	cDigito := Substr(cStr,5, 1)
	cStr    := Substr(cStr,1, 4) + Substr(cStr,6,39)
	cStr    := AllTrim(cStr)
	
	/*/
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	¦¦+-----------------------------------------------------------------------+¦¦
	¦¦¦Descriçào ¦ Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ¦¦¦
	¦¦¦          ¦ somente e utilizada como validacao do campo E2_IPTE.     ¦¦¦
	¦¦¦          ¦ Verifica o codigo de barras grafico (Atraves de leitor)    ¦¦¦
	¦¦+-----------------------------------------------------------------------+¦¦
	¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
	/*/
	
	If Len(cStr) < 43
		Help(" ", 1, "FALTADG")
		Return(.F.)
	Endif
	
	For i := Len(cStr) to 1 Step -1
		cChar := Substr(cStr,i,1)
		If isAlpha(cChar)
			Help(" ", 1, "ONLYNUM")
			Return(.F.)
		Endif
		nModulo := nModulo + Val(cChar)*nMult
		nMult:= if(nMult==9,2,nMult+1)
	Next
	
	nRest := 11 - (nModulo % 11)
	nRest := if(nRest==10 .or. nRest==11,1,nRest)
	
	If nRest <> Val(cDigito)
		Help(" ",1,"DgSISPAG")
		lRet := .f.
	Else
		lRet := .t.
	Endif
	
Endif

&& Tem linha digitavel e nao tem codigo de barras
If !Empty(cLinhaDig)
	If Len(AllTrim(cLinhaDig)) == 47
		cCodVld := 	Substr(cLinhaDig, 1, 4) + ;             					&& BANCO + MOEDA
		Substr(cLinhaDig, 33,  1) + ;                      			&& DV GERAL
		Substr(cLinhaDig, 34,  4) + ;                       		&& FATOR VENCIMENTO
		StrZero(Val(AllTrim(Substr(cLinhaDig, 38, 10))), 10) + ; 	&& VALOR
		Substr(cLinhaDig,  5,  5) + ;                             	&& CAMPO LIVRE
		Substr(cLinhaDig, 11, 10) + ;
		Substr(cLinhaDig, 22, 10)
	Else
		cCodVld := 	Substr(cLinhaDig, 1, 4) + ;             					&& BANCO + MOEDA
		Substr(cLinhaDig, 33,  1) + ;                      			&& DV GERAL
		StrZero(Val(AllTrim(Substr(cLinhaDig, 34, 14))), 14) + ; 	&& VALOR
		Substr(cLinhaDig,  5,  5) + ;                             	&& CAMPO LIVRE
		Substr(cLinhaDig, 11, 10) + ;
		Substr(cLinhaDig, 22, 10)
	EndIf
	
	cCodBarras := cCodVld
EndIf

Return(lRet)
