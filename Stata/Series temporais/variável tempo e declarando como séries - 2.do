*** para gerar matriz x'x
gene const = 1
mkmat const x m, matrix(X)
matrix B = (X'*X)
matrix list B
matrix C = inv(X'*X)
matrix list C

*** o modelo
reg y x m

******** monitoria 23/10 ******************
reg pib fbkf pop_atv

******** multicolineariedade **************
estat vif

******** autocorrelação *******************

/// para declarar série ///
gen time = q(2002q2)+_n-1
tsset time, quarterly

estat bgodfrey

**** nota: para outros *****
/// Variável de tempo anual: gen time = y(1980)+_n-1
/// Variável de tempo mensal: gen time = m(1980m1)+_n-1
/// Variável de tempo trimestral: gen time = q(1980q1)+_n-1
/// tsset time, quarterly
/// tsset time, yearly
/// tsset time, mountly

******** heterocedasticidade **************
imtest, white
