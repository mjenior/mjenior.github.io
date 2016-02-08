---
layout: post
title: Genome-Scale Metabolic Networks
description: "Predicting ecology from genomes and transcriptomics"
modified: 2016-02-07
tags: [metabolic modeling, genomics, reverse ecology]
image:
  feature: abstract-6.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
---

I've been pretty excited to talk about another angle I'm working for my project, and that is to try and 
look at the nutrient niche of bacteria in the gut by using metabolic models built from an organism's genomic 
information.  Inferring aspects of an organism's ecology and how it may impact other species in its environment 
based on high-throughput sequence data has been called [Reverse Ecology](https://en.wikipedia.org/wiki/Reverse_ecology).

I started this project after reading a pretty cool review from [Roie Levy and Elhanan Borenstein](http://elbo.gs.washington.edu/pub/re_levy_aemb.pdf).  
Their lab used an approach where they used a decomposition algorithm on metabolic networks to identify substrates or nutrients 
that a bacteria needs to obtain from its environment.  They went on to use this information to [accurately predict community 
assembly rules in mouth-associated bacterial communities](http://www.ncbi.nlm.nih.gov/pubmed/24637600).  I used their methods 
and found that comparing substrate lists between species predicted *in vitro* competition more accurately than phylogenetic 
distance.  Here's a little bit of the data:

	<div style="text-align:center"><img src ="http://mjenior.github.io//images/growth_data.pdf" width="300" height="200" /></div>

Each point is a separate bacterial species, competed against *C. difficile* in rich media.  Competitive Index refers to 
how much overlap there is between metabolic networks.  I didn't follow this up much further to focus on other projects, 
but we may come back to it in the future.

What I've been working on more recently has been integrating transcriptomic data into genome-scale metabolic models.  The 
methods I'm using are loosely based on some [work](http://www.pnas.org/content/102/8/2685.full) I read out of Jen Nielsen's lab.  
Their approach used a bipartite network architecture with enzyme nodes connecting to substrate nodes.  Since substrates only 
directly connect to enzyme nodes, you are then able to map transcript abundance to their respective enzymes and then make 
inferences about how in-demand the substrates they act on are.  Here's part of one network I've generated as an example:

	<div style="text-align:center"><img src ="http://mjenior.github.io//images/bipartite.scc.pdf" width="150" height="1400" /></div>

After mapping transcripts to the enzyme nodes, you can get a read on how important the adjacent substrate nodes are.  I'm 
extending this to infer the nutrient niche of species in the gut.  We are working on the analysis and manuscript now so I'll 
have a lot more to post soon.