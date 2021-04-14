#INCLUDE "totvs.ch"
#INCLUDE "topconn.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Função		:	PCPA0001
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	31/03/2015
	Descricao	:	Rotina para calculo do custo e gravacao de tabela personalizada (Z03)
*/

User Function PCPA0001()
Local cPerg		:= "PCPA0001"	&& Grupo de perguntas
	
	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	&& Tela de processamento
	Processa({|| ExecCalc() },"Executando cálculo.")
Return


Static Function ExecCalc()
Local cQry 		:= ""                       
Local nAuxVal   := 0     
Local nUltVnd	:= 0
Local aStruPA 	:= {}
Local nRegs		:= 0

Private nEstru 		:= 0
Private aEstrutura 	:= {} 

	DelDados()   
	
	cQry := "SELECT " + cEOL
	cQry += 	"DISTINCT " + cEOL
	cQry += 	"B1_COD,B1_DESC,B1_TIPO " + cEOL
	
	cQry += "FROM " + cEOL
	cQry += 	RetSQLName("SB1") + " B1 " + cEOL
	
	cQry += "WHERE " + cEOL
	cQry += 	"B1_FILIAL = '" + xFilial("SB1") + "' AND " + cEOL
	cQry += 	"(B1_TIPO = 'PA' OR B1_TIPO = 'PI') AND " + cEOL
	cQry += 	"B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND " + cEOL
	cQry += 	"B1_GRUPO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND " + cEOL
	cQry += 	"B1.D_E_L_E_T_ = ' '"
	
	TcQuery cQry Alias TSB1 New   
	
	Count to nRegs
	
	TSB1->(DbGoTop())
	
	ProcRegua(nRegs)
	
	nCount := 0
	
	&& Percorrer produtos
	While TSB1->(!EOF())      
		
		aStruPA 	:= {}
		aEstrutura 	:= {}
		nUltVnd		:= 0
	
		aStruPA := EstAlc(TSB1->B1_COD,1)

		If TSB1->B1_TIPO == "PA"
			nUltVnd := ConUlVnd(TSB1->B1_COD)
		EndIf
        
		For x := 1 To Len(aStruPA)
			DbSelectArea("SB1")
			
			If aStruPA[x,2] == TSB1->B1_COD
				If SB1->(DbSeek(xFilial("SB1") + aStruPA[x,3]))
					If SB1->B1_TIPO == "PI"
						nAuxVal := RetValPI(aStruPA[x,3])
					Else 
						nAuxVal := ConCusMP(aStruPA[x,3])
					EndIf
					
					RecLock("Z03",.T.)
						Z03->Z03_FILIAL 	:= xFilial()
						Z03->Z03_TPPROD		:= Posicione("SB1",1,xFilial("SB1") + aStruPA[x,3],"B1_TIPO")
						Z03->Z03_CODPA    	:= TSB1->B1_COD
						Z03->Z03_DESCPA		:= TSB1->B1_DESC
						Z03->Z03_CODCOMP	:= aStruPA[x,3]
						Z03->Z03_DESCOMP	:= Posicione("SB1",1,xFilial("SB1") + aStruPA[x,3],"B1_DESC")
						Z03->Z03_QUANT		:= aStruPA[x,4]
						Z03->Z03_VUNIT		:= nAuxVal
						Z03->Z03_VTOTAL		:= aStruPA[x,4] * nAuxVal
						Z03->Z03_UVENDA		:= nUltVnd
						Z03->Z03_TPPRIN		:= TSB1->B1_TIPO
					Z03->(MsUnLock())					
					
				EndIf
			EndIf
		Next	 	
        
		nCount ++
		
	 	IncProc("Aguarde processando... " + StrZero(nCount,6) + " de " + StrZero(nRegs,6))
	 	TSB1->(DbSkip())
	EndDo 
	
	TSB1->(DbCloseArea())  
Return                            


/****************************************************************************************************/


Static Function RetValPI(cCodPI)
Local aStruPI 	:= {}
Local nValRet	:= 0   
Local nAuxVal	:= 0

	aEstrutura 	:= {}               
	
	aStruPI := EstAlc(cCodPI)
	
	For k := 1 To Len(aStruPI)
		If aStruPI[k,2] == cCodPI
			If SB1->(DbSeek(xFilial("SB1") + aStruPI[k,3]))
				If SB1->B1_TIPO == "PI"
					nQtdPI	:= aStruPI[k,4]
					nAuxVal := 0
					
					For y := 1 To Len(aStruPI)
						If aStruPI[y,2] == aStruPI[k,3]
							nAuxVal += aStruPI[y,4] * ConCusMP(aStruPI[y,3])
						EndIf         
					Next
					
					nValRet += nQtdPI * nAuxVal
				Else
					nValRet += aStruPI[k,4] * ConCusMP(aStruPI[k,3])
				EndIf
			EndIf
		EndIf
	Next

