<!-- XSLJavaComponentModel.XSL
     
     This file is intended to process the keyword XML satisfying the syntax 
     required by keyword_library.dtd.  This is the XML that documents all the 
     Driver Commands and Component Function keywords defined for SAFS Engines.
     http://safsdev.sourceforge.net/sqabasic2000/RRAFSReference.htm
    
     The output of this transformation is Java sourcecode.  The sourcecode when 
     compiled will provide instance methods for all keywords in the library 
     processed.
     
     Example invocation:
     
     msxsl.exe WindowFunctions.xml XSLJavaComponentModel.xsl -o Window.java
     
     ********************************************************************** -->
     
<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:include href="XSLJavaCommonFunctions.XSL"/>

    <xsl:variable name="tablemode">TABLEMODE</xsl:variable>
    <xsl:variable name="normalmode">NORMAL</xsl:variable>

<!-- ************************************************************************** 
     match="/"
     Begin processing the keyword library.  Output the class header and package 
     information then begin routing processing based on the libraryType.
     ********************************************************************** -->
    <xsl:template match="/" >    
        <xsl:apply-templates select="/keyword_library/libraryInfo"/>
        <xsl:text>&#xA;&#xA;</xsl:text>
        
        <xsl:if test="/keyword_library/libraryType/@type ='COMPONENT'">
	    <xsl:apply-templates select="/keyword_library/keywords" mode="ComponentFunction"/>
        </xsl:if>
	
	<xsl:text>&#xA;}&#xA;</xsl:text>
    </xsl:template>


<!-- ************************************************************************** 
     match="keywords" mode="ComponentFunction"
     Process all keywords in this XML as Component Functions.
    
     Example:
    
     public ComponentFunction InputKeys (String Text) {
        ...
     }
     ********************************************************************** -->
    <xsl:template match="keywords" mode="ComponentFunction">    
        <xsl:variable name="library" select="/keyword_library/libraryInfo/@name" />
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
	    <!--
	         public ComponentFunction SetApplicationMap (String MapName) 
	                                                                    -->
	    <xsl:apply-templates select="." mode="JavaDocParams">
	        <xsl:with-param name="listmode" select="$normalmode"/>
	    </xsl:apply-templates>
            <xsl:variable name="methodSig"><xsl:apply-templates select="@displayText" mode="lc"/></xsl:variable>
            <xsl:text>    public ComponentFunction </xsl:text><xsl:value-of select="$methodSig"/>
            <xsl:text>(</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>String </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	        <xsl:if test="position() != last()" >
	            <xsl:text>, </xsl:text>
	        </xsl:if>
	    </xsl:for-each>
	    <xsl:text> ) {&#xA;</xsl:text>
	    <xsl:apply-templates select="./parameters" mode="TrapOptional" />
            <xsl:text>        return </xsl:text>
            <xsl:value-of select="$library"/><xsl:text>.</xsl:text><xsl:value-of select="$methodSig"/>
            <xsl:text>(getWindow().getName(), getName()</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>, </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	    </xsl:for-each>
            <xsl:text>);&#xA;</xsl:text>
            <xsl:text>    }&#xA;</xsl:text>
	    <!--
	         public void SetApplicationMap (StepTestTable table, String MapName) 
	                                                                    -->
	    <xsl:apply-templates select="." mode="JavaDocParams">
	        <xsl:with-param name="listmode" select="$tablemode"/>
	    </xsl:apply-templates>
            <xsl:text>    public void </xsl:text>
            <xsl:value-of select="$methodSig"/>
            <xsl:text>(StepTestTable table</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>, String </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	    </xsl:for-each>
	    <xsl:text> ) {&#xA;&#xA;</xsl:text>
            <xsl:call-template name="checkNull">
	        <xsl:with-param name="aKeyword" select="$methodSig"/>
	        <xsl:with-param name="aParam">table</xsl:with-param>
	    </xsl:call-template>
	    <xsl:apply-templates select="./parameters" mode="TrapOptional" />
            <xsl:text>        table.add( </xsl:text>
            <xsl:value-of select="$library"/><xsl:text>.</xsl:text><xsl:value-of select="$methodSig"/>
            <xsl:text>(getWindow().getName(), getName()</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>, </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	    </xsl:for-each>
            <xsl:text>));&#xA;</xsl:text>
            <xsl:text>    }&#xA;</xsl:text>

            <!-- *************************************************************
                 If the keyword takes more than 1 argument then output another 
                 method signature that accepts a String[] argument for all.
                 
                 Example:
                
                 static public ComponentFunction VerifyProperty ( String winname, String compname, String[] parameters ) {
                     ComponentFunction cf = new ComponentFunction ("VerifyProperty", winname, compname );
                     cf.addParameters( parameters );
                     return cf;
                 }
                 ********************************************************* -->
	    <xsl:if test="count(./parameters/parameter) &gt; 1">
		<!--
		    public ComponentFunction SetApplicationMap (String[] parameters) 
								           -->
 	        <xsl:apply-templates select="." mode="JavaDocArray">
 	            <xsl:with-param name="listmode" select="$normalmode"/>
 	        </xsl:apply-templates>
		<xsl:text>    public ComponentFunction </xsl:text>
		<xsl:value-of select="$methodSig"/>
		<xsl:text>(</xsl:text>
	        <xsl:text>String[] parameters ) {&#xA;&#xA;</xsl:text>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">parameters</xsl:with-param>
	        </xsl:call-template>
		<xsl:text>        return </xsl:text>
		<xsl:value-of select="$library"/><xsl:text>.</xsl:text><xsl:value-of select="$methodSig"/>
		<xsl:text>(getWindow().getName(), getName(), parameters);&#xA;</xsl:text>
		<xsl:text>    }&#xA;</xsl:text>
		<!--
		    public void SetApplicationMap (StepTestTable table, String[] parameters) 
								           -->
 	        <xsl:apply-templates select="." mode="JavaDocArray">
 	            <xsl:with-param name="listmode" select="$tablemode"/>
 	        </xsl:apply-templates>
		<xsl:text>    public void </xsl:text>
		<xsl:value-of select="$methodSig"/>
		<xsl:text>(StepTestTable table, String[] parameters ) {&#xA;&#xA;</xsl:text>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">table</xsl:with-param>
	        </xsl:call-template>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">parameters</xsl:with-param>
	        </xsl:call-template>
		<xsl:text>        table.add( </xsl:text>
		<xsl:value-of select="$library"/><xsl:text>.</xsl:text><xsl:value-of select="$methodSig"/>
		<xsl:text>(getWindow().getName(), getName(), parameters));&#xA;</xsl:text>
		<xsl:text>    }&#xA;</xsl:text>
	    </xsl:if>                	    
        </xsl:for-each>       
    </xsl:template>


