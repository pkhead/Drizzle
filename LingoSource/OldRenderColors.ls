global c, pal, pal2, dptsL, fogDptsL, gPalette, gEffectPaletteA, gEffectPaletteB, gFogColor, gBlurOptions, gSkyColor, gLOprops, gViewRender, keepLooping, gCustomColor


on exitFrame me
  if gViewRender then
    if _key.keyPressed(48) then
      _movie.go(9)
    end if
    me.newFrame()
    if keepLooping then
      go the frame
    end if
  else
    repeat while keepLooping
      me.newFrame()
    end repeat
  end if
  
  keepLooping = 1
end

on newFrame me
  
  l = [color(255,0,0), color(0,255,0), color(0,0,255), color(255,0,255), color(0,255,255), color(255,255,0)]
  
  sprite(59).locV = c-8
  
  repeat with q = 1 to 1040 then
    
    cl = member("finalfg").image.getPixel(q-1, c-1)
    dp = dptsL.getPos(member("dpImage").image.getPixel(q-1, c-1))
    fgDp = fogDptsL.getPos(member("fogImage").image.getPixel(q-1, c-1))
    whiteness = 0
    
    
    
    useNextColorFac = 0
    if [4, 8, 12].getPos(fgDp) then
      useNextColorFac = 0.66
    else if [3, 7, 11].getPos(fgDp) then
      useNextColorFac = 0.33
    end if
    
    lr = 0
    if cl <> color(255, 255, 255) then
      if cl.blue = 150 then
        whiteness = cl.red/255.0
        cl = 1
      else
        cl = l.getPos(cl)
      end if
      lr = 1
    else
      cl = member("finalbg").image.getPixel(q-1, c-1)
      if cl <> color(255, 255, 255) then
        if cl = color(5,5,5) then
          if (gBlurOptions.blurLight = 0)and(gBlurOptions.blurSky = 0) then
            member("finalbg").image.setPixel(q-1, c-1, color(255,255,255))
            member("finalbgLight").image.setPixel(q-1, c-1, color(255,255,255))
            --SHORT CUT HOLE COLOR
          end if
        end if
        if cl.blue = 150 then
          whiteness = cl.red/255.0
          cl = 1
        else
          cl = l.getPos(cl)
        end if
        lr = 2
      else
        if gBlurOptions.blurSky then
          member("blurredLight").image.setPixel(q-1, c-1, gSkyColor)
        end if
      end if
    end if
    
    
    
    if cl <> color(255, 255, 255) then
      shdw = (member("shadowImage").image.getPixel(q-1, c-1) = color( 0, 0, 0 ))
      gtPs = point(dp, cl)
    else
      gtPs = point(1, 1)
      cl = 1
    end if
    
    
    
    if (cl<>0)and(dp<>0) then
      
      colour = gPalette[gtPs.locH][gtPs.locV]
      oneStepFurtherColor = gPalette[gtPs.locH+(gtPs.locH<4)][gtPs.locV]
      
      if cl = 4 then
        clr1Fac = (member("gradientA"&string(dp)).image.getPixel(q-1, c-1).red/255.0)
        colour = colour*(clr1Fac) + (gEffectPaletteA[gtPs.locH]*(1.0-clr1Fac))
        oneStepFurtherColor = oneStepFurtherColor*(clr1Fac) + (gEffectPaletteA[gtPs.locH+(gtPs.locH<4)]*(1.0-clr1Fac))
      else if cl = 5 then
        clr2Fac = (member("gradientB"&string(dp)).image.getPixel(q-1, c-1).red/255.0)
        colour = colour*(clr2Fac) + (gEffectPaletteB[gtPs.locH]*(1.0-clr2Fac))
        oneStepFurtherColor = oneStepFurtherColor*(clr2Fac) + (gEffectPaletteB[gtPs.locH+(gtPs.locH<4)]*(1.0-clr2Fac))
      end if
      
      colour = (colour*(1.0-useNextColorFac)) + (oneStepFurtherColor*useNextColorFac)
      
      darkDown = 0--(255-member("screen").image.getPixel(q-1, c-1).red)*0.25
      fogFac = (255-member("fogImage").image.getPixel(q-1, c-1).red)/255.0
      
      
      
      fogFac = (fogFac - 0.0275)*(1.0/0.9411)
      
      --      if fogFac < 0.05 then
      --        member("glassImage").image.setPixel(q-1, c-1, color(255, 255, 255))
      --      end if
      
      
      
      rainBowFac = 0
      
      if member("blackOutImg2").image.getPixel(q-1, c-1) = color(255,255,255) then
        if fogFac <= 0.2 then
          repeat with dsplc in [point(-2,0), point(0,-2), point(2, 0), point(0,2), point(-1,-1), point(1,-1), point(1, 1), point(-1,1)] then
            otherFogFac = (255-member("fogImage").image.getPixel(restrict(q-1+dsplc.locH, 0, 1039), restrict(c-1+dsplc.locV, 0, 799)).red)/255.0
            otherFogFac = (otherFogFac - 0.0275)*(1.0/0.9411)
            rainBowFac = rainBowFac + (abs(fogFac-otherFogFac)>0.0333)*(restrict(fogFac - otherFogFac, 0, 1)+1)
            if rainBowFac > 5 then
              exit repeat
            end if
          end repeat
          
          rainBowFac = (rainBowFac>5)--*0.2
          
          if rainBowFac then
            repeat with dsplc in [point(0,0), point(-1,0), point(0,-1), point(1, 0), point(0,1)] then
              member("rainBowMask").image.setPixel(q-1+dsplc.locH, c-1+dsplc.locV, color(255,255,255))
            end repeat
          end if
          
        end if
        
        rainBowDisplace =   member("noiseGraf").image.getPixel(q-1, c-1).red/255.0
        rainBowColor = member("rainBow").image.getPixel((90*((fogFac*0.4)+(rainBowDisplace*1.0)) mod 10), 0)
        member("rainBowImage").image.setPixel(q-1, c-1, rainBowColor)
        
      end if
      
      
      --      global sdfas
      --      if rainBowFac > sdfas then
      --        sdfas = rainBowFac
      --      end if
      -- rainBowFac = rainBowFac 
      --  rainBowFac = restrict(rainBowFac/16.0, 0, 0.5)
      
      
      
      
      
      fogFac = fogFac*0.7
      
      colour = color((colour.red*(1.0-whiteness))+(250*whiteness), (colour.green*(1.0-whiteness))+(250*whiteness), (colour.blue*(1.0-whiteness))+(250*whiteness))
      colour = color(restrict(colour.red - darkDown, 0, 255),restrict(colour.green - darkDown, 0, 255), restrict(colour.blue - darkDown, 0, 255))
      
      -- fogColor = color(100*fogFac, 100*fogFac, 100*fogFac)
      -- colour =  gSkyColor
      
      
      -- colour = color(restrict(colour.red - (rainBowColor.red*rainBowFac), 0, 255), restrict(colour.green - (rainBowColor.green*rainBowFac), 0, 255), restrict(colour.blue - (rainBowColor.blue*rainBowFac), 0, 255))
      
      -- colour = (((rainBowColor*rainBowFac)+(colour*(1.0-rainBowFac)))*fogFac*1.4) + (darkcolour*(1.0-(fogFac*1.4)))
      --  colour = (rainBowColor*rainBowFac)+(colour*(1.0-rainBowFac))
      
      if gCustomColor <> void then
        colour = me.addCustomColor(colour, q, c, fogFac, 0, gtPs.locV, fgDp)
      end if
      
      
      if lr = 1 then
        member("finalfg").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac) )
        member("finalbg").image.setPixel(q-1, c-1, color(255,255,255))
        RECOLORED = 1
      else if lr = 2 then
        member("finalbg").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac))
        RECOLORED = 1
      end if
      
      if (clr1Fac < 1.0)and(gLOprops.colGlows[1]=2)and(cl=4) then
        member("blurredLight").image.setPixel(q-1, c-1, gEffectPaletteA[gtPs.locH]*(1.0-clr1Fac))
      end if
      if (clr2Fac < 1.0)and(gLOprops.colGlows[2]=2)and(cl=5) then
        member("blurredLight").image.setPixel(q-1, c-1, gEffectPaletteB[gtPs.locH]*(1.0-clr2Fac))
      end if
      
      
      
      if shdw = 0 then
        gtPs = point(dp, cl)
        colour = gPalette[gtPs.locH+4][gtPs.locV]
        oneStepFurtherColor = gPalette[gtPs.locH+(gtPs.locH<4)+4][gtPs.locV]
        
        if (cl = 4) then
          colour = colour*(clr1Fac) + (gEffectPaletteA[gtPs.loch+4]*(1.0-clr1Fac))
          oneStepFurtherColor = oneStepFurtherColor*(clr1Fac) + (gEffectPaletteA[gtPs.loch+(gtPs.locH<4)+4]*(1.0-clr1Fac))
        else if (cl = 5) then
          colour = colour*(clr2Fac) + (gEffectPaletteB[gtPs.loch+4]*(1.0-clr2Fac))
          oneStepFurtherColor = oneStepFurtherColor*(clr2Fac) + (gEffectPaletteB[gtPs.loch+(gtPs.locH<4)+4]*(1.0-clr2Fac))
        end if
        
        colour = (colour*(1.0-useNextColorFac)) + (oneStepFurtherColor*useNextColorFac)
        
        colour = color((colour.red*(1.0-whiteness))+(250*whiteness), (colour.green*(1.0-whiteness))+(250*whiteness), (colour.blue*(1.0-whiteness))+(250*whiteness))
        colour = color(restrict(colour.red - darkDown, 0, 255),restrict(colour.green - darkDown, 0, 255), restrict(colour.blue - darkDown, 0, 255))
        
        if gCustomColor <> void then
          colour = me.addCustomColor(colour, q, c, fogFac, 1, gtPs.locV, fgDp)
        end if
        -- colour = color(restrict(colour.red - (rainBowColor.red*rainBowFac), 0, 255), restrict(colour.green - (rainBowColor.green*rainBowFac), 0, 255), restrict(colour.blue - (rainBowColor.blue*rainBowFac), 0, 255))
        
        -- colour = (((rainBowColor*rainBowFac)+(colour*(1.0-rainBowFac)))*fogFac*1.4) + (darkcolour*(1.0-(fogFac*1.4)))
        -- colour = (rainBowColor*rainBowFac)+(colour*(1.0-rainBowFac))
        
        if gBlurOptions.blurLight = 0 then
          if (clr1Fac < 1.0)and(gLOprops.colGlows[1]=1)and(cl=4) then
            member("blurredLight").image.setPixel(q-1, c-1, gEffectPaletteA[gtPs.locH]*(1.0-clr1Fac)*0.5)
          end if
          if (clr2Fac < 1.0)and(gLOprops.colGlows[2]=1)and(cl=5) then
            member("blurredLight").image.setPixel(q-1, c-1, gEffectPaletteB[gtPs.locH]*(1.0-clr2Fac)*0.5)
          end if
        end if
        
        
        
        
        if lr = 1 then
          member("finalfgLight").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac))
          me.changeLightRect(1, point(q,c))
          if gBlurOptions.blurLight then
            member("blurredLight").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac))
          end if
        else if lr = 2 then
          member("finalbgLight").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac))
          me.changeLightRect(2, point(q,c))
          if gBlurOptions.blurLight then
            member("blurredLight").image.setPixel(q-1, c-1, (colour*(1.0-fogFac))+(gFogColor*fogFac))
          end if
        end if
        
        
      end if
      
      
    end if
    
    
    
    
  end repeat
  
  c = c + 1
  
  
  if c > 800 then
    repeat with mem in ["finalfg", "finalbg", "finalbgLight", "finalfgLight"] then
      inv = makeSilhoutteFromImg(member(mem).image, 1)
      -- member("glassImage").image.copyPixels(inv, rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36, #color:color(255,255,255)})
      member("tempRainBowImage").image.copyPixels(member("rainBowImage").image, rect(0,0,1040,800), rect(0,0,1040,800))
      member("tempRainBowImage").image.copyPixels(inv, rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36, #color:color(255,255,255)})
      member("tempRainBowImage").image.copyPixels(member("rainBowMask").image, rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36, #color:color(255,255,255)})
      member(mem).image.copyPixels(member("tempRainBowImage").image, rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36, #blend:10})
    end repeat
    
    if gLOprops.pals[gLOprops.pal].name = "Dark Light Sky" then
      member("blurredLight").image = blurOnBlack(member("blurredLight").image, 40)
      repeat with q = 1 to 20 then
        member("blurredLight").image = blurImage(member("blurredLight").image, 40)
      end repeat
    else
      member("blurredLight").image = blurOnBlack(member("blurredLight").image, 20)
      repeat with q = 1 to 10 then
        member("blurredLight").image = blurImage(member("blurredLight").image, 40)
      end repeat
    end if
    --duplImg = member("blurredLight").image.duplicate()
    --
    c = 1
    keepLooping = 0
  end if
end 



on changeLightRect me, lr, pnt
  global lightRects
  --  if (pnt.locH > 734)and(lr=1) then
  --    put pnt.locH
  --  end if
  if pnt.locH<lightRects[lr].left then
    lightRects[lr].left = pnt.locH
  end if
  
  if pnt.locH>lightRects[lr].right then
    lightRects[lr].right = pnt.locH
  end if
  if pnt.locV<lightRects[lr].top then
    lightRects[lr].top = pnt.locV
  end if
  if pnt.locV>lightRects[lr].bottom then
    lightRects[lr].bottom = pnt.locV
  end if
  sprite(10+lr).rect = lightRects[lr]+rect(-8,-16,-8,-16)
end


on addCustomColor me, colour, q, c, fogFac, lit, tnt, fgDp
  if ((gCustomColor[2].getPos(fgDp)=0)=(gCustomColor[1]=0))or(gCustomColor[3].getPos(fgDp)>0) then
    origCl = color(colour.red, colour.green, colour.blue)
    pxl = depthPnt(point(q,c),15-fogFac*45) + point(tnt*1, tnt*2)
    
    if pxl.inside(rect(1,1,1040,800)) then
      customCol = member("previewImprt").image.getPixel(pxl.locH-1, pxl.locV-1)
      if customCol = color(255,0,255) then
        member("rainBowMask").image.setPixel(q-1, c-1, color(255,255,255))
      else if customCol <> color(0,0,0) then
        mlt = color(restrict((colour.red/255.0)*(customCol.red/255.0), 0, 1.0)*255, restrict((colour.green/255.0)*(customCol.green/255.0), 0, 1.0)*255, restrict((colour.blue/255.0)*(customCol.blue/255.0), 0, 1.0)*255)
        
        
        if lit then
          colour = color((colour.red*2+mlt.red*0.5+customCol.red)/3.5, (colour.green*2+mlt.green*0.5+customCol.green)/3.5, (colour.blue*2+mlt.blue*0.5+customCol.blue)/3.5)
        else
          colour = color((colour.red*2+mlt.red*2+customCol.red)/5.0, (colour.green*2+mlt.green*2+customCol.green)/5.0, (colour.blue*2+mlt.blue*2+customCol.blue)/5.0)
        end if
        
        if gCustomColor[3].getPos(fgDp) then -- half transparency
          colour = color((colour.red+origCl.red)*0.5, (colour.green+origCl.green)*0.5,(colour.blue+origCl.blue)*0.5)
        end if
        
      end if
    end if
  end if
  return colour
end
























