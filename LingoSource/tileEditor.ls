global gTEprops, gLEProps, gTiles, gLOProps, gDirectionKeys, gEnvEditorProps, specialRectPoint


on exitFrame me
  msTile = (_mouse.mouseLoc/point(16.0, 16.0))+point(0.4999, 0.4999)
  msTile = point(msTile.loch.integer, msTile.locV.integer)+point(-1, -1)+gLEprops.camPos
  
  repeat with q = 1 to 4 then
    if (_key.keyPressed([86, 91, 88, 84][q]))and(gDirectionKeys[q] = 0) then
      gLEProps.camPos = gLEProps.camPos + [point(-1, 0), point(0,-1), point(1,0), point(0,1)][q] * (1 + 9 * _key.keyPressed(83))
      repeat with l = 1 to 3 then
        lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
        TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
      end repeat
      drawShortCutsImg(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 16, 1)
      
    end if
    gDirectionKeys[q] = _key.keyPressed([86, 91, 88, 84][q])
  end repeat
  
  
  rct = rect(0,0,gLOprops.size.loch, gLOprops.size.locv) + rect(gLOProps.extraTiles[1], gLOProps.extraTiles[2], -gLOProps.extraTiles[3], -gLOProps.extraTiles[4]) - rect(gLEProps.camPos, gLEProps.camPos)
  sprite(71).rect = (rct.intersect(rect(0,0,52,40))+rect(1, 1, 1, 1))*rect(16,16,16,16)
  
  if checkKey("Q") then
    PickUpTile(msTile)
  end if
  
  if checkKey("L") then
    gTEprops.workLayer = gTEprops.workLayer +1
    if gTEprops.workLayer > 3 then
      gTEprops.workLayer = 1
    end if
    writeMaterial(msTile)
    
    ChangeLayer()
    
    
  end if
  
  actn = 0
  actn2 = 0
  
  gTEprops.keys.m1 = _mouse.mouseDown
  if (gTEprops.keys.m1)and(gTEprops.lastKeys.m1=0) then
    actn = 1
  end if
  gTEprops.lastKeys.m1 = gTEprops.keys.m1
  gTEprops.keys.m2 = _mouse.rightmouseDown
  if (gTEprops.keys.m2)and(gTEprops.lastKeys.m2=0) then
    actn2 = 1
  end if
  gTEprops.lastKeys.m2 = gTEprops.keys.m2
  if msTile <> gTEprops.lstMsPs then
    writeMaterial(msTile)
    
    actn = gTEprops.keys.m1
    --  if gTEprops.toolType = "material" then
    actn2 = gTEprops.keys.m2
    
    --end if
    
    isTilePositionLegal(msTile)
    
  end if
  gTEprops.lstMsPs = msTile
  
  if gTEprops.specialEdit <> 0 then
    -- gTEprops.specialEdit
    sprite(19).visibility = 1
    member("default material").text = "SPECIAL EDIT:" && string(gTEprops.specialEdit)
    
    if actn then
      specialAction(msTile)
    end if
    if actn2 then
      gTEprops.specialEdit = 0
    end if
    
    sprite(19).visibility = (gTEprops.specialEdit <> 0)
  else
    if actn then
      action(msTile)
    end if
    if actn2 then
      deleteTile(msTile)
    end if
  end if
  
  if checkKey("W") then
    updateTileMenu(point(0, -1))
  end if
  if checkKey("S") then
    updateTileMenu(point(0, 1))
  end if
  if checkKey("A") then
    updateTileMenu(point(-1, 0))
  end if
  if checkKey("D") then
    updateTileMenu(point(1, 0))
  end if
  
  if checkKey("C") then
    me.deleteAllTiles()
  end if
  
  if gTEprops.toolType = "material" then
    if _key.keypressed("F") then
      sprite(15).rect = rect(msTile*16, (msTile+point(1,1))*16) + rect(-16,-16,16,16) - rect(gLEprops.camPos*16, gLEprops.camPos*16)
    else
      sprite(15).rect = rect(msTile*16, (msTile+point(1,1))*16) - rect(gLEprops.camPos*16, gLEprops.camPos*16)
    end if
    sprite(13).loc = point(-2000, -2000)
  else if gTEprops.toolType = "special" then
    
    sprite(15).color = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].color
    
    case (gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].placeMethod) of
      "rect":
        if(specialRectPoint = void)then
          sprite(15).rect = rect(msTile*16, (msTile+point(1,1))*16) - rect(gLEprops.camPos*16, gLEprops.camPos*16)
          if(actn)then
            specialRectPoint = msTile
          end if
        else
          rct = rect(specialRectPoint, specialRectPoint+point(1,1)).union(rect(msTile, msTile+point(1,1)))
          sprite(15).rect = rct*16 - rect(gLEprops.camPos*16, gLEprops.camPos*16)
          if(actn2)then
            specialRectPoint = void
          else  if(actn)then
            specialRectPoint = void
            SpecialRectPlacement(rct+rect(0,0,-1,-1))
          end if
        end if
    end case
    
    
    
    
    
    sprite(13).loc = point(-2000, -2000)
  else
    sprite(15).rect = rect(-5,-5,-5,-5)
    mdPnt = point(((gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].sz.locH*0.5)+0.4999).integer,((gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].sz.locV*0.5)+0.4999).integer)
    --offst = point(3,3)-mdPnt
    sprite(13).loc = (msTile+point(1,1)-mdPnt-gLEprops.camPos)*16
    
  end if
  
  if _key.keyPressed("E") then
    updateTileMenu(point(0,0))
  end if
  
  
  if gEnvEditorProps.waterLevel = -1 then
    sprite(9).rect = rect(0,0,0,0)
  else
    rct = rect(0, gLOprops.size.locv-gEnvEditorProps.waterLevel-gLOProps.extraTiles[4], gLOprops.size.loch, gLOprops.size.locv) - rect(gLEProps.camPos, gLEProps.camPos)
    sprite(9).rect = ((rct.intersect(rect(0,0,52,40))+rect(1, 1, 1, 1))*rect(16,16,16,16))+rect(0, -8, 0, 0)
  end if
  
  
  
  
  script("levelOverview").goToEditor()
  -- if _key.keyPressed("G")=0 then
  go the frame
  -- end if
