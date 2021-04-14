#include 'totvs.ch'

/*
@type function
@author Eduardo Cestari - Totvs Campinas
@since 12/03/2021
@version Protheus 12.1.25

Descrição: Este Ponto de Entrada MT103C7T permite redimensionar a tela de seleção 
de pedidos de compras por item <F6> para vínculo no documento de entrada.

PARAMIXB[1,1]	Numérico	Posição inicial da linha da janela	 
PARAMIXB[1,2]	Numérico	Posição inicial da coluna da janela	 
PARAMIXB[1,3]	Numérico	Posição final da linha da janela	 
PARAMIXB[1,4]	Numérico	Posição final da coluna da janela
Tamanho padrao: {30,20,270,531}
*/

User Function MT103C7T

Local aInfo := PARAMIXB

    aInfo := {30,20,486,1300}

Return aInfo
