#include 'protheus.ch'
#include 'topconn.ch' 
     
#Define PI 3.14

#DEFINE ADVPLLog_DISABLED "1" // DESABILITA A IMPRESSAO DO LOG 
#DEFINE ADVPLLog_INFO "2"
#DEFINE ADVPLLog_DEBUG "3"
#DEFINE ADVPLLog_CONSOLE "4"
/*/{Protheus.doc} RMolde
(long_description)
@author    danielbraga
@since     10/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class RMolde 
	data oModel
	data oLog 
	method RMolde() constructor 
	method list(lSB5)
	method createTool(oMolde)
	method processTool()
	method areaCircle()
	method findMolde(cCodigo)
	method processProduct()
	method updateProduct(oMolde)
	method processStrutura()
	method getMistMolde(cProduto) 
  
endclass

/*/{Protheus.doc} new
Metodo construtor
@author    danielbraga
@since     10/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method RMolde() class RMolde
	local cfileName := "calculo_massa_"+time() 
	self:oModel := TMolde():Molde()
	self:oLog := ADVPLLog():ADVPLLog(cFileName,"Log de rotina",ADVPLLog_INFO)
return

method list(lSB5) Class RMolde
	local cQuery   := "" 
	local cAlias   := getNextAlias()
	local oHash    := THashMap():New()
	local oMolde   := nil
	local oList    := nil
	default lSB5 := .f. 
	self:oLog:add(" [RMolde][list] Classe RMolde - Metodo list"  )
	if lSB5
		self:oLog:add("[RMolde][list] Usando a informacoes da SB5"  )
		cQuery := getSqlSB5()
		self:oLog:add("[RMolde][list] Query SB5"+cQuery  )
	else 
		self:oLog:add("[RMolde][list] Usando a informacoes da SH4"  )
		cQuery := getSqlSH4()
		self:oLog:add("[RMolde][list] Query SH4"+cQuery  )
	endIf
	self:oLog:add("[RMolde][list] Executando a Query"  )
    MPSysOpenQuery(cQuery, @cAlias)
    self:oLog:add("[RMolde][list] fim da Executando a Query"  )
     if (cAlias)->(!EOF())
		self:oLog:add("[RMolde][list] Iniciando o processamento da query"  )
     	while (cAlias)->(!EOF())
     		oMolde := TMolde():Molde()
     		oMolde:setCodigo(    (cAlias)->CODIGO)
     		oMolde:setDescricao( (cAlias)->DESCRICAO)
			if (cAlias)->(FieldPos("H4_ZZAREA")) > 0 
				oMolde:setArea( (cAlias)->H4_ZZAREA)
			endIf
     		oHash:set(oMolde:getCodigo(), oMolde)
     	(cAlias)->(dbSkip())
     	endDo
		self:oLog:add("[RMolde][list] fim  o processamento da query"  )
     	oHash:list(@oList)
		self:oLog:add("[RMolde][list] gerando a lista dos moldes"  )
     	oHash:Clean()
     endIf

return oList

method createTool(oMolde) Class RMolde
	local oModel := fwLoadModel("MATA620")
	local cRet   := ""
	local cChave := xFilial("SH4")+padR(oMolde:getCodigo(),tamSx3("H4_ZZCODMD")[1])

	self:oLog:add("[RMolde][createTool] Inicando a criacao do molde da MATA620"  )
	 
	dbSelectArea("SH4")
	SH4->(dbSetOrder(2))
	if SH4->(dbSeek(cChave))
		self:oLog:add("[RMolde][createTool] Molde "+oMolde:getCodigo()+" encontrado -  alteracao "  )
		oModel:SetOperation(4)
		oModel:Activate()
	else 
		self:oLog:add("[RMolde][createTool] Molde "+oMolde:getCodigo()+" nao encontrado -  inclusao  "  )
		oModel:SetOperation(3)
		oModel:Activate()
		oModel:SetValue( 'SH4MASTER'    , 'H4_CODIGO'  , GetSXENum("SH4","H4_CODIGO" ) ) 
		oModel:SetValue( 'SH4MASTER'    , 'H4_ZZCODMD' , allTrim(oMolde:getCodigo()) ) 
	endif
	

    oModel:SetValue( 'SH4MASTER'    , 'H4_DESCRI'  , oMolde:getDescricao() ) 
    oModel:SetValue( 'SH4MASTER'    , 'H4_ZZDINEX' , 1) 
	oModel:SetValue( 'SH4MASTER'    , 'H4_ZZDININ' , 1) 
	oModel:SetValue( 'SH4MASTER'    , 'H4_ZZESPPR' , 1) 
	oModel:SetValue( 'SH4MASTER'    , 'H4_ZZAREA'  , 1) 
    if oModel:VldData()
        oModel:CommitData()
        oModel:DeActivate()   
		self:oLog:add("[RMolde][createTool] Incluido com successo o molde "+allTrim(oMolde:getCodigo()))
    else 
        
        cRet := setMsgError(oModel)
		self:oLog:add("[RMolde][createTool] Erro na inclusao/alteracao  "+cRet  )
    endIf


