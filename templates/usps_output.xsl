<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			      xmlns:access="http://www.bloglines.com/about/specs/fac-1.0"
    	    	              xmlns:date="http://exslt.org/dates-and-times"
			      extension-element-prefixes="date">
							  
<xsl:output method = "xml" indent="yes"/>

<xsl:variable name="months" select="document('months.xml')"/>

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
#   NOTE: YOU MUST AGREE TO USPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
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
	<access:restriction relationship="deny" />
	<channel>
		<title>USPS Tracking Information for <xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></title>
		<link>http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></link>
		<description>This RSS feed tracks USPS package # <xsl:value-of select="/TrackResponse/TrackInfo/@ID"/>
		&lt;br /&gt;
		NOTICE: Information provided by http://www.usps.com/
		</description>
      		<language>en-us</language>
		<generator><xsl:value-of select="$version"/></generator>
		<ttl>60</ttl>
		
		<!-- test if ok -->
		<xsl:choose>
		<xsl:when test="/Error">
			<openSearch:totalResults>1</openSearch:totalResults>
			<openSearch:startIndex>1</openSearch:startIndex>
			<openSearch:itemsPerPage>1</openSearch:itemsPerPage>
			<item>
				<title>TRACKING REQUEST FAILED</title>
				<description>Failed to retrieve data from USPS, error message: <xsl:value-of select="/Error/Description"/></description>
			</item>
		</xsl:when>
		<xsl:otherwise>
			<openSearch:totalResults><xsl:value-of select="count(TrackResponse/TrackInfo/TrackDetail)"/></openSearch:totalResults>
			<openSearch:startIndex>1</openSearch:startIndex>
			<openSearch:itemsPerPage><xsl:value-of select="count(TrackResponse/TrackInfo/TrackDetail)"/></openSearch:itemsPerPage>

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
		<description><xsl:value-of select="concat(Event, ', ', EventDate, ', ', EventTime, ', ', EventCity, ', ', EventState, ', ', EventZIPCode, ', ', EventCountry)"/>
		<xsl:if test="contains(Event, 'was delivered')
					or contains(Event, 'No further info')
					or contains(Event, 'no record of that')">&lt;br/&gt;[<xsl:value-of select="$date"/>: 
		Please note that this feed may have expired. If so, please remove it from your reader.]</xsl:if>
		</description>
		<link>http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></link>
		<xsl:variable name="m_abbr" select="substring(EventDate, 1, 3)"/>
		<xsl:variable name="dt"><xsl:value-of
		    select="concat(substring-after(EventDate, ', '), '-', $months/months/m[@abbr=$m_abbr], '-', substring-before(substring-after(EventDate, ' '), ','))"/><xsl:choose>
		    <xsl:when test="EventTime">T<xsl:value-of
		       select="format-number(substring-before(substring-before(EventTime, ' '), ':'), '00')"/>:<xsl:value-of
		       select="format-number(substring-after(substring-before(EventTime, ' '), ':'), '00')"/>:00</xsl:when>
		    <xsl:otherwise>T00:00:00</xsl:otherwise></xsl:choose></xsl:variable>
		<pubDate><xsl:value-of select="concat(substring(date:day-name($dt), 1, 3), ', ', format-number(date:day-in-month($dt), '00'), ' ', date:month-abbreviation($dt), ' ', date:year($dt), ' ', substring($dt, 12, 8))"/></pubDate>
	</item>
</xsl:template>

<xsl:template match="TrackDetail">
	<item>
		<title>Activity</title>
		<description><xsl:value-of select="concat(Event, ', ', EventDate, ', ', EventTime, ', ', EventCity, ', ', EventState, ', ', EventZIPCode, ', ', EventCountry)"/></description>
		<link>http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></link>
		<xsl:variable name="m_abbr" select="substring(EventDate, 1, 3)"/>
		<xsl:variable name="dt"><xsl:value-of
		    select="concat(substring-after(EventDate, ', '), '-', $months/months/m[@abbr=$m_abbr], '-', substring-before(substring-after(EventDate, ' '), ','))"/><xsl:choose>
		    <xsl:when test="EventTime">T<xsl:value-of
		       select="format-number(substring-before(substring-before(EventTime, ' '), ':'), '00')"/>:<xsl:value-of
		       select="format-number(substring-after(substring-before(EventTime, ' '), ':'), '00')"/>:00</xsl:when>
		    <xsl:otherwise>T00:00:00</xsl:otherwise></xsl:choose></xsl:variable>
		<pubDate><xsl:value-of select="concat(substring(date:day-name($dt), 1, 3), ', ', format-number(date:day-in-month($dt), '00'), ' ', date:month-abbreviation($dt), ' ', date:year($dt), ' ', substring($dt, 12, 8))"/></pubDate>
	</item>
</xsl:template>

<xsl:template match="Error">
	<item>
		<title>Error</title>
		<description>[<xsl:value-of select="$date"/>] An Error Has Occured: '<xsl:value-of select="Description"/>'</description>
		<link>http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=<xsl:value-of select="/TrackResponse/TrackInfo/@ID"/></link>
	</item>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>