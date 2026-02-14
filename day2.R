mean(runif(100, min = 100, max = 200))

approxnorm <- rep(0, 1000)
for (i in 1:1000) {
  approxnorm[i] <- mean(runif(100, min = 100, max = 200))
}
hist(approxnorm)


approxnormpoisum <- rep(0, 1000)
for (i in 1:1000) {
  approxnormpois[i] <- mean(rpois(100, lambda = 5))
}
hist(approxnormpois)

library(Rlab)
approxnormpoiprod <- rep(0, 1000)
for (i in 1:1000) {
  approxnormpoiprod[i] <- prod(rbern(100, p = 0.5))
}
hist(approxnormpoiprod, breaks = 30)

approxnormpoilnorm <- rep(0, 1000)
for (i in 1:1000) {
  approxnormpoilnorm[i] <- rlnorm(rbern(100, p = 0.5))
}
hist(approxnormpoilnorm, breaks = 30)
mean(approxnormpoilnorm)

approxnormpoiprod <- rep(0, 1000)
for (i in 1:1000) {
  approxnormpoiprod[i] <- prod(rbern(100, p = 0.5))
}
hist(approxnormpoiprod, breaks = 30)


lnorm <- rlnorm(100, )


# Stupidest sampler ever ----------------------------------------------------------


# a <- -150
# b <- 150/17
# sigma <- 10
# t <- c(-15, -5, 3, 0, 9, 10, 23, 25, 10, 16, 5, -2, 30, 16)
# alt + click
# ctr + shift + P


profit <- rnorm(n = length(t), mean = a + b * t, sd = sigma)
profit
plot(t, profit)

n <- 1000000
a <- rnorm(n, 0, 100)
b <- rnorm(n, 5, 50)
sigma <- rexp(n, rate = 0.03)
H <- data.frame(a, b, sigma)



H$lik <- sapply(1:n, function(i) {
  prod(dnorm(profit, mean = H$a[i] + H$b[i] * t, sd = H$sigma[i]))
})
H
post.is <- sample(1:n, size = 1000, replace = T, prob = H$lik)
post <- H[post.is, ]
plot(density(post$a))
summary(post$a)

plot(density(post$b))
summary(post$b)

plot(density(post$sigma))
summary(post$sigma)

# Simple models -----------------------------------------------------------
library(rethinking)
heightboys <- rnorm(10, 160, 10)
heightgirls <- rnorm(10, 140, 10)

t.test(heightboys, heightgirls, var.equal = F)

ttestmodel <- alist(
  #likelihood
  heightgirls~dnorm(mugirls, sigma),
  heightboys~dnorm(muboys, sigma),
  #priors
  mugirls~dunif(100,200),
  muboys~dunif(100,200),
  sigma~dunif(0,1000)
)
ttestposterior <- ulam(ttestmodel,
                       data <- list(heightgirls=heightgirls, heightboys=heightboys))
precis(ttestposterior)
plot(ttestposterior)


es <- extract.samples(ttestposterior)
gp <- es$muboys
hist(gp)


heightghv <- rnorm(10,140,20)
heightbhv <- rnorm(10, 160, 5)

t <- t.test(heightbhv, heightghv, var.equal = F)

library(flexplot)
visualize(t, plot = "model")

library(flexplot)

height <- c(heightbhv, heightghv)
group  <- factor(c(rep("bhv", length(heightbhv)),
                   rep("ghv", length(heightghv))))

df <- data.frame(height, group)
flexplot(height ~ group, data = df)
t <- t.test(heightbhv, heightghv, var.equal = FALSE)
t$p.value

boxplot(c(heightbhv, heightghv) ~ c(rep(0,10), rep(1,10)))

ttestmodel <- alist(
  #likelihood
  heightghv~dnorm(mugirls, sigma),
  heightbhv~dnorm(muboys, sigma),
  #priors
  mugirls~dunif(100,200),
  muboys~dunif(100,200),
  sigma~dunif(0,1000)
)
ttestposterior <- ulam(ttestmodel,
                       data = list(heightghv=heightghv,
                                   heightbhv=heightbhv))
precis(ttestposterior)
boxplot(c(heightbhv, heightghv) ~ c(rep(0,10), rep(1,10)))



# Linear regression -------------------------------------------------------

#generating data
datareg <- data.frame(x=seq(0,10, by=1))
alpha <- 10
beta <- 2
sigma <- 3
datareg$y=rnorm(11, alpha+beta*datareg$x,sigma)
plot(datareg$y~datareg$x)
abline(lm(datareg$y~datareg$x), col = "red", lwd = 2)
m <- lm(datareg$y~datareg$x)


regresmodel <- alist(
  #likelihood
  y~dnorm(yexp, sigma),
  yexp <-  alpha+beta*x,
  #priors
  alpha~dnorm(0,100),
  beta~dnorm(0,100),
  sigma~dunif(0,100)
  
)
regres_data <- list(x=datareg$x, y=datareg$y)
regresposterior <- ulam(regresmodel, data = regres_data)
precis(regresposterior)
traceplot(regresposterior)

regres_data <- list(x=datareg$x, y=datareg$y)
regresposterior2 <- ulam(regresmodel, data = regres_data,
                         chains = 3, cores = 3)
precis(regresposterior2)
traceplot(regresposterior2)


yexpregression2 <- link(regresposterior2)
dim(yexpregression2)

# Excercise


ttestmodel <- alist(
  #likelihood
  heightgirls~dnorm(mugirls, sigma),
  heightboys~dnorm(muboys, sigma),
  #priors
  mugirls~dunif(100,200),
  muboys~dunif(100,200),
  sigma~dunif(0,1000)
)
ttestposterior <- ulam(ttestmodel,
                       data <- list(heightgirls=heightgirls, heightboys=heightboys))
precis(ttestposterior)


# Excercise

heightboys <- rnorm(10, 160, 10)
heightgirls <- rnorm(10, 140, 10)

bg <- c(heightboys, heightgirls)

regres_data <- list(x=rep(c(0,1), each = 10), y= bg)
regresposterior <- ulam(regresmodel, data = regres_data)
precis(regresposterior)
traceplot(regresposterior)

