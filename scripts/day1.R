library(Rlab)

x <- rbern(10, p=0.5)
y <- rbern(10, p=0.3)
x
hist(y)

a <- rbinom(1000000000, size = 10, prob = 0.7)
hist(a)

rbern(20, p = 0.3)
10000000*0.0000001
?rpois
# Poisson distribution
pois=rpois(100, lambda=4)
pois
hist(pois)
?rbinom
lambda <- 3/1000

a <- rbinom(1000, 1000, lambda)
hist(a)

# Exponential distribution
rexp(1, rate = 4)
waits <- rexp(1000, rate = 4)
timetofish <- cumsum(waits)
timetofish[1:10]

max(timetofish)
whichhour <- cut(timetofish, seq(0,245,1))


rexp(3, rate = 4)
?rexp
dexp(1, rate = 4)
curve(dexp(x, rate = 4, from = 0, to = 5))

PhDt <- replicate(500,sum(rexp(3, rate = 0.5)))
hist(PhDt, breaks = 30)


# Gamma distribution
PhDt2 <- rgamma(10, shape = 3, rate = 4)

# Beta distribution
rbeta(10, shape1 = 2, shape2 = 0.1)

mu <- 0.6
theta <- 20
curve(dbeta(x, shape1 = mu*theta, shape2 = (1-mu)*theta))


# Bayesian basics ---------------------------------------------------------