return cRet

method processTool() Class RMolde
	
	local oList := self:list(.t.)
	local nI := 0 
	local oMolde := nil
	local cRet   := ""
	self:oLog:add("[RMolde][processTool] Iniciando o processo de criacao do molde "  )
	for nI:=1 to len(oList)
		self:oLog:add("[RMolde][processTool] Lendo molde  "  )
		oMolde := oList[nI,2]
		cRet := self:createTool(oMolde)
		if !empty(cRet)
		    AVISO("Erro na criacao da ferramenta.",;
		          cRet ,;
		         {"OK"}, 3)
		    loop     
	    endIf
		self:oLog:add("[RMolde][processTool] finalizando molde  "  )
	next nI
	self:oLog:add("[RMolde][processTool] fim do processo de criacao do molde  "  )
return 

method processProduct() Class RMolde 
	local oList := self:list()
	local nI := 0 
	local cRet := "" 
	self:oLog:add("[RMolde][processProduct] Iniciando o processo de atualizao do molde (SB5) "  )
	for nI:=1 to len(oList)
		self:oLog:add("[RMolde][processProduct] Lendo o molde "  )
		oMolde := oList[nI,2]
		cRet :=  self:updateProduct(oMolde)
		if !empty(cRet)
		    AVISO("Erro na atualizacao do produto(SB5).",;
		          cRet ,;
		         {"OK"}, 3)
		    loop     
	    endIf
		self:oLog:add("[RMolde][processProduct] finalizando o molde "  )
	next nI
	self:oLog:add("[RMolde][processProduct] finalizando  o processo de atualizacao do molde (SB5) "  )
return 

method updateProduct(oMolde) Class RMolde 
	local cAlias := getNextAlias()
	local cQuery :="" 
	local oModel := fwLoadModel("MATA180")
	local cRet   := "" 
	local nI     := 0 

	self:oLog:add("[RMolde][updateProduct] Iniciando  atualizao do molde (SB5) "  )
	for nI := 1 to 4
		cQuery := getSqlProduto("B5_ZZMOMI"+cValToChar(nI),oMolde:getCodigo())
		MPSysOpenQuery(cQuery, @cAlias)
		if (cAlias)->(!EOF())
			self:oLog:add("[RMolde][updateProduct] Atualizando molde   "+allTrim(oMolde:getCodigo())  )	
			oModel:SetOperation(4)
			oModel:Activate()
			oModel:SetValue( 'SB5MASTER'    , 'B5_ZZVOMI'+cValToChar(nI)  , oModel:getArea()) 
			if oModel:VldData()
				oModel:CommitData()
				oModel:DeActivate()   
				self:oLog:add("[RMolde][updateProduct]  molde atualizado com sucesso   "+allTrim(oMolde:getCodigo())  )	
			else 
				cRet := setMsgError(oModel)
				self:oLog:add("[RMolde][updateProduct] Erro na atualizacao molde   "+allTrim(oMolde:getCodigo())  )	
				exit 
			endIf
			self:oLog:add("[RMolde][updateProduct] fim do processamento do  molde   "+allTrim(oMolde:getCodigo())  )	
			(cAlias)->(dbSkip())
		endIf
	next nI
	self:oLog:add("[RMolde][updateProduct] fim da attualizacao dos moldes")
