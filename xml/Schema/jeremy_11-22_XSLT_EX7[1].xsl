<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
  
<xsl:variable name="xmlFolder" select="collection('xml/?select=*.xml')"/>
<!--JJF: I made an xml variable for our xml folder, which will soon be copied over to the
personal repository so that this code can go down to the xml:for-each and
take each consoleID and sort them alphabetically. Y'know I wonder if
it would be a better idea to sort by book_title instead-->


    <xsl:key name="ref" match="contents[@ref]" use="generate-id(preceding-sibling::contents[@ref][1])" />
<!--JJF: This is a key function which will hopefully help automatically construct rows
based on the amount of unique ref values within the contents. Info from how this is
used can be found on https://stackoverflow.com/questions/42087462/xslt-create-table-header-and-rows-->
    <xsl:template match="/">
       <!--JJF: This matches the entire document and we can start to define
       the HTML structue and convert the entire xml document.-->
    <html>
        <head>
            <title>
                  <xsl:apply-templates select="descendant::Book/@ref"/>
            </title>
            <link rel="stylesheet" type="text/css" href="jeremy_11-28-XSLT_EX7.css"/>
            <!--Optional CSS when applied to the sheet-->
        </head>
        
  
        <body>
            <table>
                <tr>
                    <th>Persons</th>
                    <th>Groups</th>
                    <th>Locations</th>
                    <th>Items</th>
                    
                </tr>
                
                
                <xsl:for-each select="$xmlFolder//contents">
                    
                    
                    <tr></tr>
                
                </xsl:for-each>
                
                
                
                
                
            </table>
            
            
            
            <!--JJF: This is where the body shows all the text that is needed-->
            <h1><xsl:apply-templates select="descendant::Book/book_title"/></h1>
            <!--JJF: This displays the book title as the first words in the book
            with the largest font possible (which is what i want)-->
            <xsl:comment> #include virtual = "menu.html"</xsl:comment>
            
           
           <h2> Author: <i><xsl:apply-templates select="descendant::Book/writer"/></i></h2>
           <!--JJF: I wanted to Italicize the author so i wrapped it in <i></i>-->
            <section id="characters,quests,locations">
                
                <h2>Acquisition</h2>
                <!--JJF: Im starting by making my modal xslt here, so i can later match the
                locations,persons,and quests within a template rule later on in the 
                document to transform into <li></li> elements-->
                <strong>Locations:</strong>
                <ul><em><xsl:apply-templates select="//Acquisition/location" mode="loc"/>
                    </em>
                    
                <!--JJF: This takes lists the locations and puts them in text. I also Made locations
                strongly listed. I also listed where the possible locations are in italisized.
                I also need to figure out how to make the locations list vertically.-->
                </ul>
                <strong>Quests:</strong>
                <ul>
                    <em><xsl:apply-templates select="//Acquisition/quest" mode="quest"/>
                      </em>   
                    <!--This captures the quests in acquisitions and lists them unordered-->
                </ul>
                <strong>Characters/NPC's:</strong>
                <ul>
                    <em><xsl:apply-templates select="//Acquisition/person" mode="NPC"/>
                        </em>
                </ul>
                <!--JJF:The bullet points for the unordered list are not showing up correctly, so I think it has to do with the <em> elements
                </em> Or maybe it it just acting this way becuase in the xml i have some of the 
                locations listed horizontally with respect to another instead hard returned.-->
            </section>
            <h2> Book Contents</h2>
            <xsl:apply-templates select="descendant::contents"></xsl:apply-templates>
            <!--This matches all the <p> elements inside of the morrowind books.-->
        
            <h3>Librarium Lore Contents</h3>
    <ul>
     <xsl:for-each select="$xmlFolder//consoleID"> 
     <xsl:sort select="descendant::consoleID" data-type="text" order="ascending"></xsl:sort>
     </xsl:for-each>         
    <!--JJF: I hope this actually sorts the consoleID's alphabetically, from where they are
    linked and tokenized in an unordered list, which is somewhat ordered.
    got help from https://stackoverflow.com/questions/9815479/sort-xml-nodes-in-alphabetical-order-using-xsl
    -->
    </ul>
  <!--JJF: I am attempting to make an ordered list with links at the bottom of the 
  page where you can click on a list of all of our xml -> html markup organized
  by the consoleID element and linked to each page of a book-->
        
        
   <table>
            <tr>
               <th>Reference</th> 
                <th>Times Mentioned</th>
            </tr>
       <xsl:apply-templates select="descendant::contents[@ref]"/>
        <!--JJF: This tells the table to match all of the @ref elements within the 
        contents of the book (Hopefully)-->
   </table>
        <!-- JJF: Im attempting to make a table at the end of the contents document
        to show the count of how many xmlid's are used within the document
        This table will need to make as many rows as there is unique ref values
        are within the document and exclude everything above and below the 
        contents of the xml document. There are two columns, one for the unique
        ref value, and the other with the quantity that is mentioned-->                 
    </body>
    </html>
        <!--JJF: End of the html template-->                
