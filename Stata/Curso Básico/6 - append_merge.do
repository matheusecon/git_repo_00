****************************************************************************************************************************************************
*****************                 APOSTILA DO MINICURSO MICRODADOS COM O USO DO STATA                   ********************************************
************************                ECONS - FACULDADE DE ECONOMIA UFJF                              ********************************************
************************					  IGOR VIEIRA PROCÓPIO										********************************************
****************************************************************************************************************************************************


** Definir Diretório de Trabalho
use "https://igorprocopio.github.io/Datasets/Append-merge"


**********************************************************************************************************************************************8
***********************                        SEÇÃO 7 - COMBINAR DIVERSOS BANCOS DE DADOS                               ********************* 

use "https://igorprocopio.github.io/Datasets/Append-merge/banco3.dta", clear

append using "https://igorprocopio.github.io/Datasets/Append-merge/banco2.dta"

sort id
* Neste exemplo, vamos unir dois bancos de dados novamente, mas agora com um dos bancos 
*contendo três variáveis a menos. Para visualizar este procedimento, impute o banco de dados conforme 
*programação  abaixo e depois realize o append com o banco de dados “banco2”. 

use "https://igorprocopio.github.io/Datasets/Append-merge/banco4.dta", clear

append using "https://igorprocopio.github.io/Datasets/Append-merge/banco2.dta"



* Para ilustrar o comando merge na opção one-to-one vamos imputar o banco de dados abaixo e
 *realizar o merge com o banco de dados “banco2”. 
* Neste caso faremos um merge com correspondência um para *um,  cuja variável de ligação é a id (identificadora do indivíduo):

use "https://igorprocopio.github.io/Datasets/Append-merge/banco5.dta", clear

merge 1:1 id using  "https://igorprocopio.github.io/Datasets/Append-merge/banco2.dta"

* Neste exemplo iremos acrescentar variáveis referentes a Estados ao “banco2” que tem as 
* informações individuais.
* Neste caso a variável de ligação será a var1, que contém a sigla do Estado.
* Este vai ser um caso de várias observações de uma variável de ligação para uma. Vamos imputar o banco de 
* dados abaixo e depois fazer o merge com o “banco2”. 
* Como o banco de dados de Estado que estará aberto no Stata, a opção one-to-many será utilizada.

use "https://igorprocopio.github.io/Datasets/Append-merge/banco6.dta", clear

merge 1:m  var1 using  "https://igorprocopio.github.io/Datasets/Append-merge/banco2.dta"





