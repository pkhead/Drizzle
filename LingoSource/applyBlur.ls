global c, gSkyColor, gBlurOptions, gLOprops, gViewRender, keepLooping

on exitFrame me
  if 0 then
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
  end if
end


on newFrame me
  sprite(59).locV = c-8
  
--  repeat with q = 1 to 1040 then
--    shortCutColor = 0
--    --  clFg = member("blurredLightFg").image.getPixel(q-1, c-1)
--    blurCol = member("blurredLight").image.getPixel(q-1, c-1)
--    --if blurCol <> color(0,0,0) then
--    lr = 1 + (member("finalfg").image.getPixel(q-1, c-1)=color(255,255,255))
--    -- put lr
--    if member("finalbg").image.getPixel(q-1, c-1) = color(5,5,5) then
--      shortCutColor = 1
--    end if
--    
--    if blurCol <> color(0,0,0) then
--      if lr = 1 then
--        baseColor = member("finalfgLight").image.getPixel(q-1, c-1)
--        if baseColor = color(255,255,255)then
--          baseColor = member("finalfg").image.getPixel(q-1, c-1)
--        end if
--        blurfac = 1
--        case gLOprops.pals[gLOprops.pal].name of
--          "sunset":
--            blurfac = (1.0-(diag(point(0,0),point(q,c))/1312.0))*0.5
--          "thunder":
--            blurfac = random(200)*0.01--(1.0-(diag(point(0,0),point(q,c))/1312.0))*0.5
--          "blue":
--            --   if 
--            --  blurfac = 0.25
--            --          "rust":
--            --            blurfac = (1.0-(c/800.0)) * 0.25
--        end case
--        col = color(restrict(baseColor.red+blurCol.red*blurFac, 0, 254), restrict(baseColor.green+blurCol.green*blurFac, 0, 254),restrict(baseColor.blue+blurCol.blue*blurFac, 0, 254))
--        me.changeLightRect(1, point(q,c))
--        --        if gLOprops.pals[gLOprops.pal].name = "blue" then
--        --          col = color(restrict(col.red, 0, gSkyColor.red), restrict(col.green, 0, gSkyColor.green),restrict(col.blue, 0, gSkyColor.blue))
--        --        end if
--        member("finalfgLight").image.setPixel(q-1, c-1, col)
--      else
--        baseColor = member("finalbgLight").image.getPixel(q-1, c-1)
--        if baseColor = color(255,255,255)then
--          baseColor = member("finalbg").image.getPixel(q-1, c-1)
--        end if
--        if baseColor = color(255,255,255)then
--          baseColor = gSkyColor
--        end if
--        blurfac = 1
--        case gLOprops.pals[gLOprops.pal].name of
--          "sunset":
--            blurfac = (1.0-(diag(point(0,0),point(q,c))/1312.0))*0.5
--          "thunder":
--            blurfac = random(100)*0.01--(1.0-(diag(point(0,0),point(q,c))/1312.0))*0.5
--            -- "blue":
--            --   blurfac = 0.25
--            --          "rust":
--            --            blurfac = (1.0-(c/800.0)) * 0.25
--        end case
--        col = color(restrict(baseColor.red+blurCol.red*blurfac, 0, 240), restrict(baseColor.green+blurCol.green*blurfac, 0, 240),restrict(baseColor.blue+blurCol.blue*blurfac, 0, 240))
--        me.changeLightRect(2, point(q,c))
--        --        if gLOprops.pals[gLOprops.pal].name = "blue" then
--        --          col = color(restrict(col.red, 0, gSkyColor.red), restrict(col.green, 0, gSkyColor.green),restrict(col.blue, 0, gSkyColor.blue))
--        --        end if
--        member("finalbgLight").image.setPixel(q-1, c-1, col)
--      end if
--    end if
--    
--    if shortCutColor then
--      member("finalbg").image.setPixel(q-1, c-1, color(255,255,255))
--      member("finalbgLight").image.setPixel(q-1, c-1, color(255,255,255))
--    end if
--    
--  end repeat
--  
--  c = c + 1
  
  
 -- if (c > 800)or((gBlurOptions.blurLight=0)and(gBlurOptions.blurSky=0)and(gLOprops.colGlows[1]=0)and(gLOprops.colGlows[2]=0)) then
--    
--    
--    script("renderLightStart").quadifyMember("glassImage", (-5)*1.5)
--    
--    inv = makeSilhoutteFromImg(member("layer0").image, 0)
--    member("glassImage").image.copyPixels(inv, rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36, #color:color(255,255,255)})
--    
--    
--    repeat with img in ["finalfg", "finalbg", "finalfgLight", "finalbgLight"] then
--      member(img).image.copyPixels(member("glassImage").image, rect(depthPnt(point(0,0),-5),depthPnt(point(1040,800),-5)), rect(0,0,1040,800), {#blend:15, #color:color(255,255,255), #ink:36})
--    end repeat
--    
--    -- member("finalFg").image = depthChangeImage(member("finalFg").image, 16)
--    -- member("finalbg").image = depthChangeImage(member("finalbg").image, 16)
--    -- member("finalfgLight").image = depthChangeImage(member("finalfgLight").image, 16)
--    --member("finalbgLight").image = depthChangeImage(member("finalbgLight").image, 16)
--    global gLEProps
--    col = member("newPalette").image.getPixel(8,2)
--    repeat with q = 1 to 52 then
--      repeat with c = 1 to 40 then
--        if (gLEProps.matrix[q][c][1][2].getPos(5) > 0)and(gLEProps.matrix[q][c][1][1]=1) then
--          --          rct = depthPnt(giveMiddleOfTile(point(q,c)), -5)
--          --          rct = rect(rct,rct)+rect(-1,-1,2,2)
--          --          member("finalfg").image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:col})
--          --          member("finalfgLight").image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255,255,255)})
--          pasteShortCutHole("finalfg", point(q,c), -5, col)
--          pasteShortCutHole("finalfgLight", point(q,c), -5, color(255,255,255))
--        end if
--      end repeat
--    end repeat
--    
--    repeat with q = 0 to 29 then
--      member("layer"&string(q)).image = image(1, 1, 1)
--      member("layer"&string(q)&"sh").image = image(1, 1, 1)
--    end repeat
--    
--    --  put lightRects
--    --   gLevel.lightRects = lightRects
--    global gLoadedName, levelName
--    levelName = gLoadedName
--    member("TextInput").text = gLoadedName
--    keepLooping = 0
 -- end if
end



on changeLightRect me, lr, pnt
  global lightRects
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


