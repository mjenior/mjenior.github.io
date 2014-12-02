---
layout: post
title:  "Merging assemblies"
date:   2014-12-02
comments: true
---

Elapsed time: 17d 5h 24m 52s


Well, that took a while; let's see if it was worth it. Here's what the stats for the merged k=31 and k=33 assemblies look like:

~~~~
N50: 2456
N90: 214
3069877 (38.37%) aligned 0 times
4772813 (59.66%) aligned exactly 1 time
157310 (1.97%) aligned >1 times
total contigs: 50502
average length: 652 bp
trimmed average length: 606 bp
greater than or equal to 100:  44588
shortest conting: 61 bp
longest contig: 2315158 bp
total length: 32.930383 Mb
~~~~

Let's compare the three assemblies


|         |minimus   |k 31       |k 33    |
|---------|:--------:|:---------:|:------:|
|**N50**      |2456      | 157       |892     |
|---------|----------|-----------|--------|
|**N90**      |214       | 99        |120     |
|---------|----------|-----------|--------|
|**aligned**  |59.66%    | 67.52%    |62.44%  |
|---------|----------|-----------|--------|
|**avg len**  |652 bp    | 167 bp    |364 bp  |
|---------|----------|-----------|--------|
|**shortest** |61 bp     | 61 pb     |65 bp   |
|---------|----------|-----------|--------|
|**longest**  |2315158 bp| 13314 bp  |51129 bp|
|---------|----------|-----------|--------|
|**total len**|32.93 Mb  | 84.95 Mb  |38.39 Mb|


<br>

The minimus assembly gave us a huge increase in N50 and average contig length. The total sequence length did go down a fair amount though. It's actually quite similar to the k=41 and k=43 assemblies but with a longer total length. The minimus assembly looks pretty good but it's a little disappointing to see the percent aligned and total length go down. So yes, I think the minimus assembly is good but the real question is: is it worth the time? If I only had to do it once I would say sure, but this was just one sample from a whole lot of data. Even in parallel this would get pretty unreasonable pretty quickly. So, which assembly should I use then? To keep stringing you along I've got one more trick up my sleve, an iterative assembly which I'll look at tomorrow.
