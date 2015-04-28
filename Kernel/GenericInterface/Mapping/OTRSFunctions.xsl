<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:otrs="http://otrs.org"
                extension-element-prefixes="func otrs">

<func:function name="otrs:date-xsd-to-iso">
    <xsl:param name="date-time" />
    <xsl:variable name="formatted">
        <xsl:value-of select="substring($date-time, 1, 10)" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($date-time, 12, 8)" />
   </xsl:variable>
   <func:result select="string($formatted)" />
</func:function>

<func:function name="otrs:date-iso-to-xsd">
    <xsl:param name="date-time" />
    <xsl:variable name="formatted">
        <xsl:value-of select="substring($date-time, 1, 10)" />
        <xsl:text>T</xsl:text>
        <xsl:value-of select="substring($date-time, 12, 8)" />
        <xsl:text>Z</xsl:text>
   </xsl:variable>
   <func:result select="string($formatted)" />
</func:function>

</xsl:stylesheet>
