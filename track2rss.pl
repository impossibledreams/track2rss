#!/usr/bin/perl
#
#   track2rss v0.2
#   Written by Yakov Shafranovich
#
#   A Project of SolidMatrix Research
#   Website: http://track2rss.sourceforge.net
#   Email:  research@solidmatrix.com
#   
#   Copyright (C) 2005 SolidMatrix Technologies, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   NOTE: YOU MUST AGREE TO UPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
#   THEIR SYSTEMS VIA THIS SOFTWARE.
#
#   NOTE: YOU MUST AGREE TO USPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
#   THEIR SYSTEMS VIA THIS SOFTWARE.
#

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Crypt::SSLeay;
use LWP::UserAgent;
use XML::LibXML;
use XML::LibXSLT;

#--- User Configuration Information ---
my $ups_service_key = '';  	# XML Access Key from UPS
my $ups_service_username = '';		# Username for UPS's site
my $ups_service_password = '';		# Password for UPS's site

my $usps_service_username = '';	# Username for USPS
my $usps_service_password = '';	# Password for USPS

my $fedex_account_number = '';		# Fedex Account Number
my $fedex_meter_number = '';

#-- Optional Configuration ---
# URL to stylesheet used for formatting RSS
my $url_stylesheet = '';			

#--- NO CONFIGURATION BELOW THIS --
#-- Services configuration --
my $ups_input_xsl = 'templates/ups_input.xsl';
my $ups_output_xsl = 'templates/ups_output.xsl';
my $ups_url_track = 'https://www.ups.com/ups.app/xml/Track';
my $ups_url_type = 'POST';

my $usps_input_xsl = 'templates/usps_input.xsl';
my $usps_output_xsl = 'templates/usps_output.xsl';
# testing URL
my $usps_url_track = 'http://testing.shippingapis.com/ShippingAPITest.dll?API=TrackV2&XML=';
# production URL
#my $usps_url_track = 'http://production.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=';
my $usps_url_type = 'GET';

my $fedex_ground_input_xsl = 'templates/fedex_ground_input.xsl';
my $fedex_air_input_xsl = 'templates/fedex_air_input.xsl';
my $fedex_output_xsl = 'templates/fedex_output.xsl';
# testing URL
my $fedex_url_track = 'https://gatewaybeta.fedex.com/GatewayDC';
# production URL
#my $fedex_url_track = 'https://gateway.fedex.com/GatewayDC';
my $fedex_url_type = 'POST';

#--- Variables --
my $version = 'track2rss/0.2 (http://track2rss.sourceforge.net)';
my $from = 'research@solidmatrix.com';
my $tracking_number = '';
my $input_xsl = '';
my $output_xsl = '';
my $service_url_track = '';
my $service_url_type = '';
my $service_key = '';
my $service_username = '';
my $service_password = '';

#--- Check parameters --
if ($ENV{'REQUEST_METHOD'} eq "GET")
   { $in = $ENV{'QUERY_STRING'}; }
else
   { $in = <STDIN>; }
$q=new CGI($in);

if($q->param('type') eq '' or $q->param('tracking_number') eq '')
{  print "Content-Type: text/plain\n\n";
   print "500 ERROR: Missing either parameter 'type' or 'tracking_number'.\n";
   exit;
}
 
if($q->param('type') eq 'ups') {
   $tracking_number = $q->param('tracking_number');
   $input_xsl = $ups_input_xsl;
   $output_xsl = $ups_output_xsl;
   $service_url_track = $ups_url_track;
   $service_url_type = $ups_url_type;
   $service_key = $ups_service_key;
   $service_username = $ups_service_username;
   $service_password = $ups_service_password;
} elsif($q->param('type') eq 'usps') {
   $tracking_number = $q->param('tracking_number');
   $input_xsl = $usps_input_xsl;
   $output_xsl = $usps_output_xsl;
   $service_url_track = $usps_url_track;
   $service_url_type = $usps_url_type;
   $service_username = $usps_service_username;
   $service_password = $usps_service_password; 
} elsif($q->param('type') eq 'fedex_ground') {
   $tracking_number = $q->param('tracking_number');
   $input_xsl = $fedex_ground_input_xsl;
   $output_xsl = $fedex_output_xsl;
   $service_url_track = $fedex_url_track;
   $service_url_type = $fedex_url_type;
   $service_username = $fedex_account_number;
   $service_key = $fedex_meter_number;
} elsif($q->param('type') eq 'fedex_air') {
   $tracking_number = $q->param('tracking_number');
   $input_xsl = $fedex_air_input_xsl;
   $output_xsl = $fedex_output_xsl;
   $service_url_track = $fedex_url_track;
   $service_url_type = $fedex_url_type;
   $service_key = $fedex_service_key;
   $service_username = $fedex_service_username;
   $service_password = $fedex_service_password; 
} else {
   print "Content-Type: text/plain\n\n";
   print "500 ERROR: This type is not supported.\n";
   exit;
}
 
#--- Create input request ---
my $parser = XML::LibXML->new();
my $xslt = XML::LibXSLT->new();
my $source = $parser->parse_string('<?xml version="1.0"?><xml/>');
my $style_doc = $parser->parse_file($input_xsl);
my $stylesheet = $xslt->parse_stylesheet($style_doc);
my $results = $stylesheet->transform($source,
	XML::LibXSLT::xpath_to_string(version => $version),
	XML::LibXSLT::xpath_to_string(service_key => $service_key),
	XML::LibXSLT::xpath_to_string(service_username => $service_username),
	XML::LibXSLT::xpath_to_string(service_password => $service_password),
	XML::LibXSLT::xpath_to_string(tracking_number => $tracking_number)
	);

#--- Make request ---
my $req;
$ua = LWP::UserAgent->new;
$ua->agent($version);
$ua->from('comments@shaftek.org');

if($service_url_type eq 'GET')
{ 
	$req = HTTP::Request->new(GET => join("", $service_url_track, $stylesheet->output_string($results)));
} else { 
	$req = HTTP::Request->new(POST => $service_url_track);
	$req->content_type('application/x-www-form-urlencoded');
	$req->add_content($stylesheet->output_string($results));
}

#-- Send Request --
my $res = $ua->request($req);
if ($res->is_error) {
    print "Content-Type: text/plain\n\n";
    print "500 Request Failed: ", $res->status_line, "\n";
    exit;
}

#--- Process Response --- 
my $source = $parser->parse_string($res->content);
my $style_doc = $parser->parse_file($output_xsl);
my $stylesheet = $xslt->parse_stylesheet($style_doc);
my $results = $stylesheet->transform($source,
	XML::LibXSLT::xpath_to_string(version => $version),
	XML::LibXSLT::xpath_to_string(url_stylesheet => $url_stylesheet)
);

print "Content-Type: application/xml\n\n";
print $stylesheet->output_string($results);
exit;