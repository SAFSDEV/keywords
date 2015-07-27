<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/REC-html40">
  <xsl:output method="html" version="3.2" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="keyword"/>
  <xsl:include href="XSLKeywordsReference.XSL"/>


  <xsl:template match="/">
    <DIV NAME="detail" ID="detail">
      <xsl:text disable-output-escaping="yes"/>
          <xsl:apply-templates select="." mode="one_keyword"/>
    </DIV>
    <xsl:text disable-output-escaping="yes">
	</xsl:text>
  </xsl:template>
  
  <xsl:template match="*" mode="one_keyword">  
      <xsl:choose>
  	        <xsl:when test="string-length($engine) > 0">
  	            <xsl:for-each select="//keyword[@displayText=$keyword and (engines/engine/@tool=$engine or engines/engine/@vendor='SAFS')]">
                    <xsl:apply-templates select="." mode="detail_out"/>
  	            </xsl:for-each>
  	        </xsl:when>
  	        <xsl:otherwise>	        
  	            <xsl:for-each select="//keyword[@displayText=$keyword]">
                    <xsl:apply-templates select="." mode="detail_out"/>
  	            </xsl:for-each>
  	        </xsl:otherwise>
  	  </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>