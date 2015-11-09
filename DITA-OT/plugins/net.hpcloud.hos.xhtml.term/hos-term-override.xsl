<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg">

                
<xsl:template match="*[contains(@class,' topic/term ')]" name="topic.term">
  <xsl:variable name="keys" select="@keyref"/>
  <xsl:variable name="keydef" select="$keydefs//*[@keys = $keys][normalize-space(@href)]"/>
  <xsl:choose>
    <xsl:when test="@keyref and $keydef/@href">
      <xsl:variable name="target" select="$keydef/@href"/>
      <xsl:variable name="updatedTarget">
        <xsl:apply-templates select="." mode="find-keyref-target">
          <xsl:with-param name="target" select="$target"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:variable name="entry-file" select="concat($WORKDIR, $PATH2PROJ, $target)"/>
      <xsl:variable name="entry-file-uri" select="url:getURL($entry-file)"/>
      
      <!-- Save glossary entry file contents into a variable to workaround the infamous putDocumentCache error in Xalan -->
      <xsl:variable name="entry-file-contents" select="document($entry-file-uri, /)"/>
      <!-- Glossary id defined in <glossentry> -->
      <xsl:variable name="glossid" select="substring-after($updatedTarget, '#')"/>
      <!--
          Language preference.
          NOTE: glossid overrides language preference.
      -->
      <xsl:variable name="reflang">
        <xsl:call-template name="getLowerCaseLang"/>
      </xsl:variable>
      <xsl:variable name="matched-target">
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
          <xsl:when test="normalize-space(.)!=''">
            <xsl:apply-templates select="." mode="dita-ot:text-only"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="boolean(ancestor::*[contains(@class,' topic/copyright ')]) or generate-id(.)=generate-id(key('keyref',@keyref)[1])">
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

      <xsl:choose>
        <xsl:when test="not(normalize-space($updatedTarget)=$OUTEXT)">
          <a href="{$updatedTarget}" title="{$hovertext}" class="gloss">
            <xsl:apply-templates select="." mode="output-term">
              <xsl:with-param name="displaytext" select="normalize-space($displaytext)"/>
            </xsl:apply-templates>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="output-term">
            <xsl:with-param name="displaytext" select="normalize-space($displaytext)"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
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