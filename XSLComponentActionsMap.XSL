<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xsl:template match="componentfunctions" >    
        <xsl:for-each select="file" >
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:apply-templates select="$library/keyword_library/libraryInfo" />	    
	    <xsl:apply-templates select="$library/keyword_library/keywords" />	    
        </xsl:for-each>    
    </xsl:template>

    <xsl:template match="libraryInfo" >    
	<xsl:text>[</xsl:text>
        <xsl:value-of select="@name" />
	<xsl:text>]&#xA;</xsl:text>
    </xsl:template>

    <xsl:template match="keywords" >    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
	    <xsl:value-of select="@displayText" />
	    <xsl:text>=:T:</xsl:text>
	    <xsl:if test="starts-with(@expectWarnSupport,'Y')">
	        <xsl:text>TW:</xsl:text>
	    </xsl:if>
	    <xsl:if test="starts-with(@expectFailSupport,'Y')">
	        <xsl:text>TF:</xsl:text>
	    </xsl:if>
	    <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>       
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
