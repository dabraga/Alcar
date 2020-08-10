#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} cadMolde
Cadastro do alias Z05
@author danielbraga
@since 07/08/20
@version 1.0 
@return Nil, função sem retorno
@example cadMolde()
/*/
//--------------------------------------------------
user function cadMolde()
local oBrowse as object

oBrowse := FWLoadBrw('cadMolde')
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
oBrowse:SetAlias('Z05')

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
Add Option aRotina Title 'Visualizar' Action 'ViewDef.cadMolde' Operation OP_VISUALIZAR Access 0
Add Option aRotina Title 'Incluir'    Action 'ViewDef.cadMolde' Operation OP_INCLUIR    Access 0
Add Option aRotina Title 'Alterar'    Action 'ViewDef.cadMolde' Operation OP_ALTERAR    Access 0
Add Option aRotina Title 'Excluir'    Action 'ViewDef.cadMolde' Operation OP_EXCLUIR    Access 0
Add Option aRotina Title 'Imprimir'   Action 'ViewDef.cadMolde' Operation OP_IMPRIMIR   Access 0
Add Option aRotina Title 'Copiar'     Action 'ViewDef.cadMolde' Operation OP_COPIA      Access 0

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
local oStrctZ05 as object

oStrctZ05 := FwFormStruct( 1 , 'Z05' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcZ05' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oStrctZ05:SetProperty( "Z05_CODIGO" , MODEL_FIELD_VALID,{|| EXISTCHAV("Z05",FWFldGet("Z05_CODIGO"),1 )})
oModel:AddFields( 'M01Z05' , /*Owner*/ , oStrctZ05 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )

if Empty( oModel:GetPrimaryKey() )
   oModel:SetPrimaryKey({}) //Criar a chave única da tabela
endif

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
local oStrctZ05 as object

oModel    := FwLoadModel( 'cadMolde' )
oView     := FwFormView():New() 
oStrctZ05 := FwFormStruct( 2 , 'Z05' , /*bFiltro*/ )

oView:SetModel( oModel )
oView:AddField( 'V01Z05' , oStrctZ05 , 'M01Z05' )
oView:CreateHorizontalBox( 'VwZ05' , 100 )
oView:SetOwnerView( 'V01Z05' , 'VwZ05' )

return oView
