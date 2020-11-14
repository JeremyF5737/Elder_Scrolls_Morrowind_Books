<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    <!--2015-10-18 ebb: As usual we altered the stylesheet template to read from the TEI namespace and output in XHTML. And we need an xsl:output statement, too.-->
    
    <xsl:variable name="xmlColl" select="collection('xml/?select=*.xml')"/>
    
    <xsl:template match="/">
       <!-- Matches the document as html code-->
        <html>
            <head><h1><xsl:apply-templates/></h1></head>
<!--            Takes the book title element and outputs it into the head as text-->
            <body>
                
  
                <ul><xsl:apply-templates select="$xmlColl//body" mode="toc"/></ul>
                <hr/>
                <!--ebb: This template rule sets up my "toc" mode for the table of contents, so that in the top part of the document we'll output a selection of the body elements specially formatted for my Table of Contents, and so that in another section of my document below, which I've put inside a <div> element, we can also output the full text of the poems with their titles again.  -->           
                <div id="main">
                    <xsl:apply-templates select="$xmlColl//body"/>
                    <!-- JJF: This template displays the text form Emily Dickinsons poems-->
                </div>
                
            </body>
            
        </html>
    </xsl:template>
<!--End of the html converting template-->
    
    
    <xsl:template match="contents" mode="toc">
       <strong><xsl:apply-templates select="preceding::book_title"/></strong>: 
            <!--Takes the book title from the contents and makes -->
           
    </xsl:template>
    
    <xsl:template match="contents">
        <xsl:apply-templates select="descendant::p"/>
        
        <!--ebb: This rule outputs the titles once again, this time in another section of the document where you are reproducing the full text of each poem. 
            NOTE: You may have observed in your output that some of our titles are inconsistently formatted! Some poem numbers have a period after them, and some only white space before the parenthetical information that summarizes each poem's publication history. An Optional Challenge for the next assignment is to find a way to:
        a) output only the poem and its number in the part of the document where you reproduce the poems, and/or
        b) remove the rogue period from the output, using the replace() function.
       We'll show you how we did both of these things in our solution to XSLT Exercise 6.-->
        <xsl:apply-templates select="descendant::lg"/>
        
    </xsl:template>
    
    <xsl:template match="l" mode="toc">
        <q><xsl:apply-templates/></q>
    </xsl:template>
    
    <xsl:template match="l">
        <xsl:value-of select="count(preceding::l) + 1"/><xsl:text>: </xsl:text><xsl:apply-templates/>
        <xsl:if test="following-sibling::l"><br/></xsl:if>
        <!--        This template matches line elements and gives them numbers, then if there is a space it creates a br element and starts counting from 1 again-->
        <!--ebb: 
            1) Notice how we handled the numbering of lines, using the count() function and the preceding:: axis. 
            This works to read and count the preceding:: l inside each specific poem file in our collection. 
            2) For the xsl:if test, we actually wanted to deal with sibling elements, children of the same parent <lg>. 
            This is how we tested to see where to position a <br/> element, and prevent it from being output on the last line of a line-group. If there is a following-sibling <l>, then output a <br/>. When there is no following-sibling <l>, then, we will not output the unnecessary <br/> at the end of a <p>.-->
    </xsl:template>
    
    <xsl:template match="rdg">
        <span class="{@wit}"><xsl:apply-templates/></span>
    </xsl:template>
    <!--    Creates the span elements so that they can be modified later with a CSS link-->
    <!--ebb: This last template rule matches our <rdg> elements in order to wrap an HTML <span> around each one and give it a distinct @class attribute. This will help us to style variants using CSS or manipulate them with JavaScript later, but for now, it ensures that the HTML retains the information on Dickinson's variants that we have coded in our XML.-->
    
</xsl:stylesheet>  