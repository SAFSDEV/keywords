<!-- XSLJavaCommonFunctions.XSL
     
     XSL shared by other XSL Stylesheets used in the generation of Java code.
     
     ********************************************************************** -->
<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output method="text" encoding="UTF-8" />


<!-- ************************************************************************** 
     match="libraryInfo" mode="StaticClass"
     
     Process the libraryInfo for a DriverCommand or ComponentFunction and create 
     appropriate JavaDoc and static field for the encompassing class
    
     Example:
    
     static public final classname = CLASSNAME.class
     
     ********************************************************************** -->
    <xsl:template match="libraryInfo" mode="StaticClass">    
        <xsl:text>&#xA;    /*************************************************************</xsl:text>
        <xsl:text>&#xA;     static reference to </xsl:text><xsl:value-of select="@name"/><xsl:text>.class &#xA;</xsl:text>
        <xsl:text>&#xA;     </xsl:text><xsl:copy-of select="./description/short_desc"/><xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;     </xsl:text><xsl:copy-of select="./description/detailed_desc"/><xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;     **************************************************************/</xsl:text>
        <xsl:text>&#xA;     public static </xsl:text><xsl:value-of select="@name"/><xsl:text> _</xsl:text><xsl:value-of select="@name"/>
                            <xsl:text> = </xsl:text><xsl:value-of select="@name"/><xsl:text>.getInstance();&#xA;</xsl:text>        
    </xsl:template>


<!-- ************************************************************************** 
     match="keywords" mode="StaticFields"
     
     Process all keywords in this XML writing out static_final public fields.
    
     Example:
    
     static public final String SETAPPLICATIONMAP_KEYWORD = "SetApplicationMap";
     
     ********************************************************************** -->
    <xsl:template match="keywords" mode="StaticFields">    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@name"/>
            <xsl:text>&#xA;    /** &#x22;</xsl:text><xsl:value-of select="@displayText"/><xsl:text>&#x22; */</xsl:text>
            <xsl:text>&#xA;    static public final String </xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>_KEYWORD = &#x22;</xsl:text>
            <xsl:value-of select="@displayText"/>
            <xsl:text>&#x22;;</xsl:text>
        </xsl:for-each>
    </xsl:template>


<!-- ************************************************************************** 
     match="parameters" mode="TrapOptional"
     
     Process all parameters in this XML writing out code to throw IllegalArgumentExceptions 
     for null parameters that are not optional.
    
     calls checkNull template  to output lines like:
     
     if (mapName == null) throw new IllegalArgumentException("setApplicationMap.mapName = null");
     
     ********************************************************************** -->
    <xsl:template match="parameters" mode="TrapOptional">    
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="trapSig">
            <xsl:call-template name="methodCase">
                <xsl:with-param name="aMethod" select="../@displayText"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="./parameter">
	    <xsl:sort select="@name"/>
	    <xsl:if test="(@optional='NO')or(@optional='No')or(@optional='no') " >
                <xsl:variable name="paramSig">
                <xsl:call-template name="methodCase">
                    <xsl:with-param name="aMethod" select="@displayText"/>
                </xsl:call-template>
                </xsl:variable>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$trapSig"/>
	            <xsl:with-param name="aParam" select="$paramSig"/>
	        </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    

<!-- ************************************************************************** 
     name="checkNull"

     Code to throw an IllegalArgumentException if a keyword parameter is null.     
     
     Template Parameters:
     
        $aKeyword = the displayText of the Keyword being processed.
        $aParam   = the displayText of the Parameter being processed.
     
     Example:
    
     if (mapName == null) throw new IllegalArgumentException("setApplicationMap.mapName = null");
     
     ********************************************************************** -->
    <xsl:template name="checkNull" >
        <xsl:param name="aKeyword" />
        <xsl:param name="aParam" />
        <xsl:text>        if ( </xsl:text><xsl:value-of select="$aParam"/><xsl:text> == null ) </xsl:text>
        <xsl:text>throw new IllegalArgumentException ( &#x22;</xsl:text>
        <xsl:value-of select="$aKeyword"/><xsl:text>.</xsl:text>
        <xsl:value-of select="$aParam"/><xsl:text> = null&#x22;);&#xA;</xsl:text>
    </xsl:template>


<!-- ************************************************************************** 
     name="methodCase"

     Ensure a method name begins with lower-case character.
     
     Template Parameters:
     
        $aMethod = the method name to evaluate and convert.
     
     Example:
    
     returns "setVariableValue" if passed "SetVariableValue"
     
     ********************************************************************** -->
    <xsl:template name="methodCase" >
        <xsl:param name="aMethod" />
        <xsl:variable name="leadchar" select="translate(substring($aMethod,1,1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        <xsl:value-of select="concat($leadchar, substring($aMethod,2))"/>
    </xsl:template>


<!-- ************************************************************************** 
     mode="lc"

     return an elements value with leading lower-case character.
     
     ********************************************************************** -->
    <xsl:template match="*|@*" mode="lc" >
        <xsl:variable name="leadchar" select="translate(substring(.,1,1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
        <xsl:value-of select="concat($leadchar, substring(.,2))"/>
    </xsl:template>

</xsl:stylesheet>
