#!/bin/bash
#
# Simple script to combine a template with a markdown page
# to create a static html website
#
# XXX NOTE:
#   * The first line in a document provided as an argument must be a date, which is used
#   for sorting the files
#
# Requires:
#  * bash
#  * sed
#  * tidy-html5 from github: https://github.com/w3c/tidy-html5
#  * markdown to html converter, e.g. python-markdown
#    please set MARKDOWN_EXECUTABLE accordingly below
# The resulting HTML makes use of the javascript code prettifier:
#   https://google-code-prettify.googlecode.com/svn/trunk/README.html
#

MARKDOWN_EXECUTABLE=markdown_py

HEADER='<!DOCTYPE html>
<html>
    <head>
        <link href="prettify.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="prettify.js"></script>
        <title>TITLE</title>
    </head>
<body onload="prettyPrint()">
'

FOOTER='
</body>
</html>
'

function generate_filename() {
    echo ${1%%.*}.html
}

# build the navigation by using all arguments, ordered by creation
# time of the respective files..

FILES=$(for file in $@;
do
    CREATION_DATE=$(head -n1 $file)
    echo $(generate_filename $file) $CREATION_DATE
done | sort -k 2 | awk '{print $1}')

NAV='<div class="sitenav"><ul>
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
while [ "$#" -gt 0 ];
do
    FILE=$1
    BODY=$(sed '1d' $FILE | $MARKDOWN_EXECUTABLE | \
        sed 's/<\(code\|pre\)>/<\1 class="prettyprint">/g')
    FILENAME=$(generate_filename $FILE)
    # generate html
    cat > $FILENAME <<_
$(sed "s/TITLE/$FILENAME/g" <<EOF
$HEADER
EOF
)
$NAV
$BODY
$FOOTER 
_
    shift
done

