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
#   NOTE: YOU MUST AGREE TO FEDEX'S LICENSING AGREEMENT BEFORE USING ACCESSING
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
		<title>Fedex Tracking Information for <xsl:value-of select="/FDXTrackReply/TrackProfile/TrackingNumber"/></title>
		<link><xsl:value-of select="FDXTrackReply/TrackProfile/FedExURL"/></link>
		<description>This RSS feed tracks Fedex <xsl:choose>
			<xsl:when test="FDXTrackReply/TrackProfile/CarrierCode = 'FDXG'">GROUND</xsl:when>
			<xsl:otherwise>AIR</xsl:otherwise>
			</xsl:choose> package # <xsl:value-of select="FDXTrackReply/TrackProfile/TrackingNumber"/>
			&lt;br /&gt;Service Type: <xsl:value-of select="FDXTrackReply/TrackProfile/Service"/>
			&lt;br /&gt;Date Shipped: <xsl:value-of select="FDXTrackReply/TrackProfile/ShipDate"/>		
			&lt;br /&gt;Destination: <xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/City"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/StateOrProvinceCode"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/PostalCode"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/CountryCode"/>
		</description>
      		<language>en-us</language>
		<generator><xsl:value-of select="$version"/></generator>
		
		<!-- test if ok -->
		<xsl:choose>
		<xsl:when test="/FDXTrackReply/Error">
			<item>
				<title>TRACKING REQUEST FAILED</title>
				<description>Failed to retrieve data from Fedex, error message: <xsl:value-of select="FDXTrackReply/Error/Message"/></description>
			</item>
		</xsl:when>
		<xsl:otherwise>
			<!-- get the actual tracking data -->
			<xsl:apply-templates select="FDXTrackReply/TrackProfile"/>
		</xsl:otherwise>
		</xsl:choose>
	</channel>
	</rss>
</xsl:template>

<xsl:template match="Scan">
	<item>
		<title><xsl:choose>
			<xsl:when test="ScanType = '='">EXCEPTION</xsl:when>
			<xsl:otherwise><xsl:value-of select="ScanDescription"/></xsl:otherwise>
		</xsl:choose></title>
		<description>
		Date/Time : <xsl:value-of select="Date"/>&#160;<xsl:value-of select="Time"/>
		&lt;br /&gt;
		Location :
			<xsl:if test="City">
				<xsl:value-of select="City"/>,&#160;
			</xsl:if>
			<xsl:value-of select="StateOrProvinceCode"/>&#160;
			<xsl:value-of select="PostalCode"/>&#160;
			<xsl:value-of select="CountryCode"/>
		</description>
		<link><xsl:value-of select="../FedExURL"/></link>
	</item>
</xsl:template>

<xsl:template match="SoftError">
	<item>
		<title>Error</title>
		<description>An Error Has Occured: '<xsl:value-of select="Message"/>'</description>
		<link><xsl:value-of select="../FedExURL"/></link>
	</item>
</xsl:template>


<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>