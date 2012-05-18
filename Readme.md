static_pages
============

This is a simple script which can be used to convert a selection of markdown annotated
text files into a set of html files.

As a blog entry needs a creation date, put a Markdown comment `%` with a _RFC 2822_
compliant date on the top of the file, e.g.

    % Fri, 18 May 2012 19:11:22 +0200

Note that `date` outputs such dates using `date -R`.

Requirements
------------
* Bash 
* sed
* markdown to html converter, e.g. [pandoc](http://johnmacfarlane.net/pandoc/)

Outputs
-------
One HTML file for each text file. The HTML file uses the
[prettify](https://google-code-prettify.googlecode.com/svn/trunk/README.html) JavaScript
library to automagically prettify code blocks.

Usage
-----
    % ls *.md
    fu.md  test.md
    $ create_site.sh *.md
    % ls *.html
    fu.html  test.html

