-------------------------------------------------
README FOR track2rss v0.1
Written by Yakov Shafranovich

Copyright (C) 2005 SolidMatrix Technologies, Inc.
All rights reserved, see COPYING file for more.

A Project of SolidMatrix Research
Website: http://track2rss.sourceforge.net
Email:  research@solidmatrix.com
-------------------------------------------------

This project provides an ability to serve UPS tracking information
via an RSS feed. It was inspired by Jason Young's UPS to RSS
converter (http://www.young-technologies.com/utilities/packagetracking/).
Please see the INSTALL file for installation instructions.

NOTE: YOU MUST AGREE TO UPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
THEIR SYSTEMS VIA THIS SOFTWARE. PLEASE SEE LICENSING FILE FOR MORE INFORMATION.

This project consists of a set of XSLT templates that generate the XML
request for the UPS system and a translate the response into RSS. Given
that the UPS format (XPCI) is XML-based just like RSS, I chose XSLT
to do the translation since it is designed to that purpose. In addition
to the XSLT templates there is a Perl wrapper that executes the XSLT
templates in a semi-MVC fashion. Being that XSLT is platform independent,
I envision writing wrappers in other languages as well. I plan on
adding support for other tracking services as well.

For troubleshooting and more information about this project, please see 
the project website at http://track2rss.sourceforge.net.

-------------------------------------------------
END-OF-FILE