end


on deleteAllTiles()
  global gLOprops
  gTEprops.tlMatrix = []
  repeat with q = 1 to gLOprops.size.loch then
    l = []
    repeat with c = 1 to gLOprops.size.locv then
      l.add([[#tp:"default", #data:0], [#tp:"default", #data:0], [#tp:"default", #data:0]])
    end repeat
    gTEprops.tlMatrix.add(l)
  end repeat
  
  repeat with q = 1 to 3 then
    TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), q)
  end repeat
end


on checkKey(key)
  rtrn = 0
  gTEprops.keys[symbol(key)] = _key.keyPressed(key)
  if (gTEprops.keys[symbol(key)])and(gTEprops.lastKeys[symbol(key)]=0) then
    rtrn = 1
  end if
  gTEprops.lastKeys[symbol(key)] = gTEprops.keys[symbol(key)]
  return rtrn
end



on writeMaterial(msTile)
  global gLoprops
  sprite(8).visibility = 0
  if msTile.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
    txt = ""
    
    case gLEProps.matrix[msTile.locH][msTile.locV][gTEprops.workLayer][1] of
      1:
        txt = "Wall"
      2:
        txt = "Eastward Slope"
      3:
        txt = "Westward Slope"
      4:
        txt = "Ceiling Slope"
      5:
        txt = "Ceiling Slope"
      6:
        txt = "Floor"
      7:
        txt = "Short Cut Entrance"
        sprite(8).visibility = 1
        -- 8:
        --   txt = "Lizard's Hole"
    end case
    if txt <> "" then
      case gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].tp of
        "material":
          put " - Material:" && string(gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data) after txt
        "tileHead":
          put " - Tile:" && gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data[2] after txt
          if gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data.count > 2 then
            put " :: Additional Data:" && gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data[3] after txt
          end if
        "tileBody":
          dt = gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data
          if gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].tp = "tileHead" then
            put " - Tile:" && gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].data[2] after txt
          else
            put " - Stray Tile Fragment" after txt
          end if            
      end case
    end if
    member("editor1tool").text = txt
  else
    member("editor1tool").text = ""
  end if
  
  
