<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
<xsl:output method = "xml" indent="yes"/>

<!--
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
		<title>UPS Tracking Information for <xsl:value-of select="TrackResponse/Shipment/Package/TrackingNumber"/></title>
		<link>http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&amp;tracknums_displayed=1&amp;TypeOfInquiryNumber=T&amp;loc=en_US&amp;InquiryNumber1=<xsl:value-of select="TrackResponse/Shipment/Package/TrackingNumber"/>&amp;track.x=0&amp;track.y=0</link>
		<description>This RSS feed tracks UPS package # <xsl:value-of select="TrackResponse/Shipment/Package/TrackingNumber"/>
		&lt;br /&gt;
		NOTICE: The UPS package tracking systems accessed via this service (the "Tracking Systems") and tracking information
		obtained through this service (the "Information") are the private property of UPS. UPS authorizes you to use
		the Tracking Systems solely to track shipments tendered by or for you to UPS for delivery and for no other purpose.
		Without limitation, you are not authorized to make the Information available on any web site or otherwise reproduce,
		distribute, copy, store, use or sell the Information for commercial gain without the express written consent of UPS.
		This is a personal service, thus you right to use the Tracking System or Information is non-assignable. Any access
		or use that is inconsistent with these terms is unauthorized and strictly prohibited.
		</description>
      		<language>en-us</language>
		<generator><xsl:value-of select="$version"/></generator>
		
		<!-- test if ok -->
		<xsl:choose>
		<xsl:when test="/TrackResponse/Response/ResponseStatusCode = '1'">
			<!-- get the actual tracking data -->
			<xsl:apply-templates select="TrackResponse/Shipment/Package/Activity"/>
		</xsl:when>
		<xsl:otherwise>
		<item>
			<title>TRACKING REQUEST FAILED</title>
			<description>Failed to retrieve data from UPS, error message: <xsl:value-of select="TrackResponse/Response/Error/ErrorDescription"/></description>
		</item>
		</xsl:otherwise>
		</xsl:choose>
	</channel>
	</rss>
</xsl:template>

<xsl:template match="Activity">
	<item>
		<title><xsl:choose>
			<xsl:when test="Status/StatusType/Code = 'I'">IN TRANSIT</xsl:when>
			<xsl:when test="Status/StatusType/Code = 'D'">DELIVERED</xsl:when>
			<xsl:when test="Status/StatusType/Code = 'X'">EXCEPTION</xsl:when>
			<xsl:when test="Status/StatusType/Code = 'P'">PICKUP</xsl:when>
			<xsl:when test="Status/StatusType/Code = 'M'">MANIFEST PICKUP</xsl:when>
			<xsl:otherwise>UNKNOWN</xsl:otherwise>
		</xsl:choose></title>
		<description>
		Date/Time :
			<xsl:value-of select="substring(Date, 5, 2)"/>/
			<xsl:value-of select="substring(Date, 7, 2)"/>/
			<xsl:value-of select="substring(Date, 1, 4)"/>&#160;
			<xsl:value-of select="substring(Time, 1, 2)"/>:<xsl:value-of select="substring(Time, 3, 2)"/>:<xsl:value-of select="substring(Time, 5, 2)"/>
		&lt;br /&gt;
		Location :
			<xsl:if test="ActivityLocation/Address/City">
				<xsl:value-of select="ActivityLocation/Address/City"/>,&#160;
			</xsl:if>
			<xsl:value-of select="ActivityLocation/Address/StateProvinceCode"/>&#160;
			<xsl:value-of select="ActivityLocation/Address/CountryCode"/>
		&lt;br /&gt;Status: <xsl:value-of select="Status/StatusType/Description"/>
		</description>
		<link>http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&amp;tracknums_displayed=1&amp;TypeOfInquiryNumber=T&amp;loc=en_US&amp;InquiryNumber1=<xsl:value-of select="../../../../TrackResponse/Shipment/Package/TrackingNumber"/>&amp;track.x=0&amp;track.y=0</link>
	</item>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>