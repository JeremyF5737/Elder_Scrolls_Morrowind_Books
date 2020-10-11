<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
<xsl:output method="xml" indent="yes"/>

    <!--2020-10-11 ebb: This XSLT is designed to run over a Morrowind Wiki html page 
        to scrape out the Book author names. We can keep modifying it if we want to extract other
    data from that file. -->
    
<xsl:template match="/">
   <xml>
   <listAuthor> 
       <xsl:for-each select="//td/a[@title='Lore:Books by Author'] ! normalize-space() => distinct-values()">
           <author xml:id="{tokenize(., ' ')[1] ! lower-case(.)}"><xsl:value-of select="current()"/></author>
           
       </xsl:for-each>
   
   </listAuthor>
   </xml> 
</xsl:template>
    

    
    
</xsl:stylesheet>