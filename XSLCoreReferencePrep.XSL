<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:param name="engine"/>
    
    <xsl:template match="/" >    
        <xsl:for-each select="//file" >
	        <xsl:variable name="library" select="document(@href)" />
	        <xsl:choose>
	        <xsl:when test="string-length($engine) > 0">
	            <xsl:variable name="count1" select="count($library/keyword_library/keywords[keyword/engines/engine/@tool=$engine])"/>
	            <xsl:variable name="count2" select="count($library/keyword_library/keywords[keyword/engines/engine/@vendor='SAFS'])"/>
	            <xsl:if test="$count1 + $count2 > 0">
	                <xsl:apply-templates select="." mode="links_out"/>
                </xsl:if>
	        </xsl:when>
	        <xsl:otherwise>	        	        
	            <xsl:apply-templates select="." mode="links_out"/>
	        </xsl:otherwise>
	        </xsl:choose>
		</xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="links_out">
	    <xsl:variable name="library" select="document(@href)" />
	    <xsl:variable name="docnode" select="." />
        <xsl:text>msxsl.exe </xsl:text>
	    <xsl:text>%SAFSXML%\</xsl:text>
	    <xsl:value-of select="@href" /><xsl:text>&#32;</xsl:text>
	    <xsl:text>%SAFSXSL%\XSLKeywordsIndex.XSL </xsl:text>
        <xsl:if test="string-length($engine) > 0">
            <xsl:text>engine=</xsl:text><xsl:value-of select="$engine"/><xsl:text>&#32;</xsl:text>
        </xsl:if>
	    <xsl:text>-o %SAFSDOC%\</xsl:text>
        <xsl:if test="string-length($engine) > 0">
            <xsl:value-of select="$engine"/>
        </xsl:if>
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	    <xsl:text>Index.htm&#xA;</xsl:text>
        <xsl:text>msxsl.exe </xsl:text>
	    <xsl:text>%SAFSXML%\</xsl:text>
	    <xsl:value-of select="@href" /><xsl:text>&#32;</xsl:text>
	    <xsl:text>%SAFSXSL%\XSLKeywordsReference.XSL </xsl:text>
        <xsl:if test="string-length($engine) > 0">
            <xsl:text>engine=</xsl:text><xsl:value-of select="$engine"/><xsl:text>&#32;</xsl:text>
        </xsl:if>
	    <xsl:text>-o %SAFSDOC%\</xsl:text>
        <xsl:if test="string-length($engine) > 0">
            <xsl:value-of select="$engine"/>
        </xsl:if>
	    <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	    <xsl:text>Reference.htm&#xA;</xsl:text>
	    <xsl:for-each select="$library/keyword_library/keywords/keyword" >
	        <xsl:choose>
	        <xsl:when test="string-length($engine) > 0">
	            <xsl:variable name="count1" select="count(./engines[engine/@tool=$engine])"/>
	            <xsl:variable name="count2" select="count(./engines[engine/@vendor='SAFS'])"/>
	            <xsl:if test="$count1 + $count2 > 0">

                    <xsl:text>msxsl.exe </xsl:text>
	                <xsl:text>%SAFSXML%\</xsl:text>
	                <xsl:value-of select="$docnode/@href" /><xsl:text>&#32;</xsl:text>
	                <xsl:text>%SAFSXSL%\XSLKeywordsDynReference.XSL </xsl:text>
                    <xsl:text>engine=</xsl:text><xsl:value-of select="$engine"/><xsl:text>&#32;</xsl:text>
                    <xsl:text>keyword=</xsl:text><xsl:value-of select="./@displayText"/><xsl:text>&#32;</xsl:text>
	                <xsl:text>-o %SAFSDOC%\</xsl:text>
                    <xsl:value-of select="$engine"/>
	                <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	                <xsl:value-of select="./@displayText"/><xsl:text>.html&#xA;</xsl:text>

                </xsl:if>
	        </xsl:when>
	        <xsl:otherwise>

                    <xsl:text>msxsl.exe </xsl:text>
	                <xsl:text>%SAFSXML%\</xsl:text>
	                <xsl:value-of select="$docnode/@href" /><xsl:text>&#32;</xsl:text>
	                <xsl:text>%SAFSXSL%\XSLKeywordsDynReference.XSL </xsl:text>
                    <xsl:text>keyword=</xsl:text><xsl:value-of select="./@displayText"/><xsl:text>&#32;</xsl:text>
	                <xsl:text>-o %SAFSDOC%\</xsl:text>
	                <xsl:value-of select="$library/keyword_library/libraryInfo/@name" />
	                <xsl:value-of select="./@displayText"/><xsl:text>.html&#xA;</xsl:text>
	        
	        </xsl:otherwise>
	        </xsl:choose>
	    </xsl:for-each>
    </xsl:template>    

</xsl:stylesheet>