end



on updateTileMenu(mv)
  if(mv = void)or(mv = script("tileEditor"))then
    mv = point(0,0)
  end if
  
  gTEprops.tmPos = gTEprops.tmPos + mv
  if mv.locH <> 0 then
    if gTEprops.tmPos.locH < 1 then
      gTEprops.tmPos.locH = gTiles.count
    else if gTEprops.tmPos.locH > gTiles.count then
      gTEprops.tmPos.locH = 1
    end if 
    gTEprops.tmPos.locV = gTEprops.tmSavPosL[gTEprops.tmPos.locH]
  else if mv.locV <> 0 then
    if gTEprops.tmPos.locV < 1 then
      gTEprops.tmPos.locV = gTiles[gTEprops.tmPos.locH].tls.count
    else if gTEprops.tmPos.locV > gTiles[gTEprops.tmPos.locH].tls.count then
      gTEprops.tmPos.locV = 1
    end if
    gTEprops.tmSavPosL[gTEprops.tmPos.locH] = gTEprops.tmPos.locV
  end if
  
  gTEprops.tmPos.locH = restrict(gTEprops.tmPos.locH, 1, gTiles.count)
  gTEprops.tmPos.locV = restrict(gTEprops.tmPos.locV, 1, gTiles[gTEprops.tmPos.locH].tls.count)
  
  txt = ""
  put "[" && gTiles[gTEprops.tmPos.locH].nm && "]" after txt
  put RETURN after txt
  
  repeat with tl = 1 to gTiles[gTEprops.tmPos.locH].tls.count then
    if tl = gTEprops.tmPos.locV then
      put "-" && gTiles[gTEprops.tmPos.locH].tls[tl].nm && "-" && RETURN after txt
    else
      put gTiles[gTEprops.tmPos.locH].tls[tl].nm && RETURN after txt
    end if
  end repeat
  
  member("tileMenu").text = txt
  
  
  if gTiles[gTEprops.tmPos.locH].nm = "materials" then
    sprite(19).visibility = 1
    gTEprops.toolType = "material"
    gTEprops.toolData = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm
    member("tilePreview").image = image(1,1,1)
    if _key.keyPressed("E") then
      if  gTEprops.defaultMaterial <> gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm then
        gTEprops.defaultMaterial = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm
        --  put "set" &&     gTEprops.defaultMaterial && "as default material"
        member("default material").text = "Default material:" && gTEprops.defaultMaterial && "(Press 'E' to change)"
      end if
    end if
  else if gTiles[gTEprops.tmPos.locH].nm = "special" then
    gTEprops.toolType = "special"
    gTEprops.toolData = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm
    member("tilePreview").image = image(1,1,1)
  else
    if gTEprops.specialEdit = 0 then
      sprite(19).visibility = 0
    end if
    gTEprops.toolType = "tile"
    gTEprops.toolData = "TILE"--gTEprops.tmPos--gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV]
    drawTilePreview()
  end if
  
  isTilePositionLegal(gTEprops.lstMsPs)
  
end


