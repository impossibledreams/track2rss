<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method = "xml" indent="no" omit-xml-declaration="yes"/>


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

<xsl:param name="service_username"/>
<xsl:param name="tracking_number"/>
<xsl:param name="version"/>

<xsl:template match="/">
<TrackFieldRequest USERID="{$service_username}"><TrackID ID="{$tracking_number}"></TrackID></TrackFieldRequest>
</xsl:template>

<xsl:template match="text()">
</xsl:template>

</xsl:stylesheet>