---
layout: post
title:  "RIPTiDe published"
date:   2021-10-02 09:30:00
comments: true
tags: [metabolic network reconstructions, transcriptomics, metabolism, virulence]
---

Our paper on modeling context-specific metabolism of *C. difficile* is finally accepted in mSystems! In it we generated and extensively curated a *C. difficile* GENRE for a hypervirulent isolate (str. R20291). *In silico* validation revealed high degrees of agreement with experimental gene essentiality and carbon source utilization data sets. Then in collaboration with [Dr. Rita Tamayo](https://www.med.unc.edu/microimm/directory/rita-tamayo-phd/) at UNC, whose research focuses on an evolution strategy in some bacteria for phenotypic heterogeneity and virulence known as [phase variation](https://journals.plos.org/plosbiology/article/comments?id=10.1371/journal.pbio.3000379). We utilized transcriptome sequencing from distinct phases of *C. difficile*, and in combination with our previously [published](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007099) integration algorithm, we created context-specific models of metabolism to identify possible metabolite signals that drive differences in virulence.


<div style="text-align:center"><img src ="http://mjenior.github.io/images/Figure_3.jpg" width="550" height="450" /></div>


Using this GENRE-based analyses we found that glucose utilization through the pentose phosphate pathway is essential in the smooth phase variants of str. R20291. Here we show (A) Gene and reaction essentiality results for glycolysis and the pentose phosphate pathway across both the rough and smooth phase variant context-specific models. Components were deemed essential if models failed to generate <1% of optimal biomass flux. (B and C) Colony morphologies resulting from smooth and rough variants of *C. difficile* str. R20291 grown on either BHIS or BDM ± glucose after 48hr of growth. Defined medium colonies were then subcultured onto BHIS medium for an additional 24hr as indicated. Increased colony perimeter was found to be the defining characteristic of the rough colony morphology. This feature was quantified for multiple colonies under each permutation of colony variant and growth medium. (D) Colony perimeter for smooth and rough progenitor colony variants grown on BHIS. (E and F) Smooth (E) or rough (F) colony variant perimeter during subculture onto each of the BDM carbon source medium formulations. Significant differences determined by Wilcoxon rank sum test with Benjamini-Hochberg correction when necessary.


Our results support that differential *C. difficile* virulence is associated with distinct metabolic programs related to use of carbon sources and provide a platform for identification of novel therapeutic targets.


[You can read the whole open-access paper here!](https://journals.asm.org/doi/10.1128/mSystems.00919-21)

[Also, you can find all the analysis code here!](https://github.com/mjenior/Jenior_CdifficileGENRE_2021)

