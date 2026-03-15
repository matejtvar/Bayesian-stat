# Implementing Newbury's (bioRxiv, 2025) approach to fully model logOR in a Bayesian framework.
# Custom STAN code for Fisher's noncentral hypergeometric distribution to use as a likelihood (by Gemini AI). Implementation with brms.
# As checks: lm on logOR and optimization of Fisher's NCHg in R.
# V. Remes, started 17.2.2026


# Define fisher hg likelihood in Stan -----
# Custom Stan code to define the Fisher likelihood
stan_fisher <- stanvar(
  scode = "
  real fisher_hyper_lpmf(int k, real mu, int m1, int m2, int N) {
    if (mu <= 0) return not_a_number();
    
    // Bounds for hypergeometric distribution
    int lower = max({0, m1 + m2 - N});
    int upper = min({m1, m2});
    
    // Log-numerator for the observed value k
    real log_num = lchoose(m1, k) + lchoose(N - m1, m2 - k) + k * log(mu);
    
    // Normalization constant calculation
    int range_size = upper - lower + 1;
    vector[range_size] terms;
    
    for (i in 0:(range_size - 1)) {
      int curr_i = lower + i;
      terms[i + 1] = lchoose(m1, curr_i) + lchoose(N - m1, m2 - curr_i) + curr_i * log(mu);
    }
    
    return log_num - log_sum_exp(terms);
  }
  ",
  block = "functions",
  name = "fisher_hyper_lpmf"
)


# Define custom family for brms -----
fisher_hyper <- custom_family(
  "fisher_hyper", 
  dpars = "mu",    # mu represents 'alpha' (affinity)
  links = "log",   # models log(alpha)
  type = "int",   # response variable 'k' is an integer
  # We name these to match what we will use in the formula
  vars = c("vint1[n]", "vint2[n]", "vint3[n]") 
)


# Prepare data -----
# from our Ecography paper = Australian ABC data
#load("/Users/vladimirremes/Documents/clanky_a_projekty/GACR_sympatry/PROJEKT_cooccurrenceAu/cooccurrence_MS_R1.RData")
#rm(list = setdiff(ls(), "d_age_mask"))
load("/Users/vladimirremes/Downloads/*R experiments/FisherHyper_cooccur/FisherHyper.RData")

require(tidyverse)
my_data <- d_age_mask %>%
  select(obs_cooccur, sp1_inc, sp2_inc, no_sites, overlap) %>%
  rename(k = obs_cooccur, m1 = sp1_inc, m2 = sp2_inc, N = no_sites, sympatry = overlap)
  
my_data$k  <- as.integer(my_data$k)
my_data$m1 <- as.integer(my_data$m1)
my_data$m2 <- as.integer(my_data$m2)
my_data$N  <- as.integer(my_data$N)
my_data$zSympatry <- as.numeric( scale(d_age_mask$overlap) )

# sanity checks:
sum( my_data$k >= my_data$m1+my_data$m2-my_data$N )
sum( my_data$k <= my_data$m1 )
sum( my_data$k <= my_data$m2 )
sum( my_data$N > 0 )


# Fit the model in brms -----
require(brms)

# k is my response var. (number of co-occurrences)
# m1 - number of sites with sp1, m2 - number of sites with sp2, N - total number of sites
?brm
brm.fit <- brm(
  formula = k | vint(m1, m2, N) ~ zSympatry, 
  data = my_data,
  family = fisher_hyper, 
  stanvars = stan_fisher,
  prior = c(
    prior(normal(0, 3), class = "b"),   # Prior for predictor
    prior(normal(0, 3), class = "Intercept")   # Prior for the Intercept
  ),
  init = 0,   # Initializes all parameters (including Intercept) at 0
  chains = 4, 
  iter = 3000,
  warmup = 2000,
  cores = 4 
)

plot(brm.fit)
summary(brm.fit)
fixef(brm.fit)
#pp_check(brm.fit)  # does not work, but I have been warned by AI...needs adjustments to code to work, the same for loo etc.

# Explore prior sensitivity.
new_priors <- c(
  set_prior("normal(0, 30)", class = "b"),
  set_prior("normal(0, 30)", class = "Intercept")
)
brm.fit_new <- update(brm.fit, prior = new_priors)
plot(brm.fit_new)
summary(brm.fit_new)
fixef(brm.fit_new)



