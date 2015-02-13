---
layout: post
title:  "Depends on the data"
date:   2015-02-13
comments: true
---

A few weeks back I took a first look at megahit and (spoiler) it didn't do too hot. I'm back with a new dataset and pleased to say megahit earned a spot in my toolbox.

Sadly assemblers are not one size fits all and you'll find that some work well for some datasdets and some not as well. Before I go on, I will say neither velvet or megahit has performed poorly so you'll probably be alright with either but it may be worth your time to try both, it's easy and cpu cycles are cheap.

On to the data!

The dataset I tried this time was from Koren and colleagues study of the effects of pregnancy on the mother’s microbiome. The data was downloaded from MG-RAST, which you'll recall from previous posts, I'm not their biggest cheerleader. Getting this data was tedious but not the worst.

First, get a list of the metagenomes for project mpg265 (this study):

```
MG-RAST-Tools/tools/bin/mg-download.py --project mgp265 --list | sed 's/\t.*$//g' | sed '1d' | uniq > metagenomes.list
```

Then download the actual datasets using this list of metagenomes:

```
for MG in metagenomes.list; do
    curl http://api.metagenomics.anl.gov//download/${MG}?file=050.1 | tee >(md5sum > data/{}.md5sum)  | gzip > data/${MG}.fna.gz
done
```

You can check the md5 sums to be sure everything downloaded correctly.

Next do the digital normalization as [described before]({% post_url 2014-11-06-actually-running-khmer.md %}).

```
#files
SEQS=$1
#paths
KHMER_SCRIPTS="$HOME/khmer/scripts" #path to khmer/scripts

#parameters
K=20
C=20
X_PRAM='1e10'

python $KHMER_SCRIPTS/normalize-by-median.py -k $K -C $C -x $X_PRAM --savetable $SEQS.kh $SEQS
python $KHMER_SCRIPTS/filter-abund.py -V $SEQS.kh $SEQS.keep
rm $SEQS.kh
```

This removed a bunch of reads but we still need to remove identical replicates. To do this I like to use [fastx_collapser](http://hannonlab.cshl.edu/fastx_toolkit/). It's fast and easy to use:

```
for i in *.keep.abundfilt;
do
    fastx_collapser -i $i -o $i.fastx
done

cat *.abundfilt.fastx > all.abundfilt.fastx

```

Now, on to the assembly! As mentioned [before]({% post_url 2015-01-29-megahit.md %}) running megahit is a breeze.

```
megahit -m 45e9 -r all.abundfilt.fastx --cpu-only -l 100 -o all.abundfilt.fastx_megahit

```

I'll note here, that megahit finished in about 24 hours whereas the iterative velvet took the better part of two weeks to finish up. That's no small difference.

Let's look at the results.

Iterative velvet assembly:

```
N50: 161
N90: 95
total contigs: 8023608
average length: 159 bp
trimmed average length: 159 bp
greater than or equal to 100:  5862733
shortest conting: 41 bp
longest contig: 27977 bp
total length: 1275.947143 Mb
1157102553 reads; of these:
1157102553 (100.00%) were unpaired; of these:
369521178 (31.94%) aligned 0 times
600382674 (51.89%) aligned exactly 1 time
187198701 (16.18%) aligned >1 times
68.06% overall alignment rate
```

Megahit:

```
N50: 1225
N90: 272
total contigs: 1661385
average length: 725 bp
trimmed average length: 725 bp
greater than or equal to 100:  1661385
shortest conting: 200 bp
longest contig: 372476 bp
total length: 1205.252821 Mb
1157102553 reads; of these:
1157102553 (100.00%) were unpaired; of these:
259032801 (22.39%) aligned 0 times
645132493 (55.75%) aligned exactly 1 time
252937259 (21.86%) aligned >1 times
77.61% overall alignment rate
```

The alignment rate isn't terrible for the iterative velvet assembly, but it's a lot better with megahit. You'll also notice the total length of both assemblies are almost the same but look at the huge difference in N50. Megahit knocked it out of the park. Well, it's at least a stand up double. Much better than the iterative velvet assembly.
