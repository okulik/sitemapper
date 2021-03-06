# lame-sitemapper

A tool for a simple, static web pages hierarchy exploration. It starts from the arbitrary page you provide and descents into the tree of links until it has either traversed all possible content on the web site or has stopped at some predefined traversal depth. It is written in Ruby and implemented as a CLI application. Based on user preference, it can output text reports in a standard sitemap.xml form (used by many search engines), a dot file (for easier site hierarchy visualization, [graphviz][graphviz] compatible), a plain text file (displaying detailed hierarchical relations between pages) and a simple HTML format.

The main challenge in web site links traversal is to know if some link has been previously seen and, accordingly, not to explore any further in that direction. This prevents infinite traversal of pages, jumping from link to link forever.

See [http://www.nisdom.com/blog/2014/04/12/a-simple-ruby-sitemap-dot-xml-generator/][nisdom-sitemapper] for more details.

## Features
* Obeys robots.txt (can be optionally disregarded).
* Produces 4 different types of reports. Possible values are 'text', 'sitemap', 'html' and 'graph'.
* Tracks HTTP redirects.
* Possibility to choose the number of concurrent threads.

## Installation
Install it from RubyGems.org using `gem install lame-sitemapper`.

## Examples
Crawls up to depth 3 of page links, usees 6 threads, disregards robots.txt and creates a hierarchical text report:
```
lame-sitemapper "http://www.some.site.mom" -l 0 -d 3 -t 6 --no-robots
```
Crawls up to depth 4, uses 6 threads, disregards robots.txt, creates dot file, converts it to png file and opens it (you need to have installed [graphviz][graphviz]):
```
lame-sitemapper "http://www.some.site.mom" -l 0 -d 4 -t 6 --no-robots
  -r graph > site.dot && dot -Tpng site.dot > site.png && open site.png
```
Traverses up to level 2, obeys robots.txt and creates an html report:
```
lame-sitemapper "http://www.some.site.mom" -d 2 -r html > site.html
  && open site.html
```

[graphviz]: http://www.graphviz.org/
[github-sitemapper]: http://github.com/okulik/lame-sitemapper/
[bundler]: http://bundler.io/
[nisdom-sitemapper]: http://www.nisdom.com/blog/2014/04/12/a-simple-ruby-sitemap-dot-xml-generator/
