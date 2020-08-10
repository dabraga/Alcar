#include 'protheus.ch'
#include 'fwmvcdef.ch'

//--------------------------------------------------
/*/{Protheus.doc} CadPecAux
Cadastro do alias Z07
@author danielbraga
@since 07/08/20
@version 1.0 
@return Nil, função sem retorno
@example CadPecAux()
/*/
//--------------------------------------------------
user function CadPecAux()
local oBrowse as object

oBrowse := FWLoadBrw('CadPecAux')
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
oBrowse:SetAlias('Z07')

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
Add Option aRotina Title 'Visualizar' Action 'ViewDef.CadPecAux' Operation OP_VISUALIZAR Access 0
Add Option aRotina Title 'Incluir'    Action 'ViewDef.CadPecAux' Operation OP_INCLUIR    Access 0
Add Option aRotina Title 'Alterar'    Action 'ViewDef.CadPecAux' Operation OP_ALTERAR    Access 0
Add Option aRotina Title 'Excluir'    Action 'ViewDef.CadPecAux' Operation OP_EXCLUIR    Access 0
Add Option aRotina Title 'Imprimir'   Action 'ViewDef.CadPecAux' Operation OP_IMPRIMIR   Access 0
Add Option aRotina Title 'Copiar'     Action 'ViewDef.CadPecAux' Operation OP_COPIA      Access 0

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
local oStrctZ07 as object
local aTrgDim := dimTrg()
local aTrgEsp := espTrg()

oStrctZ07 := FwFormStruct( 1 , 'Z07' , /*bFiltro*/ )
oModel    := MPFormModel():New( 'MdlMvcZ07' , /*bPre*/ , /*bPos*/, /*bCommit*/, /*bCancel*/ )

oStrctZ07:SetProperty( "Z07_CODIGO" , MODEL_FIELD_VALID,{|| EXISTCHAV("Z07",FWFldGet("Z07_CODIGO"),1 )})

oStrctZ07:AddTrigger( ;
      aTrgDim[1] , ;       // [01] Id do campo de origem
      aTrgDim[2] , ;       // [02] Id do campo de destino
      aTrgDim[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgDim[4] )       // [04] Bloco de codigo de execução do gatilho

oStrctZ07:AddTrigger( ;
      aTrgEsp[1] , ;       // [01] Id do campo de origem
      aTrgEsp[2] , ;       // [02] Id do campo de destino
      aTrgEsp[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgEsp[4] )       // [04] Bloco de codigo de execução do gatilho      
oModel:AddFields( 'M01Z07' , /*Owner*/ , oStrctZ07 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )

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
local oStrctZ07 as object

oModel    := FwLoadModel( 'CadPecAux' )
oView     := FwFormView():New() 
oStrctZ07 := FwFormStruct( 2 , 'Z07' , /*bFiltro*/ )

oView:SetModel( oModel )
oView:AddField( 'V01Z07' , oStrctZ07 , 'M01Z07' )
oView:CreateHorizontalBox( 'VwZ07' , 100 )
oView:SetOwnerView( 'V01Z07' , 'VwZ07' )

return oView

static function dimTrg()

   local aRet := {}
   aRet := FwStruTrigger("Z07_DIAMET" ,"Z07_VOLPES", "U_volume(fwFldGet('Z07_DIAMET'),fwFldGet('Z07_ESPESS'))" , .f., "Z07" )


return aRet

static function espTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z07_ESPESS" , "Z07_VOLPES" , "U_volume(fwFldGet('Z07_DIAMET'),fwFldGet('Z07_ESPESS'))", .F., "Z07" )

return aRet
