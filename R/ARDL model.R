# ARDL model

library(ARDL)
data(denmark)

models <- auto_ardl(LRM ~ LRY + IBO + IDE, data = denmark, max_order = 5)

models$top_orders

# The best model was found to be the ARDL(3,1,3,2)
ardl_3132 <- models$best_model
ardl_3132$order

summary(ardl_3132)

# Then we can estimate the UECM (Unrestricted Error Correction Model) of the underlying ARDL(3,1,3,2)
uecm_3132 <- uecm(ardl_3132)
summary(uecm_3132)

# And also the RECM (Restricted Error Correction Model) of the underlying ARDL(3,1,3,2), allowing the 
# constant to join the short-run relationship (case 2).
srecm_3132 <- recm(uecm_3132, case = 2)
summary(srecm_3132)

# And also the RECM (Restricted Error Correction Model) of the underlying ARDL(3,1,3,2), allowing the 
# constant to join the long-run relationship (case 3).
lrecm_3132 <- recm(uecm_3132, case = 3)
summary(lrecm_3132)

# The bounds F-test (under the case 2) rejects the NULL hypothesis (let's say, assuming alpha = 0.01) with p-value = 0.004418.
bounds_f_test(ardl_3132, case = 2)

# The bounds t-test (under the case 3) rejects the NULL hypothesis (let's say, assuming alpha = 0.01) with p-value = 0.005538.
# We also provide the critical value bounds for alpha = 0.01.
tbounds <- bounds_t_test(uecm_3132, case = 3, alpha = 0.01)
tbounds

# Here is a more clear view of the main results.
tbounds$tab

# Here we have the short-run and the long-run multipliers (with standard errors, t-statistics and p-values).
multipliers(ardl_3132, type = "sr")

multipliers(ardl_3132)

summary(uecm)
