#include 'protheus.ch'

/*/{Protheus.doc} TModel
(long_description)
@author    danielbraga
@since     10/07/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class TMolde 
	data codigo
	data descricao
	data diametroInterno
	data diametroExterno
	data espessuraPrensa
	data area 
	method Molde() constructor 
	
	method setCodigo(xValue)
	method getCodigo()
	
	method setDescricao(xValue)
	method getDescricao() 

	method setInternoDiametro(xValue)
	method getInternoDiametro() 

	method setExternoDiametro(xValue)
	method getExternoDiametro() 

	method setEspessuraPrensa(xValue)
	method getEspessuraPrensa() 

	method setArea(xValue)
	method getArea() 
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
method Molde() class TMolde
	self:codigo		:= "" 
	self:descricao  := "" 
	self:diametroInterno := 0
	self:diametroExterno := 0
	self:espessuraPrensa := 0
	self:area := 0
return

method setCodigo(xValue) class TMolde
	self:codigo := xValue
return

method getCodigo() class TMolde
return self:codigo
	
method setDescricao(xValue) class TMolde
	self:descricao := xValue
return
method getDescricao() Class TMolde
return self:descricao

method setInternoDiametro(xValue)  Class TMolde
	self:diametroInterno := xValue
return

method getInternoDiametro()  Class TMolde
return self:diametroInterno

method setExternoDiametro(xValue)  Class TMolde
	self:diametroExterno := xValue
return

method getExternoDiametro()  Class TMolde
return self:diametroExterno

method setEspessuraPrensa(xValue)  Class TMolde
	self:espessuraPrensa := xValue
return

method getEspessuraPrensa()  Class TMolde
return self:espessuraPrensa

method setArea(xValue)  Class TMolde
	self:area := xValue
return

method getArea()   Class TMolde
return self:area 

