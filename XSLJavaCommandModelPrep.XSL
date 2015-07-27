<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xsl:template match="/" >    
        <xsl:text>call setSAFSEnvironment.bat&#xA;&#xA;</xsl:text>

	<xsl:text>msxsl.exe </xsl:text>
	<xsl:text>%SAFSXML%\XSLDriverCommands.xml </xsl:text>
	<xsl:text>%SAFSXSL%\XSLJavaDriverCommandsClass.XSL </xsl:text>
	<xsl:text>-o %SAFSSOURCE%\org\safs\model\commands\DriverCommands.java&#xA;</xsl:text> 

	<xsl:text>msxsl.exe </xsl:text>
	<xsl:text>%SAFSXML%\XSLComponentFunctions.xml </xsl:text>
	<xsl:text>%SAFSXSL%\XSLJavaComponentFunctionsClass.XSL </xsl:text>
	<xsl:text>-o %SAFSSOURCE%\org\safs\model\commands\ComponentFunctions.java&#xA;</xsl:text> 

        <xsl:for-each select="//file" >
            <xsl:text>msxsl.exe </xsl:text>
	    <xsl:text>%SAFSXML%\</xsl:text>
	    <xsl:value-of select="@href" /><xsl:text>&#32;</xsl:text>
	    <xsl:text>%SAFSXSL%\XSLJavaCommandModel.XSL -o %SAFSSOURCE%\org\safs\model\commands\</xsl:text>
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	    <xsl:text>.java&#xA;</xsl:text>
        </xsl:for-each>    
    </xsl:template>    

</xsl:stylesheet>
