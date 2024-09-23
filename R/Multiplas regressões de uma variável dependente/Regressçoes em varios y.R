set.seed(1)

# number of columns in the Lung and Blood data.frames. 22,000 for you?
n <- 5 

# dummy data
obs <- 50 # observations
Lung <- data.frame(matrix(rnorm(obs*n), ncol=n))
Blood <- data.frame(matrix(rnorm(obs*n), ncol=n))
Age <- sample(20:80, obs)
Gender  <- factor(rbinom(obs, 1, .5))

# run n regressions
my_lms <- lapply(1:n, function(x) lm(Lung[,x] ~ Blood[,x] + Age + Gender))

# extract just coefficients
sapply(my_lms, coef)

# if you need more info, get full summary call. now you can get whatever, like:
summaries <- lapply(my_lms, summary)
# ...coefficents with p values:
lapply(summaries, function(x) x$coefficients[, c(1,4)])
# ...or r-squared values
sapply(summaries, function(x) c(r_sq = x$r.squared, 
                                adj_r_sq = x$adj.r.squared))


