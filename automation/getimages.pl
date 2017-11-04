#!/usr/bin/perl
#
# Script: getimages.pl
# Written by: Carter A. Thompson (carter.thompson@suse.com)
# Purpose: Gathers images and other data from dita files for processing.
# Copyright: SUSE 2017
#
#
# Running the script:
#
# getimages.pl > somefilename.html
#
# This script assumes you want to redirect output to an html file.  If not, STDOUT
# is produced in html format. 


use strict;
use XML::LibXML;

my @files = `find . -name "*.dita" | cut -c 3-`;
my $total_files_with_images = 0;
my $tagname = "image";
my $docsurl = "https://docs.hpcloud.com/hos-5.x/#helion";
my $imgurl = "https://docs.hpcloud.com/hos-5.x";


# Print a html and body tag to start the file. Include total number
# of dita files for processing.
#
print "<html>\n";
print "<body>\n";
print "<h2>Total Dita Files: " . scalar(@files) . "</h2>\n";

# Process each file.
#
foreach my $file (@files) {
    chomp $file;
    
    # Load the dita file into $dom, the get the $tagname (image)
    # and add it to the array @nodelist
    #
    my $dom = XML::LibXML->load_xml(location => $file);
    my @nodelist = $dom->getElementsByTagName($tagname);
    
    # If there are no images to process, then go to next file.
    #
    if(scalar(@nodelist) == 0) {next}
    
    #Increment file count with images.
    $total_files_with_images++;
    
    # Get title, then print out title and filename.
    #
    my $title = $dom->findnodes('topic/title');
    print "<h2>$title</h2>\n";
	print "<p><b>Dita File: $file<br/>\n";
    $file =~ s/dita/html/g;
    print "HTML File: <a href=$docsurl/$file>$docsurl/$file</a></b></p>\n";
    
    # Find the href and the id from the node.
    #
    foreach my $node (@nodelist) {
        my $href = $node->getAttribute("href");
        $href =~ s/\.\.\///g; # This strips off the ../ from the string globally.
        print "<p><img src=\"$imgurl/$href\"</p>\n";
        my $image_id = $node->getAttribute("id");
        print "<p>Image Id: $image_id</p>\n";
    }
    
    # Print a horizontal rule to separate the images.
    #
    print "<hr>\n";

}

# Print the total files affected and then end html file (body/html)
#
print "<h3>Total files with images: $total_files_with_images</h3>";
print "</body>\n";
print "</html>\n";

__END__