on action(msTile)
  if msTile.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
    case gTEprops.toolType of
      "material":
        l = [msTile]
        if _key.keypressed("F") then
          l = [msTile, msTile+point(1,0),msTile+point(-1,0),msTile+point(0,1),msTile+point(0,-1),msTile+point(-1,-1),msTile+point(-1,1),msTile+point(1,1),msTile+point(1,-1)]
        end if
        repeat with q in l then
          if q.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
            if ["tileHead", "tileBody"].getPos(gTEprops.tlMatrix[q.locH][q.locV][gTEprops.workLayer].tp) = 0 then
              gTEprops.tlMatrix[q.locH][q.locV][gTEprops.workLayer].tp = "material"
              gTEprops.tlMatrix[q.locH][q.locV][gTEprops.workLayer].data = gTEprops.toolData
            end if
            TEdraw(rect(q,q), gTEprops.workLayer)
          end if
        end repeat
      "tile":
        if (isTilePositionLegal(msTile))or(_key.keypressed("F"))or(_key.keypressed("G")) then
          placeTile(msTile, gTEprops.tmPos)
          --  TEdraw(rect(msTile+point(-4, -4),msTile+point(4, 4)), 1)
          -- TEdraw(rect(msTile+point(-4, -4),msTile+point(4, 4)), 2)
        end if
    end case
  end if
end


on deleteTile(msTile)
  global gLOprops
  if msTile.inside(rect(1,1,gLOprops.size.loch,gLOprops.size.locv)) then
    case   gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].tp of
      "material":
        gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].tp = "default"
        gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data = 0
        TEdraw(rect(msTile,msTile), gTEprops.workLayer)
      "tileHead":
        deleteTileTile(msTile, gTEprops.workLayer)
        -- TEdraw(rect(msTile+point(-5, -5),msTile+point(5,5)), 1)
        -- TEdraw(rect(msTile+point(-5, -5),msTile+point(5,5)), 2)
      "tileBody":
        dt = gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data
        if gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].tp = "tileHead" then
          deleteTileTile(dt[1], dt[2])
        else
          gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].tp = "default"
          gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data = 0
          TEdraw(rect(msTile,msTile), gTEprops.workLayer)
        end if
        -- TEdraw(rect(dt[1]+point(-5, -5),dt[1]+point(5,5)), 1)
        -- TEdraw(rect(dt[1]+point(-5, -5),dt[1]+point(5,5)), 2)
    end case
  end if
end




