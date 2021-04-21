<!-- XSLJavaCucumberModel.XSL
     
     Most commonly used in conjunction with:
     
         XSLJavaCucumberModelPrep.BAT
         XSLJavaCucumberModelPrep.XSL
         
     This file is intended to process the keyword XML that documents all the 
     Driver Commands and Component Function keywords defined for SAFS Engines.
     http://safsdev.sourceforge.net/sqabasic2000/SAFSReference.php
    
     The output of this transformation is Java sourcecode.  The sourcecode when 
     compiled will provide Cucumber Step Definitions for all keywords in the library 
     processed.
     
     Example invocation:
     
     msxsl.exe DDDriverCommands.xml XSLJavaCucumberModel.xsl -o DriverCommands.java
     
     To do ALL at once:
     
     XSLJavaCucumberModelPrep.BAT    which generates:
     _JavaCucumberModelBuild.BAT     which builds all Java source code
     
     ********************************************************************** -->
     
<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:include href="XSLJavaCucumberFunctions.XSL"/>


<!-- ************************************************************************** 
     match="/"
     Begin processing the keyword library.  Output the class header and package 
     information then begin routing processing based on the libraryType.
     ********************************************************************** -->
    <xsl:template match="/" >    
        <xsl:apply-templates select="/keyword_library/libraryInfo"/>
	
	<xsl:apply-templates select="/keyword_library/keywords" mode="StaticFields"/>
        <xsl:text>&#xA;&#xA;</xsl:text>
        
        <xsl:if test="/keyword_library/libraryType/@type ='DRIVER'">
	    <xsl:apply-templates select="/keyword_library/keywords" mode="DriverCommand"/>
        </xsl:if>
        
        <xsl:if test="/keyword_library/libraryType/@type ='COMPONENT'">
	    <xsl:apply-templates select="/keyword_library/keywords" mode="ComponentFunction"/>
        </xsl:if>
	
        <xsl:if test="/keyword_library/libraryType/@type ='ENGINE'">
	    <xsl:apply-templates select="/keyword_library/keywords" mode="EngineCommand"/>
        </xsl:if>
	
	<xsl:text>&#xA;}&#xA;</xsl:text>
    </xsl:template>


