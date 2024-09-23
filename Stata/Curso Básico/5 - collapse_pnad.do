********************************************************************************************************************************************************
*********************************************************  UMA APLICAÇÃO À PNAD ************************************************************************
*********************************						   IGOR VIEIRA PROCOPIO					********************************************************
********************************************************************************************************************************************************

* Utilizar o banco de dados da PNAD 2008 para esta seção
	


use "https://igorprocopio.github.io/Datasets/pnad_mod.dta", clear

* AGREGAR BANCO DE DADOS: construir um banco de dados agregados por Estado, com o total da *população, a população entre 18 e 65 anos (inclusive) 
* e sua média de anos de estudo, o percentual de brancos, o total de pessoas com rendimentos não nulos, o percentual de trabalhadores com mais de 10 anos de 
* estudo em relação ao total de trabalhadores, a renda média do trabalho e o percentual da população com renda familiar per capita inferior a R$ 100,00. 

	* Variável de total de população
	
		gen pop = 1
	
	* População entre 18 e 65 anos (inclusive)
		
		gen pop_18_65 =idade>=18 & idade <=65

	* Média de anos de estudo para as pessoas entre 18 e 65 anos (inclusive)
	
		replace educ = . if idade <18 | idade >65

	* Populaçao branca
		
		gen branco=raca==2 

	* Percentual de trabalhadores com mais de 10 anos de escolaridade em relação ao total de trabalhadores

		gen trab_10 =educ>10
		replace trab_10 = . if renda == .

	* Percentual da população com renda per capita inferior a R$ 100,00
	
		gen pobres=ren_fam<100

		collapse (mean) renda educ idade  branco trab_10 pobres (sum) pop pop_18_65 (count) trabalhador=renda [pw=peso], by(uf)