return cRet

method areaCircle(nDiametro) class RMolde
	local  nArea  := 0
	
	self:oLog:add("[RMolde][areaCircle] Calculo  area ")
	self:oLog:add("[RMolde][areaCircle] Diametro "+ cValToChar(nDiametro))
	self:oLog:add("[RMolde][areaCircle] PI "+ cValToChar(PI))
	nArea  :=  (nDiametro * nDiametro) * PI
	self:oLog:add("[RMolde][areaCircle] PI "+ cValToChar(nArea))
	self:oLog:add("[RMolde][areaCircle] Fim Calculo  area ")
return nArea 

method findMolde(cCodigo) class RMolde

	local oMolde  :=  TMolde():Molde()
	local aArea   := SH4->(getArea())
	dbSelectArea("SH4")
	SH4->(dbSetOrder(2))
	self:oLog:add("[RMolde][findMolde] Iniciando a busca do molde  ")
	self:oLog:add("[RMolde][findMolde] Buscando molde codigo: "+cCodigo)
	if SH4->(dbSeek(xFilial("SH4")+cCodigo))
		self:oLog:add("[RMolde][findMolde] Molde encontrado" )
		oMolde:setCodigo(SH4->H4_CODIGO)
		oMolde:setDescricao(SH4->H4_DESCRI) 
		oMolde:setInternoDiametro(SH4->H4_ZZDININ)
		oMolde:setExternoDiametro(SH4->H4_ZZDINEX)
		oMolde:setEspessuraPrensa(SH4->H4_ZZESPPR)
		oMolde:setArea(SH4->H4_ZZAREA)
	else 
		self:oLog:add("[RMolde][findMolde] Molde encontrado" )
	endIf
	SH4->(restArea(aArea))
	self:oLog:add("[RMolde][findMolde] Finalizando busca do molde" )
return oMolde


method processStrutura() Class RMolde
	local cAlias := getNextAlias()
	local cQuery := getSqlStruProd()
	local cProduto := "" 
	local aMistura := {}
	local nI :=0
	local cMistura := ""
	local cMolde   := "" 
	local cAlStu   := getNextAlias()
	local cQryStu  := ""
	local nRecSG1  := 0
	local oMolde   := nil 
	local nRecno := 0

	self:oLog:add("[RMolde][processStrutura]  Iniciando atualizacao da estrutura" )
	self:oLog:add("[RMolde][processStrutura]  Query da estrutura"+cQuery )
	self:oLog:add("[RMolde][processStrutura]  iniciando a execucao da query"  )
	MPSysOpenQuery(cQuery, @cAlias)
	self:oLog:add("[RMolde][processStrutura]  Finalzando a execucao da query"  )
	while (cAlias)->(!EOF())
		cProduto := (cAlias)->G1_COD
		self:oLog:add("[RMolde][processStrutura]  Atualizacao do produto "+ cProduto )
		self:oLog:add("[RMolde][processStrutura]  Buscando o molde e mistuda do produto "+ cProduto )
		aMistura := self:getMistMolde(cProduto)
		self:oLog:add("[RMolde][processStrutura]  finalizando  o molde e mistuda do produto "+ cProduto )
		for nI:=  1 to len(aMistura)
			cMistura := aMistura[nI][1]
			cMolde   := aMistura[nI][2]
			self:oLog:add("[RMolde][processStrutura]  Iniciando a atualizacao  do molde/Mistura  "+ cMolde+"/"+cMistura )
			self:oLog:add("[RMolde][processStrutura]  Iniciando a busca do molde /mistura na esturuta")
			cQryStu := getSqlMistEst(cProduto,cMistura)
			self:oLog:add("[RMolde][processStrutura]  Query de busca do molde /mistura na esturuta"+cQryStu)
			self:oLog:add("[RMolde][processStrutura]  Iniciando a execucao da query" )
			MPSysOpenQuery(cQryStu, @cAlStu)
			self:oLog:add("[RMolde][processStrutura]  finalizando a execucao da query" )
			while (cAlStu)->(!EOF())
				self:oLog:add("[RMolde][processStrutura]  Iniciando a alteracao do molde  "+ cMolde)
				oMolde := self:findMolde(cMolde)
				nRecno := (cAlias)->ID
				dbSelectArea("SG1")
				SG1->(dbSetOrder(1))
				SG1->(dbGoTo(nRecno))
				SG1->(recLock("SG1" ,.F.))
				SG1->G1_QUANT := oMolde:getArea()
				SG1->(msUnLock())
				self:oLog:add("[RMolde][processStrutura]  Alterando o G1_QUANT  para "+ oMolde:getArea())
				self:oLog:add("[RMolde][processStrutura]  Finalizando a alteracao do molde"+ cMolde )
			(cAlStu)->(dbSkip())
			endDo
			(cAlStu)->(dbCloseArea())
			self:oLog:add("[RMolde][processStrutura]  finalizando  a atualizacao  do molde/Mistura  "+ cMolde+"/"+cMistura )
		next nI
	(cAlias)->(dbSkip())
	endDo
	(cAlias)->(dbCloseArea())
	self:oLog:add("[RMolde][processStrutura]  finalizando atualizacao da estrutura" )
