---
layout: post
title:  "Programmer time vs user time"
date:   2014-11-11
comments: true
---

Or, should I bother with C arrays in python?

Answer: It depends on if you're paid by walltime or cpu time.

I love data. The only thing I love more than data is data _about_ data or metadata in the parlance of my profession. In fact, my favorite data is data about how my code analyzes data.

{% include image.html url="/assets/timecost.png" description="Also why I wish I was paid hourly xkcd.com/1445/" %}


Yesterday's N50 calculation got me thinking, can I do it faster if I use C data structures?

Not faster, but smaller, and that's not necessarily an improvement for what we're doing. Python's array module is basically a python wrapper for a C array. Let's have a look at some code.

{% highlight python%}

from array import array
import time as t
import random as r
import sys

def n50_array(lenList):
	lenarray = array('I')
	lenList.sort()
	for x in lenList:
		lenarray.extend([x]*x)

	print "size of array: ", sys.getsizeof(lenarray)*1e-9
	#if the list length is even return mean of middle elements,
	#else return middle number
	if len(lenarray) % 2 == 0:
		medianpos = len(lenarray)/2
		print "array N50", float(lenarray[medianpos] + lenarray[medianpos-1]) / 2
	else:
		medianpos = len(nlenarray)/2
		print "array N50", lenarray[medianpos]

def n50_list(lenList):
	tmplist = []
	lenList.sort()
	for x in lenList:
		tmplist += [x]*x

	print "size of list: ", sys.getsizeof(tmplist)*1e-9
	#if the list length is even return mean of middle elements,
	#else return middle number
	if len(tmplist) % 2 == 0:
		medianpos = len(tmplist)/2
		print "list N50", float(tmplist[medianpos] + tmplist[medianpos-1]) / 2
	else:
		medianpos = len(tmplist)/2
		print "list N50", tmplist[medianpos]


t0 = t.time()
lengthlist = [r.randint(20,9001) for x in range(0, 50000)]

print t.time() - t0, "seconds of walltime to generate list"
print "size of initial list: ", sys.getsizeof(lengthlist)*1e-9

t0 = t.clock()
n50_list(lengthlist)
print t.clock() - t0, "seconds of processer time list"

t0 = t.clock()
n50_array(lengthlist)
print t.clock() - t0, "seconds of processer time array"

t0 = t.time()
n50_list(lengthlist)
print t.time() - t0, "seconds of walltime list"

t0 = t.time()
n50_array(lengthlist)
print t.time() - t0, "seconds of walltime array"


{%endhighlight%}

And the output:

~~~~
[kiverson@axiom src]$ python testarray.py
0.100698947906 seconds of walltime to generate list
size of initial list:  0.000406504
size of list:  1.829612104
list N50 6353.0
2.67 seconds of processer time list
size of array:  0.9020866
array N50 6353.0
27.82 seconds of processer time array
size of list:  1.829612104
list N50 6353.0
2.62258696556 seconds of walltime list
size of array:  0.9020866
array N50 6353.0
27.8311021328 seconds of walltime array
~~~~

Wow, the C array is half the size but took a HUGE amount of time to build. To figure out what's going on here let's first look at some [bytecode](https://en.wikipedia.org/wiki/Bytecode).

array bytecode

~~~~

 10          22 SETUP_LOOP              34 (to 59)
             25 LOAD_FAST                0 (lenList)
             28 GET_ITER
        >>   29 FOR_ITER                26 (to 58)
             32 STORE_FAST               2 (x)

 11          35 LOAD_FAST                1 (lenarray)
             38 LOAD_ATTR                2 (extend)
             41 LOAD_FAST                2 (x)
             44 BUILD_LIST               1
             47 LOAD_FAST                2 (x)
             50 BINARY_MULTIPLY
             51 CALL_FUNCTION            1
             54 POP_TOP
             55 JUMP_ABSOLUTE           29
        >>   58 POP_BLOCK
~~~~

list bytecode

~~~~
 27          16 SETUP_LOOP              31 (to 50)
             19 LOAD_FAST                0 (lenList)
             22 GET_ITER
        >>   23 FOR_ITER                23 (to 49)
             26 STORE_FAST               2 (x)

 28          29 LOAD_FAST                1 (tmplist)
             32 LOAD_FAST                2 (x)
             35 BUILD_LIST               1
             38 LOAD_FAST                2 (x)
             41 BINARY_MULTIPLY
             42 INPLACE_ADD
             43 STORE_FAST               1 (tmplist)
             46 JUMP_ABSOLUTE           23
        >>   49 POP_BLOCK
~~~~

Hmm, looks like they're both implementing a similar number of functions. Let's see how they're used.

~~~~
size of list:  1.962480896
list N50 6345.0
         7 function calls in 2.622 seconds

   Ordered by: standard name

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.656    0.656    2.622    2.622 <string>:1(<module>)
        1    1.946    1.946    1.966    1.966 testarray.py:25(n50_list)
        2    0.000    0.000    0.000    0.000 {len}
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
        1    0.020    0.020    0.020    0.020 {method 'sort' of 'list' objects}
        1    0.000    0.000    0.000    0.000 {sys.getsizeof}


size of array:  0.9020866
array N50 6345.0
         50007 function calls in 28.014 seconds

   Ordered by: standard name

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.053    0.053   28.014   28.014 <string>:1(<module>)
        1    1.091    1.091   27.961   27.961 testarray.py:8(n50_array)
        2    0.000    0.000    0.000    0.000 {len}
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
    50000   26.866    0.001   26.866    0.001 {method 'extend' of 'array.array' objects}
        1    0.003    0.003    0.003    0.003 {method 'sort' of 'list' objects}
        1    0.000    0.000    0.000    0.000 {sys.getsizeof}

~~~~

Holy cats! Look at how many function calls the array uses. We're calling extend each time we add a number to the array. Building a python list is MUCH more efficient. Here's the trade off you have to make. Is building the list more important than what you do with it? In this case we're not doing much with the list of contig sizes, just trying to find the middle value so the python list works fine for what we need. If we were going to do some calculations with this list then it might be worth the time to bulid the compact C array because the calculations would be much faster.

This is where I would show you how to implement the N50 claculation in C itself but I'm not paid hourly.
