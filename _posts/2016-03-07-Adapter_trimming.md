---
layout: post
title:  "3'-Adapter Trimming Metagenomic Reads (More Important Than It Sounds)"
date:   2016-11-07
comments: true
tags: [metagenomics, python]
---


I was recently talking with [Geof Hannigan](http://microbiology.github.io/index.html), a postdoc in our lab, and he pointed out a pretty critical 
piece of information I had been overlooking.  When sequencing reads become long enough, you may sequence passed the fragment size and into the 3' adapter.  This 
is especially problematic when you move on to assembly because these introduced sequences will have 100% homology to one another and assemble on the adapter
 instead of actual genome sequence.  Similar problems can arise in a couple different ways as shown in the figure below. These artifacts will leave you with 
 contigs that don't reflect biology at all.  

<div style="text-align:center"><img src ="http://mjenior.github.io/images/cutadapt_fig.tiff" width="800" height="500" /></div>

To avoid this I am now using a program called [Cutadapt](http://journal.embnet.org/index.php/embnetjournal/article/view/200/479), where the figure came from, 
to remove any residual adapter sequences from my reads prior to assembly.  The program requires python 2.7 and the command to run it looks like this:


{% highlight bash %}
python2.7 /mnt/EXT/Schloss-data/bin/cutadapt-1.9.1/bin/cutadapt --error-rate=0.1 --overlap=10 -a CAAGCAGAAGACGGCATACGAGATTAAGGCGAGTCTCGTGGGCTCGG -A GACGCTGCCGACGAGCGATCTAGTGTAGATCTCGGTGGTCGCCGTATCATT -o read_1.trimmed.fastq -p read_2.trimmed.fastq read_1.fastq read_2.fastq
{% endhighlight %}


Each argument supplies the following info:

	--error-rate - Rate for how generously you still call a matching sequence, basically 1 in 10 bases can be a mismatch
	--overlap - Minimum number of overlapping bases to call a match
	-a - 5' sequencing primer full sequence, adapter + index
	-A - reverse complement of the 3' sequencing primer 
	-o - Output file name for read 1 followinf trimming
	-p - Output file name for read 2
	
	The last two file names without options before them are the forward and reverse read files


In order to get the reverse complement of the 3' adapter, I wrote a small python script to reverse the order of a nucleotide sequence and then switch 
each base to it's complement.  Below is what it looks like and I've hosted on the [Github](https://github.com/mjenior/Blog_scripts) page I made for scripts I talk 
about on my blog.  This new adapter trimming step is critical for both my metagenomic and metatranscriptomic pipelines, basically anything with some amount of 
random fragment size.  Otherwise the primer fragments left in the data negatively impact and assembly or mapping you try to do downstream.


{% highlight python %}
#!/usr/bin/env python

# Computes the reverse complement of a given nucleotide string
# USAGE: rev_comp.py input_sequence


import sys

def reverse_complement(nucleotides):

	seq_str = str(nucleotides).upper()
	rev_seq_str = seq_str[::-1]

	pyr_seq_str = rev_seq_str.replace('A', 'n')
	pyr_seq_str = pyr_seq_str.replace('T', 'A')
	pyr_seq_str = pyr_seq_str.replace('n', 'T')

	final_seq_str = pyr_seq_str.replace('C', 'n')
	final_seq_str = final_seq_str.replace('G', 'C')
	final_seq_str = final_seq_str.replace('n', 'G')

	return final_seq_str


print(reverse_complement(sys.argv[1]))

{% endhighlight %}


After running this additional curation step, the quality of the assemblies increased dramatically!  I'll post some metric comparisons soon.