<!-- ************************************************************************** 
     match="keywords" mode="DriverCommand"
     Process all keywords in this XML as Driver Commands.
    
     Example:
    
     static DriverCommand SetApplicationMap (String MapName) {
         DriverCommand dc = new DriverCommand ("SetApplicationMap");
         dc.addParameter (MapName);
         return dc;
     }
     ********************************************************************** -->
    <xsl:template match="keywords" mode="DriverCommand">    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
            <xsl:variable name="methodSig"><xsl:apply-templates select="@displayText" mode="lc"/></xsl:variable>
	    <xsl:apply-templates select="." mode="JavaDocParams"/>
	    
            <xsl:text>@Given("^</xsl:text><xsl:value-of select="@name"/><xsl:text>$")&#xA;</xsl:text>
            <xsl:text>@When("^</xsl:text><xsl:value-of select="@name"/><xsl:text>$")&#xA;</xsl:text>
            <xsl:text>@Then("^</xsl:text><xsl:value-of select="@name"/><xsl:text>$")&#xA;</xsl:text>
            
            <xsl:text>    static public DriverCommand </xsl:text>
            <xsl:value-of select="$methodSig"/><xsl:text> (</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>String </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	        <xsl:if test="position() != last()">
	            <xsl:text>, </xsl:text>
	        </xsl:if>
	    </xsl:for-each>
	    <xsl:text>) {&#xA;</xsl:text>
	    <xsl:apply-templates select="./parameters" mode="TrapOptional" />
            <xsl:text>        DriverCommand dc = new DriverCommand(</xsl:text>
            <xsl:value-of select="@name"/><xsl:text>_KEYWORD);&#xA;</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>        dc.addParameter(</xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
                <xsl:text>);&#xA;</xsl:text>
	    </xsl:for-each>
            <xsl:text>        return dc;&#xA;    }&#xA;&#xA;</xsl:text>
            
            <!-- *************************************************************
                 If the keyword takes more than 1 argument then output another 
                 method signature that accepts a String[] argument for all.
                 
                 Example:
                
                 static public DriverCommand SetVariableValues ( String[] parameters ) {
                     DriverCommand dc = new DriverCommand ("SetVariableValues");
                     dc.addParameters ( parameters );
                     return dc;
                 }
                 ********************************************************* -->
	    <xsl:if test="count(./parameters/parameter) &gt; 1">
 	        <xsl:apply-templates select="." mode="JavaDocArray"/>
	        <xsl:text>    static public DriverCommand </xsl:text>
                <xsl:value-of select="$methodSig"/><xsl:text> (String[] parameters) {&#xA;&#xA;</xsl:text>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">parameters</xsl:with-param>
	        </xsl:call-template>
	        <xsl:text>        DriverCommand dc = new DriverCommand(</xsl:text>
                <xsl:value-of select="@name"/><xsl:text>_KEYWORD);&#xA;</xsl:text>
		<xsl:text>        dc.addParameters(parameters);&#xA;</xsl:text>
	        <xsl:text>        return dc;&#xA;    }&#xA;&#xA;</xsl:text>
	    </xsl:if>                	    
        </xsl:for-each>       
    </xsl:template>


<!-- ************************************************************************** 
     match="keywords" mode="EngineCommand"
     Process all keywords in this XML as Engine Commands.
    
     Example:
    
     static EngineCommand EnableDomains (String domains) {
         EngineCommand ec = new EngineCommand ("EnableDomains");
         ec.addParameter (domains);
         return ec;
     }
     ********************************************************************** -->
    <xsl:template match="keywords" mode="EngineCommand">    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
            <xsl:variable name="methodSig"><xsl:apply-templates select="@displayText" mode="lc"/></xsl:variable>
	    <xsl:apply-templates select="." mode="JavaDocParams"/>
            <xsl:text>    static public EngineCommand </xsl:text>
            <xsl:value-of select="$methodSig"/><xsl:text> (</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>String </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	        <xsl:if test="position() != last()">
	            <xsl:text>, </xsl:text>
	        </xsl:if>
	    </xsl:for-each>
	    <xsl:text>) {&#xA;</xsl:text>
	    <xsl:apply-templates select="./parameters" mode="TrapOptional" />
            <xsl:text>        EngineCommand ec = new EngineCommand(</xsl:text>
            <xsl:value-of select="@name"/><xsl:text>_KEYWORD);&#xA;</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>        ec.addParameter(</xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
                <xsl:text>);&#xA;</xsl:text>
	    </xsl:for-each>
            <xsl:text>        return ec;&#xA;    }&#xA;&#xA;</xsl:text>
            
            <!-- *************************************************************
                 If the keyword takes more than 1 argument then output another 
                 method signature that accepts a String[] argument for all.
                 
                 Example:
                
                 static public EngineCommand IsMatchingPath ( String[] parameters ) {
                     EngineCommand ec = new EngineCommand ("IsMatchingPath");
                     ec.addParameters ( parameters );
                     return ec;
                 }
                 ********************************************************* -->
	    <xsl:if test="count(./parameters/parameter) &gt; 1">
 	        <xsl:apply-templates select="." mode="JavaDocArray"/>
	        <xsl:text>    static public EngineCommand </xsl:text>
                <xsl:value-of select="$methodSig"/><xsl:text> (String[] parameters) {&#xA;&#xA;</xsl:text>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">parameters</xsl:with-param>
	        </xsl:call-template>
	        <xsl:text>        EngineCommand ec = new EngineCommand(</xsl:text>
                <xsl:value-of select="@name"/><xsl:text>_KEYWORD);&#xA;</xsl:text>
		<xsl:text>        ec.addParameters(parameters);&#xA;</xsl:text>
	        <xsl:text>        return ec;&#xA;    }&#xA;&#xA;</xsl:text>
	    </xsl:if>                	    
        </xsl:for-each>       
    </xsl:template>


<!-- ************************************************************************** 
     match="keywords" mode="ComponentFunction"
     Process all keywords in this XML as Component Functions.
    
     Example:
    
     static ComponentFunction InputKeys (String winname, String compname, String Text) {
         ComponentFunction cf = new ComponentFunction ("InputKeys", winname, compname);
         cf.addParameter (Text);
         return cf;
     }
     ********************************************************************** -->
    <xsl:template match="keywords" mode="ComponentFunction">    
        <xsl:for-each select="//keyword">
	    <xsl:sort select="@displayText"/>
            <xsl:variable name="methodSig"><xsl:apply-templates select="@displayText" mode="lc"/></xsl:variable>
	    <xsl:apply-templates select="." mode="JavaDocParams"/>
            <xsl:text>    static public ComponentFunction </xsl:text>
            <xsl:value-of select="$methodSig"/>
            <xsl:text> (String winname, String compname</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>, String </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
	    </xsl:for-each>
	    <xsl:text>) {&#xA;&#xA;</xsl:text>
	    <xsl:call-template name="checkNull">
	        <xsl:with-param name="aKeyword" select="$methodSig"/>
	        <xsl:with-param name="aParam">winname</xsl:with-param>
	    </xsl:call-template>
	    <xsl:call-template name="checkNull">
	        <xsl:with-param name="aKeyword" select="$methodSig"/>
	        <xsl:with-param name="aParam">compname</xsl:with-param>
	    </xsl:call-template>
	    <xsl:apply-templates select="./parameters" mode="TrapOptional" />
            <xsl:text>        ComponentFunction cf = new ComponentFunction(</xsl:text>
            <xsl:value-of select="@name"/><xsl:text>_KEYWORD, winname, compname);&#xA;</xsl:text>
            <xsl:for-each select="./parameters/parameter">
	        <xsl:text>        cf.addParameter(</xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
                <xsl:text>);&#xA;</xsl:text>
	    </xsl:for-each>
            <xsl:text>        return cf;&#xA;    }&#xA;&#xA;</xsl:text>

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
 	        <xsl:apply-templates select="." mode="JavaDocArray"/>
	        <xsl:text>    static public ComponentFunction </xsl:text>
		<xsl:value-of select="$methodSig"/>
		<xsl:text>(String winname, String compname, String[] parameters) {&#xA;&#xA;</xsl:text>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">winname</xsl:with-param>
	        </xsl:call-template>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">compname</xsl:with-param>
	        </xsl:call-template>
	        <xsl:call-template name="checkNull">
	            <xsl:with-param name="aKeyword" select="$methodSig"/>
	            <xsl:with-param name="aParam">parameters</xsl:with-param>
	        </xsl:call-template>
	        <xsl:text>        ComponentFunction cf = new ComponentFunction(</xsl:text>
                <xsl:value-of select="@name"/><xsl:text>_KEYWORD, winname, compname);&#xA;</xsl:text>
		<xsl:text>        cf.addParameters(parameters);&#xA;</xsl:text>
	        <xsl:text>        return cf;&#xA;    }&#xA;&#xA;</xsl:text>
	    </xsl:if>                	    
        </xsl:for-each>       
    </xsl:template>


<!-- ************************************************************************** 
     match="keyword" mode="JavaDocParams"
     Create a Javadoc header for the keyword method.
     ********************************************************************** -->
    <xsl:template match="keyword" mode="JavaDocParams">
        <xsl:text>&#xA;    /***********</xsl:text>
        <xsl:text> &lt;pre></xsl:text><xsl:copy-of select="./description/short_desc"/><xsl:copy-of select="./description/detailed_desc"/><xsl:text>    &lt;/pre></xsl:text>
        <xsl:text>    Supporting Engines:&#xA;    &lt;P/>&lt;UL></xsl:text>
        <xsl:for-each select="./engines/engine">
            <xsl:text>&#xA;        &lt;LI></xsl:text><xsl:value-of select="@vendor"/>
            <xsl:text> </xsl:text><xsl:value-of select="@tool"/><xsl:text>&lt;/LI></xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;    &lt;/UL>&#xA;</xsl:text>
        <xsl:if test="/keyword_library/libraryType/@type ='COMPONENT'" >
            <xsl:text>&#xA;     @param winname  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The name of the window to act upon.</xsl:text>
            <xsl:text>&#xA;     @param compname  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The name of the component to act upon.</xsl:text>
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
        <xsl:text>&#xA;    /***********</xsl:text>
        <xsl:text> &lt;pre></xsl:text><xsl:copy-of select="./description/short_desc"/><xsl:copy-of select="./description/detailed_desc"/><xsl:text>    &lt;/pre></xsl:text>
        <xsl:text>    &#xA;    Supporting Engines:&#xA;    &lt;P/>&lt;UL></xsl:text>
        <xsl:for-each select="./engines/engine">
            <xsl:text>&#xA;        &lt;LI></xsl:text><xsl:value-of select="@vendor"/>
            <xsl:text> </xsl:text><xsl:value-of select="@tool"/><xsl:text>&lt;/LI></xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;    &lt;/UL>&#xA;</xsl:text>
        <xsl:if test="/keyword_library/libraryType/@type ='COMPONENT'" >
            <xsl:text>&#xA;     @param winname  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The name of the window to act upon.</xsl:text>
            <xsl:text>&#xA;     @param compname  Optional:NO</xsl:text>
            <xsl:text>&#xA;            The name of the component to act upon.</xsl:text>
        </xsl:if>
        <xsl:text>&#xA;     @param parameters  Optional:NO</xsl:text>
        <xsl:text>&#xA;            An array containing the following parameters:</xsl:text>
        <xsl:text>&#xA;    &lt;UL>&#xA;</xsl:text>
        <xsl:for-each select="./parameters/parameter">
            <xsl:text>&lt;BR/>        </xsl:text><xsl:apply-templates select="@displayText" mode="lc"/>
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
     package org.safs.model.cucumber.commands;
     
     public class DDDriverCommands
    
     ********************************************************************** -->
    <xsl:template match="libraryInfo">
        <xsl:text>&#xA;/******************************************************************************</xsl:text>
        <xsl:text>&#xA; * </xsl:text><xsl:value-of select="@name"/><xsl:text>.java</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * Copyright (C) SAS Institute, All rights reserved.</xsl:text>
        <xsl:text>&#xA; * General Public License: https://www.gnu.org/licenses/gpl-3.0.en.html</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * This program is free software: you can redistribute it and/or modify</xsl:text>
        <xsl:text>&#xA; * it under the terms of the GNU Lesser General Public License as published by</xsl:text>  
        <xsl:text>&#xA; * the Free Software Foundation, either version 3 of the License, or</xsl:text>
        <xsl:text>&#xA; * (at your option) any later version.</xsl:text> 
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * This program is distributed in the hope that it will be useful,</xsl:text>  
        <xsl:text>&#xA; * but WITHOUT ANY WARRANTY; without even the implied warranty of</xsl:text>
        <xsl:text>&#xA; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</xsl:text>
        <xsl:text>&#xA; * GNU Lesser General Public License for more details.</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * !!! DO NOT EDIT THIS FILE !!!</xsl:text>
        <xsl:text>&#xA; * This file is automatically generated from XML source.  Any changes you make </xsl:text>
        <xsl:text>&#xA; * here will be erased the next time the file is generated.</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * The following assets are needed to generate this file:</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; *   </xsl:text><xsl:value-of select="@name"/><xsl:text>.xml</xsl:text>
        <xsl:text>&#xA; *   keyword_library.dtd</xsl:text>
        <xsl:text>&#xA; *   XSLJavaCucumberFunctions.xsl</xsl:text>
        <xsl:text>&#xA; *   XSLJavaCucumberModel.xsl</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; * Example invocation to generate:</xsl:text>     
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; *   msxsl.exe </xsl:text><xsl:value-of select="@name"/><xsl:text>.xml XSLJavaCucumberModel.xsl -o </xsl:text><xsl:value-of select="@name"/><xsl:text>.java</xsl:text>
        <xsl:text>&#xA; *</xsl:text>
        <xsl:text>&#xA; ******************************************************************************/ </xsl:text>
        <xsl:text>&#xA;package org.safs.model.cucumber.commands;&#xA;&#xA;</xsl:text>
        <xsl:text>&#xA;import cucumber.api.Format;&#xA;</xsl:text>
        <xsl:text>&#xA;import cucumber.api.java.en.Given;&#xA;</xsl:text>
        <xsl:text>&#xA;import cucumber.api.java.en.Then;&#xA;</xsl:text>
        <xsl:text>&#xA;import cucumber.api.java.en.When;&#xA;&#xA;</xsl:text>               
        <xsl:if test="/keyword_library/libraryType/@type = 'COMPONENT'">
            <xsl:text>&#xA;import org.safs.model.ComponentFunction;&#xA;&#xA;</xsl:text>
        </xsl:if>
        <xsl:if test="/keyword_library/libraryType/@type = 'DRIVER'">
            <xsl:text>&#xA;import org.safs.model.DriverCommand;&#xA;&#xA;</xsl:text>
        </xsl:if>
        <xsl:if test="/keyword_library/libraryType/@type = 'ENGINE'">
            <xsl:text>&#xA;import org.safs.model.EngineCommand;&#xA;&#xA;</xsl:text>
        </xsl:if>
        <xsl:text>&#xA;public class </xsl:text><xsl:value-of select="@name"/><xsl:text> {&#xA;</xsl:text>
        
        <xsl:text>&#xA;    /*****************</xsl:text>
        <xsl:text>&#xA;    Private Singleton Instance</xsl:text>
        <xsl:text>&#xA;    ****************/</xsl:text>
        <xsl:text>&#xA;    private static final </xsl:text><xsl:value-of select="@name"/><xsl:text> singleton = new </xsl:text><xsl:value-of select="@name"/><xsl:text>(); &#xA;</xsl:text>
        
        <xsl:text>&#xA;    /*****************</xsl:text>
        <xsl:text>&#xA;    Private Constructor</xsl:text>
        <xsl:text>&#xA;    Static class needing no instantiation.</xsl:text>
        <xsl:text>&#xA;    ****************/</xsl:text>
        <xsl:text>&#xA;    private </xsl:text><xsl:value-of select="@name"/><xsl:text>() {}&#xA;</xsl:text>
        
        <xsl:text>&#xA;    /*****************</xsl:text>
        <xsl:text>&#xA;    public Singleton to access class static methods via instance</xsl:text>
        <xsl:text>&#xA;    ****************/</xsl:text>
        <xsl:text>&#xA;    public static </xsl:text><xsl:value-of select="@name"/><xsl:text> getInstance() { return singleton;}&#xA;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
