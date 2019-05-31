<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html">

  <xsl:output
      method="xml"
      version="1.0"
      indent="yes"
      encoding="utf-8"/>

  <xsl:param name="version" select="'debug'" />

  <!-- Generic node copying stuff -->

  <xsl:template match="/">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- explicitly match root element to preserve xmlns attributes. -->
  <xsl:template match="xsl:stylesheet">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="text()"><xsl:value-of select="." /></xsl:template>
  <xsl:template match="comment()"><xsl:value-of select="." /></xsl:template>
  <xsl:template match="processing-instruction()"><xsl:value-of select="." /></xsl:template>

  <!-- Customization -->

  <!-- Override templates to remove comments and processing-instructions: -->
  <xsl:template match="comment()"></xsl:template>
  <xsl:template match="processing-instruction()"></xsl:template>

  <!-- Explicitly match xsl types in order to add the xsl prefix -->
  <xsl:template match="xsl:*">
    <xsl:element name="xsl:{local-name()}">
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <!-- Use parameter to determine which stylesheet to use. -->
  <xsl:template match="xsl:import[contains(@href,'debug.xsl')]">
    <xsl:element name="xsl:import">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="$version = 'debug'">
            <xsl:text>includes/sfw_debug.xsl</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>includes/sfw_compiled.xsl</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="html:title | html:h1">
    <xsl:element name="{local-name()}">
      <xsl:text>Schema Framework Pattern: Enroll</xsl:text>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
