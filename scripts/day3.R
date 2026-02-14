library(rethinking)
library(abc)
library(untb)



# 3.1 Approximate Bayesian Computation ------------------------------------

set.seed(13)
abctargetdata=rnorm(20, 52, 4)
abctargetdata
abctarget=c(median(abctargetdata), range(abctargetdata)[1]-range(abctargetdata)[2])

abcmodel=function(mu, sigma){
  temp=rnorm(20, mu, sigma)
  ret=c(median(temp),range(temp)[1]-range(temp)[2])
  return(ret)
}

abcprior=data.frame(mu=runif(10000,0,100), sigma=runif(10000,0,10))
hist(abcprior$mu, breaks = seq(0,100,1))
hist(abcprior$sigma, breaks = seq(0,10,0.1))

abcsummarystats=t(mapply(abcmodel, mu=abcprior$mu, sigma=abcprior$sigma))
abcsummarystats[1:10,]



abcposter=abc(target=abctarget, param=abcprior, sumstat=abcsummarystats, tol=.1, method =
                "rejection")
abcposter$unadj.values[1:10,]




hist(abcprior$mu, breaks = seq(0,100,1), main="",xlab="sigma")
hist(abcposter$unadj.values[,1], add=T, col="red", breaks=seq(0,100,1))
abline(v=52,lwd=3, lty=2)



hist(abcprior$sigma, breaks = seq(0,10,0.1), main="",xlab="sigma")
hist(abcposter$unadj.values[,2], add=T, col="red", breaks=seq(0,10,0.1))
abline(v=4,lwd=3, lty=2)


# Hubbells Neutral Theory of Biodiversity

target <- untb(start = rep(1,100), prob=.8, gens = 50, keep = T)
dim(target)
target.curve <- species.count(target)
plot(1:length(target.curve), target.curve, type = "l", lwd=3, xlab = "t", ylab = "richness")

untbprior = runif(10000, 0,1)

untb.streamlined_curve <- function(p){
  a <- untb(start = rep(1,100), prob = p, gens = 50, keep = T)
  return(species.count(a))
}

untb_summary_stats_curve <- t(mapply(untb.streamlined_curve, p = untbprior))

untbpostercurve=abc(target=target.curve, param=untbprior, sumstat=untb_summary_stats_curve, tol=.1, method =
                      "rejection")

hist(untbprior, seq(0,1,0.01), main="",xlab="p")
hist(untbpostercurve$unadj.values, seq(0,1,0.01), col="red", add=T)
abline(v=0.8,lwd=3, lty=2)

library(scales)
plot(1:length(target.curve),target.curve, type="l",lwd=3, xlab="t", ylab="richness")
for (i in 1:length(untb_summary_stats_curve[,1])){
  lines(1:length(target.curve),untb_summary_stats_curve[i,], type="l",col=alpha("blue",0.01))
}
for (i in 1:length(untbpostercurve$ss[,1])){
  lines(1:length(target.curve),untbpostercurve$ss[i,], type="l",col=alpha("black",0.01))
}

target.fin=target.curve[length(target.curve)]
untbsummarystatsfin=untb_summary_stats_curve[,length(target.curve)]

untbposterfin = abc(target = target.fin, 
                    param = untbprior, 
                    sumstat = untbsummarystatsfin, 
                    tol = 0.1, 
                    method = "rejection")

hist(untbprior, seq(0,1,0.01), main="p parameter estimation", xlab="p")
hist(untbposterfin$unadj.values, seq(0,1,0.01), col="red", add=T)
abline(v=0.8, lwd=3, lty=2)



# 1. Richness in time 50
untbposterfin = abc(target = target.fin, 
                    param = untbprior, 
                    sumstat = untbsummarystatsfin, 
                    tol = 0.1, 
                    method = "rejection")

# 2. Comparison of the curve and the final species count
par(mfrow=c(2,1))

# Curve estimation
hist(untbpostercurve$unadj.values, seq(0,1,0.01), col="red", 
     main="Richness 1:50", xlab="p")
abline(v=0.8, lwd=3, lty=2)

# SR estimation
hist(untbposterfin$unadj.values, seq(0,1,0.01), col="orange", 
     main="Richness t=50", xlab="p")
abline(v=0.8, lwd=3, lty=2)

par(mfrow=c(1,1))

The method you just practiced is a core part of **Approximate Bayesian Computation (ABC)**. Here is a conclusion summarizing why we use it, how it works in this context, and what the exercise revealed about data.

---
  
  ### Core Conclusion: The Power of Simulation-Based Inference
  
  **1. ABC is the "Likelihood-Free" Solution**
  In many complex biological systems (like Hubbell's Neutral Theory), we don't have a neat mathematical formula to calculate the "Likelihood." ABC bypasses this by saying: *"If I can't calculate the probability, I will just simulate the world thousands of times and see which simulations look like my reality."*
                                        
                                        **2. The "Filter" Mechanism**
                                        The process acts as a filter for your uncertainty:
                                        
                                        * **Prior:** Your starting guess (total ignorance,  is anywhere between 0 and 1).
                                      * **Simulation:** Running the `untb` model 10,000 times with different  values.
                                      * **Rejection:** Throwing away any simulation that doesn't produce a diversity result close to your `target`.
* **Posterior:** The  values that "survived" the filter. These represent your updated knowledge.

---

### Lessons from Exercise 1: Information Density

The most important takeaway from your exercise is the concept of **Summary Statistics**:

| Statistic Used | Precision of Estimate | Why? |
| --- | --- | --- |
| **Full Curve** (Richness over time) | **High** | The model captures the *rate* of change. There are fewer ways to get the whole curve right. |
| **End Point** (Final richness only) | **Low** | Many different "paths" (different  values) can end up at the same final number of species by sheer luck. |

**Final Verdict:** The "quality" of a Bayesian estimate depends entirely on how much information your chosen statistic extracts from the raw data. In ecology, **dynamics (the curve) usually tell a much deeper story than a snapshot (the end point).**

---

### What's next?
                                        
                                        Now that you've seen how the choice of statistics affects the result, would you like to see how **changing the tolerance (`tol`)**—i.e., being more or less "strict" about which simulations you accept—affects the trade-off between accuracy and the number of samples?





