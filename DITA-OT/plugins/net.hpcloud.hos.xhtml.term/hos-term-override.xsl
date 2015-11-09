<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg">

                

<xsl:template match="*[contains(@class, ' topic/term ')]" name="topic.term">
  <xsl:variable name="keys" select="@keyref" as="attribute()?"/>
  
  
  <xsl:message>concat($WORKDIR, $PATH2PROJ, @href)   <xsl:value-of select="concat($WORKDIR, $PATH2PROJ, @href)"/></xsl:message>
  <xsl:message>$WORKDIR <xsl:value-of select="$WORKDIR"/></xsl:message>
  <xsl:message>$PATH2PROJ <xsl:value-of select="$PATH2PROJ"/></xsl:message>
  <xsl:message>@href <xsl:value-of select="@href"/></xsl:message>
  
  <xsl:choose>
    <xsl:when test="@keyref and @href">
      <xsl:variable name="updatedTarget" as="xs:string">
        <xsl:apply-templates select="." mode="find-keyref-target"/>
      </xsl:variable>
      
      <xsl:variable name="entry-file-contents" as="document-node()?">
        <xsl:if test="empty(@scope) or @scope = 'local'">
          <!--<xsl:variable name="entry-file-uri" select="concat($WORKDIR, $PATH2PROJ, @href)"/>-->   
          <xsl:variable name="entry-file-uri" select="concat($WORKDIR,  @href)"/>      
          <xsl:sequence select="document($entry-file-uri, /)"/>    
        </xsl:if>
      </xsl:variable>
      <!-- Glossary id defined in <glossentry> -->
      <xsl:variable name="glossid" select="substring-after($updatedTarget, '#')" as="xs:string"/>
      <!--
          Language preference.
          NOTE: glossid overrides language preference.
      -->
      <xsl:variable name="reflang" as="xs:string?">
        <xsl:call-template name="getLowerCaseLang"/>
      </xsl:variable>
      <xsl:variable name="matched-target" as="element()?">
        <xsl:call-template name="getMatchingTarget">
          <xsl:with-param name="m_entry-file-contents" select="$entry-file-contents"/>
          <xsl:with-param name="m_glossid" select="$glossid"/>
          <xsl:with-param name="m_reflang" select="$reflang"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- End: Language preference. -->

      <!-- Text should be displayed -->
      <xsl:variable name="displaytext">
        <xsl:choose>
          <xsl:when test="normalize-space(.) != '' and empty(processing-instruction('ditaot')[. = 'gentext'])">
            <xsl:apply-templates mode="dita-ot:text-only"/>
          </xsl:when>
          <xsl:when test="exists(ancestor::*[contains(@class, ' topic/copyright ')]) or generate-id(.) = generate-id(key('keyref', @keyref)[1])">
            <xsl:apply-templates select="." mode="getMatchingSurfaceForm">
              <xsl:with-param name="m_matched-target" select="$matched-target"/>
              <xsl:with-param name="m_keys" select="$keys"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="getMatchingAcronym">
              <xsl:with-param name="m_matched-target" select="$matched-target"/>
              <xsl:with-param name="m_keys" select="$keys"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- End of displaytext -->

      <!-- hovertip text -->
      <xsl:variable name="hovertext">
        <xsl:apply-templates select="." mode="getMatchingGlossdef">
          <xsl:with-param name="m_matched-target" select="$matched-target"/>
          <xsl:with-param name="m_keys" select="$keys"/>
        </xsl:apply-templates>
      </xsl:variable>
      <!-- End of hovertip text -->

      <a class="gloss">
        <xsl:apply-templates select="." mode="add-linking-attributes"/>
        <xsl:apply-templates select="." mode="add-desc-as-hoverhelp">
          <xsl:with-param name="hovertext" select="$hovertext">
          </xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="output-term">
          <xsl:with-param name="displaytext" select="normalize-space($displaytext)"/>
        </xsl:apply-templates>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="output-term">
        <xsl:with-param name="displaytext">
          <xsl:apply-templates select="."  mode="dita-ot:text-only"/>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>