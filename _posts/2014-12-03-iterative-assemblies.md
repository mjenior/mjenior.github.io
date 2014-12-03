---
layout: post
title:  "Iterative assemblies"
date:   2014-12-03
comments: true
---

Finally we've come to the end of our assembly experiment, hopefully with good results.

The last assembly technique I'll be looking at is an iterative assembly. I've been hinting at the logic behind this technique in the previous assembly posts but now I'll get right into it. The assembly is pretty straight forward, do an assembly with a high k-mer value, assemble what you can, and work your way down assembling the unused reads from previous assembies at lower and lower values of k. This attempts to address the sensitivity and specificity trade offs. Let's look at some data.

Here are the stats for the contigs from the first iterative assembly keeping only contigs > 200 in each assembly:

~~~~
N50: 1101
N90: 222
2551119 (31.89%) aligned 0 times
4968180 (62.10%) aligned exactly 1 time
480701 (6.01%) aligned >1 times
68.11% overall alignment rate
total contigs: 70622
average length: 554 bp
trimmed average length: 553 bp
greater than or equal to 100:  70622
shortest conting: 200 bp
longest contig: 77860 bp
total length: 39.16756 Mb
~~~~

And the second, keeping all contigs:

~~~~
N50: 137
N90: 92
1478005 (18.48%) aligned 0 times
4686332 (58.58%) aligned exactly 1 time
1835663 (22.95%) aligned >1 times
81.52% overall alignment rate
total contigs: 4651018
average length: 127 bp
trimmed average length: 127 bp
greater than or equal to 100:  3506630
shortest conting: 41 bp
longest contig: 77860 bp
total length: 594.837079 Mb
~~~~

<br>

We can compare this to the table from yesterday:

|         |minimus   |k 31       |k 33    |iterative > 200|iterative-all|diginorm reads
|---------|:--------:|:---------:|:------:|:---------:|:---------:|:---------:|
|**N50**      |2456      | 157       |892     |1101|137|-
|---------|----------|-----------|--------|--------|-----------|-----------|
|**N90**      |214       | 99        |120     |222|92|-
|---------|----------|-----------|--------|--------|-----------|-----------|
|**reads aligned**  |59.66%    | 67.52%    |62.44%  |68.11%|81.52%|-
|---------|----------|-----------|--------|--------|-----------|-----------|
|**avg len**  |652 bp    | 167 bp    |364 bp  |554 bp|127 bp|93 bp
|---------|----------|-----------|--------|--------|-----------|-----------|
|**shortest** |61 bp     | 61 bp     |65 bp   |200 bp|41 pb|20 bp
|---------|----------|-----------|--------|--------|-----------|-----------|
|**longest**  |2315158 bp| 13314 bp  |51129 bp|77860 bp|77860 bp|100 bp
|---------|----------|-----------|--------|--------|-----------|-----------|
|**total len**|32.93 Mb  | 84.95 Mb  |38.39 Mb|39.16756 Mb|594.85 Mb|676.34 Mb

<br>

I didn't put it in the table, but it took about an hour to run the iterative assemblies, a few minutes to run the k 31 and k 33 assemblies and 17 _days_ to run minimus. From a time point of view the iterative is pretty good compromise but how does it stack up in terms of quality? One thing you'll notice immediately is the percentage of reads aligned in the iterative-all assembly and the total length. There's a lot of information in this assembly. This outperformed all the individual assembles and the minimus assembly. It, however, comes at the expense of contig length, there are a lot of small contigs. It's also misleading because there are a lot of duplicate contigs in this assembly. Notice how a much larger percentage of reads aligned to more than one place. We can try and eliminate some of this by removing all duplicate contigs. Doing that we get:

~~~~
N50: 121
N90: 73
1477111 (18.46%) aligned 0 times
5202313 (65.03%) aligned exactly 1 time
1320576 (16.51%) aligned >1 times
81.54% overall alignment rate
total contigs: 1921045
average length: 118 bp
trimmed average length: 118 bp
greater than or equal to 100:  967403
shortest conting: 41 bp
longest contig: 77860 bp
total length: 227.834738 Mb
~~~~


This still leaves us with a healthy amount of information and looks like a pretty good assembly.
