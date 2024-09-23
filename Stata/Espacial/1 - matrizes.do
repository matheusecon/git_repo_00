/********************************************************************************

							Matrizes espaciais

********************************************************************************/


 /*Nesta seção vamos apresentar como construir matrizes de ponderação espacial utilizando o comando spmatrix.
 Para isso, vamos utilizar o banco de dados criado anteriormente, que contém algumas informações para os estados bem como um shapefile
  associado.
 */
 
use pnad_espacial, clear

 
/*Primeiramente iremos contruir as matrizes de contiguidade          
O comando básico é: spmatrix create contiguity nome_matriz.
*/

** Rainha
spmatrix create contiguity Wc, replace
spmatrix summarize Wc

spmatrix create contiguity Wc, replace normalize(row)
spmatrix summarize Wc

spmatrix create contiguity Wc, replace normalize(none)
spmatrix summarize Wc

**** Comando que transforma a matriz em uma matriz em Mata
**** 

spmatrix matafromsp W id = Wc
mata: W



** Rook (Torre)

spmatrix create contiguity Wc, replace rook normalize(row)



** Ordem superior

spmatrix create contiguity Wc, second() replace


spmatrix create contiguity Wc, first second() replace

** É possível definir o peso da contiguidade de segunda ordem 



spmatrix create contiguity Wc, first second(0.5) replace


***** Criar variável vizinhos

spmatrix create contiguity Wc, replace normalize(row)

spmatrix summarize Wc
spmatrix summarize Wc, gen(neighbor)

grmap, label(label(neighbor) x(_CX) y(_CY))



spmatrix normalize Wc, normalize(row)









*********************       Distância geográfica       *************************


spmatrix create idistance Wi, replace
spmatrix matafromsp W id = Wi
mata: W






*********   Distância geográfica e contiguidade      *************************



spmatrix create idistance Wi, normalize(none) replace
spmatrix create contiguity Wc, normalize(none) replace

spmatrix matafromsp I v = Wi
spmatrix matafromsp C v = Wc


mata: IC = I :* C


spmatrix spfrommata Wci = IC v // 

mata: mata drop IC I C

spmatrix matafromsp W id = Wci
mata: W




********************************************************************************

spmatrix save Wci using wci, replace
spmatrix drop Wci
spmatrix dir
spmatrix use Wci using wci

spmatrix dir



********************************************************************************
********************************************************************************
*								Pacote spmat								   *
********************************************************************************





use uf, clear


*** matriz torre - equivalente ao comando: spmatrix create contiguity Wc, replace rook normalize(row)



spmat contiguity rook using uf_shp, id(_ID) rook replace normalize(row)
spmat summarize rook

spmat contiguity queen using uf_shp, id(_ID) replace normalize(row)


spmat idistance idistance _CX _CY , id(_ID) replace normalize(row)


spmat idistance idistance _CX _CY , id(_ID) replace normalize(row) knn(2)

*************************************************************************
************    Importar do Geoda 

spmat import W using idist.gwt, geoda replace

spmat import W using queen.gal, geoda replace




********************************************************************************
********************************************************************************
*					CONVERTER MATRIZES ENTRE PACOTES						   *
********************************************************************************



** spmarix para spmat

spmatrix create contiguity Wc, replace
spmatrix matafromsp W id = Wc

spmat putmatrix wspmat W, id(id)
spmat summarize wspmat


** spmat para spmatrix

spmat contiguity rook using uf_shp, id(_ID) rook replace normalize(row)
spmat getmatrix rook m, id(id) // exportar para mata
spmatrix spfrommata W = m id, replace
spmatrix summarize W




