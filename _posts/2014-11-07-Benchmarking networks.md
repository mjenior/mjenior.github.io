---
layout: post
title:  "Benchmarking networks"
date:   2014-11-07 13:55:47
comments: true
tags: [genomics, metabolic modeling]
---

Compared the seed set calculation algorithm differences between the perl
and python versions.

### Method Comparison
Found some pretty substantial differences.  I use the genome of the
intracellular pathogen Buchnera aphidicola APS to benchmark the code as
a comparison against Borenstein's original paper.  When I apply the perl
code that was originally published on, I get the correct number of seeds
at 68.  However, when I use the updated python code, I calculate only 16.  
These calculations are both done with identical parameters of a 5
node minimum per component and a minimum confidence of 0.2 per seed. 
Emailed Rogan Carr from their lab to hopefully shed some light on what's
going on.  More to come soon...

### Repeating in vitro experiments
Deriving growth curves for each strain and redoing all competition
experiments.  Nutrient re-supplementation experiments are up next.
