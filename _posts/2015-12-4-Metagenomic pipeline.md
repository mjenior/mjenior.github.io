---
layout: post
title:  "Metagenomic pipeline"
date:   2015-12-4 13:55:47
comments: true
---

I had almost totally forgotten about the blog posts and I really want to get into the habit of writing them.  I wanted to write out an update on where my pipeline stands for my 
metagenomic assemblies.  I broke it into steps from processing and managing the large intermediate files that are created with each new step.  As of now there are four metagenomes with hopefully
three more to follow and fully complement the metatranscriptomic analysis for each condition.  Each metagenome was sequenced twice (across 2 separate Hi-Seq lanes) using 250 bp paired-end libraries 
done on the Rapid setting.  After pooling the data within respect metagenomes, before curation, that resulted in ~100 GB of data per sample.  Since there was so much data per sample, I felt that 
[digital normalization](http://ivory.idyll.org/blog/what-is-diginorm.html) and [Megahit](http://www.ncbi.nlm.nih.gov/pubmed/25609793) were my best bets for fast, high-quality metagenomic assemblies.  
I have and automated pipeline in place that will submit each job with the correct dependencies in order for all the metagenomes at once.  I'll break down each of the pbs scripts here:

### Preprocessing

Here I'm concatenating read files and interleving the paired reads from each lane

'gunzip *.gz

cat *_L001_R1_*.fastq > ${sample_name}.lane1.read1.fastq
cat *_L001_R2_*.fastq > ${sample_name}.lane1.read2.fastq
cat *_L002_R1_*.fastq > ${sample_name}.lane2.read1.fastq
cat *_L002_R2_*.fastq > ${sample_name}.lane2.read2.fastq

gzip *_L00*.fastq

module rm gcc/4.6.4
module add python/2.7.9 gcc/4.9.2 khmer

interleave-reads.py ${sample_name}.lane1.read1.fastq ${sample_name}.lane1.read2.fastq -o ${sample_name}.lane1.paired.fastq
interleave-reads.py ${sample_name}.lane2.read1.fastq ${sample_name}.lane2.read2.fastq -o ${sample_name}.lane2.paired.fastq

#rm *read*

python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.lane1.paired.fastq > ${sample_name}.lane1.paired.fastq.summary
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.lane2.paired.fastq > ${sample_name}.lane2.paired.fastq.summary'

I try to do some real-time data management so large fatqs/fastas don't hang around on our cluster much longer than they need to.  I then move into read quality trimming using [Sickle](https://github.com/najoshi/sickle).  
I chose to cutoff reads below Q25 as it was a little more forgiving than the strict Q33, but still had a 99.5% confidence for base calls.  I also tossed any sequence smaller than 21 bases, which is the shortest kmer 
used by the assembler and would have been tossed anyway.  I ran into problems before I knew this and megahit thought it had single end reads in the file I gave it because it was silently tossing short reads.

'/mnt/EXT/Schloss-data/kiverson/sickle-master/sickle pe -c ${sample_name}.lane1.paired.fastq -m ${sample_name}.lane1.paired.trimmed.fastq -s ${sample_name}.lane1.orphan.trimmed.fastq -t sanger -q 25 -l 21
/mnt/EXT/Schloss-data/kiverson/sickle-master/sickle pe -c ${sample_name}.lane2.paired.fastq -m ${sample_name}.lane2.paired.trimmed.fastq -s ${sample_name}.lane2.orphan.trimmed.fastq -t sanger -q 25 -l 21

#rm *paired.fastq

cat ${sample_name}.lane1.paired.trimmed.fastq ${sample_name}.lane2.paired.trimmed.fastq > ${sample_name}.paired.trimmed.pooled.fastq
awk '{print ">" substr($0,2);getline;print;getline;getline}' ${sample_name}.paired.trimmed.pooled.fastq > ${sample_name}.paired.trimmed.pooled.fasta
cat ${sample_name}.lane1.orphan.trimmed.fastq ${sample_name}.lane2.orphan.trimmed.fastq > ${sample_name}.orphan.trimmed.pooled.fastq
awk '{print ">" substr($0,2);getline;print;getline;getline}' ${sample_name}.orphan.trimmed.pooled.fastq > ${sample_name}.orphan.trimmed.pooled.fasta

#rm *.trimmed.fastq *.pooled.fastq *.paired.fastq

cat ${sample_name}.paired.trimmed.pooled.fasta ${sample_name}.orphan.trimmed.pooled.fasta > ${sample_name}.trimmed.pooled.all.fasta
 
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.paired.trimmed.pooled.fasta > ${sample_name}.paired.trimmed.pooled.fasta.summary
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.orphan.trimmed.pooled.fasta > ${sample_name}.orphan.trimmed.pooled.fasta.summary
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.trimmed.pooled.all.fasta > ${sample_name}.trimmed.pooled.all.fasta.summary'

The seq_stats.py script that keeps showing up is a small python script I wrote to quickly assess sequence files for some standard metrics you can judge assemble quality with like N50, L50, N90, etc.  
Next I used the khmer package from Titus Brown's lab to normalize read count by kmer abundance to a coverage of 10 (what he uses in his metagenomic assemblies).

'module rm gcc/4.6.4
module add python/2.7.9 gcc/4.9.2 khmer

normalize-by-median.py -p -k 20 -C 10 -N 4 -x 1e9 --savegraph normC10k20.kh ${sample_name}.paired.trimmed.pooled.fasta
filter-abund.py -C 50 -V normC10k20.kh ${sample_name}.paired.trimmed.pooled.fasta.keep
extract-paired-reads.py -p ${sample_name}.trimmed.pooled.diginorm.paired.fasta -s ${sample_name}.trimmed.pooled.diginorm.single.fasta ${sample_name}.paired.trimmed.pooled.fasta.keep.abundfilt
normalize-by-median.py --force_single --loadgraph normC10k20.kh ${sample_name}.orphan.trimmed.pooled.fasta
filter-abund.py -C 50 -V normC10k20.kh ${sample_name}.orphan.trimmed.pooled.fasta.keep -o ${sample_name}.orphan.trimmed.pooled.keep.fasta
cat ${sample_name}.trimmed.pooled.diginorm.single.fasta ${sample_name}.orphan.trimmed.pooled.keep.fasta > ${sample_name}.trimmed.pooled.diginorm.orphan.fasta

rm *.keep *.se *.pe *.kh *.abundfilt *.single.fasta

python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.trimmed.pooled.diginorm.paired.fasta > ${sample_name}.trimmed.pooled.diginorm.paired.fasta.summary
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.trimmed.pooled.diginorm.orphan.fasta > ${sample_name}.trimmed.pooled.diginorm.orphan.fasta.summary

cat *.summary > preassembly.summaries
rm *.summary'

### Assembly

Megahit is super easy, blazing fast, and really good at it's job.  I'll list some stats in my next post when the jobs finish, but it is had-and-shoulders better than other assemblers I've tried. 
[Amanda Agelmore](http://agelmore.github.io/) in our lab has found similar results.  I used both the normalize paired-end and orphaned reads to maximize my coverage of each metagenome.

'cp /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/fastq/${sample_name}.trimmed.pooled.diginorm.paired.fasta ./
cp /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/fastq/${sample_name}.trimmed.pooled.diginorm.orphan.fasta ./

python /home/mljenior/bin/megahit/megahit -m 45e9 -l 251 --12 ${sample_name}.trimmed.pooled.diginorm.paired.fasta -r ${sample_name}.trimmed.pooled.diginorm.orphan.fasta --cpu-only --k-max 127 -o ${sample_name}.megahit

python /share/scratch/bin/removeShortContigs.py ${sample_name}.megahit/final.contigs.fa ${sample_name}.megahit/${sample_name}.final.contigs.251.fa 251

python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.megahit/${sample_name}.final.contigs.251.fa > ${sample_name}.megahit/${sample_name}.final.contigs.251.fa.summary

rm *.fasta'

### Annotation and read-mapping

I used [MGA](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2608843/) for gene calling and BLASTed the translated peptide sequences against [KEGG](http://www.genome.jp/kegg/kegg1a.html) which his what I used to construct 
the metabolic networks I discussed in a previous post.  I have two methods for that based on work frrom [Elhanan Borenstein](http://elbo.gs.washington.edu/pub/eoe_borens_pnas.pdf) and [Jens Nielsen](http://www.pnas.org/content/102/8/2685.short) which I am excited to use downstream.  

'/share/scratch/bin/mga /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/assembly/${sample_name}.megahit/${sample_name}.final.contigs.251.fa -m > ${sample_name}.final.contigs.251.mga.out

python /share/scratch/bin/getgenesbypos.py ${sample_name}.final.contigs.251.mga.out /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/assembly/${sample_name}.megahit/${sample_name}.final.contigs.251.fa ${sample_name}.genes.faa ${sample_name}.genes.fna

python /share/scratch/bin/removeShortContigs.py ${sample_name}.genes.fna ${sample_name}.genes.250.fna 250
python /share/scratch/bin/removeShortContigs.py ${sample_name}.genes.faa ${sample_name}.genes.80.faa 80

python /home/mljenior/scripts/format_fasta.py ${sample_name}.genes.250.fna ${sample_name}.genes.250.format.fna
python /home/mljenior/scripts/format_fasta.py ${sample_name}.genes.80.faa ${sample_name}.genes.80.format.faa

python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.genes.250.format.fna > ${sample_name}.genes.250.format.fna.summary
python /mnt/EXT/Schloss-data/seq_stats.py ${sample_name}.genes.80.format.faa > ${sample_name}.genes.80.format.faa.summary

blastp -query ${sample_name}.genes.80.format.faa -db /mnt/EXT/Schloss-data/kegg/kegg/genes/fasta/kegg_prot_blast.db -num_threads 16 -evalue 5e-4 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -outfmt 6 -max_target_seqs 1 -out ${sample_name}.protVprot.out'

I simply used [Bowtie](http://bowtie-bio.sourceforge.net/manual.shtml) to map reans to called genes.

'/home/mljenior/bin/bowtie/bowtie-build ${sample_name}.genes.250.format.fna ${sample_name}_gene_database

/home/mljenior/bin/bowtie/bowtie ${sample_name}_gene_database -f /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/fastq/${sample_name}.trimmed.pooled.all.fasta -p 4 -S ${sample_name}.reads2genes.sam

samtools view -bS ${sample_name}.reads2genes.sam > ${sample_name}.reads2genes.bam
samtools sort ${sample_name}.reads2genes.bam ${sample_name}.reads2genes.sorted
samtools index ${sample_name}.reads2genes.sorted.bam
samtools idxstats ${sample_name}.reads2genes.sorted.bam > ${sample_name}.mapped2genes.txt 

rm *.ebwt *.bcf *ai *.bam ${sample_name}_gene_database*'

### Quality control

One step (among others) of quality control I do is counting the number of curated reads that actually map back to the assembled contigs.  This metric is a way of telling if what you assembled actually looks like what you sequenced in the first place.

'cp /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/assembly/${sample_name}.megahit/${sample_name}.final.contigs.251.fa ./
/home/mljenior/bin/bowtie/bowtie-build ${sample_name}.final.contigs.251.fa ${sample_name}_contig_database

/home/mljenior/bin/bowtie/bowtie ${sample_name}_contig_database -f /mnt/EXT/Schloss-data/matt/metagenomes_HiSeq/${sample_name}/fastq/${sample_name}.trimmed.pooled.all.fasta -p 4 -S ${sample_name}.aligned.sam

samtools view -bS ${sample_name}.aligned.sam > ${sample_name}.aligned.bam
samtools sort ${sample_name}.merged.pe.se.aligned.megahit.bam ${sample_name}.merged.pe.se.aligned.megahit.sorted
samtools index ${sample_name}.merged.pe.se.aligned.megahit.sorted.bam
samtools idxstats ${sample_name}.merged.pe.se.aligned.megahit.sorted.bam > ${sample_name}.mapped2contigs.txt 

rm *.ebwt *.bcf *ai *.bam ${sample_name}_contig_database*'


I've revamped the pipeline in the last couple of days so when I have the quality metrics tomorrow when it's done I'll write another post about that.  