return 

method  getMistMolde(cProduto) class RMolde 

	local aArea:= SB5->(getArea())
	local aMistura := {}
	local nI	   := 0
	local nQtdMist := 5
	local nFieldPos:= 0
	local cMistura :=""
	local cMolde   := ""

	dbSelectArea("SB5")
	SB5->(dbSetOrder(1))
	self:oLog:add("[RMolde][getMistMolde]  Iniciando a busca do Molde/Mistura do produto "+cProduto )
	if SB5->(dbSeek(xFilial("SB5")+cProduto ))
		while SB5->(!EOf()) .and. SB5->B5_COD == cProduto
			self:oLog:add("[RMolde][getMistMolde]  Acho o Molde/Mistura do produto "+cProduto )
			self:oLog:add("[RMolde][getMistMolde]  processando o Molde/Mistura do produto "+cProduto )
			for nI:= 1 to nQtdMist

				nFieldPos := SB5->(FieldPos("B5_ZZMIST"+cValToChar(nI)))
                if nFieldPos > 0
					cMistura := SB5->(fieldGet(nFieldPos))
				else 
					cMistura := ""
				endIf
				nFieldPos := SB5->(FieldPos("B5_ZZMOMI"+cValToChar(nI)))
                if nFieldPos > 0
					cMolde   :=  SB5->(fieldGet(nFieldPos))
				else 
					cMolde := ""
				endIf
				if !empty(cMistura)  .and. !empty(cMolde)
					aadd(aMistura,{cMistura,cMolde })
				endif
			next nI 
			self:oLog:add("[RMolde][getMistMolde]  Fim do processamento o Molde/Mistura do produto "+cProduto )
		endDo
	endIf
	SB5->(RestArea(aArea))
return aMistura

static  function getSqlSB5()
	local cQuery := "SELECT  DISTINCT CODIGO,DESCRICAO FROM ("+CRLF 
	cQuery += "SELECT DISTINCT lTrim(RTrim(B5_ZZMOMI1)) as CODIGO , 'Molde '+lTrim(RTrim(B5_ZZMOMI1)) as DESCRICAO FROM "+retSqlName("SB5")+" WHERE D_E_L_E_T_!= '*' AND B5_FILIAL ='"+xFilial("SB5")+"'"+CRLF 
	cQuery += "UNION ALL "+CRLF
	cQuery += "SELECT DISTINCT lTrim(RTrim(B5_ZZMOMI2)) as CODIGO , 'Molde '+lTrim(RTrim(B5_ZZMOMI2)) as DESCRICAO FROM "+retSqlName("SB5")+" WHERE D_E_L_E_T_!= '*' AND B5_FILIAL ='"+xFilial("SB5")+"'"+CRLF 
	cQuery += "UNION ALL "+CRLF
	cQuery += "SELECT DISTINCT lTrim(RTrim(B5_ZZMOMI3)) as CODIGO , 'Molde '+lTrim(RTrim(B5_ZZMOMI3)) as DESCRICAO FROM "+retSqlName("SB5")+" WHERE D_E_L_E_T_!= '*' AND B5_FILIAL ='"+xFilial("SB5")+"'"+CRLF
	cQuery += "UNION ALL "+CRLF
	cQuery += "SELECT DISTINCT lTrim(RTrim(B5_ZZMOMI4)) as CODIGO , 'Molde '+lTrim(RTrim(B5_ZZMOMI4)) as DESCRICAO FROM "+retSqlName("SB5")+" WHERE D_E_L_E_T_!= '*' AND B5_FILIAL ='"+xFilial("SB5")+"'"+CRLF
	cQuery +=") TMP  WHERE TMP.CODIGO != '' order by TMP.CODIGO"
