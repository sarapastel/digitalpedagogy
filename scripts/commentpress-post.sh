#!/bin/bash

# This script assists in converting markdown files for the volume
# Digital Pedagogy into HTML, and them posting them to the CommentPress
# review site. It may be called like this (BASH):

# for file in hybrid interface praxis queer rhetoric video; do path/to/commentpress-post.sh $file; done

# Get the basename 
BASENAME=$(basename "$1")

#Get the filename without the extension
SHORTNAME="${BASENAME%.*}"

#Capitlize it for use in the title
CAPITALIZED_SHORTNAME="${SHORTNAME^}"

#Change image locations to ones that WP will understand. Change this if it's not January 2015. 
cat $1 | sed 's#(images#(../files/2015/01#g' > $1.edited

#Change /files locations to ones that WP will understand. 
sed -i.bak 's#(files#(../files/2015/01#g' $1.edited

#Remove leading YAML block, props to http://stackoverflow.com/a/28222257/584121  
sed -i.bak '1 { /^---/ { :a N; /\n---/! ba; d} }' $1.edited

#Convert to HTML
pandoc -o $SHORTNAME.html $1.edited

#Post!
wp post create $SHORTNAME.html --post_type=page --post_status=publish --post_title="$CAPITALIZED_SHORTNAME" --url=digitalpedagogy.fitzgerald.mlacommons.org 

#Clean up.
rm $SHORTNAME.html $1.bak $1.edited $1.edited.bak