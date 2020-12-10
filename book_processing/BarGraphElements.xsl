<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/2000/svg">
    
    <xsl:output method="xml" indent="yes"/>
    <!--JJF: All variables need to be placed at the top of the xslt schema for the xslt to process
    the information. The variables with the count function attached will go through each xml
    document an take a ount of how many elements that are within the contents.-->
    <xsl:variable name="morrowindColl" select="collection('morrowindColl/?select=*.xml')"/> 
    <!--JJF: Takes the collection folder of all of the kpop albums-->
    <xsl:variable name="X-Spacer" select="100"/>
    <xsl:variable name="Y-Stretcher" select="-5"/>
    <xsl:variable name="barWidth" select="30"/>
    <xsl:variable name="maxPersonCount" select="$morrowindColl//contents/count(.//person[@ref]) => max()"/>
    <xsl:variable name="maxLocationCount" select="$morrowindColl//contents/count(.//location[@ref]) => max()"/>
    <xsl:variable name="maxGroupCount" select="$morrowindColl//contents/count(.//group[@ref]) => max()"/>
    <xsl:variable name="maxItemCount" select="$morrowindColl//contents/count(.//item[@ref]) => max()"/>
    
 
    <!--jjf: we need to make a variable that gets the maximum of one of the variables and 
    for it to choose the maximum of all the variables.
    -->
    <xsl:variable name="YMax" select="($maxPersonCount, $maxLocationCount, $maxGroupCount, $maxItemCount) => max()"/>
    
    <!--2020-11-19 ebb: See SVG color names at https://www.december.com/html/spec/colorsvg.html  -->  
    <!--ebb: Album types are coded as 'mini' | 'full' | 'live' | 'repackage' | 'single' | 'extended' -->    
    
    <xsl:template match="/">
        
                
                
                <!--STACKED BAR PLOT -->           
                
                <!--JJF: for-each table functions to turn the svg table on/off.
                There are a total of 6 morrowind books that have no notable features
                within their book contents. The xsl:if at the bottom tests to see
                if there 0 elements for items, locations, groups, and person. If all
                of them are equal to 0 within the contents, the svg bar-graph will not be plotted.-->
                <xsl:for-each select="$morrowindColl//contents">
                    <xsl:variable name="locs" select="count(descendant::location)"/>
                    <xsl:variable name="groups" select="count(descendant::group)"/>
                    <xsl:variable name="peeps" select="count(descendant::person)"/>
                    <xsl:variable name="items" select="count(descendant::item)"/>
                    <xsl:if test="sum(($locs, $groups,$peeps,$items)) gt 0">
                        <xsl:result-document href="svg_output/{current()/base-uri() ! tokenize(.,'/')[last()] ! substring-before(.,'.xml')}.svg" method="xml">
  
                    <!--JJF: This viewbox determines how the svg will show once in the web/author view. Before this was 
                    created there was a translate funciton at the top of the xslt, where it set our maximum coordinates
                    on the grid and resizes the graph to be appropriate for the page. Later on this becomes 
                    kind of irrelevant due to flex.container for the resizing of the html pages.-->
                        <svg viewBox="0 0 550 1000" preserveAspectRatio="xMinYMin meet">>
                        <xsl:comment>maxPersonCount <xsl:value-of select="$maxPersonCount"/></xsl:comment>
                        <xsl:comment>max of all the Y-values <xsl:value-of select="$YMax"/></xsl:comment>
                            <xsl:comment>maxGroupCount <xsl:value-of select="$maxGroupCount"/></xsl:comment>
                            <xsl:comment>maxLocationCount <xsl:value-of select="$maxLocationCount"/></xsl:comment>
                            <xsl:comment>maxItemCount <xsl:value-of select="$maxItemCount"/></xsl:comment>
                        <!--JJF: These comments just show the maximum values beforehand on the graph and display them
                        within the text output.-->
                            
                            <g transform="translate(80, 900)">
                            <!--X axis --> 
                            <line x1="0" y1="0" x2="{10 * $X-Spacer}" y2="0" stroke="indigo"/>
                            <!--Y axis -->
                            <line x1="0" y1="0" x2="0" y2="{$YMax * $Y-Stretcher}" stroke="indigo"/>
                    
                    
                   
                    <!--JJF: These variables are here to count the contents of the book for each element-->
                    <xsl:variable name="personCount" select="count(.//person[@ref])"/>
                    <xsl:variable name="itemCount" select="count(.//item[@ref])"/>
                    <xsl:variable name="locationCount" select="count(.//location[@ref])"/>
                    <xsl:variable name="groupCount" select="count(.//group[@ref])"/>
                                                                        
                    
                        
                    <xsl:variable name="barValues" select="tokenize('person group item location', ' ')"/>    
                        
                       
                        <xsl:for-each select="$barValues">
                            <!--JJF: This is the code that actually plots the bars on the graph, and plots the X-axis labels
                            with them as well. In the background, the maximum count within all of the books is plotted in 
                            WhiteSmoke, and then in the front the colored bars stack infront of the maximum to show the refrence of
                            how many elements in that book account for that maximum.-->
                            <xsl:variable name="XPos" select="position() * $X-Spacer"/>
<xsl:if test="position() = 1"><line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$maxPersonCount * $Y-Stretcher}" stroke="WhiteSmoke" stroke-width="50"/>
    <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$personCount * $Y-Stretcher}" stroke="pink" stroke-width="50"/>
    <text x="{$XPos}"  y="30" style="writing-mode: tb; glyph-orientation-vertical: 90;"> People </text>
</xsl:if>
                            <xsl:if test="position() = 2"><line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$maxGroupCount * $Y-Stretcher}" stroke="WhiteSmoke" stroke-width="50"/>
                                <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$groupCount * $Y-Stretcher}" stroke="blue" stroke-width="50"/>
                                <text x="{$XPos}"  y="30" style="writing-mode: tb; glyph-orientation-vertical: 90;"> Groups </text>
                            </xsl:if>
                            <xsl:if test="position() = 3"><line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$maxItemCount * $Y-Stretcher}" stroke="WhiteSmoke" stroke-width="50"/>
                                <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$itemCount * $Y-Stretcher}" stroke="yellow" stroke-width="50"/>
                                <text x="{$XPos}"  y="30" style="writing-mode: tb; glyph-orientation-vertical: 90;"> Items </text>
                            </xsl:if>
                            
                            <xsl:if test="position() = 4">
                                
                                <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$maxLocationCount * $Y-Stretcher}" stroke="WhiteSmoke" stroke-width="50"/>
                                <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$locationCount * $Y-Stretcher}" stroke="orange" stroke-width="50"/>
                                <text x="{$XPos}"  y="30" style="writing-mode: tb; glyph-orientation-vertical: 90;"> Locations </text>
                            </xsl:if>                                                                                                
                   </xsl:for-each>
                    
                            <text x="-20" y="-200" style="writing-mode: tb; glyph-orientation-vertical: 90;"> Quantity of ID used</text>
                            <!--Y-Axis title-->
                          
                            <text x="125"  y="-800">Count of Morrowind References</text>
                            <!--Graph title-->
                                          
                        </g>
                    </svg>
                    </xsl:result-document></xsl:if>
                </xsl:for-each>
                                                              
    </xsl:template>   
    
    
    
</xsl:stylesheet>

