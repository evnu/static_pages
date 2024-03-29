#!/bin/bash
#
# Simple script to combine a template with a markdown page
# to create a static html website
#
# XXX NOTE:
#   * The first line in the provided documents must be a date, which is used
#   for sorting the files
#
# Requires:
#  * bash
#  * sed
#  * markdown to html converter, e.g. pandoc.
#    Please edit the function convert_to_html if you want to use another converter 
#    than markdown.

# The resulting HTML makes use of the javascript code prettifier:
#   https://google-code-prettify.googlecode.com/svn/trunk/README.html
#  This library needs the css class "prettyprint" to recognize code. That class
#   is added using sed.
#

# convert the file from stdin to the html file $1
function convert_to_html() {
    pandoc -t html
}

# convert a string to a string without /
function sanitize_title() {
    echo $1 | tr "/" " "
}

function generate_filename() {
    echo ${1%%.*}.html
}

HEADER='<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <link type="text/css" rel="stylesheet" href="static_pages.css" />
        <script type="text/javascript" src="static_pages.js"></script>
        <link href="prettify.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="prettify.js"></script>
        <title>TITLE</title>
    </head>
<body onload="prettyPrint()">
'

FOOTER='
    <div id="footer">
        <em>Created</em> CREATED, <em>last updated</em> LASTUPDATE
    </div>
</body>
</html>
'

# build the navigation by using all arguments, ordered by creation
# time of the respective files..

FILES=$(for file in $@;
do
    CREATION_DATE=$(date -d "$(head -n1 $file | sed 's/%//g')" +%s)
    echo $(generate_filename $file) $CREATION_DATE
done | sed 's/%//g' | column -t | sort -k2 | awk '{print $1}')

NAV='<div id="sitenav"><ul>
'

for file in $FILES;
do
    NAV=$NAV"
<li>
	<a href="$file">$file</a>
</li>
    "
done

NAV=$NAV'</ul></div>'

# for all arguments:
# insert class="prettyprint" into code sections
for FILE in $@;
do
    FILENAME=$(generate_filename $FILE)
    CREATION_DATE=$(head -n1 $FILE)

    # insert classes for code highlighting
    BODY=$(sed '1d' $FILE | convert_to_html | \
        sed 's/<\(code\|pre\)>/<\1 class="prettyprint">/g')

    # insert the creation date into the footer..
    FILE_FOOTER=$(echo $FOOTER | m4 -DCREATED="$CREATION_DATE" | sed 's/%//g')

    # generate html
    cat > $FILENAME <<_
$(sed "s/TITLE/$(sanitize_title $FILENAME)/g" <<EOF
$HEADER
EOF
)
$NAV
<div id="content">
$BODY
</div>
$FILE_FOOTER 
_
done

