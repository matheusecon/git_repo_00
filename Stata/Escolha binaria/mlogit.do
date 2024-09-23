*regressão
. mlogit auto renda moradores if renda>=800 & renda<=20000 [aweight=peso], b(3)
. mlogit auto renda moradores if renda>=800 & renda<=20000 [aweight=peso], b(3) rrr
. mfx, predict (outcome(0))
. mfx, predict (outcome(1))
. mfx, predict (outcome(2))
. mfx, predict (outcome(3))
. mfx, predict (outcome(0)) at (renda=8000 moradores=3)
. mfx, predict (outcome(1)) at (renda=8000 moradores=3)
. mfx, predict (outcome(2)) at (renda=8000 moradores=3)
. mfx, predict (outcome(3)) at (renda=8000 moradores=3)
