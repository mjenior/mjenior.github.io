---
layout: post
title:  "Actually running khmer"
date:   2014-11-06
comments: true
---

Yesterday I got my feet wet with the latest and greatest version of [khmer](https://github.com/ged-lab/khmer) and a few things have changed since I last updated my local copy. The algorithms behind the scenes have stayed the same but there are a few syntax differences. Bring in the humble shell script to the rescue.

You should never do what a computer can do just as poorly so I try and script as much of my analysis as possible. Below is a little shell script that will run the digital normalization portion of khmer. This is an embedded gist from github and should update as the script inevitably evolves. It's a public repo so if you're a cool guy* you can edit it too.

{% gist 0b401eed38ca870ddc65 %}

A note on the default values for k, c and x. They are just that, defaults. The goal of digital normalization is to get even coverage of all your k-mers. Picking a value of 20 for c is basically saying I want all my k-mers to have no more (and ideally no less) than a 20x coverage when they go to the assembler. If this sounds reasonable, go for it. If you have no idea, try it out and see what your assembly looks like. Since it's in a cool guy* script you can use a for loop or GNU parallel to run a bunch of different values at once. Most assemblers will output the estimated coverage and you can compare this to what when in. If it's way off you can always adjust it and try again.

Getting a good k-mer value is always tricky. Smart people already have [smart things](http://arxiv.org/abs/1309.2975) to say about this topic so I can't do it justice here. If you'd like to ride the struggle bus with me I'll try to wade through it in a future post.

*cool guy is a gender neutral pronoun, just ask Finn.
![Finn]({{ kdiverson.github.io }}/assets/cool_guy.jpg)
