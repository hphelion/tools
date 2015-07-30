<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd df relpath mapdriven index-terms java xsl mapdriven"
    xmlns:java="org.dita.dost.util.ImgUtils"
  version="2.0">

  <!-- =============================================================

       DITA Map to HTML5 Transformation

       Copyright (c) 2010, 2012 DITA For Publishers

       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.

       This transform requires XSLT 2.


       ============================================================== -->
  <!-- These two libraries end up getting imported via the dita2xhtml.xsl from the main toolkit
     because the base XSL support lib is integrated into that file. So these inclusions are redundant.
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  -->
  
  <xsl:import href="../../net.sourceforge.dita4publishers.html2/xsl/map2html2Impl.xsl"/>

  <xsl:include href="map2html5Nav.xsl"/>
  <xsl:include href="map2html5NavTabbed.xsl"/>
  <xsl:include href="map2html5NavIco.xsl"/>
  <xsl:include href="map2html5Content.xsl"/>
  <xsl:include href="map2html5Collection.xsl"/>
  <xsl:include href="map2html5Template.xsl"/>
  <xsl:include href="nav-point-title.xsl"/>
  <xsl:include href="commonHtmlExtensionSupport.xsl"/>     
  <xsl:include href="javascripts.xsl"/>
  <xsl:include href="css.xsl"/>    
  <xsl:include href="i18n.xsl"/>  
  
  <xsl:param name="dita-css" select="'css/topic-html5.css'" as="xs:string"/>
  <xsl:param name="TRANSTYPE" select="'html5'" />
  <xsl:param name="siteTheme" select="'theme-01'" />
  <xsl:param name="BODYCLASS" select="''" />
  <xsl:param name="CLASSNAVIGATION" select="'left'" />
  <xsl:param name="jsoptions" select="''" />
  <xsl:param name="JS" select="''" />
  <xsl:param name="CSSTHEME" select="''" />
  <xsl:param name="NAVIGATIONMARKUP" select="'default'" />
  <xsl:param name="JSONVARFILE" select="''" />
  <xsl:param name="HTML5D4PINIT" select="''" />
  
  
  <xsl:param name="HTML5THEMEDIR" select="'themes'" />
  <xsl:param name="HTML5THEMECONFIG" select="''" />
  

  <xsl:param name="IDMAINCONTAINER" select="'d4h5-main-container'" />
  <xsl:param name="CLASSMAINCONTAINER" select="''" />
  
  <xsl:param name="IDMAINCONTENT" select="'d4h5-main-content'" />   
  <xsl:param name="CLASSMAINCONTENT" select="''" />
  
  <xsl:param name="IDSECTIONCONTAINER" select="'d4h5-section-container'" />
  <xsl:param name="CLASSSECTIONCONTAINER" select="''" />     
  
  
  <xsl:param name="IDLOCALNAV" select="'home'" />
  
  <xsl:param name="GRIDPREFIX" select="'grid_'" />
  
  <xsl:param name="HTTPABSOLUTEURI" select="''" />

      
  <xsl:param name="mathJaxInclude" select="'false'"/>
  <xsl:param name="mathJaxIncludeBoolean" 
    select="matches($mathJaxInclude, 'yes|true|on|1', 'i')"
    as="xs:boolean"
  />
  
  <xsl:param name="mathJaxUseCDNLink" select="'false'"/>
  <xsl:param name="mathJaxUseCDNLinkBoolean" select="false()" as="xs:boolean"/><!-- For EPUB, can't use remote version -->
  
  <xsl:param name="mathJaxUseLocalLink" select="'false'"/>
  <xsl:param name="mathJaxUseLocalLinkBoolean" 
    select="$mathJaxIncludeBoolean"  
    as="xs:boolean"
  />
  
  <!-- FIXME: Parameterize the location of the JavaScript directory -->
  <xsl:param name="mathJaxLocalJavascriptUri" select="'js/mathjax/MathJax.js'"/>
  
  <!-- Parameter used in commonHtmlExtensionSupport.xsl -->
  <xsl:param name="include.roles" as="xs:string" select="''"/>
  
  
  <xsl:variable name="HTML5THEMECONFIGDOC" select="document($HTML5THEMECONFIG)" /> 
  
  <xsl:variable name="TEMPLATELANG">
 	<xsl:apply-templates select="/map" mode="mapAttributes" />
  </xsl:variable>
  
  <xsl:template match="*" mode="mapAttributes" >
  	<xsl:call-template name="getLowerCaseLang"/>
  </xsl:template>
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message>
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^

      HTML5 Parameters:

      + CLASSMAINCONTAINER = "<xsl:sequence select="$CLASSMAINCONTAINER"/>"
      + CLASSNAVIGATION    = "<xsl:sequence select="$CLASSNAVIGATION"/>"
      + CLASSSECTIONCONTAINER= "<xsl:sequence select="$CLASSSECTIONCONTAINER"/>"
      + CSSTHEME           = "<xsl:sequence select="$CSSTHEME"/>"
      + IDMAINCONTAINER    = "<xsl:sequence select="$IDMAINCONTAINER"/>"
      + IDSECTIONCONTAINER = "<xsl:sequence select="$IDSECTIONCONTAINER"/>"
      + jsoptions          = "<xsl:sequence select="$jsoptions"/>"
      + JS                 = "<xsl:sequence select="$JS"/>"
      + JSONVARFILE        = "<xsl:sequence select="$JSONVARFILE"/>"
      + cssOutputDir       = "<xsl:sequence select="$cssOutputDir"/>"
      + fileOrganizationStrategy = "<xsl:sequence select="$fileOrganizationStrategy"/>"
      + generateGlossary   = "<xsl:sequence select="$generateGlossary"/>"
      + generateFrameset   = "<xsl:sequence select="$generateFrameset"/>"
      + generateIndex      = "<xsl:sequence select="$generateIndex"/>
      + generateStaticToc  = "<xsl:sequence select="$generateStaticToc"/>"
      + imagesOutputDir    = "<xsl:sequence select="$imagesOutputDir"/>"
      + inputFileNameParam = "<xsl:sequence select="$inputFileNameParam"/>"
      + mathJaxUseCDNLink  = "<xsl:sequence select="$mathJaxUseCDNLink"/>"
      + mathJaxUseLocalLink= "<xsl:sequence select="$mathJaxUseLocalLink"/>"
      + mathJaxLocalJavascriptUri= "<xsl:sequence select="$mathJaxLocalJavascriptUri"/>"
      + mathJaxConfigParam = "<xsl:sequence select="$mathJaxConfigParam"/>"
      + NAVIGATIONMARKUP   = "<xsl:sequence select="$NAVIGATIONMARKUP"/>"
      + outdir             = "<xsl:sequence select="$outdir"/>"
      + OUTEXT             = "<xsl:sequence select="$OUTEXT"/>"
      + tempdir            = "<xsl:sequence select="$tempdir"/>"
      + titleOnlyTopicClassSpec = "<xsl:sequence select="$titleOnlyTopicClassSpec"/>"
      + titleOnlyTopicTitleClassSpec = "<xsl:sequence select="$titleOnlyTopicTitleClassSpec"/>"
      + topicsOutputDir    = "<xsl:sequence select="$topicsOutputDir"/>"

      DITA2HTML parameters:

      + CSS             = "<xsl:sequence select="$CSS"/>"
      + CSSPATH         = "<xsl:sequence select="$CSSPATH"/>"
      + DITAEXT         = "<xsl:sequence select="$DITAEXT"/>"
      + FILEDIR         = "<xsl:sequence select="$FILEDIR"/>"
      + FILTERFILE      = "<xsl:sequence select="$FILTERFILE"/>"
      + KEYREF-FILE     = "<xsl:sequence select="$KEYREF-FILE"/>"
      + OUTPUTDIR       = "<xsl:sequence select="$OUTPUTDIR"/>"
      + PATH2PROJ       = "<xsl:sequence select="$PATH2PROJ"/>"
      + WORKDIR         = "<xsl:sequence select="$WORKDIR"/>"

      + debug           = "<xsl:sequence select="$debug"/>"

      Global Variables:

      + cssOutputPath    = "<xsl:sequence select="$cssOutputPath"/>"
      + topicsOutputPath = "<xsl:sequence select="$topicsOutputPath"/>"
      + imagesOutputPath = "<xsl:sequence select="$imagesOutputPath"/>"
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"

      ==========================================
    </xsl:message>
    <xsl:apply-imports/>
  </xsl:template>



	<xsl:output name="html5" method="html" indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>


  <xsl:template match="/">

    <xsl:message> + [INFO] Using DITA for Publishers HTML5 transformation type</xsl:message>
    <xsl:apply-templates>
      <xsl:with-param name="rootMapDocUrl" select="document-uri(.)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/*[df:class(., 'map/map')]">

    <xsl:apply-templates select="." mode="report-parameters"/>
    
    <!-- this is intended to allow developper to add custom hook -->
    <xsl:apply-templates select="." mode="html5-impl" />

    <xsl:variable name="uniqueTopicRefs" as="element()*" select="df:getUniqueTopicrefs(.)"/>

    <xsl:variable name="chunkRootTopicrefs" as="element()*"
      select="//*[df:class(.,'map/topicref')][@processing-role = 'normal']"
    />

    <xsl:message> + [DEBUG] chunkRootTopicrefs=
      <xsl:sequence select="$chunkRootTopicrefs"/>
    </xsl:message>

	<!-- graphic map -->
    <xsl:variable name="graphicMap" as="element()">
      <xsl:apply-templates select="." mode="generate-graphic-map">
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:result-document href="{relpath:newFile($outdir, 'graphicMap.xml')}" format="graphic-map">
      <xsl:sequence select="$graphicMap"/>
    </xsl:result-document>

    <xsl:message> + [INFO] Collecting data for index generation, enumeration, etc....</xsl:message>

	<!-- collected data -->
    <xsl:variable name="collected-data" as="element()">
      <xsl:call-template name="mapdriven:collect-data"/>
    </xsl:variable>

    <xsl:if test="true() or $debugBoolean">
      <xsl:message> + [DEBUG] Writing file <xsl:sequence select="relpath:newFile($outdir, 'collected-data.xml')"/>...</xsl:message>
      <xsl:result-document href="{relpath:newFile($outdir, 'collected-data.xml')}"
        format="indented-xml"
        >
        <xsl:sequence select="$collected-data"/>
      </xsl:result-document>
    </xsl:if>

    <!-- NOTE: By default, this mode puts its output in the main output file
         produced by the transform.
      -->
      <xsl:variable name="navigation" as="element()*">
      	<xsl:apply-templates select="." mode="choose-html5-nav-markup" >
      	 	<xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      		<xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
      	</xsl:apply-templates>
      </xsl:variable>
      
      <xsl:variable name="documentation-title" as="xs:string">
      	<xsl:apply-templates select="." mode="generate-root-page-header" />
      </xsl:variable>


    <xsl:apply-templates select="." mode="generate-root-pages">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
      <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
      <xsl:with-param name="documentation-title" as="xs:string" select="$documentation-title" tunnel="yes"/>
      <xsl:with-param name="is-root" as="xs:boolean" select="true()" tunnel="yes"/>
    </xsl:apply-templates>
    
    <xsl:apply-templates select="." mode="generate-content">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
       <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
       <xsl:with-param name="baseUri" as="xs:string" select="@xtrf" tunnel="yes"/>
       <xsl:with-param name="documentation-title" as="xs:string" select="$documentation-title" tunnel="yes"/>
        <xsl:with-param name="is-root" as="xs:boolean" select="false()" tunnel="yes"/>
    </xsl:apply-templates>
    
    
    <xsl:apply-templates select="." mode="generate-index">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
      <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
       <xsl:with-param name="baseUri" as="xs:string" select="@xtrf" tunnel="yes"/>
       <xsl:with-param name="documentation-title" as="xs:string" select="$documentation-title" tunnel="yes"/>
         <xsl:with-param name="is-root" as="xs:boolean" select="false()" tunnel="yes"/>
    </xsl:apply-templates>
    <!--    <xsl:apply-templates select="." mode="generate-glossary">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
-->    <xsl:apply-templates select="." mode="generate-graphic-copy-ant-script">
      <xsl:with-param name="graphicMap" as="element()" tunnel="yes" select="$graphicMap"/>
    </xsl:apply-templates>
  </xsl:template>

  
  
  
    <xsl:template mode="generate-root-page-header" match="*[df:class(., 'map/map')]">
  	  <!-- hook for a user-XSL title prefix -->
      <xsl:call-template name="gen-user-panel-title-pfx"/> 
      <xsl:call-template name="map-title" />
  </xsl:template>
  
  <xsl:template name="map-title">
  	<xsl:choose>
        <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
          <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
        </xsl:when>
        <xsl:when test="/*[contains(@class,' map/map ')]/@title">
          <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
        </xsl:when>
        <xsl:otherwise>
        	<xsl:value-of select="''" />
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <xsl:template mode="html5-impl" match="*">
  
  </xsl:template>
 

</xsl:stylesheet>