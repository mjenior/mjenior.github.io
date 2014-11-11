---
layout: post
title:  "Setting up Disqus"
date:   2014-11-01 13:43:47
comments: true
---

A widely used tool for commenting on blogs and websites is
[Disqus](https://disqus.com). Go ahead over there and in the upper right corner
of the page click the "Sign Up" button. Go through the registration steps and
then hurry back here and we'll  get started with adding
[Disqus](https://disqus.com/admin/create/) to your blog.

Now that you're registered, let's add Disqus to your blog. Come up with a clever
name for your site and enter that in the window for "Site name". Once you do
that it should fill the box under where it says "Choose your unique Disqus URL".
Go ahead and pick a category - "Tech" seems reasonable. Finally, click "Finish
Registration".

The next page that opens up will as you to "Choose your platform". The first
option is "Universal Code", go ahead and click on that. You will see something
that looks like this:

      <div id="disqus_thread"></div>
      <script type="text/javascript">
          /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
          var disqus_shortname = 'example'; // required: replace example with your forum shortname

          /* * * DON'T EDIT BELOW THIS LINE * * */
          (function() {
              var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
              dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
              (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
          })();
      </script>
      <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

Don't do anything with that code. Rather, you will need to slightly modify this
to add the following lines immediately after the line that says `var
disqus_shortname` (be sure to replace 'example' with your github user name):

        <div id="disqus_thread"></div>
        <script type="text/javascript">
            /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
            var disqus_shortname = 'example'; // required: replace example with your forum shortname
        		var disqus_identifier = '{% raw %}{{ page.url }}';

        		var disqus_url = 'http://example.github.io{{ "{{ page.url " }}}}';

            /* * * DON'T EDIT BELOW THIS LINE * * */
            (function() {
                var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
                dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
                (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
            })();
        </script>
        <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

Copy and paste this code into a new file called `comments.html` and save it into
the `_includes` folder. Go ahead and do the following from the command line:

    git add _includes\comments.html  
    git commit -m "Initial commit"  


Now open up `_layouts/post.html`. In the middle of the file you'll see a
line that says `{{ "{{ content " }}}}`. Insert a line after that and add this `{{ "{%
include comments.html " }}%}`.

Save and close the file, commit the change, and push:

    git add _layouts/default.html  
    git commit -m "Added comments to layout"  
    git push

Now go to your browser and hit refresh. At the bottom you should see the Disqus
commenting pane. Well done!