Return nValRet


/****************************************************************************************************/


Static Function ConCusMP(cCodProd)
Local cQry 		:= ""
Local nPreco    := 0

	cQry := "SELECT " + cEOL
	cQry +=		"TOP 1 " + cEOL
	cQry +=		"D1_VUNIT " + cEOL

	cQry +=	"FROM " + cEOL
	cQry +=		RetSQLName("SD1") + " D1 " + cEOL
	
	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SF4") + " F4 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"F4_FILIAL = '" + xFilial("SF4") + "' AND " + cEOL
	cQry +=		"F4_CODIGO = D1_TES AND " + cEOL
	cQry +=		"F4_CODIGO BETWEEN '000' AND '499' AND " + cEOL
	cQry +=		"F4.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SA2") + " A2 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"A2_FILIAL = '" + xFilial("SA2") + "' AND " + cEOL
	cQry +=		"A2_COD = D1_FORNECE AND " + cEOL
	cQry +=		"A2_LOJA = D1_LOJA AND " + cEOL
	cQry +=		"A2.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"WHERE " + cEOL
	cQry +=		"D1_FILIAL = '" + xFilial("SD1") + "' AND " + cEOL
	cQry +=		"D1_TIPO <> 'D' AND " + cEOL
	cQry +=		"D1_COD = '" + cCodProd + "' AND " + cEOL
	cQry +=		"(F4_DUPLIC = 'S' OR A2_EST = 'EX') AND " + cEOL
	cQry +=		"D1.D_E_L_E_T_ = ' '"

	cQry +=	"ORDER BY " + cEOL
	cQry +=		"D1_EMISSAO,D1_VUNIT DESC " + cEOL
	
	TcQuery cQry Alias TSD1 New
	
	If TSD1->(!EOF())
		nPreco := TSD1->D1_VUNIT
	EndIf 
	
	TSD1->(DbCloseArea())

Return nPreco


/****************************************************************************************************/


Static Function ConUlVnd(cCodProd)
Local cQry 		:= ""
Local nPreco    := 0

	cQry := "SELECT " + cEOL
	cQry +=		"TOP 1 " + cEOL
	cQry +=		"D2_PRCVEN " + cEOL

	cQry +=	"FROM " + cEOL
	cQry +=		RetSQLName("SD2") + " D2 " + cEOL

	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SF2") + " F2 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"F2_FILIAL = '" + xFilial("SF2") + "' AND " + cEOL
	cQry +=		"F2_DOC = D2_DOC AND " + cEOL
	cQry +=		"F2_SERIE = D2_SERIE AND " + cEOL
	cQry +=		"F2_CLIENTE = D2_CLIENTE AND " + cEOL
	cQry +=		"F2_LOJA = D2_LOJA AND " + cEOL
	cQry +=		"F2_ZZTIPO <> 'V' AND " + cEOL
	cQry +=		"F2.D_E_L_E_T_ = ' ' " + cEOL
	
	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SF4") + " F4 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"F4_FILIAL = '" + xFilial("SF4") + "' AND " + cEOL
	cQry +=		"F4_CODIGO = D2_TES AND " + cEOL
	cQry +=		"F4_CODIGO BETWEEN '500' AND '999' AND " + cEOL
	cQry +=		"F4.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"INNER JOIN " + cEOL
	cQry +=		RetSQLName("SA1") + " A1 " + cEOL

	cQry +=	"ON " + cEOL
	cQry +=		"A1_FILIAL = '" + xFilial("SA2") + "' AND " + cEOL
	cQry +=		"A1_COD = D2_CLIENTE AND " + cEOL
	cQry +=		"A1_LOJA = D2_LOJA AND " + cEOL
	cQry +=		"A1.D_E_L_E_T_ = ' ' " + cEOL

	cQry +=	"WHERE " + cEOL
	cQry +=		"D2_FILIAL = '" + xFilial("SD1") + "' AND " + cEOL
	cQry +=		"D2_TIPO <> 'D' AND " + cEOL
	cQry +=		"D2_COD = '" + cCodProd + "' AND " + cEOL
	cQry +=		"(F4_DUPLIC = 'S' OR A1_EST = 'EX') AND " + cEOL
	cQry +=		"D2.D_E_L_E_T_ = ' '"

	cQry +=	"ORDER BY " + cEOL
	cQry +=		"D2_EMISSAO DESC " + cEOL

	TcQuery cQry Alias TSD2 New
	
	If TSD2->(!EOF())
		nPreco := TSD2->D2_PRCVEN
	EndIf 
	
	TSD2->(DbCloseArea())

