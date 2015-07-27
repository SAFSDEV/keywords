<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:strip-space elements="*" />
    
    <xsl:template match="drivercommands" >    
        <xsl:for-each select="file" >
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:text>&#xA;[</xsl:text>
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	    <xsl:text>]&#xA;</xsl:text>
	    <xsl:apply-templates select="$library/keyword_library/keywords" />	    
        </xsl:for-each>    
    </xsl:template>

    <xsl:template match="componentfunctions" >    
        <xsl:for-each select="file" >
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:text>&#xA;[</xsl:text>
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@class" />
	    <xsl:text>]&#xA;</xsl:text>
	    <xsl:apply-templates select="$library/keyword_library/keywords" />	    
        </xsl:for-each>    
    </xsl:template>

    <xsl:template match="enginecommands" >    
        <xsl:for-each select="file" >
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:text>&#xA;[</xsl:text>
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	    <xsl:text>]&#xA;</xsl:text>
	    <xsl:apply-templates select="$library/keyword_library/keywords" />	    
        </xsl:for-each>    
    </xsl:template>

    <xsl:template match="keywords" >    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
	    <xsl:value-of select="@displayText" />
	    <xsl:text>&#x9;</xsl:text>
            <xsl:value-of select="normalize-space(description/short_desc)"/>
	    <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>       
    </xsl:template>

</xsl:stylesheet>
