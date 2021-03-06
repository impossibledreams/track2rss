-------------------------------------------------
README FOR track2rss v1.0.0
Written by Yakov Shafranovich

Copyright (c) 2005-2008 SolidMatrix Technologies, Inc.
Copyright (c) 2008-2009 Yakov Shafranovich.
Copyright (c) 2009-2010 Shaftek Enterprises LLC.
All rights reserved, see COPYING file for more.

Website: http://track2rss.sourceforge.net
-------------------------------------------------

This project provides an ability to serve UPS, Fedex and USPS tracking information
via an RSS feed. It was inspired by Jason Young's UPS to RSS
converter (http://www.young-technologies.com/utilities/packagetracking/).
Please see the INSTALL file for installation instructions.

USAGE (no spaces in tracking numbers):

[http://www.example.com/dir/]track2data.pl?type=XXXXX&tracking_number=YYYYYY

Valid types (XXX):

ups - United Parcel Service (UPS)
usps - United States Postal Service (USPS)
fedex_air - Fedex Air
fedex_ground - Fedex Ground

NOTE: Starting with version 0.4.1, the type parameter may be omitted and the script
will try to auto-guess the carrier. However, this will not work with Fedex Ground.

-------------------------------------------------

NOTE: YOU MUST AGREE TO UPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
THEIR SYSTEMS VIA THIS SOFTWARE. PLEASE SEE COPYING.TXT FILE FOR MORE INFORMATION.

NOTE: YOU MUST AGREE TO USPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
THEIR SYSTEMS VIA THIS SOFTWARE. PLEASE SEE COPYING.TXT FILE FOR MORE INFORMATION.

NOTE: YOU MUST AGREE TO FEDEX'S LICENSING AGREEMENT BEFORE USING ACCESSING
THEIR SYSTEMS VIA THIS SOFTWARE. PLEASE SEE COPYING.TXT FILE FOR MORE INFORMATION.

This project consists of a set of XSLT templates that generate the XML
request for the UPS, Fedex and USPS systems and a translate the response into RSS.
Given that the UPS, Fedex and USPS formats are XML-based just like RSS, I chose XSLT
to do the translation since it is designed to that purpose. In addition
to the XSLT templates there is a Perl wrapper that executes the XSLT
templates in a semi-MVC fashion. Being that XSLT is platform independent,
I envision writing wrappers in other languages as well. I plan on
adding support for other tracking services as well.

For OpenSearch support, see INSTALL.TXT, section III.

For troubleshooting and more information about this project, please see 
the project website at http://track2rss.sourceforge.net.

-------------------------------------------------
END-OF-FILE