<!-- ************************************************************************** 
     match="keyword" mode="JavaDocParams"
     Create a Javadoc header for the keyword method.
     ********************************************************************** -->
    <xsl:template match="keyword" mode="JavaDocParams">
        <xsl:param name="listmode" />
        <xsl:text>&#xA;    /***********</xsl:text>
        <xsl:text> &lt;pre></xsl:text><xsl:copy-of select="./description/short_desc"/><xsl:copy-of select="./description/detailed_desc"/><xsl:text>    &lt;/pre></xsl:text>
        <xsl:text>    Supporting Engines:&#xA;    &lt;P/>&lt;UL></xsl:text>
        <xsl:for-each select="./engines/engine">
            <xsl:text>&#xA;    &lt;LI></xsl:text><xsl:value-of select="@vendor"/>
            <xsl:text> </xsl:text><xsl:value-of select="@tool"/><xsl:text>&lt;/LI></xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;    &lt;/UL>&#xA;</xsl:text>
        <xsl:if test="$listmode = $tablemode" >
            <xsl:text>&#xA;     @param table  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The table to add the record to.</xsl:text>
        </xsl:if>
        <xsl:for-each select="./parameters/parameter">
            <xsl:text>&#xA;     @param </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
            <xsl:text>  Optional:</xsl:text><xsl:value-of select="@optional"/>
            <xsl:if test="count(@default) &gt; 0">
                <xsl:text>  DefaultVal:</xsl:text><xsl:value-of select="@default"/>
            </xsl:if>
            <xsl:copy-of select="./description/short_desc"/>
        </xsl:for-each>
        <xsl:text>&#xA;     **********/&#xA;</xsl:text>
    </xsl:template>

    