on drawTilePreview()
  member("tilePreview").image = image(85*5, 85*5, 16)
  tl = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV]--gTEprops.toolData
  --  offst = point(1,1)
  
  mdPnt = point(((tl.sz.locH*0.5)+0.4999).integer,((tl.sz.locV*0.5)+0.4999).integer)
  offst = point(3*5,3*5)-mdPnt
  
  if tl.specs2 <> void then
    n = 1
    repeat with q = 1 to tl.sz.locH then
      repeat with c = 1 to tl.sz.locV then
        if tl.specs2[n] <> -1 then
          member("tilePreview").image.copyPixels(member("prvw"&string(tl.specs2[n])).image, rect((q-1+offst.locH)*16, (c-1+offst.locV)*16, (q+offst.locH)*16, (c+offst.locV)*16)\
          +rect(5,0, 5, 0),  member("prvw"&string(tl.specs2[n])).image.rect, {#ink:36, #color:color(50, 50, 50)})
        end if
        n = n + 1
      end repeat
    end repeat
  end if
  
  
  n = 1
  repeat with q = 1 to tl.sz.locH then
    repeat with c = 1 to tl.sz.locV then
      if tl.specs[n] <> -1 then
        cl = color(150, 150, 150)
        --        if (q=mdPnt.locH)and(c=mdPnt.locV) then
        --          cl = color(255, 0, 0)
        --        end if
        member("tilePreview").image.copyPixels(member("prvw"&string(tl.specs[n])).image, rect((q-1+offst.locH)*16, (c-1+offst.locV)*16, (q+offst.locH)*16, (c+offst.locV)*16)\
        +rect(0,5, 0, 5),  member("prvw"&string(tl.specs[n])).image.rect, {#ink:36, #color:cl})
      end if
      n = n + 1
    end repeat
  end repeat
  
  member("tileMouse").image = image(tl.sz.locH*16, tl.sz.locV*16, 16)
  member("tileMouse").image.copyPixels(member("previewTiles").image, member("tileMouse").image.rect, rect(tl.ptPos, 0, tl.ptPos+(tl.sz.locH*16), tl.sz.locV*16), {#ink:36, #color:color(150, 150, 150)})
  member("tileMouse").regPoint = point(0,0)
end




on isTilePositionLegal(msTile)
  
  rtrn = 1
  if  gTEprops.toolType = "tile" then
    tl = gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV]--gTEprops.toolData
    mdPnt = point(((tl.sz.locH*0.5)+0.4999).integer,((tl.sz.locV*0.5)+0.4999).integer)
    strt = msTile-mdPnt+point(1,1)
    
    
    if (tl.specs2 <> void)and(gTEprops.worklayer<3) then
      n = 1
      repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
        repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
          if (tl.specs2[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)))and(gTEprops.worklayer<3) then
            if (afaMvLvlEdit(point(q,c), gTEprops.worklayer+1) <> tl.specs2[n])or(["tileHead", "tileBody"].getPos(gTEprops.tlMatrix[q][c][gTEprops.worklayer+1].tp) > 0) then
              rtrn = 0
              --  put point(q,c) && afaMvLvlEdit(point(q,c), gTEprops.worklayer) && "2"
              exit repeat
            end if
          end if
          n = n + 1
        end repeat
        if rtrn = 0 then
          exit repeat
        end if
      end repeat
      
    end if
    
    
    if rtrn = 1 then
      n = 1
      repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
        repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
          if (tl.specs[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))) then
            if (afaMvLvlEdit(point(q,c), gTEprops.worklayer) <> tl.specs[n])or(["tileHead", "tileBody"].getPos(gTEprops.tlMatrix[q][c][gTEprops.workLayer].tp) > 0) then
              rtrn = 0
              -- put point(q,c) && afaMvLvlEdit(point(q,c), gTEprops.worklayer) && "1"
              exit repeat
            end if
          end if
          n = n + 1
        end repeat
        if rtrn = 0 then
          exit repeat
        end if
      end repeat
      
    end if
    
  end if
  sprite(15).color = color(255, 255*rtrn, 255*rtrn)
  sprite(13).color = color(255, 255*rtrn, 255*rtrn)
  
  return rtrn
end



on PickUpTile(msTile)
  case gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].tp of
    "material":
      -- put string(gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data) 
      repeat with q = 1 to gTiles[1].tls.count then
        -- put gTiles[1].tls[q].nm && gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data
        if(gTiles[1].tls[q].nm = gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data) then
          gTEprops.tmPos = point(1, q)
          updateTileMenu(point(0,0))
          exit repeat
        end if
      end repeat
    "tileHead":
      -- put " - Tile:" && gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data 
      gTEprops.tmPos = gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data[1]
      updateTileMenu(point(0,0))
    "tileBody":
      dt = gTEprops.tlMatrix[msTile.locH][msTile.locV][gTEprops.workLayer].data
      if gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].tp = "tileHead" then
        --   put " - Tile:" && gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].data
        gTEprops.tmPos = gTEprops.tlMatrix[dt[1].locH][dt[1].locV][dt[2]].data[1]
        updateTileMenu(point(0,0))
        --   else
        --  put " - Stray Tile Fragment" 
      end if            
  end case
end 