# The Prior: normal(0, 3) is a sensible "weakly informative" prior. Since it's on the log scale, a value of 3 is quite large (equivalent to an odds ratio of e^3 = 20), so it allows the data to speak while preventing the model from wandering into biologically impossible territory.

# Before you run the brm model:
# 1) Ensure your data satisfies these physical bounds for every row:k >= (m1 + m2 - N), k <= m1, and k <= m2 (see my sanity checks above). If your observed k falls outside those bounds (which can only happen if there's a typo in the data entry), the lchoose functions in the Stan code will return NaN, and the model will fail to initialize.
# 2) Scale the predictors
# 3) Check for zeros: Ensure N > 0. If N=0 in any row, the math for the hypergeometric distribution breaks.


# Calculate logOR ----
# Using both fisher.test{stats} and affinity2x2{CooccurrenceAffinity}
# fisher.test
# Create cells of the contingency table
my_data$a <- my_data$k
my_data$b <- my_data$m1-my_data$k
my_data$c <- my_data$m2-my_data$k
my_data$d <- my_data$N-my_data$m1-my_data$m2+my_data$k

my_data$OddsRatio <- apply( X = my_data, MARGIN = 1, function(x) fisher.test(matrix(data = x[7:10], nrow = 2, ncol = 2, byrow = TRUE))$estimate )
my_data$logOR <- log(my_data$OddsRatio)

# CooccurrenceAffinity
require(CooccurrenceAffinity)
my_data.matrix <- as.matrix(my_data)
res <- as.data.frame(
  do.call(rbind,
          lapply(seq_len(nrow(my_data.matrix)), function(i)
            unlist(affinity2by2(my_data.matrix[i, 1], my_data.matrix[i, 2:4]))))
)

my_data$affinity <- res$est
my_data$Sorensen <- res$sorensen
rm(my_data.matrix, res)

my_data$SEShg <- d_age_mask$SES
pairs(my_data[, 11:15])

# correlation:
plot(logOR~affinity, my_data)  # perfect line = OK
abline(c(0,1))
# BUT! Affinity assigns arbitrary values where logOR = Inf or -Inf.
# Filter out and plot again
my_data_filt <- filter(my_data, is.finite(logOR))
plot(logOR~affinity, my_data_filt)  # perfect line = OK
abline(c(0,1))

pairs(my_data_filt[, 11:15])


# Run OLS on calculated logOR -----
# Affinity = logOR
lmod <- lm(affinity ~ zSympatry, my_data_filt)
summary(lmod)


# Fit model manually in R by optimizing nll -----
# Not using BiasedUrn, because it is not vectorized and is parametrized differently (in terms of input values).

# Calculating the log PMF for the Fisher's noncentral hypergeometric distribution.
fisher_hyper_lpmf <- function(k, mu, m1, m2, N) {
  
  if (mu <= 0) return(NaN)
  
  # Bounds
  lower <- max(0, m1 + m2 - N)
  upper <- min(m1, m2)
  
  # If k outside support → log prob = -Inf
  if (k < lower || k > upper) return(-Inf)
  
  # Log numerator
  log_num <- lchoose(m1, k) +
    lchoose(N - m1, m2 - k) +
    k * log(mu)
  
  # Denominator terms
  j_vals <- lower:upper
  
  log_terms <- lchoose(m1, j_vals) +
    lchoose(N - m1, m2 - j_vals) +
    j_vals * log(mu)
  
  # log-sum-exp trick
  m <- max(log_terms)
  log_denom <- m + log(sum(exp(log_terms - m)))
  
  return(log_num - log_denom)
}


# Negative log likelihood function to optimize.
nll_fisher <- function(pars, k, m1, m2, N, predictor) {
  
  beta0 <- pars[1]
  beta1 <- pars[2]
  
  mu <- exp(beta0 + beta1 * predictor)
  
  log_lik <- mapply(
    fisher_hyper_lpmf,
    k  = k,
    mu = mu,
    m1 = m1,
    m2 = m2,
    N  = N
  )
  
  # Protect optimizer
  if (any(!is.finite(log_lik)))
    return(1e10)
  
  return(-sum(log_lik))
}


# Choose dataset.
df <- my_data
df <- my_data_filt


# Optimize the NLL function.
fit <- optim(
  par = c(0, 0),
  fn  = nll_fisher,
  k = df$k,
  m1 = df$m1,
  m2 = df$m2,
  N  = df$N,
  predictor = df$zSympatry,
  method = "BFGS",
  control = list(maxit = 1000)
)

fit$par  # agrees with the brms fit!


