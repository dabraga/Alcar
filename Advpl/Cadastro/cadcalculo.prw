#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} cadCalculo
Cadastro do alias Z08
@author danielbraga
@since 07/08/20
@version 1.0 
@return Nil, fun��o sem retorno
@example cadCalculo()
/*/
//--------------------------------------------------
user function cadCalculo()
local oBrowse as object

oBrowse := FWLoadBrw('cadCalculo')
oBrowse:Activate()
oBrowse:DeActivate()
oBrowse:Destroy()
oBrowse := Nil

return Nil

//--------------------------------------------------
/*/{Protheus.doc} BrowseDef
Defini��es do browse
@author danielbraga
@since 07/08/20
@version 1.0 
@return oBrowse, Objeto do browse
@example BrowseDef()
/*/
//--------------------------------------------------
static function BrowseDef()
local oBrowse as object

oBrowse := FwMBrowse():New()
oBrowse:SetAlias('Z08')

return oBrowse

//--------------------------------------------------
/*/{Protheus.doc} MenuDef
Defini��o das op��es de menu
@author danielbraga
@since 07/08/20
@version 1.0 
@return aRotina , Array contendo as op��es de menu
@example MenuDef()
/*/
//--------------------------------------------------
static function MenuDef()
local aRotina as array

aRotina := {}

Add Option aRotina Title 'Pesquisar'  Action 'PesqBrw'               Operation OP_PESQUISAR  Access 0
Add Option aRotina Title 'Visualizar' Action 'ViewDef.cadCalculo' Operation OP_VISUALIZAR Access 0
Add Option aRotina Title 'Incluir'    Action 'ViewDef.cadCalculo' Operation OP_INCLUIR    Access 0
Add Option aRotina Title 'Alterar'    Action 'ViewDef.cadCalculo' Operation OP_ALTERAR    Access 0
Add Option aRotina Title 'Excluir'    Action 'ViewDef.cadCalculo' Operation OP_EXCLUIR    Access 0
Add Option aRotina Title 'Imprimir'   Action 'ViewDef.cadCalculo' Operation OP_IMPRIMIR   Access 0
Add Option aRotina Title 'Copiar'     Action 'ViewDef.cadCalculo' Operation OP_COPIA      Access 0

return aRotina

//--------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do modelo de dados
@author danielbraga
@since 07/08/20
@version 1.0 
@return oModel, objeto do modelo de dados
@example ModelDef()
/*/
//--------------------------------------------------
static function ModelDef()
local oModel as object
local oStrctZ08 as object
local oStrctZ09 as object
local oStrctZ10 as object
local oStrctZ11 as object
local aTrgProd := prodTrg()
local aTrgMolde := moldeTrg()
local aTrgFuro  := furoTrg()
local aTrgVol  :=  volTrg()

oStrctZ08 := FwFormStruct( 1 , 'Z08' , /*bFiltro*/ )
oStrctZ09 := FwFormStruct( 1 , 'Z09' , /*bFiltro*/ )
oStrctZ10 := FwFormStruct( 1 , 'Z10' , /*bFiltro*/ )
oStrctZ11 := FwFormStruct( 1 , 'Z11' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcZ08' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oStrctZ08:AddTrigger( ;
      aTrgProd[1] , ;       // [01] Id do campo de origem
      aTrgProd[2] , ;       // [02] Id do campo de destino
      aTrgProd[3] , ;       // [03] Bloco de codigo de valida��o da execu��o do gatilho
      aTrgProd[4] ) 

oStrctZ09:AddTrigger( ;
      aTrgMolde[1] , ;       // [01] Id do campo de origem
      aTrgMolde[2] , ;       // [02] Id do campo de destino
      aTrgMolde[3] , ;       // [03] Bloco de codigo de valida��o da execu��o do gatilho
      aTrgMolde[4] ) 
oStrctZ09:AddTrigger( ;
      aTrgFuro[1] , ;       // [01] Id do campo de origem
      aTrgFuro[2] , ;       // [02] Id do campo de destino
      aTrgFuro[3] , ;       // [03] Bloco de codigo de valida��o da execu��o do gatilho
      aTrgFuro[4] ) 

oStrctZ09:AddTrigger( ;
      aTrgVol[1] , ;       // [01] Id do campo de origem
      aTrgVol[2] , ;       // [02] Id do campo de destino
      aTrgVol[3] , ;       // [03] Bloco de codigo de valida��o da execu��o do gatilho
      aTrgVol[4] ) 
oStrctZ08:SetProperty( "Z08_CODIGO" , MODEL_FIELD_INIT,{|| GetSxeNum("Z08","Z08_CODIGO")})

