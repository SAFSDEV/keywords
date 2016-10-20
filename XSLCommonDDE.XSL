<xsl:stylesheet version='1.0'
		xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
		xmlns='http://www.w3.org/TR/REC-html40'>
    
    <xsl:output encoding="UTF-8"  method="html" version="3.2" omit-xml-declaration="yes"/>
		
    <xsl:variable name="maindir"></xsl:variable>
    <xsl:variable name="abbotdir"></xsl:variable>
    <xsl:variable name="imagedir"></xsl:variable>
    <xsl:variable name="javadocdir"></xsl:variable>
    <xsl:variable name="robotdir"></xsl:variable>
    <xsl:variable name="robotjdir"></xsl:variable>
    <xsl:variable name="winrunnerdir"></xsl:variable>
    <xsl:variable name="silkdir"></xsl:variable>
    <xsl:variable name="qarundir"></xsl:variable>
    <xsl:variable name="seleniumdir"></xsl:variable>
    <xsl:variable name="tcdir"></xsl:variable>
    <xsl:variable name="iosdir"></xsl:variable>
    <xsl:variable name="droiddir"></xsl:variable>

    <xsl:template match='/'>
    	<HTML>
    	<HEAD><TITLE>Data Driven Engine (DDE) Action Commands
    	</TITLE></HEAD>
    	<BODY BGCOLOR="#FFFFFF">
    	
    	<!-- Header Area -->
    	<xsl:call-template name="ShellTop"/>
    	
    		<!-- any content you can think of? -->
    	
    	<!-- Footer Area -->
    	<xsl:call-template name="ShellBottom"/>
    	
    	</BODY></HTML>
    </xsl:template>

    <xsl:template name="ShellTop">
	<xsl:call-template name="navBar"/>
	<HR/>    
    </xsl:template>
    
    <xsl:template name="ShellBottom">
    	<TABLE><TR>
    	<TD><FONT FACE="Arial" SIZE="2" COLOR="red">
    	    <xsl:for-each select="//error">
    	        <xsl:value-of select="."/><BR/>
    	    </xsl:for-each>
    	<BR/></FONT></TD></TR></TABLE>
	<HR/>    
	<xsl:call-template name="navBar"/>
    </xsl:template>

    <xsl:template name="navBar">
	<A HREF="DDEngineSetup.htm" target="_blank">DDE Setup</A>, 
	<A HREF="DDEngineReference.htm" target="_blank">DDEngineReference</A>, 
	<!-- A HREF="SQABasicLibraries.htm" target="_blank">SQABasic Libraries</A>, -->
	<A HREF="UsingDDVariables.htm" target="_blank">Using DDVariables</A>, 
	<A HREF="UsingFlowControl.htm" target="_blank">Error Recovery and Flow Control</A>, 
	<A HREF="UsingCustomExtensions.htm" target="_blank">Custom Extensions</A>
    </xsl:template>

	<xsl:template match="domain" mode="domainlinks_out" >
		<xsl:variable name="domainName" select="@name"/>
        <xsl:text disable-output-escaping="yes">&lt;SPAN CLASS='domainMarker'</xsl:text>	
        <xsl:text disable-output-escaping="yes"> TITLE='</xsl:text>
		<xsl:value-of select="$domainName"/>
		<xsl:text disable-output-escaping="yes"> Domain'></xsl:text>
        <xsl:choose>
            <xsl:when test="$domainName='DEV'">
                <xsl:text disable-output-escaping="yes">DEV</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='DOJO'">
                <xsl:text disable-output-escaping="yes">DOJ</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='FLEX'">
                <xsl:text disable-output-escaping="yes">FLX</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='JAVA'">
                <xsl:text disable-output-escaping="yes">JAV</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='NET'">
                <xsl:text disable-output-escaping="yes">NET</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='SAP'">
                <xsl:text disable-output-escaping="yes">SAP</xsl:text>
            </xsl:when>
            <xsl:when test="$domainName='HTML'">
                <xsl:text disable-output-escaping="yes">HTM</xsl:text>
            </xsl:when>            
		</xsl:choose>		
		<xsl:text disable-output-escaping="yes">&lt;/SPAN></xsl:text>
	</xsl:template>
	
    <xsl:template name="keywordEngineLinks">
		<TABLE><TR>
			<xsl:choose>
				<!--If we generate reference for a specific engine, we append the domain information if it exists-->
				<xsl:when test="string-length($engine) > 0">
					<xsl:for-each select="engines/engine[@tool=$engine or @vendor='SAFS']">
						<xsl:variable name="hasDomainsInfo" select="domains"/>
						<TD class="borderStyle">
							<xsl:apply-templates select="." mode="enginelinks_out"/>
							<xsl:if test="$hasDomainsInfo">
								<xsl:text disable-output-escaping="yes">:</xsl:text>
								<xsl:for-each select="domains/domain">
									<xsl:apply-templates select="." mode="domainlinks_out"/>
								</xsl:for-each>						
							</xsl:if>
						</TD>
					</xsl:for-each>
				</xsl:when>
				<!--If we generate reference for all engines, we only list the engine information.-->
				<xsl:otherwise>
					<xsl:for-each select="engines/engine">
						<TD class="borderStyle">
							<xsl:apply-templates select="." mode="enginelinks_out"/>
						</TD>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</TR></TABLE>
    </xsl:template>

    <xsl:template match="engine" mode="enginelinks_out" >
		<xsl:variable name="tool" select="@tool"/>
		<xsl:variable name="toolName" select="@name"/>
        <xsl:text disable-output-escaping="yes">&lt;SPAN CLASS='</xsl:text>
			<xsl:if test="@expectWarnSupport='YES'" >W</xsl:if>
            <xsl:if test="@expectFailSupport='YES'" >F</xsl:if>
			<xsl:text disable-output-escaping="yes">Support'</xsl:text>
			<xsl:choose>
				<xsl:when test="$tool='Robot'">
					<xsl:text disable-output-escaping="yes"> TITLE='Rational Robot Classic'></xsl:text>
					<xsl:text disable-output-escaping="yes">RC</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='RobotJ'">
					<xsl:text disable-output-escaping="yes"> TITLE='Rational RobotJ'></xsl:text>
					<xsl:text disable-output-escaping="yes">RJ</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='SDCommands'">
					<xsl:text disable-output-escaping="yes"> TITLE='SAFS Driver Commands'></xsl:text>
					<xsl:text disable-output-escaping="yes">SDC</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='IOS'">
					<xsl:text disable-output-escaping="yes"> TITLE='Apple IOS'></xsl:text>
					<xsl:text disable-output-escaping="yes">IOS</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='Android'">
					<xsl:text disable-output-escaping="yes"> TITLE='Android'></xsl:text>
					<xsl:text disable-output-escaping="yes">DRD</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='Silk'">
					<xsl:text disable-output-escaping="yes"> TITLE='Segue SilkTest'></xsl:text>
					<xsl:text disable-output-escaping="yes">ST</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='WinRunner'">
					<xsl:text disable-output-escaping="yes"> TITLE='Mercury Interactive WinRunner'></xsl:text>
					<xsl:text disable-output-escaping="yes">WR</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='TestComplete'">
					<xsl:text disable-output-escaping="yes"> TITLE='SmartBear Test Complete'></xsl:text>
					<xsl:text disable-output-escaping="yes">TC</xsl:text>
				</xsl:when>
				<!-- TIDDriverXXXCommands will all match here and shown as TID Engine -->
				<xsl:when test="starts-with($tool, 'TIDDriver')  and contains($tool, 'Commands')">
					<xsl:text disable-output-escaping="yes"> TITLE='SAFS TID Commands'></xsl:text>
					<xsl:text disable-output-escaping="yes">TID</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='TIDComponent'">
					<xsl:text disable-output-escaping="yes"> TITLE='SAFS TID Commands'></xsl:text>
					<xsl:text disable-output-escaping="yes">TID</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='Abbot'">
					<xsl:text disable-output-escaping="yes"> TITLE='Abbot Commands'></xsl:text>
					<xsl:text disable-output-escaping="yes">ABT</xsl:text>
				</xsl:when>
				<xsl:when test="$tool='Selenium'">
					<xsl:if test="@name='Selenium'">
						<xsl:text disable-output-escaping="yes"> TITLE='Selenium1.0'></xsl:text>
						<xsl:text disable-output-escaping="yes">SE</xsl:text>
					</xsl:if>
					<!--For Selenium2.0 (WebDriver), use different icons.-->
					<xsl:if test="@name='Selenium2.0'">
						<xsl:text disable-output-escaping="yes"> TITLE='Selenium2.0'></xsl:text>
						<xsl:text disable-output-escaping="yes">SE2</xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$tool='Autoit'">
                    <xsl:text disable-output-escaping="yes"> TITLE='AutoIT'></xsl:text>
                    <xsl:text disable-output-escaping="yes">AUT</xsl:text>
                </xsl:when>
			</xsl:choose>
		<xsl:text disable-output-escaping="yes">&lt;/SPAN></xsl:text>

    </xsl:template>

    <xsl:template name="iconLegendLine">
        <A href="SAFSReferenceKey.htm" alt="Reference Legend or Key">
        <SMALL><B>[How To Read This Reference]</B></SMALL>
        </A>
    </xsl:template>
	
	<xsl:template match="engine" mode="keywordEngineLinks_domainTitle">
		<xsl:param name="prefixInfo" />
		<xsl:value-of select="domainSupport" />
		<xsl:if test="domainSupport"> 
			<xsl:text disable-output-escaping="yes"> TITLE='</xsl:text>
				<xsl:if test="string-length($prefixInfo) > 0">
					<xsl:value-of select="$prefixInfo"/>
					<xsl:text disable-output-escaping="yes"> &#xD;</xsl:text>
				</xsl:if>		
			<xsl:value-of select="domainSupport" />
			<xsl:text disable-output-escaping="yes">'</xsl:text>
		</xsl:if>
    </xsl:template>  

    <xsl:template name="domain_description">
    <TABLE  col="2" border="1" width="100%">
		<TR>
			<xsl:for-each select="engines/engine">
			<xsl:sort select="@tool"/>
			<TD>
			<xsl:value-of select="@tool" />
			</TD>
			</xsl:for-each>
		</TR>
		<TR>
			<xsl:for-each select="engines/engine">
			<xsl:sort select="@tool"/>
			<TD>
			<xsl:choose>
			<xsl:when test="domainSupport">
				<xsl:value-of select="domainSupport" />
			</xsl:when>
	        <xsl:otherwise><xsl:text disable-output-escaping="yes">TBD</xsl:text></xsl:otherwise>
			</xsl:choose>	  
			</TD>
			</xsl:for-each>
		</TR>
	</TABLE>
    </xsl:template>

    
</xsl:stylesheet>