return cQuery

static function getSqlSH4()

	local cQuery := "" 
	cQuery += "SELECT H4_CODIGO AS CODIGO, H4_DESCRICAO AS DESCRICAO , H4_ZZAREA FROM "+retSqlName("SH4")+" WHERE D_E_L_E_T_!= '*' AND H4_FILIAL ='"+xFilial("SH4")+"'"+CRLF 
	
return cQuery

static function getSqlProduto(cCampo,cMolde)
	local cQuery  := "" 
	cQuery := "SELECT R_E_C_N_O_ as ID FROM "+retSqlName("SB5" )+" WHERE D_E_L_E_T_!='*' AND B5_FILIAL='"+xFilial("SB5" )+"' AND  "+cCampo+" = '"+cMolde+"'" 

return cQuery

static function getSqlStruProd()

	local cQuery := "" 

	cQuery+="select DISTINCT "+CRLF
	cQuery+="       G1_COD   "+CRLF
	cQuery+="	  ,SB1.B1_DESC "+CRLF
	cQuery+="from "+retSqlName("SG1")+"  SG1"+CRLF
	cQuery+="INNER JOIN "+retSqlName("SB1")+" SB1 ON 1=1 "+CRLF
	cQuery+="			AND SB1.B1_COD =  SG1.G1_COD " +CRLF
	cQuery+="			AND SB1.B1_TIPO = 'PA' "+CRLF
	cQuery+="			AND SB1.D_E_L_E_T_!= '*' " +CRLF
	cQuery+="WHERE  SG1.D_E_L_E_T_ !='*' "  +CRLF
	cQuery+="ORDER BY SG1.G1_COD  ASC" +CRLF
	cQuery+="       , SB1.B1_DESC ASC" +CRLF

return cQuery


