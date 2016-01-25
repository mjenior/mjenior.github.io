---
layout: post
title:  "Annotating KEGG Gene Mapping with Pathway Information"
date:   2016-1-11 17:55:47
comments: true
tags: []
image:
  feature: abstract-3.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
---

After mapping transcriptomic reads to the KEGG gene database, you get a file that looks like the following:

	cdf:CD630_00010|dnaA;_chromosomal_replication_initiation_protein        1320    108     0
	cdf:CD630_00020|dnaN;_DNA_polymerase_III_subunit_beta_(EC:2.7.7.7)      1107    59      0
	cdf:CD630_00030|RNA-binding_mediating_protein   207     6       0
	cdf:CD630_00040|recF;_DNA_replication_and_repair_protein_RecF   1116    41      0
	cdf:CD630_00050|gyrB;_DNA_gyrase_subunit_B_(EC:5.99.1.3)        1902    224     0
	cdf:CD630_00060|gyrA;_DNA_gyrase_subunit_A_(EC:5.99.1.3)        2427    544     0
	...
	
The columns represent:  Target name, length of target sequence, number of mapped reads, number of unmapped partner sequences after counterpart matching.  The only 
ones we care about right now are the name of the target and how many reads mapped to it.  The problem is, reporting the gene name doesn't really 
help anyone because if you report more than 10 in a figure it gets way too dense.  To simplify reporting the results, it helps to label each gene with the pathway 
it is a part of.  This reduces the number of possible categories and makes it easier to label figures like the linear correlations in [Franzosa et al., (2014)](http://www.ncbi.nlm.nih.gov/pubmed/24843156).
	
An important note is that the reference fastas that you will be mapping to are not in a great format.  You'll lose a lot of important information when bowtie makes the database 
as it splits the name on whitespace and only takes the first element.  The original file looks like this:

	>cdf:CD630_00010  dnaA; chromosomal replication initiation protein
	atggatatagtttctttatgggacaaaaccctacaattaataaaaggtgacttaacttca
	gtaagttttaataccttttttaaaaacatcgtaccattaaaaatacatcttaatgattta
	atcttactggctcctagtgattttaataaagatatcttagagaatagatatttacattta
	...

And you want something that looks like this:

	>cdf:CD630_00010|dnaA;_chromosomal_replication_initiation_protein
	ATGGATATAGTTTCTTTATGGGACAAAACCCTACAATTAATAAAAGGTGACTTAACTTCAGTAAGTTTTAATACCTTTTTTAAAAACATCGTACCATTAAAAATACATCTTAATGATTTAATCTTACTGGCTCCTAGTGATTTTAATAAAGATATCTTAGAGAATAGATATTTACATTTA
	...

Here's a script to bridge that gap:

	#!/bin/python

	# USAGE: format_fasta.py input_file

	import sys

	infile = open(sys.argv[1], 'r')
	out_str = str(seq_name).rstrip('.fasta') + '.format.fasta'

	temp_seq = ''
	current = 0

	with open(out_str, 'w') as outfile:
		for line in infile:

			if line == '\n': continue
	
			line = line.strip()
		
			if line[0] == '>':
				if current != 0: outfile.write(temp_seq + '\n')
				seq_name = '|'.join(line.split('  '))
				seq_name = seq_name.replace(' ', '_')
				outfile.write(seq_name + '\n')
				temp_seq = ''
				current += 1
				continue
			
			else:
				temp_seq = temp_seq + line.upper()
		
		outfile.write(temp_seq)

	infile.close()


The first step in the process of connecting the gene IDs to the relevant pathway information for each.  The KEGG reference files are large and cumbersome, so the easiest 
way to handle them repeatedly is the turn them into manageable python dictionaries and then pickle them so they only need to be actually constructed once.  In case you were wondering, 
a pickle in python is where you convert an object hierarachy into a byte stream. This is great because then you can save it as a file and open it up later as an already 
formed python data structure.  A guide can be found [here](https://docs.python.org/2/library/pickle.html).

The files we need to use are going to be used for the gene code to pathway code and pathway code to pathway category translation.  Here's my code to create pickles of both KEGG reference files:
	
	#!/usr/bin/env python
	'''USAGE:  python kegg_pkl.py
	Creates python pickle objects of KEGG reference files as dictionaries
	'''
	
	import pickle
	import re
	import time
	
	start_time = time.time()
	
	log_file = open('ref_log.txt', 'w')
	
	# Create smaller dictionary first
	log_file.write('Making pathway category dictionary...\n')
	with open('/mnt/EXT/Schloss-data/kegg/kegg/pathway/pathway.list', 'r') as pathway_file:
		
		pathway_dict = {}
		
		for line in pathway_file:
		
			line = line.strip()
			
			if line[1] == '#':
				category = line.strip('##')
				continue
			elif line[0] == '#':
				group = line.strip('#')
				continue
			else:
				temp = line.split('\t')
				pathway_code = temp[0]
				pathway_name = temp[1]
				entry = pathway_name + ';' + group + ';' + category
				pathway_dict[pathway_code] = entry
	
	#		Example entry:  '01100' = 'Metabolic pathways;Global and overview maps;Metabolism'
	log_file.write('Done\n')
		
	log_file.write('Writing pathway dictionary to file...\n')
	with open('pathway.pkl', 'wb') as outfile1:
		pickle.dump(pathway_dict, outfile1)	
	pathway_dict = None
	log_file.write('Done\n')
	
	
	log_file.write('Making gene code to KO dictionary...\n')
	with open('/mnt/EXT/Schloss-data/matt/seeds/support/ko_genes.list','r') as ko_file:
		
		ko_dict = {}
	
		for line in ko_file:
		
			ko = line.split()[0]
			ko = ko.strip('ko:')
			
			gene = line.split()[1]
			gene = gene.strip()
					
			ko_dict[gene] = ko
			
	#	Example entry:  'cdf:CD630_00010' = 'K02313'
	
	log_file.write('Done\n')
	
	log_file.write('Writing ko dictionary to file...\n')
	with open('ko.pkl', 'wb') as outfile2:
		pickle.dump(ko_dict, outfile2)	
	ko_dict = None
	log_file.write('Done\n')
	
	
	log_file.write('Making gene to pathway dictionary...\n')
	with open('/mnt/EXT/Schloss-data/kegg/kegg/genes/links/genes_pathway.list', 'r') as gene_file:
		
		gene_set = set()
		gene_dict = {}
		
		for line in gene_file:
			temp = line.split()
			gene = temp[0]
			pathway = temp[1]
			pathway = re.sub('[^0-9]', '', pathway)
			
			if not gene in gene_set:
				gene_set.update(gene)
				gene_dict[gene] = [pathway]
			else:
				gene_dict[gene].append(pathway)
	
	#	Example entry:  'hsa:10' = ['00232', '00983', '01100' , '05204']
	gene_set = None
	log_file.write('Done\n')
	
	log_file.write('Writing gene dictionary to file...\n')
	with open('gene.pkl', 'wb') as outfile3:
		pickle.dump(gene_dict, outfile3)
	log_file.write('Done\n')	
	
	end_time = int(time.time() - start_time)
	time_str = 'It took ' + str(end_time) + ' seconds to complete.'
	
	log_file.write(time_str)
	
	log_file.close()
	
	
You might notice that during the construction of the second, larger dictionary that I create a set containing gene IDs and reference it iteratively.  
Specifically, [sets](https://docs.python.org/2/library/sets.html) are unordered collections of unique elements.  Since they are not indexed, have no order, and each element 
appears only once, they are great for membership checking.  If I were to use just the dictionary to check membership using something like...

	if not gene in gene_dict:
		gene_dict[gene] = [pathway]
	else:
		gene_dict[gene].append(pathway)
	
The run time of a script containing this would take several orders of magnitude more time to complete that doing the membership test using a set instead.
	
	
The next step is to run the code that will use the libraries I just made and annotate the bowtie output to be a little more useful.  It looks like this:

	#!/usr/bin/env python
	'''USAGE:  python annotate_bowtie.py human_readable_bowtie_results read_length
	Annotates human readable bowtie mapping files with pathway information from KEGG
	'''
	
	import sys
	import pickle
	import time
		
	
	def read_alignment(infile):
	
		with open(infile, 'r') as bowtie:
			
			mapped_list = []
		
			for line in bowtie:
			
				if line[0] != '*':
					
					target = line.split()[0]
					target = target.split('|')
					
					gene_code = target[0]
					
					gene_name = ' '.join(target[1:])
					
					mapped = str(line.split()[2])
					
					length = str(line.split()[1])
					
					if mapped == 0:
						continue
						
					else:
						mapped_list.append([gene_code, gene_name, mapped, length])
					
		return(mapped_list)
	
	
	def translate_gene(gene_list, gene_d, ko_d, pathway_d, read):
	
		output_list = []
		
		for index_1 in gene_list:
			
			code = index_1[0]
			gene = index_1[1]
			count = int(index_1[2])
			length = int(index_1[3])
			
			# Normalize read count to gene length
			norm = str((count * read) / length)
					
			try:
				ko = ko_d[code]
			except KeyError:
				ko = 'ko_key_error'
		
			try:
				pathways = gene_d[code]
			except KeyError:
				entry = '\t'.join([norm, code, gene, ko, 'path_key_error', 'metadata_key_error', 'metadata_key_error', 'metadata_key_error'])
				output_list.append(entry)
				continue
	
			for index_2 in pathways:
			
				try:
					meta_pathway = pathway_d[str(index_2)]
				except KeyError:
					entry = '\t'.join([norm, code, gene, ko, str(index_2), 'metadata_key_error', 'metadata_key_error', 'metadata_key_error'])
					output_list.append(entry)
					continue
			
				info = meta_pathway.split(';')
				
				pathway = info[0]
				group = info[1]
				category = info[2]
	
				entry = '\t'.join([norm, code, gene, ko, str(index_2), pathway, group, category])
				output_list.append(entry)
	
		return(output_list)
	
	
	# Do the work
	print('Loading KEGG dictionaries...')
	with open('/mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/kegg/gene.pkl', 'rb') as gene_pkl:
		gene_dict = pickle.load(gene_pkl)
	with open('/mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/kegg/pathway.pkl', 'rb') as pathway_pkl:
		pathway_dict = pickle.load(pathway_pkl)
	with open('/mnt/EXT/Schloss-data/matt/metatranscriptomes_HiSeq/kegg/ko.pkl', 'rb') as ko_pkl:
		ko_dict = pickle.load(ko_pkl)	
	print('Done')
	
	print('Reading bowtie results...')
	mapped = read_alignment(sys.argv[1])
	print('Done')
	
	print('Translating pathway information...')
	read_len = int(sys.argv[2])
	translated = translate_gene(mapped, gene_dict, ko_dict, pathway_dict, read_len)
	mapped = None
	gene_dict = None
	ko_dict = None
	pathway_dict = None
	print('Done')
	
	print('Writing output to file...')
	outfile_str = str(sys.argv[1]).strip('.txt') + '.annotated.txt'
	with open(outfile_str, 'w') as outfile:
		for index in translated:
			out_string = ''.join(index) + '\n'
			outfile.write(out_string)
	translated = None
	print('Done')



Through trial and error I learned that you need to account for key errors just in case it doesn't find something in a dictionary.  This shouldn't happen in this instance 
but just to be sure.  The final output that will be made into figure looks like this:


	108     cdf:CD630_00010 dnaA;_chromosomal_replication_initiation_protein        K02313  02020   Two-component system    Environmental Information Processing    Signal transduction
	59      cdf:CD630_00020 dnaN;_DNA_polymerase_III_subunit_beta_(EC:2.7.7.7)      ko_key_error    path_key_error  metadata_key_error      metadata_key_error      metadata_key_error
	6       cdf:CD630_00030 RNA-binding_mediating_protein   K14761  path_key_error  metadata_key_error      metadata_key_error      metadata_key_error
	41      cdf:CD630_00040 recF;_DNA_replication_and_repair_protein_RecF   K03629  03440   Homologous recombination        Genetic Information Processing  Replication and repair

The columns are:  normalized read # followed by gene code, gene name, KEGG ortholog, pathway code, then some additional classifications.  As you can see there are a couple 
of key errors, but this is due to the fact that the annotation of some genes is incomplete in the KEGG reference files.

I'll be posted some figures with some R code I used to make them pretty soon hopefully.