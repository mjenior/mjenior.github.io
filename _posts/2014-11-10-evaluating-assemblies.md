---
layout: post
title:  "Evaluating assemblies"
date:   2014-11-10
comments: true
---

Is this a good assemby?

There are several metrics to look at how good an assembly is. The most common are contig size, coverage and N50. Now, let's look at a giant list of data. Below is a long list of common metrics for each of the assemblies I ran for each k-mer 19-49, by 2 (velvet requires an odd k-mer value because of palindromes).

The metrics are pretty self-explanatory with the exception of N50 and N90. The N numbers can be thought of as a kind of contig median meaning that if you lined up all your contigs from smallest to largest that is the length of the contig right in the middle (N50). So half your bases are on contigs of that length or larger. Similarly, N90 is the length of contig where 90% of the bases are on contigs of this length or longer.

{% include image.html url="/assets/allyourbase.png" description="The CATS metric has all your base" %}

In addition to N50 and N90 we can look at the size distribution of the contigs. We want large contigs as opposed to many small contigs. This is where you'll start to notice the trade-off between sensitivity and specificity I noted in the previous post. When the k-mer value is large we get big contigs but we also have fewer total bases.

Finally we can look at read alignment. This is my preferred metric because it gives a sense of how much information is contained in the assembly. The alignment output shown below is from bowtie which I used to align the trimmed reads to the assembled contigs. These are not the normalized reads that went into the assembly.

Let's have a look at two assemblies.

~~~~
combined_001.velvet.31.d
N50: 157
N90: 99
2465093 (30.81%) aligned 0 times
5401339 (67.52%) aligned exactly 1 time
133568 (1.67%) aligned >1 times
combined_001.velvet.31.d
total contigs: 506522
average length: 167 bp
trimmed average length: 167 bp
greater than or equal to 100:  401974
shortest conting: 61 bp
longest contig: 13314 bp
total length: 84.954406 Mb
~~~~
~~~~
combined_001.velvet.33.d
N50: 892
N90: 120
2808342 (35.10%) aligned 0 times
4995086 (62.44%) aligned exactly 1 time
196572 (2.46%) aligned >1 times
combined_001.velvet.33.d
total contigs: 105283
average length: 364 bp
trimmed average length: 364 bp
greater than or equal to 100:  91266
shortest conting: 65 bp
longest contig: 51129 bp
total length: 38.385858 Mb
~~~~

A couple things to notice, look at that jump in N50 and drop in total length. This is a good example of the k-mer length trade off. An interesting thing to note, the number of reads that aligned isn't all that different, about a 5% drop. There are fewer reads aligning but the contigs in the k=33 assembly are much longer, double the average length. This is telling me we've found a sort of sweet spot for this particular dataset and anecdotal evidence has shown me that k-mers between 31 and 35 for metagenomes tend to be the best assemblies so this is right in line. The next step will be to merge these two assemblies to try and capture the best of both worlds.



