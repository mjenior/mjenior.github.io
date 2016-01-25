---
layout: post
title:  "Subsampling"
date:   2015-12-26 17:55:47
comments: true
tags: []
image:
  feature: abstract-12.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
---

After all of the filtering is done, I'm now finally ready to subsample the read files.  Also, since the 
awk one-liners for subsampling isn't working I wrote my own in python.

Below are the totals of reads per file.  The goal is to subsample the groups of reads (paired and orphan) to 
the lowest acceptable value among them.  

	Condition 1 - Plus
	read 1:  164655029
	read 2:  164655029
	orphan:  14957436

	Condition 1 - Minus
	read 1:  147430303
	read 2:  147430303
	orphan:  14500000

	Condition 2 - Plus
	read 1:  113675146
	read 2:  113675146
	orphan:  11505508

	Condition 2 - Minus
	read 1:  110752263
	read 2:  110752263
	orphan:  12084021

	Condition 3 - Plus
	read 1:  126954804
	read 2:  126954804
	orphan:  16455611

	Condition 3 - Minus
	read 1:  115484599
	read 2:  115484599
	orphan:  11895524

	Negative Control - Plus
	read 1:  138811772
	read 2:  138811772
	orphan:  11936178

	Positive Control - Plus
	read 1:  170018546
	read 2:  170018546
	orphan:  19394415
	
This is great news.  It looks like I still have >100 million paired-end reads and >10 million orphaned reads 
are left per sample after subsampling.  I'll post some rarefaction curves when I get them.

The awk commands I found are not working properly, so I wrote this python script to subsample both the interleaved 
pair-end and single-end reads.  Make sure you install argparse before trying to use it though!

	#!/usr/bin/env python
	'''USAGE: subsample_fasta.py file.fasta --size n --total n' --pair y/n
	Randomly subsamples a fasta file to the given size, handles both single and paired-end read data
	'''
	
	# It's important to know the correct number of sequences per file for this script to run properly,
	# please run seq_stats.py prior to running subsample_fasta.py

	import sys
	import random
	import argparse


	parser = argparse.ArgumentParser(description='Subsample reads from a fasta file.')
	parser.add_argument('newfile')
	parser.add_argument('--size', default=0, help='Number of sequences to subsample (# of pairs for paired-end)')
	parser.add_argument('--total', default=0, help='Total number of sequences in the fasta file')
	parser.add_argument('--pair', default='n', help='Indicates if the file is interleaved, pired-end reads')
	args = parser.parse_args()

	if int(args.size) == 0 or int(args.total) == 0:
		print('ERROR: File or subsample value are of size 0')
		sys.exit()


	# Check if the subsample is that same or larger than the total sequence count, and then
	# generates a random list of positions to pick from fasta file
	print 'Creating subsampling distribution...'

	if args.pair == 'n':
		sample_list = range(1, int(args.total) + 1)
		if int(args.size) >= int(args.total):
			sample_list = set(sample_list)
			print 'Subsample size is greater than or equal to the total number of sequences.  Using all sequences.'
		else:
			sample_list = set(sorted(random.sample(sample_list, int(args.size) + 1)))
	elif args.pair == 'y':
		sample_list = range(1, int(args.total) + 1, 2)
		if int(args.size) >= int(args.total):
			sample_list = set(sample_list)
			print 'Subsample size is greater than or equal to the total number of sequences.  Using all sequences.'
		else:
			sample_list_forward = sorted(random.sample(sample_list, int(args.size) + 1))
			sample_list_reverse = []
			for index in sample_list_forward: sample_list_reverse.append(index + 1)
			sample_list = set(sorted(sample_list_forward + sample_list_reverse))
	elif args.pair not in ['y', 'n']:
		print('ERROR: Invalid input file type')
		sys.exit()
	
	
	# Name and open output file
	outfile_str = str(args.newfile).rstrip('fasta') + 'pick.fasta' 
	outfile = open(outfile_str, 'w')

	# Create logfile of subsampling
	logfile_str = str(args.newfile).rstrip('fasta') + 'pick.log' 
	logfile = open(logfile_str, 'w')

	# Label the input as pe or se
	if args.pair == 'y':
		file_type = 'Paired-end'
	else:
		file_type = 'Single-end'

	log_str = '''Input file name: {infile}
	Input file type:  {type}
	Output file name: {outfile}
	Total sequences: {total}
	Subsample size: {size}
	'''.format(infile=str(args.newfile), type=file_type, outfile=outfile_str, total=str(args.total), size=str(int(args.size)))
	logfile.write(log_str)
	logfile.close()

	# Open and begin looping through fasta file and picking sequences
	print 'Writing subsampled fasta file...'
	with open(args.newfile, 'r') as infile:
	
		outfile = open(outfile_str, 'w')
	
		seq_count = 0
		include = 0
		iteration = 0
		pair_include = 0
	
		for line in infile:
		
			line = line.strip()
		
			if line[0] == '>':
				
				include = 0
				seq_count += 1
				iteration += 1
				
				if iteration == 10000:
					iteration = 0
					progress_str = str(seq_count) + ' of ' + str(args.total)
					print(progress_str)

				if seq_count in sample_list:
					sample_list.discard(seq_count)
					outfile.write(line)
					outfile.write('\n')
					include = 1
					continue
					
			elif line[0] != '>' and include == 1: 
				outfile.write(line)
				outfile.write('\n')
				continue
					
		
	outfile.close()			
	print 'Done.'

	
I streamlined the process as much as possible by making it only necessary to loop through the large 
fastas a single time.  It also prints a logfile so you can remember what the heck you did in a month.

After all of the filtering and tweaking the subsampling algorithm, the jobs are finally running.  As soon 
as they finish, I'll map the residual reads to the C. difficile 630 genome and get some useable data.
		

	
	