on placeTile(plcTile, tmPos)
  
  if(plcTile.locH < 1)or(plcTile.locV < 1)or(plcTile.locH > gTEprops.tlMatrix.count)or(plcTile.locV > gTEprops.tlMatrix[1].count)then
    return void
  end if
  
  forceAdaptTerrain = _key.keypressed("G")
  
  tl = gTiles[tmPos.locH].tls[tmPos.locV]
  mdPnt = point(((tl.sz.locH*0.5)+0.4999).integer,((tl.sz.locV*0.5)+0.4999).integer)
  strt = plcTile-mdPnt+point(1,1)
  
  
  gTEprops.tlMatrix[plcTile.locH][plcTile.locV][gTEprops.workLayer].tp = "tileHead"
  gTEprops.tlMatrix[plcTile.locH][plcTile.locV][gTEprops.workLayer].data = [tmPos, tl.nm]--gTEprops.toolData
  if tl.nm = "Chain Holder" then
    gTEprops.tlMatrix[plcTile.locH][plcTile.locV][gTEprops.workLayer].data.add("NONE")
    gTEprops.specialEdit = ["Attatch Chain", plcTile, gTEprops.workLayer]
  end if
  
  
  TEdraw(rect(plcTile.locH,plcTile.locV,plcTile.locH,plcTile.locV), gTEprops.worklayer)
  
  if (tl.specs2 <> void)and(gTEprops.workLayer<3) then
    n = 1
    repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
      repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
        if (tl.specs2[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))) then
          gTEprops.tlMatrix[q][c][gTEprops.workLayer+1].tp = "tileBody"
          gTEprops.tlMatrix[q][c][gTEprops.workLayer+1].data = [plcTile, gTEprops.worklayer]
          TEdraw(rect(q,c,q,c), gTEprops.worklayer+1)
          if(forceAdaptTerrain)then
            gLEProps.Matrix[q][c][gTEprops.workLayer+1][1] = tl.specs2[n]
          end if
        end if
        n = n + 1
      end repeat
    end repeat
  end if
  
  n = 1
  repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
    repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
      if (tl.specs[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))) then
        if(point(q,c)<>plcTile)then
          gTEprops.tlMatrix[q][c][gTEprops.workLayer].tp = "tileBody"
          gTEprops.tlMatrix[q][c][gTEprops.workLayer].data = [plcTile, gTEprops.worklayer]
          TEdraw(rect(q,c,q,c), gTEprops.worklayer)
        end if
        if(forceAdaptTerrain)then
          gLEProps.Matrix[q][c][gTEprops.workLayer][1] = tl.specs[n]
        end if
      end if
      n = n + 1
    end repeat
  end repeat
  
  if(forceAdaptTerrain)then
    lvlEditDraw(rect(strt, strt+tl.sz), 1)
    lvlEditDraw(rect(strt, strt+tl.sz), 2)
    lvlEditDraw(rect(strt, strt+tl.sz), 3)
  end if
  
end


on deleteTileTile(ps, lr)
  tl = gTEprops.tlMatrix[ps.locH][ps.locV][lr].data[1]
  tl = gTiles[tl.locH].tls[tl.locV]
  mdPnt = point(((tl.sz.locH*0.5)+0.4999).integer,((tl.sz.locV*0.5)+0.4999).integer)
  strt = ps-mdPnt+point(1,1)
  
  
  if (tl.specs2 <> 0)and(lr<3) then
    n = 1
    repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
      repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
        if (tl.specs2[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))) then
          gTEprops.tlMatrix[q][c][lr+1].tp = "default"
          gTEprops.tlMatrix[q][c][lr+1].data = 0
          
          rct = rect((q-1)*16, (c-1)*16, q*16, c*16) - rect(gLEprops.camPos*16, gLEprops.camPos*16)
          member("TEimg"&string(2)).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 255, 255)})
          
        end if
        n = n + 1
      end repeat
    end repeat
  end if
  
  n = 1
  repeat with q = strt.locH to strt.locH + tl.sz.locH-1 then
    repeat with c = strt.locV to strt.locV + tl.sz.locV-1 then
      if (tl.specs[n] <> -1)and(point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))) then
        gTEprops.tlMatrix[q][c][lr].tp = "default"
        gTEprops.tlMatrix[q][c][lr].data = 0
        
        rct = rect((q-1)*16, (c-1)*16, q*16, c*16) - rect(gLEprops.camPos*16, gLEprops.camPos*16)
        member("TEimg"&string(lr)).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 255, 255)})
        
      end if
      n = n + 1
    end repeat
  end repeat