<!-- ************************************************************************** 
     match="keyword" mode="JavaDocArray"
     Create a Javadoc header for the keyword method.
     ********************************************************************** -->
    <xsl:template match="keyword" mode="JavaDocArray">
        <xsl:param name="listmode" />
        <xsl:text>&#xA;    /***********</xsl:text>
        <xsl:text> &lt;pre></xsl:text><xsl:copy-of select="./description/short_desc"/><xsl:copy-of select="./description/detailed_desc"/><xsl:text>    &lt;/pre></xsl:text>
        <xsl:text>    &#xA;    Supporting Engines:&#xA;    &lt;P/>&lt;UL></xsl:text>
        <xsl:for-each select="./engines/engine">
            <xsl:text>&#xA;    &lt;LI></xsl:text><xsl:value-of select="@vendor"/>
            <xsl:text> </xsl:text><xsl:value-of select="@tool"/><xsl:text>&lt;/LI></xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;    &lt;/UL>&#xA;</xsl:text>
        <xsl:if test="$listmode = $tablemode" >
            <xsl:text>&#xA;     @param table  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The table to add the record to.</xsl:text>
        </xsl:if>
        <xsl:text>&#xA;     @param parameters  Optional:NO</xsl:text>
        <xsl:text>&#xA;            An array containing the following parameters:</xsl:text>
        <xsl:text>&#xA;    &lt;UL>&#xA;</xsl:text>
        <xsl:for-each select="./parameters/parameter">
            <xsl:text>&lt;BR/>         </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
            <xsl:text> -- Optional:</xsl:text><xsl:value-of select="@optional"/>
            <xsl:if test="count(@default) &gt; 0">
                <xsl:text>  DefaultVal:</xsl:text><xsl:value-of select="@default"/>
            </xsl:if>
            <xsl:copy-of select="./description/short_desc"/>
        </xsl:for-each>
        <xsl:text>&#xA;    &lt;/UL>&#xA;</xsl:text>
        <xsl:text>&#xA;     **********/&#xA;</xsl:text>
    </xsl:template>

    
