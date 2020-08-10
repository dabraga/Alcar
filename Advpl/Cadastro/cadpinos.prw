#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} CadPinos
Cadastro do alias Z06
@author danielbraga
@since 07/08/20
@version 1.0 
@return Nil, função sem retorno
@example CadPinos()
/*/
//--------------------------------------------------
user function CadPinos()
local oBrowse as object

oBrowse := FWLoadBrw('CadPinos')
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
oBrowse:SetAlias('Z06')

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
Add Option aRotina Title 'Visualizar' Action 'ViewDef.CadPinos' Operation OP_VISUALIZAR Access 0
Add Option aRotina Title 'Incluir'    Action 'ViewDef.CadPinos' Operation OP_INCLUIR    Access 0
Add Option aRotina Title 'Alterar'    Action 'ViewDef.CadPinos' Operation OP_ALTERAR    Access 0
Add Option aRotina Title 'Excluir'    Action 'ViewDef.CadPinos' Operation OP_EXCLUIR    Access 0
Add Option aRotina Title 'Imprimir'   Action 'ViewDef.CadPinos' Operation OP_IMPRIMIR   Access 0
Add Option aRotina Title 'Copiar'     Action 'ViewDef.CadPinos' Operation OP_COPIA      Access 0

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
local oStrctZ06 as object

oStrctZ06 := FwFormStruct( 1 , 'Z06' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcZ06' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oStrctZ06:SetProperty( "Z06_CODIGO" , MODEL_FIELD_VALID,{|| EXISTCHAV("Z06",FWFldGet("Z06_CODIGO"),1 )})
oModel:AddFields( 'M01Z06' , /*Owner*/ , oStrctZ06 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )

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
local oStrctZ06 as object

oModel    := FwLoadModel( 'CadPinos' )
oView     := FwFormView():New() 
oStrctZ06 := FwFormStruct( 2 , 'Z06' , /*bFiltro*/ )

oView:SetModel( oModel )
oView:AddField( 'V01Z06' , oStrctZ06 , 'M01Z06' )
oView:CreateHorizontalBox( 'VwZ06' , 100 )
oView:SetOwnerView( 'V01Z06' , 'VwZ06' )

return oView
