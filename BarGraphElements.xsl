<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns="http://www.w3.org/2000/svg">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="morrowindColl" select="collection('morrowinColl/?select=*.xml')"/> 
    <!--JJF: Takes the collection folder of all of the kpop albums-->
    <xsl:variable name="X-Spacer" select="50"/>
    <xsl:variable name="Y-Stretcher" select="-10"/>
    <xsl:variable name="barWidth" select="30"/>
    <xsl:variable name="maxPersonCount" select="$morrowindColl//contents/count(.//person[@ref]) => max()"/>
    <xsl:variable name="maxLocationCount" select="$morrowindColl//contents/count(.//location[@ref]) => max()"/>
    <xsl:variable name="maxGroupCount" select="$morrowindColl//contents/count(.//group[@ref]) => max()"/>
    <xsl:variable name="maxItemCount" select="$morrowindColl//contents/count(.//item[@ref]) => max()"/>
    
    
    <!--2020-11-19 ebb: See SVG color names at https://www.december.com/html/spec/colorsvg.html  -->  
    <!--ebb: Album types are coded as 'mini' | 'full' | 'live' | 'repackage' | 'single' | 'extended' -->    
    
    <xsl:template match="/">
        <svg>
            <xsl:comment>maxPersonCount <xsl:value-of select="$maxPersonCount"/></xsl:comment>
            <g transform="translate(80, 500)">
                <!--X axis --> 
                <line x1="0" y1="0" x2="{10 * $X-Spacer}" y2="0" stroke="indigo"/>
                <!--Y axis -->
                <!--<line x1="0" y1="0" x2="0" y2="{$maxElementCount * $Y-Stretcher}" stroke="indigo"/>-->
                
                
                <!--STACKED BAR PLOT -->           
                
                <xsl:for-each select="$morrowindColl//contents/p">
                    <!--WE CAN SET AN <xsl:sort> here: sort on count of albums or anything you like from the source collection. -->
                    
                    <xsl:variable name="XPos" select="position() * $X-Spacer"/>
        <!--            <xsl:variable name="YPos" select="count($maxElementCount) * $Y-Stretcher"/>-->
                    <!--JJF: This needs to be finding another y-element for something to be max, so it needs to 
                    count person,group,item, and location and attempt to take the max-->
                    <xsl:variable name="personCount" select="count(content/p/person[@ref]) * $Y-Stretcher"/>
                    <xsl:variable name="itemCount" select="count(content/p/item[@ref]) * $Y-Stretcher"/>
                    <xsl:variable name="locationCount" select="count(content/p/location[@ref]) * $Y-Stretcher"/>
                    <xsl:variable name="groupCount" select="count(content/p/group[@ref]) * $Y-Stretcher"/>
                                                                        
                    <g class="graphOutput">
                        
                        <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$maxPersonCount}" stroke="purple"/>          
                        <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$itemCount}" stroke="red" width="20"/>         
                        <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$personCount}" stroke="blue" width="20"/>
                        <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$locationCount}" stroke="yellow" width="20"/>
                        <line x1="{$XPos}" y1="0" x2="{$XPos}" y2="{$groupCount}" stroke="orange" width="20"/>                                                                                                
                   
                    </g>
                </xsl:for-each> 
                
                <text x="-20" y="-200" style="writing-mode: tb; glyph-orientation-vertical: 90;"> Number of Albums</text>
                <!--Y-Axis title-->
                
                <text x="150"  y="30"> Kpop Groups </text>
                <!--X-Axis title-->
                
                <text x="100"  y="-400">Number of Albums under each Kpop Group</text>
                <!--Graph title-->
                
                <text x="{$X-Spacer}" y="50" style="writing-mode: tb; glyph-orientation-vertical: 90;"><xsl:apply-templates select="groupName"></xsl:apply-templates></text>
                
            </g> 
        </svg>
    </xsl:template>   
    
    
    
</xsl:stylesheet>

