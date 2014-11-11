---
layout: post
title:  "Customizing your blog"
date:   2014-11-01 13:48:47
comments: true
---

You should notice by now that there's a lot of awesomeness on our blog
even though you haven't done anything yet. Although you are awesome, you aren't
really - that - awesome. Let's bring you down to earth...

First, let's go to the `_config.yml` file that is in the root of your repository.
Opening it you will see the following:

    # Site settings
    title: Your awesome title
    email: your-email@domain.com
    description: > # this means to ignore newlines until "baseurl:"
      Write an awesome description for your new site here. You can edit this
      line in _config.yml. It will appear in your document head meta (for
      Google search results) and in your feed.xml site description.
    baseurl: "" # the subpath of your site, e.g. /blog/
    url: "http://yourdomain.com" # the base hostname & protocol for your site
    twitter_username: jekyllrb
    github_username:  jekyll

    # Build settings
    markdown: kramdown

Let's change "Your awesome title" to something more specific about you. Then
you'll want to insert your email address. Now remove the text starting with
"Write an awesome description..." through "feed.xml site description" and
replace that with a brief description of what this notebook is. This text will
appear in the lower right corner of each page, so don't write a novel. Now
you'll want to replace `http://yourdomain.com` with
`http://yourgithubid.github.io` where you replace the `yourgithubid` with you
GitHub id. Be sure that this is surrounded in double quotes. Finally, feel free
to insert your `twitter_username` and `github_username`. If you don't have a
twitter handle, you suck, and cand remove that line from the file. Now commit
the changes  

    git add _config.yml
    git commit -m "Added my information"

If you go to the window running the jekyll server, hit `CTRL-C` and then
re-launch the local server. You should notice a change in your blog.

The next bit of customization you want to do is to add a description about
yourself. Open the `about.md` file. You'll see some text in there that starts,
"This is the base Jekyll theme..." Go ahead and delete that and everything that
follows. Replace it with a description of who you are. Remember that this is a
markdown file and so you can use markdown to format the page. Once you're happy
with how it looks, save it, commit the changes, and push.

    git add about.md
    git commit -m "Added my about information"
    git push
