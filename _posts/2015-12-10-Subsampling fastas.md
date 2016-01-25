---
layout: post
title:  "Subsampling fasta files"
date:   2015-12-10 17:55:47
comments: true
tags: [metatranscriptomics, bash]
---

After spending too much time on writing a python script to subsample reads from a fasta file, I found some pretty great awk scripts to do the job courtesy of [Umer Zeeshan Ijaz](http://userweb.eng.gla.ac.uk/umer.ijaz/bioinformatics/subsampling_reads.pdf).  They also 
happen to finish in a fraction of the time without all the overhead that comes with python.  The goal was to normalize the read files to each other for mapping to 
genes downstream.  Without this step first, comparing groups is unfair to those samples that didn't have quite as many reads.  The difference in coverage between samples 
was almost negligible, however I wanted to be thorough with my approach.

For paired-end reads you need to subsample before interleaving and then do that afterwards.  It takes reads randomly and always grabs its counterpart in the read 2 file. I 
hadn't figured out how to insert bash variables into the output file name as is so I renamed them immediately after the script finishes.  Here is the code:
	
	{% highlight bash %}
	# Paired-end fasta
	paste <(awk '/^>/ {printf("\n%s\n",$0);next; }{printf("%s",$0);} END {printf("\n");}' < ${sample_name}.read1.trim.pool.fasta) <(awk '/^>/{printf("\n%s\n",$0);next; } { printf("%s",$0);} END{printf("\n");}' < ${sample_name}.read2.trim.pool.fasta) | awk 'NR>1{ printf("%s",$0); n++;if(n%2==0) { printf("\n");} else { printf("\t");} }' | awk -v k=${k1} 'BEGIN{srand(systime() + PROCINFO["pid"]);}{s=x++<k?x-1:int(rand()*x);if(s<k)R[s]=$0}END{for(i in R)print R[i]}' | awk -F"\t" '{print $1"\n"$3 > "temp.read1.fasta";print $2"\n"$4 > "temp.read2.fasta"}'
	mv temp.read1.fasta ${sample_name}.read1.trim.pool.pick.fasta
	mv temp.read2.fasta ${sample_name}.read2.trim.pool.pick.fasta
	{% endhighlight %}
	
These files are subsampled identically and are still interleave-ready.  Similarly, you can subsample the orphaned reads from sickle with the following awk script:

	{% highlight bash %}
	# Single-end fasta
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);} END{printf("\n");}' < ${sample_name}.trim.orphan.pool.fasta |  awk 'NR>1{ printf("%s",$0); n++; if(n%2==0) { printf("\n");} else { printf("\t");} }' | awk -v k=${k2} 'BEGIN{srand(systime() + PROCINFO["pid"]);}{s=x++<k?x-1:int(rand()*x);if(s<k)R[s]=$0}END{for(i in R)print R[i]}' | awk -F"\t" '{print $1"\n"$2 > "temp.single.fasta"}'
	mv temp.single.fasta ${sample_name}.trim.orphan.pool.pick.fasta
	{% endhighlight %}
	
I subsampled all the files to the lowest common denominator among the each group of like read files respectively.
	
	
	
