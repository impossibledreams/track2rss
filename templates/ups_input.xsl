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
#   NOTE: YOU MUST AGREE TO UPS'S LICENSING AGREEMENT BEFORE USING ACCESSING
#   THEIR SYSTEMS VIA THIS SOFTWARE.
#
-->

<xsl:param name="service_key"/>
<xsl:param name="service_username"/>
<xsl:param name="service_password"/>
<xsl:param name="tracking_number"/>
<xsl:param name="version"/>

<xsl:template match="/">	
	<AccessRequest xml:lang="en-US">
		<AccessLicenseNumber><xsl:value-of select="$service_key"/></AccessLicenseNumber>
		<UserId><xsl:value-of select="$service_username"/></UserId>
		<Password><xsl:value-of select="$service_password"/></Password>
	</AccessRequest>
	
	<xsl:text disable-output-escaping="yes">&lt;?xml version='1.0'?&gt;</xsl:text>
	<TrackRequest xml:lang='en-US'>
	<Request>
		<TransactionReference>
			<CustomerContext><xsl:value-of select="$version"/></CustomerContext>
			<XpciVersion>1.0001</XpciVersion>
		</TransactionReference>
		<RequestAction>Track</RequestAction>
		<RequestOption>activity</RequestOption>
	</Request>
	<TrackingNumber><xsl:value-of select="$tracking_number"/></TrackingNumber>
	</TrackRequest>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>