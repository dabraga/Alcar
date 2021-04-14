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

Z08Trigger(@oStrctZ08)
Z09Trigger(@oStrctZ09)
Z10Trigger(@oStrctZ10)
Z11Trigger(@oStrctZ11)


oStrctZ08:SetProperty( "Z08_CODIGO" , MODEL_FIELD_INIT,{|| Z08CODInit() })
//oStrctZ08:SetProperty( "Z08_PRODUT" , MODEL_FIELD_VALID,{|| u_ValidField("Z08_PRODUT" ) })
//oStrctZ09:SetProperty( "Z09_MOLDE"  , MODEL_FIELD_VALID,{|| u_ValidField("Z09_MOLDE" ) })
oStrctZ09:SetProperty( "Z09_AREA"      , MODEL_FIELD_WHEN,{|| U_getCalcArea() })
//oStrctZ10:SetProperty( "Z10_CODMAT" , MODEL_FIELD_VALID,{|| u_ValidField("Z10_CODMAT" ) })
//oStrctZ11:SetProperty( "Z11_CODVOL" , MODEL_FIELD_VALID,{|| u_ValidField("Z11_CODVOL" ) })


oModel:AddFields( 'M01Z08' , /*Owner*/ , oStrctZ08 , /*bPre*/ , /*bPos*/ , /*bLoad*/ )
oModel:AddGrid( 'M02Z09' , 'M01Z08' , oStrctZ09 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M03Z10' , 'M02Z09' , oStrctZ10 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 
oModel:AddGrid( 'M04Z11' , 'M03Z10' , oStrctZ11 , /*bLinePre*/ , /*bLinePost*/ , /*bPre*/ , /*bLinePost*/ , /*bLoad*/ ) 

if Empty( oModel:GetPrimaryKey() )
   oModel:SetPrimaryKey({}) //Criar a chave única da tabela
endif
oModel:SetRelation(  'M02Z09' , {{ 'Z09_FILIAL' , 'xFilial( "Z09")' } , { 'Z09_CODIGO' , 'Z08_CODIGO' } , {'Z09_CODPRO'   ,'Z08_PRODUT' } } , Z09->( IndexKey(1) ) )
oModel:SetRelation(  'M03Z10' , {{ 'Z10_FILIAL' , 'xFilial( "Z10")' } , { 'Z10_CODIGO' , 'Z08_CODIGO' } , { 'Z10_CODPRO' , 'Z08_PRODUT' },{'Z10_MOLDE','Z09_MOLDE'} } , Z10->( IndexKey(1) ) )
oModel:SetRelation(  'M04Z11' , {{ 'Z11_FILIAL' , 'xFilial( "Z11")' } , { 'Z11_CODIGO' , 'Z08_CODIGO' } , { 'Z11_CODPRO' , 'Z08_PRODUT' },{'Z11_MOLDE','Z09_MOLDE'}} , Z11->( IndexKey(1) ) )
oModel:GetModel( 'M02Z09' ):SetUniqueLine( {  } )
oModel:GetModel( 'M03Z10' ):SetUniqueLine( { 'Z10_CODMAT' } )
oModel:GetModel( 'M03Z10' ):SetOptional( .T. )
oModel:GetModel( 'M04Z11' ):SetUniqueLine( { 'Z11_CODVOL' } )
oModel:GetModel( 'M04Z11' ):SetOptional( .T. )
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


oStrctZ08:SetProperty( "Z08_PRODUT" , MVC_VIEW_LOOKUP,"SB1")
oStrctZ08:SetProperty( "Z08_CODIGO" , MVC_VIEW_CANCHANGE,.F.)
oStrctZ08:SetProperty( "Z08_DESCRI" , MVC_VIEW_CANCHANGE,.T.)


oStrctZ09:SetProperty( "Z09_MOLDE"  , MVC_VIEW_LOOKUP,"Z05")
oStrctZ09:SetProperty( "Z09_FURO"   , MVC_VIEW_LOOKUP ,"Z06")
//oStrctZ09:SetProperty( "Z09_AREA"   , MVC_VIEW_CANCHANGE,.f. )
oStrctZ09:SetProperty( "Z09_VOLUME" , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_PESO"   , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_ITEM"   , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_PRENSA" , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_MISTUR"   , MVC_VIEW_CANCHANGE,.F.)
oStrctZ09:SetProperty( "Z09_TIPMIS"   , MVC_VIEW_CANCHANGE,.F.)


oStrctZ10:SetProperty( "Z10_CODMAT" , MVC_VIEW_LOOKUP ,"SB1")
oStrctZ10:SetProperty( "Z10_VOLPES"   , MVC_VIEW_CANCHANGE,.F.)

oStrctZ11:SetProperty( "Z11_CODVOL" , MVC_VIEW_LOOKUP ,"Z07")
oStrctZ11:SetProperty( "Z11_VOLPES"   , MVC_VIEW_CANCHANGE,.F.)

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
//oView:SetViewProperty( 'V02Z09' , 'ENABLEDGRIDDETAIL' , { 50 } )

oView:SetOwnerView( 'V03Z10' , 'VwZ10' )
//oView:SetViewProperty( 'V03Z10' , 'ENABLEDGRIDDETAIL' , { 50 } )
oView:SetOwnerView( 'V04Z11' , 'VwZ11' )
//oView:SetViewProperty( 'V04Z11' , 'ENABLEDGRIDDETAIL' , { 50 } )

oView:AddIncrementField("V02Z09", "Z09_ITEM")
oView:AddUserButton( 'Recalcular', 'CLIPS', {|oView| u_Z09ReCalc()}) 
return oView


static function Z08Trigger(oStruct)
   local aTrgProd := prodTrg()

   oStruct:AddTrigger( ;
      aTrgProd[1] , ;       // [01] Id do campo de origem
      aTrgProd[2] , ;       // [02] Id do campo de destino
      aTrgProd[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgProd[4] ) 

return

static function Z09Trigger(oStruct)
   local aTrgMolde := moldeTrg()
   local aTrgFuro  := furoTrg()
   local aTrgVol  :=  volTrg()
   local aTrgPeso := pesoTrg()
  
   
oStruct:AddTrigger( ;
      aTrgMolde[1] , ;       // [01] Id do campo de origem
      aTrgMolde[2] , ;       // [02] Id do campo de destino
      aTrgMolde[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgMolde[4] ) 
oStruct:AddTrigger( ;
      aTrgFuro[1] , ;       // [01] Id do campo de origem
      aTrgFuro[2] , ;       // [02] Id do campo de destino
      aTrgFuro[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgFuro[4] ) 

oStruct:AddTrigger( ;
      aTrgVol[1] , ;       // [01] Id do campo de origem
      aTrgVol[2] , ;       // [02] Id do campo de destino
      aTrgVol[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgVol[4] ) 
oStruct:AddTrigger( ;
      aTrgPeso[1] , ;       // [01] Id do campo de origem
      aTrgPeso[2] , ;       // [02] Id do campo de destino
      aTrgPeso[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgPeso[4] ) 

return

static function Z10Trigger(oStruct)
    local aTrgCodMat :=  matProdTrg()
    local aTrgDistMat := distMatTrg()
   oStruct:AddTrigger( ;
      aTrgCodMat[1] , ;       // [01] Id do campo de origem
      aTrgCodMat[2] , ;       // [02] Id do campo de destino
      aTrgCodMat[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgCodMat[4] ) 

   oStruct:AddTrigger( ;
      aTrgDistMat[1] , ;       // [01] Id do campo de origem
      aTrgDistMat[2] , ;       // [02] Id do campo de destino
      aTrgDistMat[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgDistMat[4] ) 
   
return


static function Z11Trigger(oStruct)
    local aTrgDistVol :=  distVolTrg()
   
   oStruct:AddTrigger( ;
      aTrgDistVol[1] , ;       // [01] Id do campo de origem
      aTrgDistVol[2] , ;       // [02] Id do campo de destino
      aTrgDistVol[3] , ;       // [03] Bloco de codigo de validação da execução do gatilho
      aTrgDistVol[4] ) 

   
   
return

static function prodTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z08_PRODUT" , "Z08_DESCRI" , "u_addLineZ09(fwFldGet('Z08_PRODUT')) ", .F., "Z08" )

return aRet

static function moldeTrg()
   local aRet := {}

   aRet :=  FwStruTrigger("Z09_MOLDE" , "Z09_AREA" , "iif(u_getCalcArea(),fwFldget('Z09_AREA') ,  u_areaCalc())", .F., "Z09" )
return aRet

static function furoTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_FURO" , "Z09_AREA" , "iif(u_getCalcArea(),fwFldget('Z09_AREA') ,  u_areaCalc())", .F., "Z09" )
return aRet

static function volTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_ESPESS" , "Z09_VOLUME" , "u_vbCalc()", .F., "Z09" )
return aRet

static function pesoTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z09_DENSID" , "Z09_PESO" , "u_pbCalc()", .F., "Z09" )
return aRet

static function matProdTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z10_CODMAT" , "Z10_VALOR" , "u_gatB1PSVL()", .F., "Z10" )
return aRet

static function distMatTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z10_DISTRI" , "Z10_VOLPES" , "u_z10CalcLine()", .F., "Z10" )
   
return aRet

static function distVolTrg()
   local aRet := {}
   aRet :=  FwStruTrigger("Z11_DISTRI" , "Z11_VOLPES" , "u_z11CalcLine()", .F., "Z11" )
   
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
   

   local nArea    := fwFldGet("Z09_AREA")
   local nEspessura   := fwFldGet("Z09_ESPESS")
   local nVolBrut := 0



   nVolBrut := u_volBruto(nArea,nEspessura)


return nVolBrut

user function pbCalc()
   

   local nVolume        := fwFldGet("Z09_VOLUME")
   local nDensidade   := fwFldGet("Z09_DENSID")
   local nPesoBrut := 0



   nPesoBrut := u_pesoBruto(nVolume,nDensidade)


return nPesoBrut

static function Z08CODInit()
   local cCodigo := "" 
   cCodigo :=  GetSxeNum("Z08","Z08_CODIGO")
   ConfirmSX8()
return cCodigo


user function ValidField(cField )
   local cValue := ""
   if cField == "Z09_MOLDE"
         cValue :=  posicione("Z05",1,xFilial("Z05")+fwFldGet("Z09_MOLDE"),"Z05_CODIGO")
   endIf    
   if cField == "Z09_FURO"
         cValue :=  posicione("Z06",1,xFilial("Z06")+fwFldGet("Z09_FURO"),"Z06_CODIGO")
   endIf
   if cField == "Z11_CODVOL"
         cValue :=  posicione("Z07",1,xFilial("Z07")+fwFldGet("Z11_CODVOL"),"Z07_CODIGO")
   endIf
   if cField == "Z08_PRODUT"
         cValue :=  posicione("SB1",1,xFilial("SB1")+fwFldGet("Z08_PRODUT"),"B1_COD")
   endIf
   if cField == "Z10_CODMAT"
         cValue :=  posicione("SB1",1,xFilial("SB1")+fwFldGet("Z10_CODMAT"),"B1_COD")
   endIf
   if empty(cValue)
       //Help( ,, 'Help',, 'Registro nao encontrado.', 1, 0 )
      return .f.
   endIf

return .t.

user function getCalcArea(cProduto)

      default cProduto := fwFldGet("Z08_PRODUT")
       dbSelectArea("SB1") 
      SB1->(dbSetOrder(1))
      if !empty(cProduto)
         if SB1->(dbSeek(xFilial("SB1")+cProduto))
               if SB1->(FieldPos("B1_ZZCALVL")) > 0
                  if !Empty(SB1->B1_ZZCALVL )
                     return iif( SB1->B1_ZZCALVL != "1",.t.,.f. )
                  else 
                     return .f.
                  endIf   
               else
                  return .F.
               endIF
         endIf
      endIf
return .F.

user function addLineZ09(cProduto)

   local oModel := FWModelActive()
   local oMdZ09 := oModel:getModel("M02Z09")
   local aLine :={}
   local aCols := {}
   local nX    := 0

   dbSelectArea("SB5")
   SB5->(dbSetOrder(1))
   if SB5->(dbSeek(xFilial("SB5")+cProduto))
      if !Empty(SB5->B5_ZZMIST1) 
         aadd(aCols,{SB5->B5_ZZPRENS,SB5->B5_ZZMIST1,SB5->B5_ZZTPMI1})
      endIf
      if !Empty(SB5->B5_ZZMIST2)
         aadd(aCols,{SB5->B5_ZZPRENS,SB5->B5_ZZMIST2,SB5->B5_ZZTPMI2})
      endIf 
      if !Empty(SB5->B5_ZZMIST3) 
         aadd(aCols,{SB5->B5_ZZPRENS,SB5->B5_ZZMIST3,SB5->B5_ZZTPMI3})
      endIf
      if !Empty(SB5->B5_ZZMIST4) 
         aadd(aCols,{SB5->B5_ZZPRENS,SB5->B5_ZZMIST4,SB5->B5_ZZTPMI4})
      endIf
   endIf

    for nX:= 1 to len(aCols)
           oMdZ09:AddLine()
           oMdZ09:GoLine( nx )
           oMdZ09:SetValue('Z09_PRENSA', aCols[nx][1] )
           oMdZ09:SetValue('Z09_MISTUR', aCols[nx][2] )
           oMdZ09:SetValue('Z09_TIPMIS', aCols[nx][3] )
   next nX


return posicione('SB1',1,xFilial('SB1')+cProduto,'B1_DESC' )