end


on specialAction(tl)
  --gTEprops.specialEdit
  case gTEprops.specialEdit[1] of
    "Attatch Chain":
      gTEprops.tlMatrix[gTEprops.specialEdit[2].locH][gTEprops.specialEdit[2].locV][gTEprops.specialEdit[3]].data[3] = tl--.add(tl)
      gTEprops.specialEdit = 0
  end case
end

on changeLayer()
  if gTEprops.workLayer = 2 then
    --gTEprops.workLayer = 2
    sprite(1).blend = 10
    sprite(2).blend = 10
    
    sprite(3).blend = 90
    sprite(4).blend = 100
    sprite(5).blend = 70
    sprite(6).blend = 0
  else if gTEprops.workLayer = 1 then
    -- gTEprops.workLayer = 1
    sprite(1).blend = 10
    sprite(2).blend = 10
    sprite(3).blend = 60
    sprite(4).blend = 10
    sprite(5).blend = 70
    sprite(6).blend = 100
  else
    sprite(1).blend = 100
    sprite(2).blend = 100
    sprite(3).blend = 60
    sprite(4).blend = 10
    sprite(5).blend = 60
    sprite(6).blend = 10
  end if
  member("layerText").text = "Work Layer:" && string(gTEprops.workLayer)
  
  pos = 2 - gTEprops.workLayer
  sprite(1).loc = point(432, 336) + point(pos+1,-pos-1)*3
  sprite(2).loc = point(432, 336) + point(pos+1,-pos-1)*3
  sprite(3).loc = point(432, 336) + point(pos,-pos)*3
  sprite(4).loc = point(432, 336) + point(pos,-pos)*3
  sprite(5).loc = point(432, 336) + point(pos-1,-pos+1)*3
  sprite(6).loc = point(432, 336) + point(pos-1,-pos+1)*3
end