oModel:AddFields( 'M01Z08' , /*Owner*/ , oStrctZ08 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )
oModel:AddGrid( 'M02Z09' , 'M01Z08' , oStrctZ09 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M03Z10' , 'M02Z09' , oStrctZ10 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M04Z11' , 'M03Z10' , oStrctZ11 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 

if Empty( oModel:GetPrimaryKey() )
   oModel:SetPrimaryKey({}) //Criar a chave �nica da tabela
endif
oModel:SetRelation(  'M02Z09' , {{ 'Z09_FILIAL' , xFilial( 'Z09') } , { 'Z09_CODIGO' , 'Z08_CODIGO' } } , Z09->( IndexKey(1) ) )
oModel:SetRelation(  'M03Z10' , {{ 'Z10_FILIAL' , xFilial( 'Z10') } , { 'Z10_CODIGO' , 'Z09_CODIGO' } , { 'Z10_CODPRO' , 'Z09_CODPRO' } } , Z10->( IndexKey(1) ) )
oModel:SetRelation(  'M04Z11' , {{ 'Z11_FILIAL' , xFilial( 'Z11') } , { 'Z11_CODIGO' , 'Z10_CODIGO' } , { 'Z11_CODPRO' , 'Z10_CODPRO' } } , Z11->( IndexKey(1) ) )
oModel:GetModel( 'M02Z09' ):SetUniqueLine( { 'Z09_CODPRO' } )
oModel:GetModel( 'M03Z10' ):SetUniqueLine( { 'Z10_MOLDE' } )
oModel:GetModel( 'M04Z11' ):SetUniqueLine( { 'Z11_MOLDE' } )

return oModel

//--------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o da interface
@author danielbraga
@since 07/08/20
@version 1.0 
@return oView, objeto da interface
@example ViewDef()
/*/
//--------------------------------------------------
static function ViewDef()
local oModel as object
local oView as object
local oStrctZ08 as object
local oStrctZ09 as object
local oStrctZ10 as object
local oStrctZ11 as object

oModel    := FwLoadModel( 'cadCalculo' )
oView     := FwFormView():New() 
oStrctZ08 := FwFormStruct( 2 , 'Z08' , /*bFiltro*/ )
oStrctZ09 := FwFormStruct( 2 , 'Z09' , /*bFiltro*/ )
oStrctZ10 := FwFormStruct( 2 , 'Z10' , /*bFiltro*/ )
oStrctZ11 := FwFormStruct( 2 , 'Z11' , /*bFiltro*/ )


oStrctZ08:SetProperty( "Z08_PRODUT" , MVC_VIEW_LOOKUP,"SB1")
oStrctZ08:SetProperty( "Z08_CODIGO" , MVC_VIEW_CANCHANGE,.F.)
oStrctZ08:SetProperty( "Z08_DESCRI" , MVC_VIEW_CANCHANGE,.F.)


oStrctZ09:SetProperty( "Z09_MOLDE"  , MVC_VIEW_LOOKUP,"Z05")
oStrctZ09:SetProperty( "Z09_FURO"   , MVC_VIEW_LOOKUP ,"Z06")
oStrctZ09:SetProperty( "Z09_AREA"   , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_VOLUME" , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_PESO"   , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_ITEM"   , MVC_VIEW_CANCHANGE,.F.)


oStrctZ10:SetProperty( "Z10_CODMAT" , MVC_VIEW_LOOKUP ,"SB1")

oStrctZ11:SetProperty( "Z11_CODVOL" , MVC_VIEW_LOOKUP ,"Z07")

oView:SetModel( oModel )
oView:AddField( 'V01Z08' , oStrctZ08 , 'M01Z08' )
oView:AddGrid( 'V02Z09' , oStrctZ09 , 'M02Z09' )
oView:AddGrid( 'V03Z10' , oStrctZ10 , 'M03Z10' )
oView:AddGrid( 'V04Z11' , oStrctZ11 , 'M04Z11' )
oView:CreateHorizontalBox( 'VwZ08' , 25 )
oView:CreateHorizontalBox( 'VwZ09' , 25 )
oView:CreateHorizontalBox( 'VwZ10' , 25 )
oView:CreateHorizontalBox( 'VwZ11' , 25 )
oView:SetOwnerView( 'V01Z08' , 'VwZ08' )
oView:SetOwnerView( 'V02Z09' , 'VwZ09' )
oView:SetViewProperty( 'V02Z09' , 'ENABLEDGRIDDETAIL' , { 50 } )
oView:SetOwnerView( 'V03Z10' , 'VwZ10' )
oView:SetViewProperty( 'V03Z10' , 'ENABLEDGRIDDETAIL' , { 50 } )
oView:SetOwnerView( 'V04Z11' , 'VwZ11' )
oView:SetViewProperty( 'V04Z11' , 'ENABLEDGRIDDETAIL' , { 50 } )

oView:AddIncrementField("V02Z09", "Z09_ITEM")
return oView

static function prodTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z08_PRODUT" , "Z08_DESCRI" , "posicione('SB1',1,xFilial('SB1')+fwFldGet('Z08_PRODUT'),'B1_DESC' )", .F., "Z08" )

return aRet

static function moldeTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_MOLDE" , "Z09_AREA" , "u_areaCalc()", .F., "Z09" )
return aRet

static function furoTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_FURO" , "Z09_AREA" , "u_areaCalc()", .F., "Z09" )
return aRet

static function volTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_ESPESS" , "Z09_VOLUME" , "u_vbCalc()", .F., "Z09" )
return aRet

user function areaCalc()
   
   local nDiametro :=0
   local nFuro     := 0
   local cMolde     := fwFldGet("Z09_MOLDE")
   local cFuro     := fwFldGet("Z09_FURO")
   local nArea     := 0

   nDiametro :=  posicione("Z05",1,xFilial("Z05")+cMolde,"Z05_DIAMET"  )
   nFuro     :=  posicione("Z06",1,xFilial("Z06")+cFuro ,"Z06_FURO"  )

   nArea := u_area(nDiametro , nFuro)


return nArea

user function vbCalc()
   

   local nArea    := 9.0//fwFldGet("Z09_AREA")
   local nEspessura     := fwFldGet("Z09_ESPESS")
   local nVolBrut := 0



   nVolBrut := u_volBruto(nArea,nEspessura)


return nVolBrut
