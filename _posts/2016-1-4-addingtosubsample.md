---
layout: post
title:  "Adding Features to Subsampling Script"
date:   2016-1-4 17:55:47
comments: true
---


I ran in to an instance that I needed to subsample separate forward and reverse read files equally.  I ran in to an issue 
when I realized that python doesn't duplicate variables during assignment.  I figured out a workaround using [deepcopy](https://docs.python.org/2/library/copy.html), 
but an even better solution was to use [izip](https://docs.python.org/2/library/itertools.html) (a part of itertools).  In this way I can loop through 
both reads and sample them simultaneously.

I am still running some tests, but here is the updated code:


	#!/usr/bin/env python
	'''USAGE: subsample_fasta.py file.fasta --size n --total n' --pair y/n
	Randomly subsamples a fasta file to the given size, handles both single and paired-end read data
	'''
	
	# It's important to know the correct number of sequences per file for this script to run properly,
	# please run seq_stats.py prior to running subsample_fasta.py
	
	import sys
	import random
	import argparse
	from itertools import izip
	
	
	parser = argparse.ArgumentParser(description='Subsample reads from a fasta file.')
	parser.add_argument('--reads', default='none', help='Single-end or interleaved paire-end read file')
	parser.add_argument('--forward', default='none', help='Forward paired-end read.')
	parser.add_argument('--reverse', default='none', help='Reverse paired-end read.')
	parser.add_argument('--size', default=0, help='Number of sequences to subsample (# of pairs for paired-end)')
	parser.add_argument('--total', default=0, help='Total number of sequences in the fasta file')
	parser.add_argument('--paired', default='n', help='Indicates if the file(s) are paired-end reads')
	args = parser.parse_args()
	
	if int(args.size) == 0 or int(args.total) == 0:
		print('ERROR: File or subsample value are of size 0')
		sys.exit()
	elif args.reads == 'none':
		if args.forward == 'none' or args.reverse == 'none':
			print('ERROR: Input file(s) not provided')
			sys.exit()
		
		
	# Check if the subsample is that same or larger than the total sequence count, and then
	# generates a random list of positions to pick from fasta file
	print 'Creating subsampling distribution...'
	
	if args.paired == 'n':
		sample_list = range(1, int(args.total) + 1)
		if int(args.size) >= int(args.total):
			sample_list = set(sample_list)
			print 'Subsample size is greater than or equal to the total number of sequences.  Using all sequences.'
		else:
			sample_list = set(sorted(random.sample(sample_list, int(args.size))))
	elif args.paired == 'y' and args.forward == 'none' and args.reverse == 'none':
		sample_list = range(1, int(args.total) + 1, 2)
		if int(args.size) >= int(args.total):
			sample_list = set(sample_list)
			print 'Subsample size is greater than or equal to the total number of sequences.  Using all sequences.'
		else:
			sample_list_forward = sorted(random.sample(sample_list, int(args.size)))
			sample_list_reverse = []
	
			# These steps add the pair to each of the 
			for index in sample_list_forward: sample_list_reverse.append(index + 1)
			sample_list = set(sorted(sample_list_forward + sample_list_reverse))
	elif args.paired == 'y' and args.forward != 'none' and args.reverse != 'none':
		sample_list = range(1, int(args.total) + 1)
		if int(args.size) >= int(args.total):
			sample_list = set(sample_list)
			print 'Subsample size is greater than or equal to the total number of sequences.  Using all sequences.'
		else:
			sample_list = set(sorted(random.sample(sample_list, int(args.size))))		
	elif args.paired not in ['y', 'n']:
		print('ERROR: Invalid input file type')
		sys.exit()
		
	
	# Label the input as pe or se
	if args.paired == 'y':
		file_type = 'Paired-end'
	else:
		file_type = 'Single-end'
	
	if args.paired == 'y' and args.forward != 'none' and args.reverse != 'none':
		# Name and open output file
		outfile_str1 = str(args.forward).rstrip('fasta') + 'pick.fasta' 
		outfile1 = open(outfile_str1, 'w')
		outfile_str2 = str(args.reverse).rstrip('fasta') + 'pick.fasta' 
		outfile2 = open(outfile_str2, 'w')
	
		# Create logfile of subsampling
		logfile_str = str(args.reads).rstrip('fasta') + 'pick.log' 
		logfile = open(logfile_str, 'w')
	
		log_str = '''Input file names : {infile1} {infile2}
	Input file types:  {type}
	Output file names: {outfile1} {outfile2}
	Total sequences: {total}
	Subsample size: {size}
	'''.format(infile1=str(args.forward), infile2=str(args.reverse), type=file_type, outfile1=outfile_str1, outfile2=outfile_str2, total=str(args.total), size=str(int(args.size)))
		logfile.write(log_str)
		logfile.close()
	else:
		# Name and open output file
		outfile_str = str(args.reads).rstrip('fasta') + 'pick.fasta' 
		outfile = open(outfile_str, 'w')
	
		# Create logfile of subsampling
		logfile_str = str(args.reads).rstrip('fasta') + 'pick.log' 
		logfile = open(logfile_str, 'w')
		log_str = '''Input file name: {infile}
	Input file type:  {type}
	Output file name: {outfile}
	Total sequences: {total}
	Subsample size: {size}
	'''.format(infile=str(args.reads), type=file_type, outfile=outfile_str, total=str(args.total), size=str(int(args.size)))
		logfile.write(log_str)
		logfile.close()
	
	# Open and begin looping through fasta file and picking sequences
	print 'Writing subsampled fasta file...'
	
	if args.paired == 'y' and args.forward != 'none' and args.reverse != 'none':
		
		seq_count = 0
		include = 0
		iteration = 0
		
		for line_1, line_2 in izip(open(args.forward, 'r'), open(args.reverse, 'r')):
		
			if line_1[0] == '>':
			
				include = 0
				seq_count += 1
				iteration += 1
			
				if iteration == 10000:
					iteration = 0
					progress_str = str(seq_count) + ' of ' + str(args.total)
					print(progress_str)
	
				if seq_count in sample_list:
					sample_list.discard(seq_count)
					outfile1.write(line_1)
					outfile2.write(line_2)
					include = 1
					continue
		
			elif line_1[0] != '>' and include == 1: 
					outfile1.write(line_1)
					outfile2.write(line_2)
					continue
						
		outfile1.close()
		outfile2.close()
		
	
	else:
		with open(args.reads, 'r') as infile:
			
			seq_count = 0
			include = 0
			iteration = 0
		
			for line in infile:
					
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
						include = 1
						continue
			
				elif line[0] != '>' and include == 1: 
						outfile.write(line)
						continue
							
		outfile.close()			
	
	
	print 'Done.'
	
	
Hopefully, the alignments I'm using the subsampled reads for are done soon so I can finally talk about something else in the next post.
		