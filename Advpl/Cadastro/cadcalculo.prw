#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} cadCalculo
Cadastro do alias Z08
@author danielbraga
@since 07/08/20
@version 1.0 
@return Nil, função sem retorno
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
Definições do browse
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
Definição das opções de menu
@author danielbraga
@since 07/08/20
@version 1.0 
@return aRotina , Array contendo as opções de menu
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
Definição do modelo de dados
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

oStrctZ08 := FwFormStruct( 1 , 'Z08' , /*bFiltro*/ )
oStrctZ09 := FwFormStruct( 1 , 'Z09' , /*bFiltro*/ )
oStrctZ10 := FwFormStruct( 1 , 'Z10' , /*bFiltro*/ )
oStrctZ11 := FwFormStruct( 1 , 'Z11' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcZ08' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oModel:AddFields( 'M01Z08' , /*Owner*/ , oStrctZ08 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )
oModel:AddGrid( 'M02Z09' , 'M01Z08' , oStrctZ09 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M03Z10' , 'M02Z09' , oStrctZ10 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M04Z11' , 'M03Z10' , oStrctZ11 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 

if Empty( oModel:GetPrimaryKey() )
   oModel:SetPrimaryKey({}) //Criar a chave única da tabela
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
Definição da interface
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

return oView