<!-- ************************************************************************** 
     match="libraryInfo"
     Begin output with generic header comment information then output the class  
     information.
    
     Example:
     
     /****
      * Copyright ...
      ****
     package org.safs.model.commands;
     
     public class DDDriverCommands
    
     ********************************************************************** -->
    <xsl:template match="libraryInfo">
        <xsl:variable name="compType" select="substring-before(@name,'Functions')"/>
        <xsl:text>&#xA;/******************************************************************************</xsl:text>
        <xsl:text>&#xA; * </xsl:text><xsl:value-of select="$compType"/><xsl:text>.java</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * Copyright (c) by SAS Institute Inc., Cary, NC 27513</xsl:text>
        <xsl:text>&#xA; * General Public License: http://www.opensource.org/licenses/gpl-license.php</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * !!! DO NOT EDIT THIS FILE !!!</xsl:text>
        <xsl:text>&#xA; * This file is automatically generated from XML source.  Any changes you make </xsl:text>
        <xsl:text>&#xA; * here will be erased the next time the file is generated.</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * The following assets are needed to generate this file:</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; *   </xsl:text><xsl:value-of select="@name"/><xsl:text>.xml</xsl:text>
        <xsl:text>&#xA; *   keyword_library.dtd</xsl:text>
        <xsl:text>&#xA; *   XSLJavaCommonFunctions.xsl</xsl:text>
        <xsl:text>&#xA; *   XSLJavaComponentModel.xsl</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * Example invocation to generate:</xsl:text>     
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; *   msxsl.exe </xsl:text><xsl:value-of select="@name"/><xsl:text>.xml XSLJavaComponentModel.xsl -o </xsl:text><xsl:value-of select="$compType"/><xsl:text>.java</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; ******************************************************************************/ </xsl:text>
        <xsl:text>&#xA;package org.safs.model.components;&#xA;</xsl:text>
        <xsl:text>&#xA;import org.safs.model.commands.</xsl:text><xsl:value-of select="@name"/><xsl:text>;</xsl:text>
        <xsl:text>&#xA;import org.safs.model.ComponentFunction;</xsl:text>
        <xsl:text>&#xA;import org.safs.model.components.UIComponent;</xsl:text>
        <xsl:text>&#xA;import org.safs.model.StepTestTable;&#xA;</xsl:text>
        <xsl:text>&#xA;public class </xsl:text><xsl:value-of select="$compType"/>        
        <xsl:text> extends </xsl:text>
        <xsl:if test="count(@chainTo) = 0">
            <xsl:text>UIComponent {&#xA;</xsl:text>
        </xsl:if>
        <xsl:if test="count(@chainTo) &gt; 0">
            <xsl:value-of select="substring-before(@chainTo, 'Functions')"/>
            <xsl:text> {&#xA;</xsl:text>
        </xsl:if>
        <!-- 
             For all components EXCEPT Window
                                              -->
        <xsl:if test="$compType != 'Window'" >        
            <xsl:text>&#xA;    /*****************</xsl:text>
            <xsl:text>&#xA;    Constructor &#xA;</xsl:text>
            <xsl:text>&#xA;    Create an instance of pseudo-component representing </xsl:text>
            <xsl:text>&#xA;    a specific component in a specific window.</xsl:text>
            <xsl:text>&#xA;    </xsl:text>
            <xsl:text>&#xA;    @param window  Optional:NO </xsl:text>
            <xsl:text>&#xA;           Specifies which Window this component is 'in'.</xsl:text>
            <xsl:text>&#xA;    @param compname Optional:NO </xsl:text>
            <xsl:text>&#xA;           Specifies the AppMap name of the component in the Window.</xsl:text>
            <xsl:text>&#xA;    ****************/</xsl:text>
            <xsl:text>&#xA;    public </xsl:text><xsl:value-of select="$compType"/>
            <xsl:text>(Window window, String compname) {&#xA;</xsl:text>
            <xsl:text>&#xA;        super(window, compname);</xsl:text>
            <xsl:text>&#xA;    }&#xA;</xsl:text>
            <xsl:text>&#xA;    /*****************</xsl:text>
            <xsl:text>&#xA;    Constructor &#xA;</xsl:text>
            <xsl:text>&#xA;    Create an instance of pseudo-component representing </xsl:text>
            <xsl:text>&#xA;    a specific component in a specific window.</xsl:text>
            <xsl:text>&#xA;    </xsl:text>
            <xsl:text>&#xA;    This convenience routine will create the requisite Window component.</xsl:text>
            <xsl:text>&#xA;    </xsl:text>
            <xsl:text>&#xA;    @param winname  Optional:NO </xsl:text>
            <xsl:text>&#xA;           Specifies the AppMap name of the window.</xsl:text>
            <xsl:text>&#xA;    @param compname Optional:NO </xsl:text>
            <xsl:text>&#xA;           Specifies the AppMap name of the component in the Window.</xsl:text>
            <xsl:text>&#xA;    ****************/</xsl:text>
            <xsl:text>&#xA;    public </xsl:text><xsl:value-of select="$compType"/>
            <xsl:text>(String winname, String compname) {&#xA;</xsl:text>
            <xsl:text>&#xA;        this(new Window(winname), compname);</xsl:text>
            <xsl:text>&#xA;    }&#xA;</xsl:text>
            <xsl:text>&#xA;    protected </xsl:text><xsl:value-of select="$compType"/>
            <xsl:text>(String compname) {&#xA;</xsl:text>
            <xsl:text>&#xA;        super(compname);</xsl:text>
            <xsl:text>&#xA;    }&#xA;</xsl:text>
        </xsl:if>
        <!-- 
             For Window component
                                              -->
        <xsl:if test="$compType = 'Window'" >        
            <xsl:text>&#xA;    /*****************</xsl:text>
            <xsl:text>&#xA;    Constructor &#xA;</xsl:text>
            <xsl:text>&#xA;    Create an instance of pseudo-Window representing </xsl:text>
            <xsl:text>&#xA;    a specific AppMap window.</xsl:text>
            <xsl:text>&#xA;    </xsl:text>
            <xsl:text>&#xA;    @param winname  Optional:NO </xsl:text>
            <xsl:text>&#xA;           Specifies the AppMap name of the window.</xsl:text>
            <xsl:text>&#xA;    ****************/</xsl:text>
            <xsl:text>&#xA;    public </xsl:text><xsl:value-of select="$compType"/>
            <xsl:text>(String winname) {&#xA;</xsl:text>
            <xsl:text>&#xA;        super(winname);</xsl:text>
            <xsl:text>&#xA;        setWindow(this);</xsl:text>
            <xsl:text>&#xA;    }&#xA;</xsl:text>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