Full assembly metrics:
==
~~~~
combined_001.velvet.19.d
N50: 103
N90: 52
4715919 (58.95%) aligned 0 times
3282728 (41.03%) aligned exactly 1 time
1353 (0.02%) aligned >1 times
combined_001.velvet.19.d
total contigs: 1171854
average length: 93 bp
trimmed average length: 93 bp
greater than or equal to 100:  368582
shortest conting: 37 bp
longest contig: 1585 bp
total length: 109.56487 Mb
~~~~
~~~~
combined_001.velvet.21.d
N50: 132
N90: 63
3746354 (46.83%) aligned 0 times
4251249 (53.14%) aligned exactly 1 time
2397 (0.03%) aligned >1 times
combined_001.velvet.21.d
total contigs: 887871
average length: 114 bp
trimmed average length: 114 bp
greater than or equal to 100:  395880
shortest conting: 41 bp
longest contig: 4561 bp
total length: 101.494393 Mb
~~~~
~~~~
combined_001.velvet.23.d
N50: 138
N90: 70
3463215 (43.29%) aligned 0 times
4531095 (56.64%) aligned exactly 1 time
5690 (0.07%) aligned >1 times
combined_001.velvet.23.d
total contigs: 794978
average length: 123 bp
trimmed average length: 123 bp
greater than or equal to 100:  404873
shortest conting: 45 bp
longest contig: 5070 bp
total length: 98.519699 Mb
~~~~
~~~~
combined_001.velvet.25.d
N50: 143
N90: 77
3182535 (39.78%) aligned 0 times
4797469 (59.97%) aligned exactly 1 time
19996 (0.25%) aligned >1 times
combined_001.velvet.25.d
total contigs: 722324
average length: 132 bp
trimmed average length: 132 bp
greater than or equal to 100:  411378
shortest conting: 49 bp
longest contig: 5544 bp
total length: 96.04674 Mb
~~~~
~~~~
combined_001.velvet.27.d
N50: 147
N90: 83
2968410 (37.11%) aligned 0 times
4983884 (62.30%) aligned exactly 1 time
47706 (0.60%) aligned >1 times
combined_001.velvet.27.d
total contigs: 663798
average length: 140 bp
trimmed average length: 140 bp
greater than or equal to 100:  414338
shortest conting: 53 bp
longest contig: 5393 bp
total length: 93.535528 Mb
~~~~
~~~~
combined_001.velvet.29.d
N50: 150
N90: 90
2816672 (35.21%) aligned 0 times
5110746 (63.88%) aligned exactly 1 time
72582 (0.91%) aligned >1 times
combined_001.velvet.29.d
total contigs: 606082
average length: 148 bp
trimmed average length: 148 bp
greater than or equal to 100:  417568
shortest conting: 57 bp
longest contig: 11647 bp
total length: 90.24859 Mb
~~~~
~~~~
combined_001.velvet.31.d
N50: 157
N90: 99
2465093 (30.81%) aligned 0 times
5401339 (67.52%) aligned exactly 1 time
133568 (1.67%) aligned >1 times
combined_001.velvet.31.d
total contigs: 506522
average length: 167 bp
trimmed average length: 167 bp
greater than or equal to 100:  401974
shortest conting: 61 bp
longest contig: 13314 bp
total length: 84.954406 Mb
~~~~
~~~~
combined_001.velvet.33.d
N50: 892
N90: 120
2808342 (35.10%) aligned 0 times
4995086 (62.44%) aligned exactly 1 time
196572 (2.46%) aligned >1 times
combined_001.velvet.33.d
total contigs: 105283
average length: 364 bp
trimmed average length: 364 bp
greater than or equal to 100:  91266
shortest conting: 65 bp
longest contig: 51129 bp
total length: 38.385858 Mb
~~~~
~~~~
combined_001.velvet.35.d
N50: 1091
N90: 144
2807263 (35.09%) aligned 0 times
4966553 (62.08%) aligned exactly 1 time
226184 (2.83%) aligned >1 times
combined_001.velvet.35.d
total contigs: 84203
average length: 430 bp
trimmed average length: 429 bp
greater than or equal to 100:  77365
shortest conting: 69 bp
longest contig: 61585 bp
total length: 36.239633 Mb
~~~~
~~~~
combined_001.velvet.37.d
N50: 1178
N90: 152
2779814 (34.75%) aligned 0 times
4943259 (61.79%) aligned exactly 1 time
276927 (3.46%) aligned >1 times
combined_001.velvet.37.d
total contigs: 77133
average length: 460 bp
trimmed average length: 459 bp
greater than or equal to 100:  72028
shortest conting: 73 bp
longest contig: 62245 bp
total length: 35.499856 Mb
~~~~
~~~~
combined_001.velvet.39.d
N50: 1280
N90: 162
2753228 (34.42%) aligned 0 times
4923801 (61.55%) aligned exactly 1 time
322971 (4.04%) aligned >1 times
combined_001.velvet.39.d
total contigs: 69514
average length: 499 bp
trimmed average length: 498 bp
greater than or equal to 100:  65877
shortest conting: 77 bp
longest contig: 65044 bp
total length: 34.69573 Mb
~~~~
~~~~
combined_001.velvet.41.d
N50: 2024
N90: 271
2917361 (36.47%) aligned 0 times
4739688 (59.25%) aligned exactly 1 time
342951 (4.29%) aligned >1 times
combined_001.velvet.41.d
total contigs: 36285
average length: 791 bp
trimmed average length: 789 bp
greater than or equal to 100:  34569
shortest conting: 81 bp
longest contig: 75195 bp
total length: 28.735841 Mb
~~~~
~~~~
combined_001.velvet.43.d
N50: 2243
N90: 325
2884825 (36.06%) aligned 0 times
4719599 (58.99%) aligned exactly 1 time
395576 (4.94%) aligned >1 times
combined_001.velvet.43.d
total contigs: 31158
average length: 912 bp
trimmed average length: 910 bp
greater than or equal to 100:  30012
shortest conting: 85 bp
longest contig: 77854 bp
total length: 28.433697 Mb
~~~~
~~~~
combined_001.velvet.45.d
N50: 2423
N90: 364
2868099 (35.85%) aligned 0 times
4700377 (58.75%) aligned exactly 1 time
431524 (5.39%) aligned >1 times
combined_001.velvet.45.d
total contigs: 28162
average length: 998 bp
trimmed average length: 995 bp
greater than or equal to 100:  27351
shortest conting: 89 bp
longest contig: 81354 bp
total length: 28.118196 Mb
~~~~
~~~~
combined_001.velvet.47.d
N50: 2423
N90: 381
2863996 (35.80%) aligned 0 times
4687170 (58.59%) aligned exactly 1 time
448834 (5.61%) aligned >1 times
combined_001.velvet.47.d
total contigs: 26924
average length: 1033 bp
trimmed average length: 1030 bp
greater than or equal to 100:  26340
shortest conting: 93 bp
longest contig: 81317 bp
total length: 27.820733 Mb
~~~~
~~~~
combined_001.velvet.49.d
N50: 2387
N90: 391
2856808 (35.71%) aligned 0 times
4672718 (58.41%) aligned exactly 1 time
470474 (5.88%) aligned >1 times
combined_001.velvet.49.d
total contigs: 26107
average length: 1054 bp
trimmed average length: 1051 bp
greater than or equal to 100:  25662
shortest conting: 97 bp
longest contig: 77860 bp
total length: 27.527456 Mb
~~~~
