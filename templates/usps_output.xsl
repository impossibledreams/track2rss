<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
<xsl:output method = "xml" indent="yes"/>

<!--
#
#   track2rss v0.3
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
#   NOTE: YOU MUST AGREE TO USPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
#   THEIR SYSTEMS VIA THIS SOFTWARE.
#
-->

<xsl:param name="url_stylesheet"/>
<xsl:param name="version"/>

<xsl:template match="/">
	<!-- initial data -->
	<xsl:if test="$url_stylesheet">
		<xsl:text disable-output-escaping="yes">&lt;?xml-stylesheet href="</xsl:text><xsl:value-of select="$url_stylesheet"/><xsl:text disable-output-escaping="yes">" type="text/css"?&gt;</xsl:text>
	</xsl:if>
	<rss version="2.0">
	<channel>
		<title>USPS Tracking Information for <xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></title>
		<link>
		http://trkcnfrm1.smi.usps.com/netdata-cgi/db2www/cbd_243.d2w/output?CAMEFROM=OK&amp;strOrigTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>&amp;Go+to+Track+%26+Confirm.x=0&amp;Go+to+Track+%26+Confirm.y=0&amp;Go+to+Track+%26+Confirm=Go
		</link>
		<description>This RSS feed tracks USPS package # <xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>
		&lt;br /&gt;
		NOTICE: Information provided by http://www.usps.com/
		</description>
      		<language>en-us</language>
		<generator><xsl:value-of select="$version"/></generator>
		
		<!-- test if ok -->
		<xsl:choose>
		<xsl:when test="/Error">
		<item>
			<title>TRACKING REQUEST FAILED</title>
			<description>Failed to retrieve data from USPS, error message: <xsl:value-of select="/Error/Description"/></description>
		</item>
		</xsl:when>
		<xsl:otherwise>
			<!-- get the actual tracking data -->
			<xsl:apply-templates select="/TrackResponse/TrackInfo"/>
		</xsl:otherwise>
		</xsl:choose>
	</channel>
	</rss>
</xsl:template>

<xsl:template match="TrackSummary">
	<item>
		<title>Summary</title>
		<description><xsl:value-of select="."/></description>
		<link>
		http://trkcnfrm1.smi.usps.com/netdata-cgi/db2www/cbd_243.d2w/output?CAMEFROM=OK&amp;strOrigTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>&amp;Go+to+Track+%26+Confirm.x=0&amp;Go+to+Track+%26+Confirm.y=0&amp;Go+to+Track+%26+Confirm=Go
		</link>
	</item>
</xsl:template>

<xsl:template match="TrackDetail">
	<item>
		<title>Activity</title>
		<description><xsl:value-of select="."/></description>
		<link>
		http://trkcnfrm1.smi.usps.com/netdata-cgi/db2www/cbd_243.d2w/output?CAMEFROM=OK&amp;strOrigTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>&amp;Go+to+Track+%26+Confirm.x=0&amp;Go+to+Track+%26+Confirm.y=0&amp;Go+to+Track+%26+Confirm=Go
		</link>
	</item>
</xsl:template>

<xsl:template match="Error">
	<item>
		<title>Error</title>
		<description>An Error Has Occured: '<xsl:value-of select="Description"/>'</description>
		<link>
		http://trkcnfrm1.smi.usps.com/netdata-cgi/db2www/cbd_243.d2w/output?CAMEFROM=OK&amp;strOrigTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>&amp;Go+to+Track+%26+Confirm.x=0&amp;Go+to+Track+%26+Confirm.y=0&amp;Go+to+Track+%26+Confirm=Go
		</link>
	</item>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>