</xsl:template>
    
  <xsl:template match="location" mode="loc">
     <!-- JJF: the purpose of using modal xslt is to multiple elements
      in different places but you are too lazy to specify if you want
      the location element within the Acquisition or the contents, so the 
      mode="loc" specifies that it is already in the acquision which
      was matched with the other mode in the <ul></ul>-->
      <li><xsl:apply-templates></xsl:apply-templates></li>
      
  </xsl:template>
       
    <xsl:template match="quest" mode="quest">
        <!-- JJF: This matches the quests in the acquisition and
        turns them into line elements for bullet pointing-->
        <li><xsl:apply-templates></xsl:apply-templates></li>       
    </xsl:template>
       
    <xsl:template match="person" mode="NPC">
        <!-- JJF: This matches the quests in the acquisition and
        turns them into line elements for bullet pointing-->
        <li><xsl:apply-templates></xsl:apply-templates></li>       
    </xsl:template>
       
     <!--JJF: Attempting to make an xsl:if statement-->
    <xsl:template match="item">
        <item>
            <xsl:if test="item">
                <xsl:attribute name="class">blue</xsl:attribute>
            </xsl:if>
         <xsl:apply-templates/>
        </item>
    </xsl:template>       
    
    <!--JJF: Now lets go into the coloring of the document using CSS-->
    <xsl:template match="contents//person">
        <span class="orange"> <xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="contents//location">
        <span class="green"> <xsl:apply-templates/></span>
    </xsl:template>
 <xsl:template match="group">
                <span class="purple">
                    <xsl:apply-templates/>
                </span>
            </xsl:template>


    <xsl:template match="item">
    <span class="gray">
    <xsl:apply-templates/>    
    </span>
        </xsl:template>

<!--JJF: I just figured out that if i make span elements within the bullet point
it ruins the bullet points I already made with the <li></li> elements, so yeah thats a problem i can 
do without, so i just commented all the code.-->
   <!--<xsl:template match="person" mode="NPC">
       
       <span class="red"><xsl:apply-templates/></span>
   </xsl:template>
    
    <xsl:template match="quest" mode="quest">
        
        <span class="yellow"><xsl:apply-templates/></span>
    </xsl:template>   

    <xsl:template match="location" mode="loc">
        
        <span class="blue"><xsl:apply-templates/></span>
    </xsl:template> -->
    <!--JJF: End of the CSS stylesheet coding-->
    <xsl:template match="descendant::contents[@ref]">
    
        <xsl:for-each select="key('ref', generate-id())">
            <td>
                <tr><xsl:apply-templates/></tr>
            </td>
        </xsl:for-each>
    
    <!--JJF: This is matching with the xsl:key at the top of the xslt stylesheet
    where it is creating a tr element for every unique value of ref within
    the contents of the book-->
</xsl:template>
    
 <xsl:template match="descendant::consoleID">
     <a href="#{tokenize(@xmlid, '\s+')[1]}"></a>
     <!--JJF: This is supposed to turn the consoleID element into a <a></a> element
     with an href attached, then tokenize it with a # infront of the console code
     so it then creates a link up in the sorted list-->
 </xsl:template>   
    
</xsl:stylesheet>