static function getSqlMistEst(cProduto,cComponente)

	local cQuery := "" 

	cQuery+=" WITH ESTRUTURA( CODIGO, COD_PAI, COD_COMP, QTD, PERDA, DT_INI, DT_FIM, NIVEL ,ID) AS "+CRLF
	cQuery+=" ( "+CRLF
    cQuery+="   SELECT G1_COD PAI, G1_COD, G1_COMP, G1_QUANT, G1_PERDA, G1_INI, G1_FIM, 1 AS NIVEL , R_E_C_N_O_ AS ID"+CRLF
    cQuery+="     FROM SG1010 SG1 (NOLOCK) "+CRLF
    cQuery+="  WHERE SG1.D_E_L_E_T_ = ''"+CRLF
    cQuery+="      AND G1_FILIAL      = ' ' "+CRLF
	cQuery+=" "+CRLF
    cQuery+="  UNION ALL "+CRLF
	cQuery+=" "+CRLF
    cQuery+="   SELECT CODIGO, G1_COD, G1_COMP, QTD * G1_QUANT, G1_PERDA, G1_INI, G1_FIM, NIVEL + 1 , R_E_C_N_O_ AS ID"+CRLF
    cQuery+="     FROM SG1010 SG1 (NOLOCK) "+CRLF
    cQuery+="  INNER JOIN ESTRUTURA EST "+CRLF
    cQuery+="     ON G1_COD = COD_COMP "+CRLF
    cQuery+="  WHERE SG1.D_E_L_E_T_ = '' "+CRLF
    cQuery+="     AND SG1.G1_FILIAL = ' ' "+CRLF
	cQuery+=" ) "+CRLF
	cQuery+=" SELECT  CODIGO , SB1_A.B1_DESC AS DESCRI, SB1_A.B1_TIPO AS TIPO , SB1_A.B1_GRUPO AS GRUPO, "+CRLF
    cQuery+="    		COD_PAI , SB1_B.B1_DESC AS DESC_PAI , SB1_B.B1_TIPO AS TIPO_PAI , SB1_B.B1_GRUPO AS GRUPO_PAI, "+CRLF
    cQuery+="    		COD_COMP, SB1_C.B1_DESC AS DESC_COMP, SB1_C.B1_TIPO AS TIPO_COMP, SB1_C.B1_GRUPO AS GRUPO_COMP, "+CRLF
    cQuery+="    		QTD     , PERDA, SB1_C.B1_UM AS UM_COMP, DT_INI, DT_FIM, NIVEL,ID   "+CRLF     
	cQuery+=" FROM ESTRUTURA "+CRLF
	cQuery+=" INNER JOIN SB1010 SB1_A (NOLOCK) "+CRLF
	cQuery+=" 	ON SB1_A.D_E_L_E_T_ = '' "+CRLF
	cQuery+=" 	AND SB1_A.B1_FILIAL = ' ' "+CRLF
	cQuery+=" AND SB1_A.B1_COD     = CODIGO "+CRLF
	cQuery+=" INNER JOIN SB1010 SB1_B (NOLOCK) "+CRLF
	cQuery+=" 	ON SB1_B.D_E_L_E_T_ = '' "+CRLF
	cQuery+=" 	AND SB1_B.B1_FILIAL = ' ' "+CRLF
	cQuery+=" AND SB1_B.B1_COD     = COD_PAI "+CRLF
	cQuery+=" INNER JOIN SB1010 SB1_C (NOLOCK) "+CRLF
	cQuery+=" 	ON SB1_C.D_E_L_E_T_ = '' "+CRLF
	cQuery+=" 	AND SB1_C.B1_FILIAL = ' ' "+CRLF
	cQuery+=" AND SB1_C.B1_COD     = COD_COMP "+CRLF
	cQuery+=" WHERE ESTRUTURA.CODIGO = '"+cProduto+"' AND  ESTRUTURA.COD_COMP ='"+cComponente+"'"

return cQuery

static function setMsgError(oModel)
	local aMsgErro  := {}
	local cResp		:= ""
	aMsgErro := oModel:GetErrorMessage()				
	cResp := "Mensagem do erro: " 			+ StrTran( StrTran( AllToChar(aMsgErro[6]), "<", "" ), "-", "" ) + (" ")
	cResp += "Mensagem da solucaoo: " 		+ StrTran( StrTran( AllToChar(aMsgErro[7]), "<", "" ), "-", "" ) + (" ")
	cResp += "Valor atribuido: " 			+ StrTran( StrTran( AllToChar(aMsgErro[8]), "<", "" ), "-", "" ) + (" ")
	cResp += "Valor anterior: " 			+ StrTran( StrTran( AllToChar(aMsgErro[9]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do formulario de origem: " + StrTran( StrTran( AllToChar(aMsgErro[1]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do campo de origem: " 		+ StrTran( StrTran( AllToChar(aMsgErro[2]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do formulario de erro: " 	+ StrTran( StrTran( AllToChar(aMsgErro[3]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do campo de erro: " 		+ StrTran( StrTran( AllToChar(aMsgErro[4]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do erro: " 				+ StrTran( StrTran( AllToChar(aMsgErro[5]), "<", "" ), "-", "" ) + (" ")
return  cResp
user function tsthashmap()
	local oRMolde := nil
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv( "01","01")

   oRMolde := RMolde():RMolde()
   oRMolde:processTool()
  //FWMsgRun(, {|oRMolde| oRMolde:processTool() }, "Processando", "Criando os moldes no cadastro de ferramenta.")
return
