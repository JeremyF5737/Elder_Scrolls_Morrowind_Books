<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
   
    <xsl:output indent="yes" method="xhtml" omit-xml-declaration="yes" doctype-system="about:legacy-compat"/>
    
    <xsl:variable name="morrowindColl" select="collection('morrowindColl/?select=*.xml')"/>   
    <!-- This is our root template establishing the structure of our HTML-output -->
    <xsl:template match="/">
        <xsl:result-document href="../web/librarium/morrowindTables.html" method="xhtml"> 
        <!--ebb: xsl:result-document outputs a file with a file name. We'll use it again later to output each of the morrowind books in the collection. -->
         <html>
            <head>
                <title>Morrowind Book Information</title>
            <link rel="stylesheet" type="text/css" href="bookTable.css"/>
            </head>
            <body>
                <h1>Morrowind Book Information</h1>
                <ul>
                    <xsl:for-each select="$morrowindColl//Book">
                        <xsl:sort select="book_title"/>
                        <li><a href="{tokenize(base-uri(), '/')[last()] ! substring-before(., '.')}.html"><xsl:apply-templates select="book_title"/></a></li>
                    </xsl:for-each>
                    
                </ul>
                
              <h2>Table of Items</h2> 
                <table>
                    <tr>
                        <th>Items</th>
                        <th>Books with Counts</th>
                        <th>Link to First Mention in Each Book</th>
                    </tr>
                  <xsl:for-each select="$morrowindColl//item/@ref ! lower-case(.) ! normalize-space() => distinct-values()">
                      <!--ebb: We have to use xsl:for-each instead of xsl:apply-templates to process this because distinct-values converts XML nodes into strings of text. -->          
                      <xsl:sort/>
                    <xsl:variable name="currentItem" as="xs:string" select="current()"/>
                  <tr>
                      <td><xsl:value-of select="current()"/></td>
                      
                      <td><ul>
                          <xsl:for-each select="$morrowindColl//Book[descendant::item/@ref ! lower-case(.) ! normalize-space() = current()]">
                              
                          <xsl:sort select="count(current()/descendant::item[@ref ! lower-case(.) !  normalize-space() = $currentItem])" order="descending"/>  
                           <!--ebb: I repaired this sort() so it is working. Here I needed to sort on a count of item elements, not item/@ref attributes (there would always be just one @ref, so that's why the sort() didn't work before.) -->   
                              
                          <li><xsl:apply-templates select="book_title"/>, count: <xsl:value-of select="count(descendant::item[@ref ! lower-case(.) ! normalize-space() = $currentItem])"/></li>              
                      </xsl:for-each>
                      </ul>
                      </td>
                      
                      
                      <td> <ul>
                          <xsl:for-each select="$morrowindColl//Book[descendant::item/@ref ! lower-case(.) ! normalize-space()  = $currentItem]">
                              <li><a href="../web/librarium/{tokenize(current()/base-uri(), '/')[last()] ! substring-before(., '.')}.html#{replace(descendant::item[@ref ! lower-case(.) ! normalize-space() =$currentItem][1]/@ref ! lower-case(.) ! normalize-space(), '[ '']', '')}">first mention</a></li>
                              
                          </xsl:for-each> 
                      </ul></td>
                      
                  </tr>
                  </xsl:for-each>
                    
                    
                </table>
             <hr/> <!-- horizontal rule line to separate sections-->
                <h2>Table of locations</h2>
                <table>
                    <tr>
                        <th>Locations</th>
                        <th>Books with Counts</th>
                        <th>Link to First Mention in Each Book</th>
                    </tr>
                    <xsl:for-each select="distinct-values($morrowindColl//location/@ref ! normalize-space())">
                        <!--ebb: We have to use xsl:for-each instead of xsl:apply-templates to process this because distinct-values converts XML nodes into strings of text. -->
                        <xsl:sort/>
                        <!--ebb: This sorts the nodes in alphabetical order by the last name if there's space separator. -->
                        <xsl:variable name="currentLoc" as="xs:string" select="current()"/>
                        
                        <tr> <td><xsl:value-of select="current()"/></td>
                            <td>
                                <ul><xsl:for-each select="$morrowindColl//Book[descendant::location/@ref ! normalize-space() = current()]">
                                    <xsl:sort select="count(descendant::location[@ref ! normalize-space() = $currentLoc])" order="descending"/>                 
                                    <li><xsl:apply-templates select="book_title"/>, count: <xsl:value-of select="count(descendant::location[@ref ! normalize-space() = $currentLoc])"/></li>              
                                </xsl:for-each>
                                    
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <xsl:for-each select="$morrowindColl//Book[descendant::location/@ref ! normalize-space()  = $currentLoc]">
                                        <li><a href="{tokenize(current()/base-uri(), '/')[last()] ! substring-before(., '.')}.html#{replace(descendant::location[@ref ! normalize-space() =$currentLoc][1]/@ref, '[ '']', '')}">first mention</a></li>
                                        
                                    </xsl:for-each> 
                                </ul>
                            </td>
                        </tr>
                    </xsl:for-each>   
                    
                    
                </table>
                
                <hr/> <!-- horizontal rule line to separate sections-->
                <h2>Table of Groups</h2>
             <table>
                 <tr>
                     <th>Groups</th>
                     <th>Books with Counts</th>
                     <th>Link to First Mention in Each Book</th>
                 </tr>
                 <xsl:for-each select="distinct-values($morrowindColl//group/@ref ! normalize-space() )">
                     <!--ebb: We have to use xsl:for-each instead of xsl:apply-templates to process this because distinct-values converts XML nodes into strings of text. -->
                     <xsl:sort select="tokenize(., ' ')[last()]"/>
                     <!--ebb: This sorts the nodes in alphabetical order  y the last name if there's space separator. -->
                     <xsl:variable name="currentGroup" as="xs:string" select="current()"/>
                     
                     <tr> <td><xsl:value-of select="current()"/></td>
                         <td>
                             <ul><xsl:for-each select="$morrowindColl//Book[descendant::group/@ref ! normalize-space() = current()]">
                                 <xsl:sort select="count(descendant::group[@ref ! normalize-space()  = $currentGroup])" order="descending"/>                 
                                 <li><xsl:apply-templates select="book_title"/>, count: <xsl:value-of select="count(descendant::group[@ref ! normalize-space()  = $currentGroup])"/></li>              
                             </xsl:for-each>
                                 
                             </ul>
                         </td>
                         <td>
                             <ul>
                                 <xsl:for-each select="$morrowindColl//Book[descendant::group[@ref ! normalize-space()  = $currentGroup]]">
                                     <li><a href="{tokenize(current()/base-uri(), '/')[last()]! substring-before(., '.')}.html#{replace(descendant::group[@ref ! normalize-space()=$currentGroup][1]/@ref, '[ '']', '')}">first mention</a></li>
                                     
                                 </xsl:for-each> 
                             </ul>
                         </td>
                     </tr>
                 </xsl:for-each>    
              
                
             </table>
                <hr/> <!-- horizontal rule line to separate sections-->
                <h2>Table of Persons</h2>
                <table>
                    <tr>
                        <th>Persons</th>
                        <th>Books with Counts</th>
                        <th>Link to First Mention in Each Book</th>
                    </tr>
                    <xsl:for-each select="distinct-values($morrowindColl//person/@ref ! normalize-space() )">
                        <!--ebb: We have to use xsl:for-each instead of xsl:apply-templates to process this because distinct-values converts XML nodes into strings of text. -->
                        <xsl:sort select="tokenize(., ' ')[last()]"/>
                        <!--ebb: This sorts the nodes in alphabetical order  y the last name if there's space separator. -->
                        <xsl:variable name="currentPerson" as="xs:string" select="current()"/>
                        
                        <tr> <td><xsl:value-of select="current()"/></td>
                            <td>
                                <ul><xsl:for-each select="$morrowindColl//Book[descendant::person/@ref ! normalize-space() = current()]">
                                    <xsl:sort select="count(descendant::person/@ref ! normalize-space()  = $currentPerson)" order="descending"/>                 
                                    <li><xsl:apply-templates select="book_title"/>, count: <xsl:value-of select="count(descendant::person[@ref ! normalize-space()  = $currentPerson])"/></li>              
                                </xsl:for-each>
                                    
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <xsl:for-each select="$morrowindColl//Book[descendant::person[@ref ! normalize-space()  = $currentPerson]]">
                                        <li><a href="{tokenize(current()/base-uri(), '/')[last()]! substring-before(., '.')}.html#{replace(descendant::person[@ref ! normalize-space()=$currentPerson][1]/@ref, '[ '']', '')}">first mention</a></li>
                                        
                                    </xsl:for-each> 
                                </ul>
                            </td>
                        </tr>
                    </xsl:for-each>   
                </table>
            </body>
        </html>
        </xsl:result-document>
        
        <!--ebb: BELOW THIS, in a new xsl:for-each, we output each book as a separate document to save in the same file directory as the morrowindTables.html output file. -->
     
        <xsl:for-each select="$morrowindColl//Book">]
      <!--ebb: Set a variable to work out the new output filename for each book --><xsl:variable name="fileName" as="xs:string" select="tokenize(current()/base-uri(), '/')[last()] ! substring-before(., '.')"/>
 
            <xsl:result-document href="../web/librarium/{$fileName}.html" method="xhtml">
              <html>
                  <head>
                      <title><xsl:apply-templates select="book_title"/></title>
                      <link rel="stylesheet" type="text/css" href="bookSpine.css"/>
                      <!--JJF: Let Issac style using CSS and replace using his link.-->
                      <!--ebb: Replace with your project CSS to style the books -->
                  </head>
                  <body>
                      <h1><xsl:apply-templates select="book_title"/></h1>
                       <h2><xsl:apply-templates select="writer"/></h2>
                      
                      <h3>Acquisitions</h3>
                      <ul><xsl:apply-templates select="Acquisition/location"/></ul>
                      
                      <xsl:apply-templates select="contents"/>
                     
                  </body>
              </html>
          </xsl:result-document>
      </xsl:for-each>   
    </xsl:template>
    
    <xsl:template match="Acquisition/location">
        <li><xsl:apply-templates/>: Visitable? <xsl:apply-templates select="@visitable"/></li>
    </xsl:template>   
    
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="count(preceding::item) = 0">
                <span class="{name()}" id="{replace(@ref, '[ '']', '') ! lower-case(.) ! normalize-space()}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{name()}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
    
    <xsl:template match="location">
        <xsl:choose>
            <xsl:when test="count(preceding::location) = 0">
                <span class="{name()}" id="{replace(@ref, '[ '']', '')}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{name()}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
    
    <xsl:template match="group">
        <xsl:choose>
            <xsl:when test="count(preceding::group) = 0">
                <span class="{name()}" id="{replace(@ref, '[ '']', '')}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{name()}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
    
    <xsl:template match="person">
        <xsl:choose>
            <xsl:when test="count(preceding::person) = 0">
                <span class="{name()}" id="{replace(@ref, '[ '']', '')}"><xsl:apply-templates/></span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{name()}"><xsl:apply-templates/></span>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>
  
</xsl:stylesheet>
