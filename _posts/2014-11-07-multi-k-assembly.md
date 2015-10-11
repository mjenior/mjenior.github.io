---
layout: post
title:  "Multi K assembly"
date:   2014-11-07
comments: true
---

Now that all the reads are preped for assembly it's time to actually get the assemblies going.

Running the assembler, velvet, is pretty straight forward but the one thing that is a bit confusing is picking a good value for k. Like so many things in life, it's basically a trade off between sensitivity and specificity. A long k-mer will give you fewer false overlaps but the end result will have lower coverage. The best way to find a good k value is to just run a lot of assemblies and look at how well they do. A simple for-loop will run all the different assemblies.

{% highlight bash %}

seq_file=$1

fq=$(basename $seq_file .trimmed.fq.keep.abundfilt)
for k in {19..51..2};
do
    quicksubmit "velveth $fq.velvet.$k.d $k -fastq -shortPaired $seq_file ;; velvetg $fq.velvet.$k.d -exp_cov auto -cov_cutoff auto; rm $fq.velvet.$k.d/Sequences; rm $fq.velvet.$k.d/*Graph*" --walltime 500:00:00 --cput 9999:00:00 --pm nodes=1:ppn=8,mem=46gb;
done

{% endhighlight %}


This gives us an assembly for k=19 through k=51 and the contigs are in $fq.velvet.$k.d/contigs.fa This range of k values was picked because 19 seems to be the lower limit that actually produces an asembly (as per the velvet manual) and 51 is the default maximum. We can exceed this maximun by recompiling the assembler to use a different upper limit but keep in mind this will push the memory usage way up. I will experiment with these higher k-mer values later when I touch on the iterative assembly approach. There is also a file in there called stats.txt and that has coverage information in it. It's mildly interesting but keep in mind I removed a bunch of reads with the digital normalization so this isn't quite reflective of the data as a whole. To do this I like to map all of the trimmed reads on to this assembly using Bowtie, which is a pretty cool tool and I'll go into detail about that next time.
