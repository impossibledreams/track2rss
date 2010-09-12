<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			      xmlns:access="http://www.bloglines.com/about/specs/fac-1.0"
			      xmlns:date="http://exslt.org/dates-and-times"
	    	              extension-element-prefixes="date">
					  
<xsl:output method = "xml" indent="yes"/>

<!--
#
#   track2rss v1.0.0
#   Written by Yakov Shafranovich
#   Website: http://track2rss.sourceforge.net
#   
#   Copyright (c) 2005-2008 SolidMatrix Technologies, Inc.
#   Copyright (c) 2008-2009 Yakov Shafranovich.
#   Copyright (c) 2009-2010 Shaftek Enterprises LLC.
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

<xsl:param name="date" select="20300101"/>
<xsl:param name="url_stylesheet"/>
<xsl:param name="version"/>

<xsl:template match="/">
	<!-- initial data -->
	<xsl:if test="$url_stylesheet">
		<xsl:text disable-output-escaping="yes">&lt;?xml-stylesheet href="</xsl:text><xsl:value-of select="$url_stylesheet"/><xsl:text disable-output-escaping="yes">" type="text/css"?&gt;</xsl:text>
	</xsl:if>
	<rss version="2.0" xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/">
	<xsl:copy-of select="."/>
	<access:restriction relationship="deny" />
	<channel>
		<title>Fedex Tracking Information for <xsl:value-of select="/FDXTrackReply/TrackProfile/TrackingNumber"/></title>
		<link><xsl:value-of select="FDXTrackReply/TrackProfile/FedExURL"/></link>
		<description>This RSS feed tracks Fedex <xsl:choose>
			<xsl:when test="FDXTrackReply/TrackProfile/CarrierCode = 'FDXG'">GROUND</xsl:when>
			<xsl:otherwise>AIR</xsl:otherwise>
			</xsl:choose> package # <xsl:value-of select="FDXTrackReply/TrackProfile/TrackingNumber"/>
			&lt;br /&gt;Service Type: <xsl:value-of select="FDXTrackReply/TrackProfile/Service"/>
			&lt;br /&gt;Package Type: <xsl:value-of select="FDXTrackReply/TrackProfile/PackagingDescription"/>
			&lt;br /&gt;Weight: <xsl:value-of select="FDXTrackReply/TrackProfile/Weight"/>
			&lt;br /&gt;Date Shipped: <xsl:value-of select="FDXTrackReply/TrackProfile/ShipDate"/>		
			&lt;br /&gt;Estimation of Delivery: <xsl:value-of select="FDXTrackReply/TrackProfile/EstimatedDeliveryDate"/> <xsl:value-of select="FDXTrackReply/TrackProfile/EstimatedDeliveryTime"/>	
			&lt;br /&gt;Destination: <xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/City"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/StateOrProvinceCode"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/PostalCode"/>,
			<xsl:value-of select="FDXTrackReply/TrackProfile/DestinationAddress/CountryCode"/>
		</description>
      		<language>en-us</language>
		<generator><xsl:value-of select="$version"/></generator>
		<ttl>60</ttl>
		
		<!-- test if ok -->
		<xsl:choose>
		<xsl:when test="/FDXTrackReply/Error">
			<openSearch:totalResults>1</openSearch:totalResults>
			<openSearch:startIndex>1</openSearch:startIndex>
			<openSearch:itemsPerPage>1</openSearch:itemsPerPage>
			<item>
				<title>TRACKING REQUEST FAILED</title>
				<description>Failed to retrieve data from Fedex, error message: <xsl:value-of select="FDXTrackReply/Error/Message"/></description>
			</item>
		</xsl:when>
		<xsl:otherwise>
			<openSearch:totalResults><xsl:value-of select="count(FDXTrackReply/TrackProfile/Scan)"/></openSearch:totalResults>
			<openSearch:startIndex>1</openSearch:startIndex>
			<openSearch:itemsPerPage><xsl:value-of select="count(FDXTrackReply/TrackProfile/Scan)"/></openSearch:itemsPerPage>

			<!-- get the actual tracking data -->
			<xsl:apply-templates select="FDXTrackReply/TrackProfile"/>
		</xsl:otherwise>
		</xsl:choose>
	</channel>
	</rss>
</xsl:template>

<xsl:template match="Scan">
	<xsl:variable name="scandate"><xsl:value-of select="substring(Date, 1, 4)"/><xsl:value-of select="substring(Date, 6, 2)"/><xsl:value-of select="substring(Date, 9, 2)"/></xsl:variable>
	<item>
		<title><xsl:choose>
			<xsl:when test="ScanType = '='">EXCEPTION</xsl:when>
			<xsl:otherwise><xsl:value-of select="ScanDescription"/></xsl:otherwise>
		</xsl:choose></title>
		<description>
		<xsl:if test="contains(ScanDescription, 'Delivered') and ($date - $scandate) &gt; 30">[FEED EXPIRED]</xsl:if>		
		Date/Time : <xsl:value-of select="Date"/>&#160;<xsl:value-of select="Time"/>
		&lt;br /&gt;
		<xsl:if test="StatusExceptionDescription">
			Exception: <xsl:value-of select="StatusExceptionDescription"/>
    			&lt;br /&gt;
		</xsl:if>
		Location :
			<xsl:if test="City">
				<xsl:value-of select="City"/>,&#160;
			</xsl:if>
			<xsl:value-of select="StateOrProvinceCode"/>&#160;
			<xsl:value-of select="PostalCode"/>&#160;
			<xsl:value-of select="CountryCode"/>
		</description>
		<link><xsl:value-of select="../FedExURL"/></link>
		<xsl:variable name="dt" select="concat(Date, 'T', Time)"/>
		<pubDate><xsl:value-of select="concat(substring(date:day-name($dt), 1, 3), ', ', format-number(date:day-in-month($dt), '00'), ' ', date:month-abbreviation($dt), ' ', date:year($dt), ' ', substring($dt, 12, 8))"/></pubDate>		
	</item>
</xsl:template>

<xsl:template match="SoftError">
	<item>
		<title>Error</title>
		<description>[<xsl:value-of select="$date"/>] An Error Has Occured: '<xsl:value-of select="Message"/>'</description>
		<link><xsl:value-of select="../FedExURL"/></link>
	</item>
</xsl:template>


<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>