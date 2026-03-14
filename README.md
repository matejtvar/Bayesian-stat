# Assignment properties from Petr Tureček Bayesian Stat Course

Because we claim that to be able to analyse your data the Bayesian way, you must be able to generate the data you would like to collect, your task is to:

1. Generate data from your dream experiment (we will appreciate if the total number of parameters to do this is 4 or more, but if you convince us that your dream experiment really is of the complexity of ice cream stant profits in response to temperature - 3 parameters, a, b, sigma - we will accept also a simpler system)
2. Do a basic visualization to convince us that your data generating process works.
It is great if you complete the assignment as an R markdown document that will allow you to combine text, latex equations (if needed), code and results of the code. Learning to make R markdown files is easy - just click File-New File-R Markdown, the thing itself tries to teach you how to do it. Try to click the Knit button and the plain text is converted into a decent html or pdf file. You can, of course, consult any online tutorials or chatbots (Just submit a file that you are able to take full responsibility for. If the code is too different from the one used in our course - e.g. when it uses too much tidyverse that we avoided - we might be a little bit sour, because we might interpret this as just going with the AI slop flow.)

So that is it. Optionally, if you want feedback on your analysis or on your prior choice etc. you can

3. Add a block that will demonstrate (preferably with an ulam function) that you can extract the same parameter values that you baked in from that generated data. You will see that after generating the data properly, this step comes almost for free, so we encourage you to do this.

**Some people asked me this: If you already have your dream data (collected, for instance, within work on your diploma or research in general) it is fine to start with loading the empirical data and analysing them the Bayesian way. So, just submitting a high-quality version of 3 is also a passable strategy.**

# My topic: Bayesian analysis of syntopy (local Co-occurence) in birds using data from Remeš & Harmáčková 2023

In this assignment I analyse the data from the template study of my supervisor prof. Vladimír Remeš. I am going to replicate his approach in my master's thesis and we already decide to do it the Bayesian way, because it provides advantages over traditionally used indicies of co-occurrence.

Here is the plan: 
We will analyse species co-occurrence using **Fisher's non-central hypergeometric distribution** for the occurence data of sister species pairs to examine which niche and spatial predictors facilitate/impede their presence on the same local sites.


# Master Thesis Proposal
## Secondary syntopy in North American passerines: Multiscale analysis using the BBS dataset
## Supervisor: Prof. Vladimír Remeš

### Annotation
Understanding the ecological and evolutionary drivers of local cooccurrence (syntopy) among closely related species is key to explaining biodiversity patterns. My Bachelor's thesis, Ecology and Evolution of Secondary Sympatry in Birds, provides a theoretical foundation for this topic by exploring how ecological divergence facilitates co-existence following range overlap. Building on this framework, my master’s thesis will focus on the ecology and evolution of local syntopy in North American passerines using data from the North American Breeding Bird Survey (BBS), a standardised large-scale monitoring programme. The central hypothesis is that local syntopy is promoted by ecological divergence, particularly in resource use, and that the influence of such predictors differs between spatial scales. I will assess syntopy at the scale of individual point counts and entire transects, and evaluate the role of species traits in shaping these patterns. The methodological approach will replicate the framework of Remeš & Harmáčková (2023), which uses unbiased cooccurrence analyses to infer the drivers of syntopy.

### Methods
The study will use data from the North American Breeding Bird Survey (BBS), a long-term, standardised monitoring programme that records bird assemblages across approximately 2,900 routes annually. Each route includes 50 point counts spaced at 0.5-mile intervals. I will analyse patterns of syntopy at two spatial resolutions:

- Point scale (individual stops)
- Transect scale (combined stops along each route)

To infer drivers of syntopy, I will replicate the analytical framework of Remeš & Harmáčková (2023), which uses cooccurrence analyses and species trait data to identify ecological predictors of coexistence. A novel feature of this thesis will be analysing syntopy at two spatial resolutions (see above).

Remeš, V. and Harmáčková, L. (2023), Resource use divergence facilitates the evolution of secondary syntopy in a continental radiation of songbirds (Meliphagoidea): insights from unbiased co-occurrence analyses. Ecography, 2023: e06268. https://doi.org/10.1111/ecog.06268 
