# Setting Up Your Blog
## April 20, 2019

This is your full-length article.

The blog is written in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) and we use [Earmark](https://github.com/pragdave/earmark) to compile it into HTML.

The intent of `techblog` is self-fullfilling really.  I wanted to move my blog off of Medium, but I also didn't really need a "web editor".  I did however, want to do some programming like stuff, and my language of choice right now is [Elixir](http://elixir-lang.org), so I felt this would allow me to integrate things nicely.

Here's the latest list of [supported tags](https://github.com/pragdave/earmark#github-flavored-markdown), with a simple example shown below.

# This is a title (h1)
## This is a title (h2)
### This is a title (h3)
#### This is a title (h4)
##### This is a title (h5)
###### This is a title (h6)

I ~~like~~love Elixir.

Task lists:

- Deploy my blog
- ???
- Be rich

![Art](artboard.png?raw=true)

The above was (mostly) rendered using

```markdown
# This is a title (h1)
## This is a title (h2)
### This is a title (h3)
#### This is a title (h4)
##### This is a title (h5)
###### This is a title (h6)

I ~~like~~love Elixir.

Task lists:

- Deploy my blog
- ???
- Be rich
```

For images, if you want it to show up in GitHub AND on your blog
then you can use this cheat

```
BANG[Art](artboard.png?raw=true)
```

Where `BANG` is really `!`.

![A sample blog with one article](/images/sample.png)

A summary of your article will be written in `how-to-deploy-using-docker/summary.md`.  This is accessed by clicking on the `Back` link you see below (and at the top of the article.