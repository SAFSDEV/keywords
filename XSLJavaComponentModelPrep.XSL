<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xsl:template match="/" >    
        <xsl:text>call setSAFSEnvironment.bat&#xA;&#xA;</xsl:text>
        <xsl:for-each select="//file" >
            <xsl:text>msxsl.exe </xsl:text>
	    <xsl:text>%SAFSXML%\</xsl:text>
	    <xsl:value-of select="@href" /><xsl:text>&#32;</xsl:text>
	    <xsl:text>%SAFSXSL%\XSLJavaComponentModel.XSL -o %SAFSSOURCE%\org\safs\model\components\</xsl:text>
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:value-of select="substring-before($library/keyword_library/libraryInfo/@name,'Functions')" />
	    <xsl:text>.java&#xA;</xsl:text>
        </xsl:for-each>    
    </xsl:template>    

</xsl:stylesheet>