on SpecialRectPlacement(rct)
  case gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm of
    "Rect Clear":
      repeat with px = rct.left  to rct.right  then
        repeat with py = rct.top  to rct.bottom  then
          deleteTile(point(px, py))
        end repeat
      end repeat
      
      
    "SH pattern box",  "SH grate box":
      placeTile(point(rct.left, rct.top), point(4, 5))
      placeTile(point(rct.right, rct.top), point(4, 6) )
      placeTile(point(rct.right, rct.bottom), point(4, 7)  )
      placeTile(point(rct.left, rct.bottom), point(4, 8)   )
      repeat with px = rct.left + 1 to rct.right -1 then
        placeTile(point(px, rct.top), point(4, 1)) 
        placeTile(point(px, rct.bottom), point(4, 3))  
      end repeat
      repeat with py = rct.top + 1 to rct.bottom -1 then
        placeTile(point(rct.left, py), point(4, 4)) 
        placeTile(point(rct.right, py), point(4, 2))  
      end repeat
      
      lookForTileCat = "SU patterns"
      stringLength = 10
      if gTiles[gTEprops.tmPos.locH].tls[gTEprops.tmPos.locV].nm = "SH grate box" then
        lookForTileCat = "SU grates"
        stringLength = 8
      end if 
      
      repeat with q = 3 to gTiles.count then
        if(gTiles[q].nm = lookForTileCat)then
          lookForTileCat = q
          exit repeat
        end if
      end repeat
      
      patterns = []
      patterns.add([#tiles:["A"], #upper:"dense", #lower:"dense", #tall:1, #freq:5])
      patterns.add([#tiles:["B1"], #upper:"espaced", #lower:"dense", #tall:1, #freq:5])
      patterns.add([#tiles:["B2"], #upper:"dense", #lower:"espaced", #tall:1, #freq:5])
      patterns.add([#tiles:["B3"], #upper:"ospaced", #lower:"dense", #tall:1, #freq:5])
      patterns.add([#tiles:["B4"], #upper:"dense", #lower:"ospaced", #tall:1, #freq:5])
      patterns.add([#tiles:["C1"], #upper:"espaced", #lower:"espaced", #tall:1, #freq:5])
      patterns.add([#tiles:["C2"], #upper:"ospaced", #lower:"ospaced", #tall:1, #freq:5])
      patterns.add([#tiles:["E1"], #upper:"ospaced", #lower:"espaced", #tall:1, #freq:5])
      patterns.add([#tiles:["E2"], #upper:"espaced", #lower:"ospaced", #tall:1, #freq:5])
      patterns.add([#tiles:["F1"], #upper:"dense", #lower:"dense", #tall:2, #freq:1])
      patterns.add([#tiles:["F2"], #upper:"dense", #lower:"dense", #tall:2, #freq:1])
      patterns.add([#tiles:["F1", "F2"], #upper:"dense", #lower:"dense", #tall:2, #freq:5])
      patterns.add([#tiles:["F3"], #upper:"dense", #lower:"dense", #tall:2, #freq:5])
      patterns.add([#tiles:["F4"], #upper:"dense", #lower:"dense", #tall:2, #freq:5])
      patterns.add([#tiles:["G1", "G2"], #upper:"dense", #lower:"ospaced", #tall:2, #freq:5])
      patterns.add([#tiles:["I"], #upper:"espaced", #lower:"dense", #tall:1, #freq:4])
      patterns.add([#tiles:["J1"], #upper:"ospaced", #lower:"ospaced", #tall:2, #freq:1])
      patterns.add([#tiles:["J2"], #upper:"ospaced", #lower:"ospaced", #tall:2, #freq:1])
      patterns.add([#tiles:["J1", "J2"], #upper:"ospaced", #lower:"ospaced", #tall:2, #freq:2])
      patterns.add([#tiles:["J3"], #upper:"espaced", #lower:"espaced", #tall:2, #freq:1])
      patterns.add([#tiles:["J4"], #upper:"espaced", #lower:"espaced", #tall:2, #freq:1])
      patterns.add([#tiles:["J3", "J4"], #upper:"espaced", #lower:"espaced", #tall:2, #freq:2])
      patterns.add([#tiles:["B1", "I"], #upper:"espaced", #lower:"dense", #tall:1, #freq:2])
      
      repeat with q = 1 to patterns.count then
        repeat with a = 1 to patterns[q].tiles.count then
          repeat with b = 1 to gTiles[lookForTileCat].tls.count then
            if(patterns[q].tiles[a] = chars(gTiles[lookForTileCat].tls[b].nm, stringLength, gTiles[lookForTileCat].tls[b].nm.length))then
              patterns[q].tiles[a] = b
            end if
          end repeat
        end repeat
      end repeat
      
      py = rct.top + 1
      currentPattern = patterns[random(patterns.count)]
      
      repeat while py < rct.bottom then
        possiblePatterns = []
        repeat with q = 1 to patterns.count then
          if(patterns[q].upper = currentPattern.lower)and(py + patterns[q].tall < rct.bottom+1)then
            repeat with a = 1 to patterns[q].freq then
              possiblePatterns.add(q)
            end repeat
          end if
        end repeat
        
        currentPattern = patterns[possiblePatterns[random(possiblePatterns.count)]]
        tl = random(currentPattern.tiles.count)
        
        repeat with px = rct.left + 1 to rct.right -1 then
          tl = tl + 1
          if(tl > currentPattern.tiles.count)then
            tl = 1
          end if
          placeTile(point(px, py), point(lookForTileCat, currentPattern.tiles[tl])) 
        end repeat
        
        py = py + currentPattern.tall
      end repeat
      
      
  end case
end 







































