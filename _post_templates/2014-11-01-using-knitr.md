---
layout: post
title:  "kntir demonstration"
date:   2014-11-01 13:38:47
comments: true
---

You can generate blog posts using the knitr R package. Don't be fooled, even
though it is an R package, it allows one to run commands in Python and bash.
Before you get going in knitr, be sure to see the Resources page for tutorials
on how to use knitr.

To get going, a template file should be copied from
`_post_templates/YYYY-MM-DD-knitr-post-name.Rmd`, put into the `_knitr` folder,
and renamed appropriately. Be sure to change the YAML front matter including the
date and the title of the post. The first time you ever create a knitr document
may need to run the following commands from the terminal:

    chmod +x render_post.R
    chmod +x render_post.sh
    pip install watchdog

Now you have three options for your workflow. The first is to bang out your knitr
document and then run:

    ./render_post.R 2014-11-04-using_knitr.Rmd

This will run the Rmd file and copy the markdown file into the `_posts` folder.
Alternatively, you could run:

    ./render_post.sh 2014-11-04-using_knitr.Rmd

If you already have the local version of the website loaded or you go ahead and
load it now, then whenever you hit refresh on your browser the page will be
updated.

The third option is to

Below is a minimal R markdown example that I've swiped from the [knitr GitHub site](https://github.com/yihui/knitr-examples/raw/master/001-minimal.Rmd) plus
some other goodies I've added to demonstrate that you can use bash and Python
commands within knitr documents.

----

# A minimal R Markdown example

A quote:

> Markdown is not LaTeX.


## code chunks

A _paragraph_ here. A code chunk below (remember the three backticks):


{% highlight r %}
1+1
{% endhighlight %}



{% highlight text %}
## [1] 2
{% endhighlight %}



{% highlight r %}
.4-.7+.3 # what? it is not zero!
{% endhighlight %}



{% highlight text %}
## [1] 5.551115e-17
{% endhighlight %}

## graphics

It is easy.


{% highlight r %}
plot(1:10)
{% endhighlight %}

![center](/../figs/2014-11-04-using-knitr/unnamed-chunk-2-1.png)

{% highlight r %}
hist(rnorm(1000))
{% endhighlight %}

![center](/../figs/2014-11-04-using-knitr/unnamed-chunk-2-2.png)

## inline code

Yes I know the value of pi is 3.1415927, and 2 times pi is 6.2831853.



## nested code chunks

You can write code within other elements, e.g. a list

1. foo is good

    {% highlight r %}
    strsplit('hello indented world', ' ')[[1]]
    {% endhighlight %}



    {% highlight text %}
    ## [1] "hello"    "indented" "world"
    {% endhighlight %}
2. bar is better


## bash code chunks

{% highlight bash %}
ls *.Rmd
{% endhighlight %}




{% highlight text %}
## 2014-11-04-using-knitr.Rmd
{% endhighlight %}


## python code chunks

{% highlight python %}
print "Hello, World!"
{% endhighlight %}




{% highlight text %}
## Hello, World!
{% endhighlight %}

## perl code chunks

{% highlight python %}
print "Hello, World!\n"
{% endhighlight %}




{% highlight text %}
## Hello, World!
{% endhighlight %}


## conclusion

Nothing fancy. You are ready to go. When you become picky, go to the [knitr website](http://yihui.name/knitr/).

![knitr logo](http://yihui.name/knitr/images/knit-logo.png)
