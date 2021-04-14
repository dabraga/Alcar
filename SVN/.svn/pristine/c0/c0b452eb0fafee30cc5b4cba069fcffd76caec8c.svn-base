#Include "topconn.ch"
#Include "protheus.ch"

/* Rotina	:	M030INC
* Autor		:	Marcos Wey da Mata
* Data		:	05/06/2015
* Descricao	:	PontoPonto de entrada p/ geração da conta contabil de Cliente
*/

User Function M030INC()

&& Declaração das Variáveis
Local _aArea      	:= GetArea()
Local _aAreaCT1   	:= CT1->(GetArea())
Local _aAreaSA1   	:= SA1->(GetArea())

Private _CtaCtb 	:= "0000"
Private _CtaSint	:= "110201"
Private _CtaRef		:= If(SA1->A1_EST <> "EX", "1.01.02.02.01", "1.01.02.02.02")

&& Contas referenciais novas (ECF)
// 1.01.02.02.01	DUPLICATAS A RECEBER - OPERACOES COM PARTES NAO RELACIONADAS - NO PAIS
// 1.01.02.02.02	DUPLICATAS A RECEBER - OPERACOES COM PARTES NAO RELACIONADAS - NO EXTERIOR

//If PARAMIXB == 1
//	If Alltrim(A1_ZZTP) $ "A,B,D"
		&& Monta a conta contabil
		_CtaCtb := AllTrim(_CtaSint) + AllTrim(SA1->A1_COD)// + AllTrim(SA1->A1_LOJA)
		
		&& Funcao para gravar conta contabil
		fGravaConta()
//	EndIf
//EndIf

RestArea(_aAreaSA1)
RestArea(_aAreaCT1)
RestArea(_aArea)

Return Nil

***********************************************************************************************************
Static Function fGravaConta()
***********************************************************************************************************

&& Gravacao da conta contabil (CT1)
CT1->(DbSelectArea("CT1"))
CT1->(DbSetOrder(1))

If !CT1->(DbSeek(xFilial("CT1")+_CtaCtb))
	
	If CT1->(RecLock("CT1",.T.))
		CT1->CT1_FILIAL := xFilial("CT1")
		CT1->CT1_CONTA  := _CtaCtb
		CT1->CT1_DESC01 := SA1->A1_NOME
		CT1->CT1_CLASSE := "2"
		CT1->CT1_NORMAL := "1"
		CT1->CT1_RES    := "C" + AllTrim(SA1->A1_COD) + AllTrim(SA1->A1_LOJA)
		CT1->CT1_BLOQ   := "2"
		CT1->CT1_DC     := CtbDigCont(_CtaCtb)
		CT1->CT1_CVD02  := "1"
		CT1->CT1_CVD03  := "1"
		CT1->CT1_CVD04  := "1"
		CT1->CT1_CVD05  := "1"
		CT1->CT1_CVC02  := "1"
		CT1->CT1_CVC03  := "1"
		CT1->CT1_CVC04  := "1"
		CT1->CT1_CVC05  := "1"
		CT1->CT1_CTASUP := _CtaSint//CtbCtaSup( _CtaCtb )
		CT1->CT1_ACITEM := "2"
		CT1->CT1_ACCUST := "2"
		CT1->CT1_ACCLVL := "2"
		CT1->CT1_DTEXIS := CToD("01/01/1980")
		CT1->CT1_BOOK	:= "001/002/003/004/005"
		CT1->CT1_AGLSLD	:= "2"
		CT1->CT1_CCOBRG := "2"
		CT1->CT1_ITOBRG := "2"
		CT1->CT1_CLOBRG := "2"
		CT1->CT1_LALUR  := "0"
		CT1->CT1_CTLALU	:= _CtaCtb
		CT1->CT1_ACATIV := "2"
		CT1->CT1_ATOBRG := "2"
		CT1->CT1_ACET05 := "2"
		CT1->CT1_05OBRG := "2"
		CT1->CT1_NTSPED := "01"
		CT1->(MsUnLock())
		
		&& Gravacao da conta contabil no cadastro de Cliente (SA1)
		SA1->(DbSelectarea("SA1"))
		If RecLock("SA1",.F.)
			SA1->A1_CONTA := _CtaCtb
			SA1->(MsUnLock())
		EndIf
		
		&& Amarração Plano de Contas x Referência (SPED Contabil e ECF)
		CVD->(DbSelectarea("CVD"))
		If RecLock("CVD",.T.)
		CVD->CVD_FILIAL	:= 	xFilial("CVD")
		CVD->CVD_CONTA  :=	_CtaCtb
		CVD->CVD_CTAREF	:=	_CtaRef
		CVD->CVD_ENTREF	:=	"10"
		CVD->CVD_CODPLA	:=	"PJGE15"
		CVD->CVD_CUSTO 	:= 	""
		CVD->CVD_TPUTIL	:= 	"A"
		CVD->CVD_CLASSE	:= 	"2"
		CVD->CVD_NATCTA	:= 	"01"
		CVD->CVD_CTASUP	:= 	"1.01.02.02"
		CVD->(MsUnLock())
		EndIf	
	Else
		Alert("Atenção!!! Erro na inclusão da conta contábil!!!")
	EndIf

EndIf

Return Nil