Return nPreco


/****************************************************************************************************/


Static Function DelDados()
Local cQry := ""

	cQry := "DELETE " + cEOL
	cQry +=	"FROM " + cEOL
	cQry += 	RetSqlName("Z03")

	TcSqlExec(cQry)
Return                                  


/****************************************************************************************************/


Static Function EstAlc(cProduto,nQuant,lOneLevel,lPreEstru)
LOCAL nRegi
LOCAL nQuantItem:=0
LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc

DEFAULT lOneLevel := .F.
DEFAULT lPreEstru := .F.

nQuant:=IF(nQuant == NIL,1,nQuant)
nEstru++
If nEstru == 1
	aEstrutura:={}
EndIf
dbSelectArea(If(lPreEstru,"SGG","SG1"))
dbSetOrder(1)
dbSeek(xFilial()+cProduto)
While !Eof() .And. If(lPreEstru,GG_FILIAL+GG_COD,G1_FILIAL+G1_COD) == xFilial()+cProduto
	nRegi:=Recno()
	cCodigo    :=If(lPreEstru,GG_COD,G1_COD)
	cComponente:=If(lPreEstru,GG_COMP,G1_COMP)
	cTrt       :=If(lPreEstru,GG_TRT,G1_TRT)
	cGrOpc     :=If(lPreEstru,GG_GROPC,G1_GROPC)
	cOpc       :=If(lPreEstru,GG_OPC,G1_OPC)
	If cCodigo != cComponente
		nProcura:=aScan(aEstrutura,{|x| x[1] == nEstru .And. x[2] == cCodigo .And. x[3] == cComponente .And. x[5] == cTrt})
		If nProcura  = 0
			//nQuantItem:=ExplAlc(nQuant,nil,nil,nil,nil,lPreEstru) 
			
			nQuantItem := G1_QUANT
			
			AADD(aEstrutura,{nEstru,cCodigo,cComponente,nQuantItem,cTrt,cGrOpc,cOpc,Recno()})
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lOneLevel
			nRecno:=Recno()
			dbSeek(xFilial()+cComponente)
			IF Found()
				cCodigo:=If(lPreEstru,GG_COD,G1_COD)
				EstAlc(cCodigo,nQuantItem,nil,lPreEstru)
				nEstru --
			Else
				dbGoto(nRecno)
				nProcura:=aScan(aEstrutura,{|x| x[1] == nEstru .And. x[2] == cCodigo .And. x[3] == cComponente .And. x[5] == cTrt})
				If nProcura  = 0
					//nQuantItem:=ExplAlc(nQuant,nil,nil,nil,nil,lPreEstru) 
					
					nQuantItem := G1_QUANT
					
					AADD(aEstrutura,{nEstru,cCodigo,cComponente,nQuantItem,cTrt,cGrOPc,cOpc,Recno()})
				EndIf
			Endif
		EndIf
	EndIf
	dbGoto(nRegi)
	dbSkip()
Enddo
Return(aEstrutura)                                            
      

/****************************************************************************************************/


&& Funcao		: ValidPerg(cPerg)
&& Descricao	: Verifica a existencia do grupo de perguntas, caso nao exista cria.
Static Function ValidPerg(cPerg)
Local aAlias 	:= Alias()
Local aRegs 	:= {}
Local i,j       
Local aCposSX1 := FWSX1Util():GetGroup(cPerg)                                                                                                                         

	SX1->(DbSelectArea("SX1"))
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))
	
	&& Grupo - Ordem - Pergunta - Variavel - Tipo - Tamanho - Decimal - Presel - GSC - Valid - Var01 - Def01 - Cnt01 - Var02 - Def02 - Cnt02 - Var03 - Def03 - Cnt03 - Var04 - Def04 - Cnt04 - Var05 - Def05 - Cnt05
	AADD(aRegs,{cPerg,"01","Produto de ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"02","Produto até","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"03","Grupo de ","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
	AADD(aRegs,{cPerg,"04","Grupo até","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})

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
Return