#include "protheus.ch"  
#Include "Colors.ch"
#Include "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  | VENDXES	   บAutor ณMarcio Nascimento  บ Data ณ 14/05/2010 บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo das Vendas para conf. da coluna  Vendas do         บฑฑ
ฑฑบ          ณ relat๓rio Entradas e Saidas.       						  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION VENDXES()
Local oReport
Local cPerg := "VENDXES"

If TRepInUse()
	ValidPerg(@cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()	
EndIf                       
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณReportDef ณ Autor ณ Marcio Nascimento   ณ Data ณ 15/04/2010 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Montagem do layout do relatorio.                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Protheus 10                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION ReportDef(cPerg)
Local oReport
Local oSection
Local cTitulo	:= "Analise das Vendas x Entradas e Saํdas:"  

oReport := TReport():New("VENDXES",cTitulo,"VENDXES",{|oReport| PrintReport(oReport)},cTitulo)
oSection := TRSection():New(oReport,"Analise das Devolucoes de Compras x Entradas e Saํdas",{"SD1","SB1","SF4"}) 
oSection:AutoSize()           
oSection:SetTotalText("Total")
oSection:SetTotalInLine(.F.)  
	TRCell():New(oSection,"D2_DOC"		,"QRYSD2", "Nota Fiscal:"	)
	TRCell():New(oSection,"D2_SERIE"	,"QRYSD2", "Serie:"     	) 
	TRCell():New(oSection,"D2_COD"		,"QRYSD2", "Cod. Produto:" 	)
	TRCell():New(oSection,"B1_DESC"   	,"QRYSD2", "Desc. Produto:"	) 
	TRCell():New(oSection,"D2_CUSTO1"	,"QRYSD2", "Custo:"      	) 
	TRCell():New(oSection,"D2_EMISSAO" 	,"QRYSD2", "Dt. Emissao:"   ) 
	TRCell():New(oSection,"D2_TP"		,"QRYSD2", "Tipo SD2:"     	) 
	TRCell():New(oSection,"B1_TIPO"		,"QRYSD2", "Tipo SB1:"     	) 
	TRCell():New(oSection,"D2_TIPO"		,"QRYSD2", "Tipo Doc:"     	) 
	TRCell():New(oSection,"D2_TES"		,"QRYSD2", "TES:"	     	) 
	
	oSection:Cell("D2_CUSTO1"):SetHeaderAlign("RIGHT")									  	                                   
		
	TRFunction():New(oSection:Cell("D2_CUSTO1"),NIL,"SUM",,,,,,.F.)

RETURN (oReport)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณPrintReporณ Autor ณ Marcio Nascimento   ณ Data ณ 15/05/2010 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Impressao do Relatorio                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ Protheus 10                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
STATIC FUNCTION PrintReport(oReport)
Local oSection 	:= oReport:Section(1)
oSection:BeginQuery()		    
	BeginSql alias "TSD1"
		SELECT D2_DOC, D2_COD, B1_DESC, D2_CUSTO1, D2_EMISSAO, D2_TP, B1_TIPO, D2_SERIE, D2_TIPO, D2_TES
		FROM %table:SD2% D2, %table:SB1% B1, %table:SF4% F4, 
		WHERE ((D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%) AND (D2_TP BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% )
		AND (D2_LOCAL BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06% )) AND
		D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND D2_COD = B1_COD AND F4_PODER3 = 'N' AND D2_TIPO <> 'D'
		AND B1.D_E_L_E_T_ = ' ' AND D2.D_E_L_E_T_ = ' ' AND F4.D_E_L_E_T_ = ' '
		ORDER BY D2_TP, D2_COD, D2_DOC, D2_SERIE, D2_EMISSAO
	EndSql          		
oSection:EndQuery()
oSection:Print()
RETURN
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณ Marcio Nascimento  บ Data ณ  15/05/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ValidPerg(cPerg)
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	Local aCposSX1 := FWSX1Util():GetGroup(cPerg)

	DbSelectArea("SX1")
	DbSetOrder(1)

	cPerg := PADR(cPerg,Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01","Da Emissao de?"	,	"",	"",	"mv_ch1", "D", 08 				 	, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "02","Da Emissao ate ?"	,	"",	"",	"mv_ch2", "D", 08				 	, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "03","Tipo de ?" 		,	"",	"",	"mv_ch3", "C", Len(SB1->B1_TIPO)	, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "04","Tipo ate?" 		,	"",	"",	"mv_ch4", "C", Len(SB1->B1_TIPO)	, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})	
	aAdd(aRegs, {cPerg, "05","Local de ?" 		,	"",	"",	"mv_ch5", "C", Len(SB1->B1_LOCPAD)	, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})
	aAdd(aRegs, {cPerg, "06","Local ate?" 		,	"",	"",	"mv_ch6", "C", Len(SB1->B1_LOCPAD)	, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, ""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next i
	
	DbSelectArea(_sAlias)
  
RETURN .T.