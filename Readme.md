static_pages
============

This is a simple script which can be used to convert a selection of markdown annotated
text files into a set of html files.

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

