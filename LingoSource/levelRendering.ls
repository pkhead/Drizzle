global gLEProps, gTEprops, gLastImported, tileSetIndex, gTiles, gTinySignsDrawn, gLOprops
global gRenderCameraTilePos, gRenderCameraPixelPos, gRenderTrashProps, gMegaTrash, gDRMatFixes, gDRInvI, gRRSpreadsMore
global RandomMetals_allowed, RandomMetals_grabTiles, ChaoticStone2_needed, DRRandomMetal_needed, SmallMachines_forbidden, SmallMachines_grabTiles, RandomMachines_grabTiles, RandomMachines_forbidden, RandomMachines2_forbidden, RandomMachines2_grabTiles

on renderLevel()
  if checkMinimize() then
    _player.appMinimize()
    
  end if
  if checkExit() then
    _player.quit()
  end if
  
  tm = _system.milliseconds
  
  gTinySignsDrawn = 0
  
  gRenderTrashProps = []
  
  RENDER = 0
  cols = 100--gLOprops.size.loch
  rows = 60--gLOprops.size.locv
  
  -- member("bkgBkgImage").image = image(cols*20, rows*20, 16)
  member("finalImage").image = image(cols*20, rows*20, 32)
  
  the randomSeed = gLOprops.tileSeed
  
  setUpLayer(3)
  setUpLayer(2)
  setUpLayer(1)
  
  gLastImported = ""
  
  global gLoadedName
  
  put gLoadedName && "rendered in" && (_system.milliseconds-tm)
end





on setUpLayer(layer)
  -- global gLoprops
  cols = 100--gLoprops.size.loch
  rows = 60--gLoprops.size.locv
  tlset = member("tileSet1").image.duplicate()
  if layer = 1 then
    dpt = 0
  else if layer = 2 then
    dpt = 10
  else
    dpt = 20
  end if
  
  --  repeat with q = dpt to dpt+9 then
  --    member("layer"&string(q)).image = image(cols*20, rows*20, 32)
  --  end repeat
  
  --  member("concreteTexture").image = image(1040,800,32)
  --  repeat with q = 1 to 10 then
  --    repeat with c = 1 to 8 then
  --      member("concreteTexture").image.copyPixels( member("concreteTexture2").image, rect((q-1)*108, (c-1)*108,q*108,c*108), rect(0,0,108,108) )
  --    end repeat
  --  end repeat
  global gLOprops
  
  member("vertImg").image = image(cols*20, rows*20, 32)
  member("horiImg").image = image(cols*20, rows*20, 32)
  
  frntImg = image(cols*20, rows*20, 32)
  mdlFrntImg = image(cols*20, rows*20, 32)
  mdlBckImg = image(cols*20, rows*20, 32)
  poleCol = color(255,0,0)
  drawLaterTiles = []
  drawLastTiles = []
  shortCutEntrences = []
  shortCuts = []
  -- depthPnt(pnt, dpt)
  repeat with q = 1 to cols then
    repeat with c = 1 to rows then
      -- if((q >= gRenderCameraTilePos.locH)and(q < gRenderCameraTilePos.locH + cols)and(c >= gRenderCameraTilePos.locV)and(c < gRenderCameraTilePos.locV + rows))or(checkIfTileHasMaterialRenderTypeTiles(point(q,c), layer))then
      if(q+gRenderCameraTilePos.locH > 0)and(q+gRenderCameraTilePos.locH <= gLOprops.size.locH)and(c+gRenderCameraTilePos.locV > 0)and(c+gRenderCameraTilePos.locV <= gLOprops.size.locV)then
        ps = point(q,c)+gRenderCameraTilePos
        
        tp = gLEProps.matrix[ps.loch][ps.locV][layer][1]
        
        
        repeat with t in gLEProps.matrix[ps.locH][ps.locV][layer][2] then
          case t of
            1:
              rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(0, 8, 0, -8)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
              mdlFrntImg.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:poleCol})
            2:
              rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(8, 0, -8, 0)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
              mdlFrntImg.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:poleCol})
            3:
              -- rct = rect((q-1)*20, (c-1)*20, q*20, c*20)--+rect(0, 8, 0, -8)
              --   mdlFrntImg.copyPixels(member("hiveGrass").image, rct, member("hiveGrass").image.rect, {color:pltt[1]})
            4:
              tp = 1
          end case
        end repeat
        
        --drawATile(q, c, layer)
        --  put gLEProps.matrix[q][c][layer][1]
        if (gLEProps.matrix[ps.locH][ps.locV][1][1] = 7)and(layer=1) then
          shortCutEntrences.add([random(1000), ps.locH, ps.locV])
        else
          
          if gLEProps.matrix[ps.locH][ps.locV][1][2].getPos(5)<>0 then--------------------
            if layer = 1 then
              if gLEProps.matrix[ps.locH][ps.locV][1][1]=1 then
                if ["material", "default"].getPos(gTEprops.tlMatrix[ps.locH][ps.locV][layer].tp) <> 0 then--------------------
                  shortCuts.add(point(ps.locH,ps.locV))
                end if
              end if 
            else if layer = 2 then
              if gLEProps.matrix[ps.locH][ps.locV][2][1]=1 then
                if gLEProps.matrix[ps.locH][ps.locV][1][1]<>1 then
                  if ["material", "default"].getPos(gTEprops.tlMatrix[ps.locH][ps.locV][layer].tp) <> 0 then--------------------
                    shortCuts.add(point(ps.locH,ps.locV))
                  end if
                end if 
              end if
            end if
          end if
          
          if gTEprops.tlMatrix[ps.locH][ps.locV][layer].tp = "tileHead" then
            dt = gTEprops.tlMatrix[ps.locH][ps.locV][layer].data
            if (gTiles[dt[1].locH].tls[dt[1].locV].tags.getPos("drawLast")<>0) then--------------------
              drawLastTiles.add([random(999), ps.locH, ps.locV])
            else
              drawLaterTiles.add([random(999), ps.locH, ps.locV])
            end if
          else if gTEprops.tlMatrix[ps.locH][ps.locV][layer].tp <> "tileBody" then
            drawLaterTiles.add([random(999), ps.locH, ps.locV])
          end if
          
        end if
        
        
      end if
    end repeat
  end repeat
  
  
  drawLaterTiles.sort()
  drawMaterials = []
  indxer = []
  --CAT CHANGE
  repeat with nc = 1 to getLastMatCat()
    repeat with q = 1 to gTiles[nc].tls.count then
      indxer.add(gTiles[nc].tls[q].nm)
      drawMaterials.add([gTiles[nc].tls[q].nm, [], gTiles[nc].tls[q].renderType])
    end repeat
  end repeat
  
  
  repeat with tl in drawLaterTiles then
    savSeed = the randomSeed
    global gLOprops
    the randomSeed = seedForTile(point(tl[2], tl[3]), gLOprops.tileSeed + layer)
    case gTEprops.tlMatrix[tl[2]][tl[3]][layer].tp of
      "material":
        if indxer.getPos(gTEprops.tlMatrix[tl[2]][tl[3]][layer].data) <> void then--------------------
          drawMaterials[indxer.getPos(gTEprops.tlMatrix[tl[2]][tl[3]][layer].data)][2].add(tl)--------------------
        end if
      "default":
        drawMaterials[indxer.getPos(gTEprops.defaultMaterial)][2].add(tl)--------------------
      "tileHead":
        if gTEprops.tlMatrix[(tl[2])][(tl[3])][layer].data <> void then
          dt = gTEprops.tlMatrix[(tl[2])][(tl[3])][layer].data
          frntImg = drawATileTile(tl[2],tl[3],layer,gTiles[dt[1].locH].tls[dt[1].locV], frntImg, dt)
        end if
    end case
    the randomSeed = savSeed
  end repeat
  
  repeat with q = 1 to drawMaterials.count then
    savSeed = the randomSeed
    global gLOprops
    the randomSeed = gLOprops.tileSeed + layer
    if(drawMaterials[q][2].count > 0) then
      case drawMaterials[q][3] of
        "invisibleI":
          if (gDRInvI = FALSE) then
            repeat with tl in drawMaterials[q][2]
              frntImg = drawATileMaterial(tl[2], tl[3], layer, drawMaterials[q][1], frntImg)
            end repeat
          end if
          
        "unified":
          repeat with tl in drawMaterials[q][2] then
            frntImg = drawATileMaterial(tl[2], tl[3], layer, drawMaterials[q][1], frntImg)
          end repeat
          
        "customUnified":
          repeat with tl in drawMaterials[q][2] then
            afa = afaMvLvlEdit(point(tl[2], tl[3]), layer)
            if (afa <> 0) and (afa <> 7) and (afa <> 8) and (afa <> 9) then
              LDrawATileMaterial(tl[2], tl[3], layer, drawMaterials[q][1])
            end if
          end repeat
          
        "tiles":
          frntImg = renderTileMaterial(layer, drawMaterials[q][1], frntImg)
          
        "customAutofit":
          frntImg = LRenderTileMaterial(layer, drawMaterials[q][1], frntImg)
          
        "pipeType":
          repeat with tl in drawMaterials[q][2] then
            -- frntImg = drawATileMaterial(tl[2], tl[3], layer, pltt, drawTiles[q][1], frntImg)
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)<>0 then
              drawPipeTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer)
            end if
          end repeat
          
        "rockType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)<>0 then
              drawRockTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, FALSE)
            end if
          end repeat
          
        "largeTrashType":
          repeat with tl in drawMaterials[q][2] then
            if (gDRMatFixes) and (afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6) then
              drawPipeTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer)
            end if
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 or ((gDRMatFixes) and (afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6)) then
              drawLargeTrashTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "roughRock":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              case drawMaterials[q][1] of
                "Rough Rock":
                  drawRockTypeTile("Rocks", point(tl[2], tl[3]), layer, TRUE)
                "Sandy Dirt":
                  drawPipeTypeTile("Sandy Dirt", point(tl[2], tl[3]), layer)
              end case
            end if
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 then
              drawRoughRockTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "megaTrashType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              drawPipeTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer)
            end if
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              drawMegaTrashTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "dirtType":
          repeat with tl in drawMaterials[q][2] then
            if (gDRMatFixes) and (afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6) then
              drawPipeTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer)
            end if
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 then
              drawDirtTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "sandy":
          repeat with tl in drawMaterials[q][2]
            block = afaMvLvlEdit(point(tl[2], tl[3]), layer)
            if (block <> 0) and (block <> 7) and (block <> 8) and (block <> 9) then
              drawSandyTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg, 4, [40, 28, 24, 16, 10], [0, 40, 68, 92, 108], 30)
            end if
          end repeat
          
        "wv":
          repeat with tl in drawMaterials[q][2] then
            if (afaMvLvlEdit(point(tl[2], tl[3]), layer) <> 0) and (afaMvLvlEdit(point(tl[2], tl[3]), layer) <> 7) and (afaMvLvlEdit(point(tl[2], tl[3]), layer) <> 8) and (afaMvLvlEdit(point(tl[2], tl[3]), layer) <> 9) then
              drawWVTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer)
            end if
          end repeat
          
        "ridgeType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 then
              drawRidgeTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "densePipeType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)<>0 then
              drawDPTTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "randomPipesType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)<>0 then
              drawRandomPipesMat(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if
          end repeat
          
        "ceramicType":
          repeat with tl in drawMaterials[q][2] then
            if (point(tl[2], tl[3]).inside(rect(gRenderCameraTilePos, gRenderCameraTilePos + point(100, 60)))) and (gDRMatFixes = FALSE) and (afaMvLvlEdit(point(tl[2], tl[3]), layer) <> 1) then
              frntImg = drawATileMaterial(tl[2], tl[3], layer, "Standard", frntImg)
            else if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              drawCeramicTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if          
          end repeat
          
        "ceramicAType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              drawCeramicATypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if          
          end repeat
          
        "ceramicBType":
          repeat with tl in drawMaterials[q][2] then
            if afaMvLvlEdit(point(tl[2], tl[3]), layer)=1 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=2 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=3 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=4 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=5 or afaMvLvlEdit(point(tl[2], tl[3]), layer)=6 then
              drawCeramicBTypeTile(drawMaterials[q][1], point(tl[2], tl[3]), layer, frntImg)
            end if          
          end repeat
      end case
    end if
    the randomSeed = savSeed
  end repeat
  
  
  
  
  --shortCuts.sort()
  repeat with tl in shortCuts then
    if (shortCuts.getPos(tl+point(-1,0))>0)and((shortCuts.getPos(tl+point(1,0))>0))then--------------------
      drawATileTile(tl.locH, tl.locV, layer,  [#nm:"shortCutHorizontal", #sz:point(1,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[1, 9], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg)
    else if (shortCuts.getPos(tl+point(0,-1))>0)and((shortCuts.getPos(tl+point(0,1))>0))then--------------------
      drawATileTile(tl.locH, tl.locV, layer,  [#nm:"shortCutVertical", #sz:point(1,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[1, 9], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg)
    else
      drawATileTile(tl.locH, tl.locV, layer,  [#nm:"shortCutTile", #sz:point(1,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[1, 9], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg)
    end if
  end repeat
  
  repeat with tl in drawLastTiles then
    dt = gTEprops.tlMatrix[(tl[2])][(tl[3])][layer].data
    frntImg = drawATileTile(tl[2],tl[3],layer,gTiles[dt[1].locH].tls[dt[1].locV], frntImg)
  end repeat
  
  global gShortcuts
  shortCutEntrences.sort()
  repeat with tl in shortCutEntrences then
    -- frntImg = drawAShortCut(tl[2], tl[3], layer, pltt, frntImg)
    -- put gShortcuts
    tp = "shortCut"
    if gShortcuts.indexL.getPos(point(tl[2], tl[3])-gRenderCameraTilePos)>0 then--------------------
      tp = gShortcuts.scs[gShortcuts.indexL.getPos(point(tl[2], tl[3])-gRenderCameraTilePos)]--------------------
    end if
    
    mem = "shortCut"
    if tp = "shortCut" then
      mem = "shortCutArrows"
    else if tp = "playerHole" then
      mem = "shortCutDots"
    end if
    
    drawATileTile(tl[2], tl[3], 1, [#nm:mem, #sz:point(3,3), #specs:[], #specs2:[], #tp:"voxelStruct", #repeatL:[1,7,12], #bfTiles:1, #rnd:-1, #ptPos:0, #tags:[]], frntImg)
    
  end repeat
  
  
  
  --  repeat with q = dpt to dpt+9 then
  --    member("layer"&string(q)).image.copyPixels(frntImg,rect(0,0,1040,800), rect(0,0,1040,800), {#ink:36})
  --  end repeat
  
  repeat with q = 0 to cols then
    drawVerticalSurface(q, dpt)
  end repeat
  repeat with q = 0 to rows then
    drawHorizontalSurface(q, dpt)
  end repeat
  
  
  
  member("layer"&string(dpt+5)).image.copyPixels(mdlBckImg, mdlBckImg.rect, mdlBckImg.rect, {#ink:36})
  member("layer"&string(dpt)).image.copyPixels(frntImg, frntImg.rect, frntImg.rect, {#ink:36})
  
  
  --ADD CRACKS
  d = 0
  if layer = 2 then
    d = 10
  else if layer = 3 then
    d = 20
  end if
  repeat with q = 1 to cols then
    repeat with c = 1 to rows then
      q2 = q + gRenderCameraTilePos.locH
      c2 = c + gRenderCameraTilePos.locV
      
      if(q2 > 1)and(q2 < gLOprops.size.locH)and(c2 > 1)and(c2 < gLOprops.size.locV)then
        if (gLEProps.matrix[q2][c2][layer][2].getPos(11) > 0)then--------------------
          rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
          if (gLEProps.matrix[q2-1][c2][layer][2].getPos(11)>0)or(gLEProps.matrix[q2-1][c2][layer][1]=0)or(gLEProps.matrix[q2+1][c2][layer][2].getPos(11)>0)or(gLEProps.matrix[q2+1][c2][layer][1]=0)then
            rct = rct+rect(-10, 0, 10, 0)  
          else
            rct = rct+rect(5, 0, -5, 0)
          end if
          if (gLEProps.matrix[q2][c2-1][layer][2].getPos(11)>0)or(gLEProps.matrix[q2][c2-1][layer][1]=0)or(gLEProps.matrix[q2][c2+1][layer][2].getPos(11)>0)or(gLEProps.matrix[q2][c2+1][layer][1]=0)then
            rct = rct+rect(0, -10, 0, 10)
          else
            rct = rct+rect(0, 5, 0, -5)
          end if
          
          repeat with dir in [point(-1,0), point(0,-1),point(1,0),point(0,1)] then
            if (gLEProps.matrix[q2+dir.locH][c2+dir.locV][layer][1] <> 1)then
              repeat with z = d to d+8 then
                repeat with r = 1 to 3 then
                  rnd = random(4)
                  member("layer"&string(z)).image.copyPixels(member("rubbleGraf"&string(rnd)).image, rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(dir*10, dir*10)+rect(random(3)-random(8)+(z-d), random(3)-random(8)+(z-d), random(8)-random(3)-(z-d), random(8)-random(3)-(z-d)), member("rubbleGraf"&string(rnd)).image.rect, {#color:color(255,255,255), #ink:36})
                end repeat  
              end repeat  
            end if
          end repeat
          
          repeat with z = d to d+8 then
            repeat with r = 1 to 4 then
              if ((random(8)>(z-d))and(random(3)>1))or(random(5)=1) then
                rnd = random(4)
                member("layer"&string(z)).image.copyPixels(member("rubbleGraf"&string(rnd)).image, rct+rect(random(8)-random(8)+(z-d), random(8)-random(8)+(z-d), random(8)-random(8)-(z-d), random(8)-random(8)-(z-d)), member("rubbleGraf"&string(rnd)).image.rect, {#color:color(255,255,255), #ink:36})
              end if              
            end repeat
          end repeat
          
        end if
      end if
    end repeat
  end repeat
  
  -- POLES ADDED AFTER CRACKS
  member("layer"&string(dpt+4)).image.copyPixels(mdlFrntImg, mdlFrntImg.rect, mdlFrntImg.rect, {#ink:36})
  --  --ADD POLES (AGAIN)
  --  repeat with q = 1 to 52 then
  --    repeat with c = 1 to 40 then
  --      repeat with t in gLEProps.matrix[q][c][layer][2] then
  --        case t of
  --          1:
  --            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(0, 8, 0, -8)
  --            mdlFrntImg.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:poleCol})
  --          2:
  --            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(8, 0, -8, 0)
  --            mdlFrntImg.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:poleCol})
  --            --   3:
  --            -- rct = rect((q-1)*20, (c-1)*20, q*20, c*20)--+rect(0, 8, 0, -8)
  --            --   mdlFrntImg.copyPixels(member("hiveGrass").image, rct, member("hiveGrass").image.rect, {color:pltt[1]})
  --            --  4:
  --            --    tp = 1
  --        end case
  --      end repeat
  --    end repeat
  --  end repeat
end

on checkIfATileIsSolidAndSameMaterial(tl, lr, mat)
  tl = point(restrict(tl.locH,1,gLOprops.size.loch), restrict(tl.locV,1,gLOprops.size.locv))
  rtrn = 0
  if gLEprops.matrix[tl.locH][tl.locV][lr][1] = 1 then
    if (gTEprops.tlMatrix[tl.locH][tl.locV][lr].tp = "material")and(gTEprops.tlMatrix[tl.locH][tl.locV][lr].data = mat) then
      rtrn = 1
    else if (gTEprops.tlMatrix[tl.locH][tl.locV][lr].tp = "default")and(gTEprops.defaultMaterial = mat) then
      rtrn = 1
    end if 
  end if 
  return rtrn
end

on drawATileMaterial(q: number, c: number, l: number, mat: string, frntImg: image)
  type dp: number

  global gLOprops, gEEprops, gAnyDecals
  
  if l = 1 then
    dp = 0
  else if l = 2 then
    dp = 10
  else
    dp = 20
  end if
  rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
  myTileSet = mat
  if (mat = "Scaffolding") and (gDRMatFixes) then
    myTileSet = mat & "DR"
  else if (mat = "Invisible") then
    myTileSet = "SuperStructure"
  end if
  
  case gLEProps.matrix[q][c][l][1] of
    1:
      repeat with f = 1 to 4 then
        type f: number
        type profL: list
        type gtAtV: number
        type gtAtH: number
        type pstRect: rect
        case f of
          1:
            profL = [point(-1, 0), point(0, -1)]
            gtAtV = 2
            pstRect = rct + rect(0,0,-10, -10)
          2:
            profL = [point(1, 0), point(0, -1)]
            gtAtV = 4
            pstRect = rct + rect(10,0,0, -10)
          3:
            profL = [point(1, 0), point(0, 1)]
            gtAtV = 6
            pstRect = rct + rect(10,10,0,0)
          otherwise:
            profL = [point(-1, 0), point(0, 1)]
            gtAtV = 8
            pstRect = rct + rect(0,10,-10,0)
        end case
        ID: string = ""
        repeat with dr in profL then
          type dr: point
          ID = ID & string( isMyTileSetOpenToThisTile(mat, point(q,c)+dr, l))
        end repeat
        if ID = "11" then
          if (       [1,2,3,4,5].getpos(isMyTileSetOpenToThisTile(mat, point(q,c)+profL[1]+profL[2], l)) > 0        )then
            gtAtH = 10
            gtAtV = 2
          else
            gtAtH = 8
          end if
        else
          gtAtH = [0, "00", 0, "01", 0, "10"].getPos(ID)
        end if
        if gtAtH = 4 then
          if gtAtV = 6 then
            gtAtV = 4
          else if gtAtV = 8 then
            gtAtV = 2
          end if
        else if gtAtH = 6 then
          if (gtAtV = 4)or(gtAtV = 8) then
            gtAtV = gtAtV - 2
          end if
        end if
        gtRect: rect = rect((gtAtH-1)*10, (gtAtV-1)*10, gtAtH*10, gtAtV*10)+rect(-5,-5, 5, 5)
        pstRect = pstRect - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        
        
        --  member("layer"&string(dp)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect, {#ink:36})
        if (mat <> "Sand Block") then
          frntImg.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect, {#ink:36})
          repeat with d = dp+1 to dp+9 then
            member("layer"&string(d)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(120, 0, 120, 0), {#ink:36})
          end repeat
        end if
      end repeat
    2,3,4,5:
      slp = gLEProps.matrix[q][c][l][1]
      if (gDRMatFixes) then
        askDirs = [0, [point(-1, 0), point(0, 1)], [point(0, 1), point(1, 0)], [point(-1, 0), point(0, -1)], [point(0, -1), point(1, 0)]]
      else
        askDirs = [0, [point(-1, 0), point(0, 1)], [point(1, 0), point(0, 1)], [point(-1, 0), point(0, -1)], [point(1, 0), point(0, -1)]]
      end if
      myAskDirs = askDirs[slp]
      type slp:       number
      type askDirs:   list
      type myAskDirs: list
      pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
      
      repeat with ad = 1 to myAskDirs.count then
        type ad: number
        gtRect = rect(10, 90, 30, 110) + rect(60*(ad=2), 30*(slp-2), 60*(ad=2), 30*(slp-2))
        if isMyTileSetOpenToThisTile(mat, point(q,c)+myAskDirs[ad], l) then
          gtRect = gtRect + rect(30, 0, 30, 0)
        end if
        --  member("layer"&string(dp)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(-5,-5, 5, 5), {#ink:36})
        
        if (mat = "Scaffolding") and (gDRMatFixes = FALSE) then
          repeat with d = dp+5 to dp+6 then
            member("layer"&string(d)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(-5,-5, 5, 5)+rect(120, 0, 120, 0), {#ink:36})
          end repeat
          repeat with d = dp+8 to dp+9 then
            member("layer"&string(d)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(-5,-5, 5, 5)+rect(120, 0, 120, 0), {#ink:36})
          end repeat
        else if (mat <> "Sand Block") then
          frntImg.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(-5,-5, 5, 5), {#ink:36})
          repeat with d = dp+1 to dp+9 then
            member("layer"&string(d)).image.copyPixels(member("tileSet"&string(myTileSet)).image, pstRect+rect(-5,-5, 5, 5), gtRect+rect(-5,-5, 5, 5)+rect(120, 0, 120, 0), {#ink:36})
          end repeat
        end if
        --        end if
        
      end repeat
    6:
      if (mat <> "Invisible") then
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        if (mat = "Stained Glass") then
          drawATileTile(q, c, l, [#nm:"SGFL", #sz:point(1,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[10], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg)
        else if (gDRMatFixes) or ((mat <> "Sand Block") and (mat <> "Scaffolding") and (mat <> "Tiny Signs")) then
          drawATileTile(q, c, l, [#nm:"tileSet"&string(myTileSet)&"Floor", #sz:point(1,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[6,1,1,1,1], #bfTiles:1, #rnd:1, #ptPos:0, #tags:[]], frntImg)
        else 
          drawATileTile(q, c, l, [#nm:"tileSetBigMetalFloor", #sz:point(1, 1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[6, 1, 1, 1, 1], #bfTiles:1, #rnd:1, #ptPos:0, #tags:[]], frntImg)
        end if
      end if
  end case
  
  matInt = ["Concrete","RainStone", "Bricks", "Tiny Signs", "Cliff", "Non-Slip Metal", "BulkMetal", "MassiveBulkMetal", "Asphalt"].getPos(mat)
  if (matInt > 0) then
    modder = [45, 6, 1, 10, 45, 5, 5, 10, 45][matInt]
    
    gtRect = rect((q mod modder)*20, (c mod modder)*20, ((q mod modder)+1)*20, ((c mod modder)+1)*20)
    if mat = "Bricks" then
      gtRect = rect(0,0,20,20)
    end if
    if (mat = "Tiny Signs") and (gTinySignsDrawn=0)then
      drawTinySigns()
      gTinySignsDrawn = 1
    end if
    case gLEProps.matrix[q][c][l][1] of
      1:
        
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        --put mat&"Texture"
        -- put member(mat&"Texture")
        member("layer"&string(dp)).image.copyPixels(member(mat&"Texture").image, pstRect, gtRect, {#ink:36})  
      2,3,4,5:
        member("layer"&string(dp)).image.copyPixels(member(mat&"Texture").image, pstRect, gtRect, {#ink:36})
        case gLEProps.matrix[q][c][l][1] of
          5:--2:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.top), point(rct.left, rct.top), point(rct.right, rct.bottom), point(rct.left, rct.bottom)]
          4:--3:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.top), point(rct.right, rct.top), point(rct.left, rct.bottom), point(rct.right, rct.bottom)]
          3:--4:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.bottom), point(rct.left, rct.bottom), point(rct.right, rct.top), point(rct.left, rct.top)]
          2:--5:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.bottom), point(rct.right, rct.bottom), point(rct.left, rct.top), point(rct.right, rct.top)]
        end case
        rct = rct - [gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos]*20
        member("layer"&string(dp)).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255,255,255)})
    end case
  end if
  
  if ["Stained Glass"].getPos(mat)>0 then
    matInt = ["Stained Glass"].getPos(mat)
    modder = [1][matInt]
    imgLoad = "SG"
    gtRect = rect(0,0,20,20)
    var = "1"
    clr1 = "A"
    clr2 = "B"
    q2 = q + gRenderCameraTilePos.locH
    c2 = c + gRenderCameraTilePos.locV
    repeat with nav = 1 to gEEprops.effects.count
      if(gEEprops.effects[nav].nm = "Stained Glass Properties")then
        if (gEEprops.effects[nav].mtrx[q][c] >= 1) then
          case gEEprops.effects[nav].options[2][3] of
            "1":
              var = "1"
            "2":
              var = "2"
            "3":
              var = "3"
            otherwise:
              var = "1"
          end case
          case gEEprops.effects[nav].options[3][3] of
            "EffectColor1":
              clr1 = "A"
            "EffectColor2":
              clr1 = "B"
            "None":
              clr1 = "C"
            otherwise:
              clr1 = "A"
          end case
          case gEEprops.effects[nav].options[4][3] of
            "EffectColor1":
              clr2 = "A"
            "EffectColor2":
              clr2 = "B"
            "None":
              clr2 = "C"
            otherwise:
              clr2 = "B"
          end case
        end if
      end if
    end repeat
    
    case gLEProps.matrix[q][c][l][1] of
      1:
        
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        member("layer"&string(dp)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        --repeat with den = 1 to 9 then
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&clr1&clr2).image, pstRect, gtRect, {#ink:36})
        member("gradientA"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        member("gradientB"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        --den = den+1
        --end repeat
      2,3,4,5:
        member("layer"&string(dp)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        --repeat with dep = 1 to 9 then
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&clr1&clr2).image, pstRect, gtRect, {#ink:36})
        member("gradientA"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        member("gradientB"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        --dep = dep+1
        --end repeat
        case gLEProps.matrix[q][c][l][1] of
          5:--2:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.top), point(rct.left, rct.top), point(rct.right, rct.bottom), point(rct.left, rct.bottom)]
          4:--3:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.top), point(rct.right, rct.top), point(rct.left, rct.bottom), point(rct.right, rct.bottom)]
          3:--4:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.bottom), point(rct.left, rct.bottom), point(rct.right, rct.top), point(rct.left, rct.top)]
          2:--5:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.bottom), point(rct.right, rct.bottom), point(rct.left, rct.top), point(rct.right, rct.top)]
        end case
        rct = rct - [gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos]*20
        repeat with vj = 0 to 1 then
          member("layer"&string(dp+vj)).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255,255,255)})
          --vj = vj + 1
        end repeat
        
      6:
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        member("layer"&string(dp)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        --repeat with des = 1 to 9 then
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Socket").image, pstRect, gtRect, {#color:color(0, 255, 0), #ink:36})
        member("layer"&string(dp+1)).image.copyPixels(member(imgLoad&var&clr1&clr2).image, pstRect, gtRect, {#ink:36})
        member("gradientA"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        member("gradientB"&string(dp+1)).image.copyPixels(member(imgLoad&var&"Grad").image, pstRect, gtRect, {#ink:39})
        --des = des+1
        --end repeat
        case gLEProps.matrix[q][c][l][1] of
          6:
            rct = rect((q-1)*20, (c-1)*20+10, q*20, c*20)
            rct = [point(rct.right, rct.bottom), point(rct.left, rct.bottom), point(rct.left, rct.top), point(rct.right, rct.top)]
        end case
        rct = rct - [gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos]*20
        repeat with v6 = 0 to 1 then
          member("layer"&string(dp+v6)).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255,255,255)})
          --v6 = v6 + 1
        end repeat
    end case
  end if
  
  if ["Sand Block"].getPos(mat)>0 then
    matInt = ["Sand Block"].getPos(mat)
    modder = [28][matInt]
    
    gtRect = rect((q mod modder)*20, (c mod modder)*20, ((q mod modder)+1)*20, ((c mod modder)+1)*20)
    case gLEProps.matrix[q][c][l][1] of
      1:
        
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        rnd = random(4)
        repeat with dep = 0 to 9
          member("layer"&string(dp+dep)).image.copyPixels(member(mat&"Texture"&string(random(4))).image, pstRect, gtRect, {#ink:36})
          --dep = dep+1
        end repeat
      2,3,4,5:
        rnd = random(4)
        repeat with dep = 0 to 9
          member("layer"&string(dp+dep)).image.copyPixels(member(mat&"Texture"&string(random(4))).image, pstRect, gtRect, {#ink:36})
          --dep = dep+1
        end repeat
        case gLEProps.matrix[q][c][l][1] of
          5:--2:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.top), point(rct.left, rct.top), point(rct.right, rct.bottom), point(rct.left, rct.bottom)]
          4:--3:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.top), point(rct.right, rct.top), point(rct.left, rct.bottom), point(rct.right, rct.bottom)]
          3:--4:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.left, rct.bottom), point(rct.left, rct.bottom), point(rct.right, rct.top), point(rct.left, rct.top)]
          2:--5:
            rct = rect((q-1)*20, (c-1)*20, q*20, c*20)
            rct = [point(rct.right, rct.bottom), point(rct.right, rct.bottom), point(rct.left, rct.top), point(rct.right, rct.top)]
        end case
        rct = rct - [gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos, gRenderCameraTilePos]*20
        repeat with dep = 0 to 9
          member("layer"&string(dp+dep)).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255,255,255)})
          --dep = dep+1
        end repeat
      6:
        pstRect = rect((q-1)*20, (c-1)*20, q*20, c*20-10) - rect(gRenderCameraTilePos, gRenderCameraTilePos)*20
        repeat with dep = 0 to 9
          member("layer"&string(dp+dep)).image.copyPixels(member(mat&"Texture"&string(random(4))).image, pstRect, gtRect, {#ink:36})
          --dep = dep+1
        end repeat
    end case
  end if
  
  return frntImg
end


on isMyTileSetOpenToThisTile(mat: string, tl: point, l: number)
  type return: number
  global gLOprops
  rtrn = 0
  if tl.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))then
    if [1,2,3,4,5].getPos(gLEProps.matrix[tl.locH][tl.locV][l][1]) > 0 then
      if (gTEprops.tlMatrix[tl.locH][tl.locV][l].tp = "material")and(gTEprops.tlMatrix[tl.locH][tl.locV][l].data = mat) then
        rtrn = 1
      else if (gTEprops.tlMatrix[tl.locH][tl.locV][l].tp = "default")and(gTEprops.defaultMaterial=mat) then
        rtrn = 1
      end if
    end if
  else
    if gTEprops.defaultMaterial=mat then
      rtrn = 1
    end if
  end if
  return rtrn
end


on drawRidgeTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer) 
  distanceToAir = -1
  repeat with dist = 1 to 5
    repeat with dir in [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)]
      if (afaMvLvlEdit(tl + dir * dist, layer) <> 1) then
        distanceToAir = dist
        exit repeat
      end if
    end repeat
    if (distanceToAir <> -1) then
      exit repeat
    end if
  end repeat
  if (distanceToAir = -1) then
    distanceToAir = 5
  end if  
  if (distanceToAir >= 1) then
    layRB = (layer - 1) * 10
    dp = layRB
    dsct = giveMiddleOfTile(tl - gRenderCameraTilePos)
    pos = dsct
    if (distanceToAir = 1) then
      member("layer" & string(layRB + 2)).image.copyPixels(member("ridgeBase").image, rect(pos.locH - 10, pos.locV - 10, pos.locH + 10, pos.locV + 10), rect(0, 0, 22, 22), {#ink:36})
    end if 
    if (random(5) <= distanceToAir) then
      var = random(30)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      frntImg.copyPixels(member("ridgeRocks").image, rotateToQuad(rct, random(15)), rect((var - 1) * 52, 1, var * 52, 53), {#ink:36})
    end if 
    repeat with q = 1 to distanceToAir
      if (distanceToAir = 1) then
        dp = layRB + random(2) - 1
      else
        dp = layRB + random(10) - 1
      end if
      pos = dsct + point(-11 + random(21), -11 + random(21))
      var = random(30)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      member("layer" & string(dp)).image.copyPixels(member("ridgeRocks").image, rotateToQuad(rct, random(15)), rect((var - 1) * 52, 1, var * 52, 53), {#ink:36})
    end repeat   
  end if 
  the randomSeed = savSeed
end


on drawATileTile(q: number, c: number, l: number, tl, frntImg: image, dt: list)
  
  global gAnyDecals
  
  --INTERNAL
  if (checkDRInternal(tl.nm)) then
    tileImage = member(tl.nm).image
  else
    tileImage = cacheLoadImage("Graphics" & the dirSeparator & tl.nm & ".png")
  end if
  
  q = q - gRenderCameraTilePos.locH
  c = c - gRenderCameraTilePos.locV
  
  
  
  --clTile = member(("layer")&string(lr)).image.getPixel(pnt)
  
  mdPnt = point(((tl.sz.locH*0.5)+0.4999).integer,((tl.sz.locV*0.5)+0.4999).integer)
  strt = point(q,c)-mdPnt+point(1,1)
  
  type rct:     rect
  type gtRect:  rect
  type dp:      number
  type getrect: rect
  type getrct:  rect
  type rnd:     number
  type d:       number
  
  colored = (tl.tags.GetPos("colored") > 0)
  if(colored)then
    gAnyDecals = 1
  end if
  
  effectColorA = (tl.tags.GetPos("effectColorA") > 0)
  --  if(effectColorA)then
  --    gAnyDecals = 1
  --  end if
  
  effectColorB = (tl.tags.GetPos("effectColorB") > 0)
  --  if(effectColorB)then
  --    gAnyDecals = 1
  --  end if
  
  case tl.tp of
    "box":
      
      nmOfTiles = tl.sz.locH*tl.sz.locV
      type nmOfTiles: number
      
      
      n = 1
      type n: number
      repeat with g = strt.locH to strt.locH + tl.sz.locH-1 then
        type g: number
        repeat with h = strt.locV to strt.locV + tl.sz.locV-1 then
          type h: number
          rct = rect((g-1)*20, (h-1)*20, (g*20), (h*20)) 
          getrct = rect(20, (n-1)*20, 40, n*20)
          member("vertImg").image.copyPixels(tileImage, rct, getrct, {#ink:36})
          getrct = rect(0, (n-1)*20, 20, n*20)
          member("horiImg").image.copyPixels(tileImage, rct, getrct, {#ink:36})
          --          if(colored)then
          --            if (tl.tags.GetPos("effectColorA") = 0) and (tl.tags.GetPos("effectColorB") = 0) then
          --              member("horiDc").image.copyPixels(tileImage, rct, getrct+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:36})
          --            end if
          --          end if
          --          if(effectColorA)then
          --            member("horiGradA").image.copyPixels(tileImage, rct, getrct+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:36})
          --          end if
          --          if(effectColorB)then
          --            member("horiGradB").image.copyPixels(tileImage, rct, getrct+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:36})
          --          end if
          n = n + 1
        end repeat
      end repeat
      rct = rect(strt*20, (strt+tl.sz)*20)+rect(-20*tl.bfTiles, -20*tl.bfTiles, 20*tl.bfTiles, 20*tl.bfTiles)+rect(-20, -20, -20, -20)
      getRect = rect(0,0,tl.sz.locH*20, tl.sz.locV*20)+rect(0,0,40*tl.bfTiles, 40*tl.bfTiles)+rect(0,nmOfTiles*20,0,nmOfTiles*20)
      rnd = random(tl.rnd)
      getRect = getRect + rect(getRect.width*(rnd-1), 0, getRect.width*(rnd-1), 0)
      frntImg.copyPixels(tileImage, rct, getRect, {#ink:36})
      
      --    "wvStruct":
      --      drawWVTagTile(q, c, l, tl, frntImg, effectColorA, effectColorB, colored, tileImage)
      
    "voxelStruct":
      
      if l = 1 then
        dp = 0
      else if l = 2 then
        dp = 10
      else
        dp = 20
      end if
      
      rct = rect(strt*20, (strt+tl.sz)*20)+rect(-20*tl.bfTiles, -20*tl.bfTiles, 20*tl.bfTiles, 20*tl.bfTiles)+rect(-20, -20, -20, -20)
      gtRect = rect(0,0,(tl.sz.locH*20)+(40*tl.bfTiles), (tl.sz.locV*20)+(40*tl.bfTiles))
      
      if tl.rnd = -1 then
        rnd = 1
        
        repeat with dir in [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)] then
          type dir: point
          if [0,6].getPos(afaMvLvlEdit(point(q,c)+dir+gRenderCameraTilePos, 1))<>0 then
            exit repeat
          else
            rnd = rnd + 1
          end if
        end repeat
        
      else
        rnd = random(tl.rnd)
      end if
      
      if tl.tags.getPos("ramp")<> 0 then
        rnd = 2
        if (afaMvLvlEdit(point(q,c)+gRenderCameraTilePos, 1)=3) then
          rnd = 1
        end if
      end if
      
      
      frntImg.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1), 0, gtRect.width*(rnd-1), 0)+rect(0,1,0,1), {#ink:36})
      
      
      d = -1
      repeat with ps = 1 to tl.repeatL.count then
        type ps: number
        repeat with ps2n = 1 to tl.repeatL[ps] then
          type ps2n: number
          d = d + 1  
          if d+dp > 29 then
            exit repeat
          else
            member("layer"&string(d+dp)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1),gtRect.height*(ps-1), gtRect.width*(rnd-1), gtRect.height*(ps-1))+rect(0,1,0,1), {#ink:36})
            
            if(colored)then
              if (effectColorA = FALSE) and (effectColorB = FALSE) then
                member("layer"&string(d+dp)&"dc").image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1),gtRect.height*(ps-1), gtRect.width*(rnd-1), gtRect.height*(ps-1))+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:36})
              end if
            end if
            
            if(effectColorA)then
              member("gradientA"&string(d+dp)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1),gtRect.height*(ps-1), gtRect.width*(rnd-1), gtRect.height*(ps-1))+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:39})
            end if
            
            if(effectColorB)then
              member("gradientB"&string(d+dp)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1),gtRect.height*(ps-1), gtRect.width*(rnd-1), gtRect.height*(ps-1))+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:39})
            end if
          end if
        end repeat
      end repeat
      
    "voxelStructRandomDisplaceHorizontal", "voxelStructRandomDisplaceVertical":
      
      if l = 1 then
        dp = 0
      else if l = 2 then
        dp = 10
      else
        dp = 20
      end if
      
      rct = rect(strt*20, (strt+tl.sz)*20)+rect(-20*tl.bfTiles, -20*tl.bfTiles, 20*tl.bfTiles, 20*tl.bfTiles)+rect(-20, -20, -20, -20)
      gtRect = rect(0,0,(tl.sz.locH*20)+(40*tl.bfTiles), (tl.sz.locV*20)+(40*tl.bfTiles))
      
      -- rnd = 1
      
      seed = the randomSeed
      type seed: number
      global gLOprops
      
      type gtRect1: rect
      type gtRect2: rect
      type rct1: rect
      type rct2: rect
      
      if tl.tp = "voxelStructRandomDisplaceVertical" then
        the randomSeed = gLOprops.tileSeed + q
        dsplcPoint: number = random(gtRect.height)
        gtRect1 = rect(gtRect.left, gtRect.top, gtRect.right, gtRect.top+dsplcPoint)
        gtRect2 = rect(gtRect.left, gtRect.top+dsplcPoint, gtRect.right, gtRect.bottom)
        rct1 = rect(rct.left, rct.bottom-dsplcPoint, rct.right, rct.bottom)
        rct2 = rect(rct.left, rct.top, rct.right, rct.bottom-dsplcPoint)
      else
        the randomSeed = gLOprops.tileSeed + c
        dsplcPoint = random(gtRect.width)
        gtRect1 = rect(gtRect.left, gtRect.top, gtRect.left+dsplcPoint, gtRect.bottom)
        gtRect2 = rect(gtRect.left+dsplcPoint, gtRect.top, gtRect.right, gtRect.bottom)
        rct1 = rect(rct.right-dsplcPoint, rct.top, rct.right, rct.bottom)
        rct2 = rect(rct.left, rct.top, rct.right-dsplcPoint, rct.bottom)
      end if
      the randomSeed = seed
      
      frntImg.copyPixels(tileImage, rct1, gtRect1 +rect(0,1,0,1), {#ink:36})
      frntImg.copyPixels(tileImage, rct2, gtRect2 +rect(0,1,0,1), {#ink:36})
      
      
      d = -1
      repeat with ps = 1 to tl.repeatL.count then
        repeat with ps2n = 1 to tl.repeatL[ps] then
          d = d + 1  
          if d+dp > 29 then
            exit repeat
          else
            member("layer"&string(d+dp)).image.copyPixels(tileImage, rct1, gtRect1 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1), {#ink:36})
            if(colored)then
              if (effectColorA = FALSE) and (effectColorB = FALSE) then
                member("layer"&string(d+dp)&"dc").image.copyPixels(tileImage, rct1, gtRect1 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:36})
              end if
            end if
            
            if(effectColorA)then
              member("gradientA"&string(d+dp)).image.copyPixels(tileImage, rct1, gtRect1 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:39})
            end if
            
            if(effectColorB)then
              member("gradientB"&string(d+dp)).image.copyPixels(tileImage, rct1, gtRect1 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:39})
            end if
            
            member("layer"&string(d+dp)).image.copyPixels(tileImage, rct2, gtRect2 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1), {#ink:36})
            if(colored)then
              if (effectColorA = FALSE) and (effectColorB = FALSE) then
                member("layer"&string(d+dp)&"dc").image.copyPixels(tileImage, rct2, gtRect2 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:36})
              end if
            end if
            
            if(effectColorA)then
              member("gradientA"&string(d+dp)).image.copyPixels(tileImage, rct2, gtRect2 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:39})
            end if
            
            if(effectColorB)then
              member("gradientB"&string(d+dp)).image.copyPixels(tileImage, rct2, gtRect2 + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1)+rect(tl.sz.locH*20+(40*tl.bfTiles),0,tl.sz.locH*20+(40*tl.bfTiles), 0), {#ink:39})
            end if
            
          end if
        end repeat
      end repeat
      
    "voxelStructRockType":
      if l = 1 then
        dp = 0
      else if l = 2 then
        dp = 10
      else
        dp = 20
      end if
      rct = rect(strt*20, (strt+tl.sz)*20)+rect(-20*tl.bfTiles, -20*tl.bfTiles, 20*tl.bfTiles, 20*tl.bfTiles)+rect(-20, -20, -20, -20)
      gtRect = rect(0,0,(tl.sz.locH*20)+(40*tl.bfTiles), (tl.sz.locV*20)+(40*tl.bfTiles))
      
      
      rnd = random(tl.rnd)
      
      repeat with d = dp to restrict(dp+9+(10*(tl.specs2 <> void)), 0, 29) then
        if [12, 8, 4].getPos(d) then
          rnd = random(tl.rnd)
        end if
        member("layer"&string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1), 0, gtRect.width*(rnd-1), 0)+rect(0,1,0,1), {#ink:36})
        
        if(colored)then
          if (effectColorA = FALSE) and (effectColorB = FALSE) then
            member("layer"&string(d)&"dc").image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1), 0, gtRect.width*(rnd-1), 0)+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:36})
          end if
        end if
        
        if(effectColorA)then
          member("gradientA"&string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1), 0, gtRect.width*(rnd-1), 0)+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:39})
        end if
        
        if(effectColorB)then
          member("gradientB"&string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width*(rnd-1), 0, gtRect.width*(rnd-1), 0)+rect(0,1,0,1)+rect((tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd,0,(tl.sz.locH*20+(40*tl.bfTiles))*tl.rnd, 0), {#ink:39})
        end if
        
      end repeat
      
    "voxelStructSandType":
      if (l = 1) then
        dp = 1
      else if (l = 2) then
        dp = 11
      else
        dp = 21
      end if
      rct = rect(strt * 20, (strt + tl.sz) * 20) + rect(-20 * tl.bfTiles, -20 * tl.bfTiles, 20 * tl.bfTiles, 20 * tl.bfTiles) + rect(-20, -20, -20, -20)
      gtRect = rect(0, 0, (tl.sz.locH * 20) + (40 * tl.bfTiles), (tl.sz.locV * 20) + (40 * tl.bfTiles))
      repeat with d = dp to restrict(dp + 9 + (10 * (tl.specs2 <> VOID)), 1, 29)
        rnd = random(tl.rnd)
        member("layer" & string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width * (rnd - 1), 0, gtRect.width * (rnd - 1), 0) + rect(0, 1, 0, 1), {#ink:36})
        if (colored) then
          if (effectColorA = FALSE) and (effectColorB = FALSE) then
            member("layer" & string(d) & "dc").image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width * (rnd - 1), 0, gtRect.width * (rnd - 1), 0) + rect(0, 1, 0, 1) + rect((tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0, (tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0), {#ink:36})
          end if
        end if
        if (effectColorA) then
          member("gradientA" & string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width * (rnd - 1), 0, gtRect.width * (rnd - 1), 0) + rect(0, 1, 0, 1) + rect((tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0, (tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0), {#ink:39})
        end if
        if (effectColorB) then
          member("gradientB" & string(d)).image.copyPixels(tileImage, rct, gtRect + rect(gtRect.width * (rnd - 1), 0, gtRect.width * (rnd - 1), 0) + rect(0, 1, 0, 1) + rect((tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0, (tl.sz.locH * 20 + (40 * tl.bfTiles)) * tl.rnd, 0), {#ink:39})
        end if
      end repeat
  end case
  
  repeat with tag in tl.tags then
    type tag: string

    type img: image
    type r: list
    case tag of
      "Chain Holder":
        if (dt.count > 2)then
          if (dt[3] <> "NONE") then
            ps1: point = giveMiddleOfTile(point(q,c))+point(10.1,10.1)
            ps2: point = giveMiddleOfTile(dt[3]-gRenderCameraTilePos)+point(10.1,10.1)
            
            if l = 1 then
              dp = 2
            else if l = 2 then
              dp = 12
            else
              dp = 22
            end if
            
            global gLOProps
            
            steps: number = ((diag(ps1, ps2)/12.0)+0.4999).integer
            dr: point = moveToPoint(ps1, ps2, 1.0)
            ornt: number = random(2)-1
            degDir: number = lookatpoint(ps1, ps2)
            stp: number = random(100)*0.01
            repeat with q = 1 to steps then
              pos: point = ps1+(dr*12*(q-stp))
              if ornt then
                --   pos = (pnt+lastPnt)*0.5
                rct = rect(pos,pos)+rect(-6,-10,6,10)
                gtRect = rect(0,0,12,20)
                ornt = 0
              else
                -- pos = (pnt+lastPnt)*0.5
                rct = rect(pos,pos)+rect(-2,-10,2,10)
                gtRect = rect(13,0,16,20)
                ornt = 1
              end if
              -- put rct
              member("layer"&string(dp)).image.copypixels(member("bigChainSegment").image, rotateToQuad(rct, degDir), gtRect, {#color:gLOProps.pals[gLOProps.pal].detCol, #ink:36})
              -- member("layer"&string(dp)).image.copypixels(member("bigChainSegment").image, rct, member("bigChainSegment").image.rect, {#color:color(255,0,0), #ink:36})
            end repeat
            
          end if
        end if
        
      "fanBlade":
        if l = 1 then
          dp = 10
        else if l = 2 then
          dp = 20
        else
          dp = 25
        end if
        rct = rect(-23,-23,23,23)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))
        -- dp = 1
        member("layer"&string(dp-2)).image.copyPixels(member("fanBlade").image, rotateToQuad(rct, random(360)), member("fanBlade").image.rect, {#ink:36, #color:color(0,255,0)})
        
        member("layer"&string(dp)).image.copyPixels(member("fanBlade").image, rotateToQuad(rct, random(360)), member("fanBlade").image.rect, {#ink:36, #color:color(0,255,0)})
        
      "Big Wheel":
        type dpsl: list
        if l = 1 then
          dpsL = [0, 7]
        else if l = 2 then
          dpsL = [9, 17]
        else
          dpsL = [19, 27]
        end if
        rct = rect(-90,-90,90,90)+rect(giveMiddleOfTile(point(q,c))+point(10,10), giveMiddleOfTile(point(q,c))+point(10,10))
        -- dp = 1
        repeat with dp1 in dpsL then
          type dp1: number
          rnd = random(360)
          repeat with dp in [dp1, dp1+1, dp1+2] then
            member("layer"&string(dp)).image.copyPixels(member("Big Wheel Graf").image, rotateToQuad(rct, rnd+0.001), member("Big Wheel Graf").image.rect, {#ink:36, #color:color(0,255,0)})
          end repeat
        end repeat
        
        
      "Sawblades":
        if l = 1 then
          dpsL = [0, 7]
        else if l = 2 then
          dpsL = [9, 17]
        else
          dpsL = [19, 27]
        end if
        rct = rect(-90,-90,90,90)+rect(giveMiddleOfTile(point(q,c))+point(10,10), giveMiddleOfTile(point(q,c))+point(10,10))
        repeat with dp1 in dpsL then
          rnd = random(360)
          repeat with dp in [dp1] then
            member("layer"&string(dp)).image.copyPixels(member("sawbladeGraf").image, rotateToQuad(rct, rnd+0.001), member("sawbladeGraf").image.rect, {#ink:36, #color:color(0,0,255)})
          end repeat
        end repeat
        
        
      "randomCords":
        if l = 1 then
          dp = random(9)
        else if l = 2 then
          dp = 10+random(9)
        else
          dp = 20+random(9)
        end if
        -- put tl
        pnt = giveMiddleOfTile(point(q,c+(tl.sz.locV/2)))-- + point(-0.5*tl.sz.locH+random(tl.sz.locH), 0)
        type pnt: point
        rct = rect(-50,-50,50,50)+rect(pnt, pnt)
        -- dp = 1
        --  member("layer"&string(dp-2)).image.copyPixels(member("fanBlade").image, rotateToQuad(rct, random(360)), member("fanBlade").image.rect, {#ink:36, #color:color(0,255,0)})
        rnd = random(7)
        member("layer"&string(dp)).image.copyPixels(member("randomCords").image, rotateToQuad(rct, -30+random(60)), rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1), {#ink:36})
        
      "Big Sign":
        -- put "BIG SIGN"
        img = image(60,60,1)
        rnd = random(20)
        rct = rect(3,3,29,33)
        img.copyPixels(member("bigSigns1").image, rct, rect((rnd-1)*26, 0, rnd*26, 30), {#ink:36, #color:color(0,0, 0)})
        rnd = random(20)
        rct = rect(3+28,3,29+28,33)
        img.copyPixels(member("bigSigns1").image, rct, rect((rnd-1)*26, 0, rnd*26, 30), {#ink:36, #color:color(0,0, 0)})
        rnd = random(14)
        rct = rect(3,35,3+55,35+24)
        img.copyPixels(member("bigSigns2").image, rct, rect((rnd-1)*55, 0, rnd*55, 24), {#ink:36, #color:color(0,0,0)})
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          frntImg.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,60,60), {#ink:36, #color:r[2]})
        end repeat
        
        
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        frntImg.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(255,0,255)})
        --member("layer"&string(dp-1)).image.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(255,255,255)})
        --member("layer"&string(dp)).image.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(255,0,255)})
        
        mdPnt = giveMiddleOfTile(point(q,c))--depthPnt(giveMiddleOfTile(point(q,c)), -5+dp)
        
        copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-30,-30),mdPnt+point(30,30)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1.0)
        
      "Big Sign B":
        -- put "BIG SIGN"
        img = image(60,60,1)
        rnd = random(20)
        rct = rect(3,3,29,33)
        img.copyPixels(member("bigSigns1").image, rct, rect((rnd-1)*26, 0, rnd*26, 30), {#ink:36, #color:color(0,0, 0)})
        rnd = random(20)
        rct = rect(3+28,3,29+28,33)
        img.copyPixels(member("bigSigns1").image, rct, rect((rnd-1)*26, 0, rnd*26, 30), {#ink:36, #color:color(0,0, 0)})
        rnd = random(14)
        rct = rect(3,35,3+55,35+24)
        img.copyPixels(member("bigSigns2").image, rct, rect((rnd-1)*55, 0, rnd*55, 24), {#ink:36, #color:color(0,0,0)})
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          frntImg.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,60,60), {#ink:36, #color:r[2]})
        end repeat
        
        
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        frntImg.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(0,255,255)})
        --member("layer"&string(dp-1)).image.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(255,255,255)})
        --member("layer"&string(dp)).image.copyPixels(img, rect(-30,-30,30,30)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c))), rect(0,0,60,60), {#ink:36, #color:color(255,0,255)})
        
        mdPnt = giveMiddleOfTile(point(q,c))--depthPnt(giveMiddleOfTile(point(q,c)), -5+dp)
        
        copyPixelsToEffectColor("B", dp, rect(mdPnt+point(-30,-30),mdPnt+point(30,30)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1.0)
        
        
      "Big Western Sign", "Big Western Sign Tilted":
        img = image(36,48,1)
        rnd = random(20)
        --  rct = rect(3,3,29,33)
        img.copyPixels(member("bigWesternSigns").image, img.rect, rect((rnd-1)*36, 0, rnd*36, 48), {#ink:36, #color:color(0,0, 0)})
        
        
        mdPoint = giveMiddleOfTile(point(q,c))+point(10,0)
        lst = [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)],[point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]]
        type mdPoint: point
        type lst: list
        
        if tag = "Big Western Sign Tilted" then
          tlt: number = -45.1+random(90)
          repeat with r in lst then
            frntImg.copyPixels(img, rotateToQuad(rect(mdPoint, mdPoint) + rect(-18,-24,18,24) +rect(r[1],r[1]), tlt), rect(0,0,36,48), {#ink:36, #color:r[2]})
          end repeat
        else
          repeat with r in lst then
            frntImg.copyPixels(img, rect(mdPoint, mdPoint) + rect(-18,-24,18,24) +rect(r[1],r[1]), rect(0,0,36,48), {#ink:36, #color:r[2]})
          end repeat
        end if
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        copyPixelsToEffectColor("A", dp, rect(mdPoint+point(-25,-30),mdPoint+point(25,30)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1)
        
      "Big Western Sign B", "Big Western Sign Tilted B":
        img = image(36,48,1)
        rnd = random(20)
        --  rct = rect(3,3,29,33)
        img.copyPixels(member("bigWesternSigns").image, img.rect, rect((rnd-1)*36, 0, rnd*36, 48), {#ink:36, #color:color(0,0, 0)})
        
        
        mdPoint = giveMiddleOfTile(point(q,c))+point(10,0)
        lst = [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)],[point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(0,255,255)]]
        
        if tag = "Big Western Sign Tilted B" then
          tlt = -45.1+random(90)
          repeat with r in lst then
            frntImg.copyPixels(img, rotateToQuad(rect(mdPoint, mdPoint) + rect(-18,-24,18,24) +rect(r[1],r[1]), tlt), rect(0,0,36,48), {#ink:36, #color:r[2]})
          end repeat
        else
          repeat with r in lst then
            frntImg.copyPixels(img, rect(mdPoint, mdPoint) + rect(-18,-24,18,24) +rect(r[1],r[1]), rect(0,0,36,48), {#ink:36, #color:r[2]})
          end repeat
        end if
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        copyPixelsToEffectColor("B", dp, rect(mdPoint+point(-25,-30),mdPoint+point(25,30)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1)
        
      "Small Asian Sign", "small asian sign on wall":
        img = image(20,20,1)
        rnd = random(14)
        rct = rect(0,1,20,18)
        img.copyPixels(member("smallAsianSigns").image, rct, rect((rnd-1)*20, 0, rnd*20, 17), {#ink:36, #color:color(0,0, 0)})
        
        if tag = "Small Asian Sign" then
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]] then
            frntImg.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          if l = 1 then
            dp = 0
          else if l = 2 then
            dp = 10
          else
            dp = 20
          end if
          
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1)
          
        else
          if l = 1 then
            dp = 8
          else if l = 2 then
            dp = 18
          else
            dp = 28
          end if
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]] then
            member("layer"&string(dp)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            member("layer"&string(dp+1)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            -- member("layer"&string(dp+2)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1)
          
          
        end if
        
      "Small Asian Sign B", "small asian sign on wall B":
        img = image(20,20,1)
        rnd = random(14)
        rct = rect(0,1,20,18)
        img.copyPixels(member("smallAsianSigns").image, rct, rect((rnd-1)*20, 0, rnd*20, 17), {#ink:36, #color:color(0,0, 0)})
        
        if tag = "Small Asian Sign B" then
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(0,255,255)]] then
            frntImg.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          if l = 1 then
            dp = 0
          else if l = 2 then
            dp = 10
          else
            dp = 20
          end if
          
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("B", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1)
          
        else
          if l = 1 then
            dp = 8
          else if l = 2 then
            dp = 18
          else
            dp = 28
          end if
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(0,255,255)]] then
            member("layer"&string(dp)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            member("layer"&string(dp+1)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            -- member("layer"&string(dp+2)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("B", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1)
          
          
        end if
        
      "Small Asian Sign Station", "Small Asian Sign On Wall Station":
        img = image(20,20,1)
        rnd = random(14)
        rct = rect(0,1,20,18)
        img.copyPixels(member("smallAsianSignsStation").image, rct, rect((rnd-1)*20, 0, rnd*20, 17), {#ink:36, #color:color(0,0, 0)})
        
        if tag = "Small Asian Sign Station" then
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]] then
            frntImg.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          if l = 1 then
            dp = 0
          else if l = 2 then
            dp = 10
          else
            dp = 20
          end if          
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1)         
        else
          if l = 1 then
            dp = 8
          else if l = 2 then
            dp = 18
          else
            dp = 28
          end if
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]] then
            member("layer"&string(dp)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            member("layer"&string(dp+1)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat  
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1)    
        end if
        
      "Small Asian Sign Station B", "Small Asian Sign On Wall Station B":
        img = image(20,20,1)
        rnd = random(14)
        rct = rect(0,1,20,18)
        img.copyPixels(member("smallAsianSignsStation").image, rct, rect((rnd-1)*20, 0, rnd*20, 17), {#ink:36, #color:color(0,0, 0)})
        
        if tag = "Small Asian Sign Station B" then
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(0,255,255)]] then
            frntImg.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat
          if l = 1 then
            dp = 0
          else if l = 2 then
            dp = 10
          else
            dp = 20
          end if     
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("B", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1)   
        else
          if l = 1 then
            dp = 8
          else if l = 2 then
            dp = 18
          else
            dp = 28
          end if
          repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(0,255,255)]] then
            member("layer"&string(dp)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
            member("layer"&string(dp+1)).image.copyPixels(img, rect(-10,-10,10,10)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))+rect(r[1],r[1]), rect(0,0,20,20), {#ink:36, #color:r[2]})
          end repeat  
          mdPnt = giveMiddleOfTile(point(q,c))
          copyPixelsToEffectColor("B", dp, rect(mdPnt+point(-13,-13),mdPnt+point(13,13)), "bigSignGradient", rect(0, 0, 60, 60), 1, 1) 
        end if
        
      "glass":
        if l = 1 then
          rct = rect(-10*tl.sz.loch,-10*tl.sz.locv,10*tl.sz.loch,10*tl.sz.locv)+rect(giveMiddleOfTile(point(q,c)), giveMiddleOfTile(point(q,c)))
          member("glassImage").image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#ink:36})
        end if  
        
      "harvester":
        renderHarvesterDetails(q, c, l, tl, frntImg, dt)
        
      "Temple Floor":
        tileCat = 0
        type tileCat: number
        repeat with a = 1 to gTiles.count then
          type a: number
          if(gTiles[a].nm = "Temple Stone")then
            tileCat = a
            exit repeat
          end if
        end repeat
        
        actualTlPs = point(q,c) + gRenderCameraTilePos
        type actualrlps: point
        
        
        
        nextIsFloor = 0
        type nextisfloor: number
        if(actualTlPs.locH+8 <= gTEProps.tlMatrix.count)then
          if(gTEProps.tlMatrix[actualTlPs.locH+8][actualTlPs.locV][l].tp = "tileHead")then
            if(gTEProps.tlMatrix[actualTlPs.locH+8][actualTlPs.locV][l].data[2] = "Temple Floor")then
              nextIsFloor = 1
            end if
          end if
        end if
        prevIsFloor = 0
        type prevIsFloor: number
        if(actualTlPs.locH-8 > 0)then
          if(gTEProps.tlMatrix[actualTlPs.locH-8][actualTlPs.locV][l].tp = "tileHead")then
            if(gTEProps.tlMatrix[actualTlPs.locH-8][actualTlPs.locV][l].data[2] = "Temple Floor")then
              prevIsFloor = 1
            end if
          end if
        end if
        
        if(prevIsFloor)then
          frntImg = drawATileTile(q+gRenderCameraTilePos.locH-4,c+gRenderCameraTilePos.locV-1,l, gTiles[tileCat].tls[13], frntImg)
        else 
          frntImg = drawATileTile(q+gRenderCameraTilePos.locH-3,c+gRenderCameraTilePos.locV-1,l, gTiles[tileCat].tls[7], frntImg)
        end if
        
        if(nextIsFloor = 0)then
          frntImg = drawATileTile(q+gRenderCameraTilePos.locH+4,c+gRenderCameraTilePos.locV-1,l, gTiles[tileCat].tls[8], frntImg)
        end if
        
        --  drawATileTile(q-4, c-1, l, [#nm:"Temple Stone Wedge", #sz:point(2,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[1,1,1,1,6], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg)
        --  drawATileTile(q+4, c-1, l, [#nm:"Temple Stone Wedge", #sz:point(2,1), #specs:[], #specs2:void, #tp:"voxelStruct", #repeatL:[1,1,1,1,6], #bfTiles:0, #rnd:1, #ptPos:0, #tags:[]], frntImg) 
        
      "Larger Sign":
        -- put "BIG SIGN"
        img = image(80+6,100+6,1)
        rnd = random(14)
        rct = rect(3,3,83,103)
        img.copyPixels(member("largerSigns").image, rct, rect((rnd-1)*80, 0, rnd*80, 100), {#ink:36, #color:color(0,0, 0)})
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        mdPnt = giveMiddleOfTile(point(q,c))+point(10, 0)
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          repeat with d = 0 to 1 then
            member("layer" & string(dp + d)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt)+rect(r[1],r[1]), rect(0,0,86,106), {#ink:36, #color:r[2]})
          end repeat
        end repeat
        
        
        member("layer" & string(dp)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,255,255)})
        member("layer" & string(dp + 1)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,0,255)})
        
        member("largeSignGrad2").image.copyPixels(member("largeSignGrad").image, rect(0,0,80,100), rect(0,0,80,100))
        
        repeat with a = 0 to 6 then
          repeat with b = 0 to 13 then
            type b: number
            rct = rect((a*16)-6, (b*8)-1, ((a+1)*16)-6, ((b+1)*8)-1) --+ rect(0,0,-1,-1)
            if(random(7)=1)then
              blnd: number = random(random(100))
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(0,0,1,1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
            else if(random(7)=1)then
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(0, 0, 0), #blend:random(random(60))})
            end if
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top, rct.right, rct.top+1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top+1, rct.left+1, rct.bottom), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            
            
          end repeat
        end repeat
        
        copyPixelsToEffectColor("A", dp + 1, rect(mdPnt+point(-43,-53),mdPnt+point(43,53)), "largeSignGrad2", rect(0, 0, 86, 106), 1, 1.0)
        
      "Larger Sign B":
        -- put "BIG SIGN"
        img = image(80+6,100+6,1)
        rnd = random(14)
        rct = rect(3,3,83,103)
        img.copyPixels(member("largerSigns").image, rct, rect((rnd-1)*80, 0, rnd*80, 100), {#ink:36, #color:color(0,0, 0)})
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        mdPnt = giveMiddleOfTile(point(q,c))+point(10, 0)
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          repeat with d = 0 to 1 then
            member("layer" & string(dp + d)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt)+rect(r[1],r[1]), rect(0,0,86,106), {#ink:36, #color:r[2]})
          end repeat
        end repeat
        
        
        member("layer" & string(dp)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,255,255)})
        member("layer" & string(dp + 1)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(0,255,255)})
        
        member("largeSignGrad2").image.copyPixels(member("largeSignGrad").image, rect(0,0,80,100), rect(0,0,80,100))
        
        repeat with a = 0 to 6 then
          repeat with b = 0 to 13 then
            rct = rect((a*16)-6, (b*8)-1, ((a+1)*16)-6, ((b+1)*8)-1) --+ rect(0,0,-1,-1)
            if(random(7)=1)then
              blnd = random(random(100))
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(0,0,1,1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
            else if(random(7)=1)then
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(0, 0, 0), #blend:random(random(60))})
            end if
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top, rct.right, rct.top+1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top+1, rct.left+1, rct.bottom), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            
            
          end repeat
        end repeat
        
        copyPixelsToEffectColor("B", dp + 1, rect(mdPnt+point(-43,-53),mdPnt+point(43,53)), "largeSignGrad2", rect(0, 0, 86, 106), 1, 1.0)
        
      "Station Larger Sign":
        img = image(80+6,100+6,1)
        rnd = random(14)
        rct = rect(3,3,83,103)
        img.copyPixels(member("largerSignsStation").image, rct, rect((rnd-1)*80, 0, rnd*80, 100)+rect(0,1,0,1), {#ink:36, #color:color(0,0, 0)})
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        mdPnt = giveMiddleOfTile(point(q,c))+point(10, 0)
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          repeat with d = 0 to 1 then
            member("layer" & string(dp + d)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt)+rect(r[1],r[1]), rect(0,0,86,106), {#ink:36, #color:r[2]})
          end repeat
        end repeat
        
        member("layer" & string(dp)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,255,255)})
        member("layer" & string(dp + 1)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,0,255)})        
        member("largeSignGrad2").image.copyPixels(member("largeSignGrad").image, rect(0,0,80,100), rect(0,0,80,100))
        
        repeat with a = 0 to 6 then
          repeat with b = 0 to 13 then
            rct = rect((a*16)-6, (b*8)-1, ((a+1)*16)-6, ((b+1)*8)-1)
            if(random(7)=1)then
              blnd = random(random(100))
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(0,0,1,1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
            else if(random(7)=1)then
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(0, 0, 0), #blend:random(random(60))})
            end if
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top, rct.right, rct.top+1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top+1, rct.left+1, rct.bottom), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})    
          end repeat
        end repeat
        
        copyPixelsToEffectColor("A", dp + 1, rect(mdPnt+point(-43,-53),mdPnt+point(43,53)), "largeSignGrad2", rect(0, 0, 86, 106), 1, 1.0)
        
      "Station Larger Sign B":
        img = image(80+6,100+6,1)
        rnd = random(14)
        rct = rect(3,3,83,103)
        img.copyPixels(member("largerSignsStation").image, rct, rect((rnd-1)*80, 0, rnd*80, 100)+rect(0,1,0,1), {#ink:36, #color:color(0,0, 0)})
        
        if l = 1 then
          dp = 0
        else if l = 2 then
          dp = 10
        else
          dp = 20
        end if
        
        mdPnt = giveMiddleOfTile(point(q,c))+point(10, 0)
        
        repeat with r in [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)], [point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(2,2), color(0,255,0)]] then
          repeat with d = 0 to 1 then
            member("layer" & string(dp + d)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt)+rect(r[1],r[1]), rect(0,0,86,106), {#ink:36, #color:r[2]})
          end repeat
        end repeat   
        
        member("layer" & string(dp)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(255,255,255)})
        member("layer" & string(dp + 1)).image.copyPixels(img, rect(-43,-53,43,53)+rect(mdPnt,mdPnt), rect(0,0,86,106), {#ink:36, #color:color(0,255,255)})    
        member("largeSignGrad2").image.copyPixels(member("largeSignGrad").image, rect(0,0,80,100), rect(0,0,80,100))
        
        repeat with a = 0 to 6 then
          repeat with b = 0 to 13 then
            rct = rect((a*16)-6, (b*8)-1, ((a+1)*16)-6, ((b+1)*8)-1)
            if(random(7)=1)then
              blnd = random(random(100))
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(0,0,1,1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:blnd/2})
            else if(random(7)=1)then
              member("largeSignGrad2").image.copyPixels(member("pxl").image, rct+rect(1,1,0,0), rect(0,0,1,1), {#color:color(0, 0, 0), #blend:random(random(60))})
            end if
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top, rct.right, rct.top+1), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})
            member("largeSignGrad2").image.copyPixels(member("pxl").image, rect(rct.left, rct.top+1, rct.left+1, rct.bottom), rect(0,0,1,1), {#color:color(255, 255, 255), #blend:20})      
          end repeat
        end repeat
        
        copyPixelsToEffectColor("B", dp + 1, rect(mdPnt+point(-43,-53),mdPnt+point(43,53)), "largeSignGrad2", rect(0, 0, 86, 106), 1, 1.0)
        
      "Station Lamp": -- Dry does documentation during a 24 hr session :( On the bright side, it's documentation.
        -- Magic stuff
        img = image(40,20,1) --Single variation size (w(+buffer), h(+buffer), (???))
        rnd = random(1) -- Variations
        rct = rect(1,1,39,19) -- I don't know what this does
        img.copyPixels(member("StationLamp").image, img.rect, rect((rnd-1)*40, 0, rnd*40, 20), {#ink:36, #color:color(0,0, 0)}) -- Image thingy
        
        --lst = [[point(-4,-4), color(0,0,255)],[point(-3,-3), color(0,0,255)],[point(3,3), color(255,0,0)],[point(4,4), color(255,0,0)],[point(-2,-2), color(0,255,0)], [point(-1,-1), color(0,255,0)], [point(0,0), color(0,255,0)], [point(1,1), color(0,255,0)], [point(2,2), color(0,255,0)], [point(0,0), color(255,0,255)]]
        repeat with r in [[point(0,0), color(255,0,255)]] then --Creates the colour space
          frntImg.copyPixels(img, rect(-20,-10,20,10)+rect(giveMiddleOfTile(point(q,c))+point(11,1), giveMiddleOfTile(point(q,c))+point(11,1))+rect(r[1],r[1]), rect(0,0,40,20), {#ink:36, #color:r[2]})
        end repeat
        
        if l = 1 then
          dp = 1
        else if l = 2 then
          dp = 11
        else
          dp = 21
        end if
        
        mdPnt = giveMiddleOfTile(point(q,c))+point(11,1)
        copyPixelsToEffectColor("A", dp, rect(mdPnt+point(-20,-10),mdPnt+point(20,10)), "StationLampGradient", rect(0, 0, 40, 20), 1)
        
      "LumiaireH":
        
        if l = 1 then
          dp = 7
        else if l = 2 then
          dp = 17
        else
          dp = 27
        end if
        
        rct = rect(-29,-11,29,11)+rect(giveMiddleOfTile(point(q,c))+point(10,10), giveMiddleOfTile(point(q,c))+point(10,10))
        member("layer"&string(dp)).image.copyPixels(member("LumiaireH").image, rct, member("LumiaireH").image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(dp)).image.copyPixels(member("LumHGrad").image, rct, member("LumHGrad").image.rect, {#ink:39})
        
      "LumiaireV":
        
        if l = 1 then
          dp = 7
        else if l = 2 then
          dp = 17
        else
          dp = 27
        end if
        
        rct = rect(-11,-29,11,29)+rect(giveMiddleOfTile(point(q,c))+point(10,10), giveMiddleOfTile(point(q,c))+point(10,10))
        member("layer"&string(dp)).image.copyPixels(member("LumiaireV").image, rct, member("LumiaireV").image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(dp)).image.copyPixels(member("LumVGrad").image, rct, member("LumVGrad").image.rect, {#ink:39}) 
        
    end case
  end repeat
  
  
  
  return frntImg  
end


--on drawAShortCut(q, c, l, pltt, frntImg)
--  --  if l = 1 then
--  dp = 0
--  --  else
--  --    dp = 10
--  --  end if
--  
--  rct = rect(strt*20, (strt+tl.sz)*20)+rect(-20*tl.bfTiles, -20*tl.bfTiles, 20*tl.bfTiles, 20*tl.bfTiles)+rect(-20, -20, -20, -20)
--  gtRect = rect(0,0,(tl.sz.locH*20)+(40*tl.bfTiles), (tl.sz.locV*20)+(40*tl.bfTiles))
--  d = 0
--  repeat with ps = 1 to tl.repeatL.count then
--    repeat with ps2 = 1 to tl.repeatL[ps] then
--      -- gtRect =  + rect(0, (((tl.sz.locV*20)+(40*tl.bfTiles))-1)*d, 0, ((tl.sz.locV*20)+(40*tl.bfTiles))*d) 
--      member("layer"&string(d+dp)).image.copyPixels(tileImage, rct, gtRect + rect(0,gtRect.height*(ps-1), 0, gtRect.height*(ps-1))+rect(0,1,0,1), {#ink:36})
--      d = d + 1  
--    end repeat
--  end repeat
--end


on drawHorizontalSurface(row, dpt)
  -- if row < 10 then
  pnt1 = point(0, row*20)
  pnt2 = point(gLOprops.size.locH*20, row*20)
  
  repeat with q = 1 to 10 then
    dp = dpt + 10 - q
    -- pt1 = depthPnt(pnt1, dp-5)
    --  pt2 = depthPnt(pnt2, dp-5)
    member("layer"&string(dp)).image.copyPixels(member("horiImg").image, rect(pnt1+point(0,15), pnt2+point(0,20)), rect(pnt1, pnt2)+rect(0,20-q,0,21-q), {#ink:36})
    --member("layer"&string(dp)&"dc").image.copyPixels(member("horiDc").image, rect(pnt1+point(0,15), pnt2+point(0,20)), rect(pnt1, pnt2)+rect(0,20-q,0,21-q), {#ink:36})
    --member("gradientA"&string(dp)).image.copyPixels(member("horiGradA").image, rect(pnt1+point(0,15), pnt2+point(0,20)), rect(pnt1, pnt2)+rect(0,20-q,0,21-q), {#ink:36})
    --member("gradientB"&string(dp)).image.copyPixels(member("horiGradB").image, rect(pnt1+point(0,15), pnt2+point(0,20)), rect(pnt1, pnt2)+rect(0,20-q,0,21-q), {#ink:36})
  end repeat
  -- else
  pnt1 = point(0, (row-1)*20)
  pnt2 = point(gLOprops.size.locH*20, (row-1)*20)
  repeat with q = 1 to 10 then
    dp = dpt + 10 - q
    --   pt1 = depthPnt(pnt1, dp-5)
    -- pt2 = depthPnt(pnt2, dp-5)
    member("layer"&string(dp)).image.copyPixels(member("horiImg").image, rect(pnt1+point(0,0), pnt2+point(0,5)), rect(pnt1, pnt2)+rect(0,q,0,q+1), {#ink:36})
    --member("layer"&string(dp)&"dc").image.copyPixels(member("horiDc").image, rect(pnt1+point(0,0), pnt2+point(0,5)), rect(pnt1, pnt2)+rect(0,q,0,q+1), {#ink:36})
    --member("gradientA"&string(dp)).image.copyPixels(member("horiGradA").image, rect(pnt1+point(0,0), pnt2+point(0,5)), rect(pnt1, pnt2)+rect(0,q,0,q+1), {#ink:36})
    --member("gradientB"&string(dp)).image.copyPixels(member("horiGradB").image, rect(pnt1+point(0,0), pnt2+point(0,5)), rect(pnt1, pnt2)+rect(0,q,0,q+1), {#ink:36})
  end repeat
  --end if
end

on drawVerticalSurface(col, dpt)
  --if col < 26 then
  pnt1 = point(col*20, 0)
  pnt2 = point(col*20, gLOprops.size.locV*20)
  repeat with q = 1 to 10 then
    dp = dpt + 10 - q
    --   pt1 = depthPnt(pnt1, dp-5)
    --  pt2 = depthPnt(pnt2, dp-5)
    member("layer"&string(dp)).image.copyPixels(member("vertImg").image, rect(pnt1+point(15,0), pnt2+point(20,0)), rect(pnt1, pnt2)+rect(20-q,0,21-q,0), {#ink:36})
    --member("layer"&string(dp)&"dc").image.copyPixels(member("vertDc").image, rect(pnt1+point(15,0), pnt2+point(20,0)), rect(pnt1, pnt2)+rect(20-q,0,21-q,0), {#ink:36})
    --member("gradientA"&string(dp)).image.copyPixels(member("vertGradA").image, rect(pnt1+point(15,0), pnt2+point(20,0)), rect(pnt1, pnt2)+rect(20-q,0,21-q,0), {#ink:36})
    --member("gradientB"&string(dp)).image.copyPixels(member("vertGradB").image, rect(pnt1+point(15,0), pnt2+point(20,0)), rect(pnt1, pnt2)+rect(20-q,0,21-q,0), {#ink:36})
  end repeat
  --else
  pnt1 = point((col-1)*20, 0)
  pnt2 = point((col-1)*20, gLOprops.size.locV*20)
  repeat with q = 1 to 10 then
    dp = dpt + 10 - q
    --  pt1 = depthPnt(pnt1, dp-5)
    --  pt2 = depthPnt(pnt2, dp-5)
    member("layer"&string(dp)).image.copyPixels(member("vertImg").image, rect(pnt1+point(0,0), pnt2+point(5,0)), rect(pnt1, pnt2)+rect(q,0,q+1, 0), {#ink:36})
    --member("layer"&string(dp)&"dc").image.copyPixels(member("vertDc").image, rect(pnt1+point(0,0), pnt2+point(5,0)), rect(pnt1, pnt2)+rect(q,0,q+1, 0), {#ink:36})
    --member("gradientA"&string(dp)).image.copyPixels(member("vertGradA").image, rect(pnt1+point(0,0), pnt2+point(5,0)), rect(pnt1, pnt2)+rect(q,0,q+1, 0), {#ink:36})
    --member("gradientB"&string(dp)).image.copyPixels(member("vertGradB").image, rect(pnt1+point(0,0), pnt2+point(5,0)), rect(pnt1, pnt2)+rect(q,0,q+1, 0), {#ink:36})
  end repeat
  --end if
end







on giveDptFromCol(col)
  val = 255
  repeat with q = 0 to 19 then
    put val
    val = (val * 0.9).integer
  end repeat
end







on drawPipeTypeTile(mat, tl, layer)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  
  gtPos = point(0,0)
  case gLEProps.matrix[tl.locH][tl.locV][layer][1] of
    1:
      
      nbrs = ""
      repeat with dir in [point(-1,0),point(0,-1),point(1,0),point(0,1)]then
        --if afaMvLvlEdit(tl+dir, layer)=1 then
        if (random(2)=1)and(afaMvLvlEdit(tl+dir, layer)=1) then
          nbrs = nbrs & "1"
        else
          nbrs = nbrs & string(isMyTileSetOpenToThisTile(mat, tl+dir, layer))
        end if
        -- else
        --  nbrs = nbrs & "0"
        --end if
      end repeat
      
      --  put nbrs
      case nbrs of
        "0101":
          gtPos = point(2,2)
        "1010":
          gtPos = point(4,2)
        "1111":
          gtPos = point(6,2)
        "0111":
          gtPos = point(8,2)
        "1101":
          gtPos = point(10,2)
        "1110":
          gtPos = point(12,2)
        "1011":
          gtPos = point(14,2)
        "0011":
          gtPos = point(16,2)
        "1001":
          gtPos = point(18,2)
        "1100":
          gtPos = point(20,2)
        "0110":
          gtPos = point(22,2)
        "1000":
          gtPos = point(24,2)
        "0010":
          gtPos = point(26,2)
        "0100":
          gtPos = point(28,2)
        "0001":
          gtPos = point(30,2)
        "0000":
          if (gDRMatFixes) then
            gtPos = point(40,2)
          end if
          
      end case
      if mat = "small Pipes" then
        member("layer"&string( ((layer-1)*10)+5 )).image.copyPixels(member("frameWork").image, rect((tl.locH-1-gRenderCameraTilePos.locH)*20, (tl.locV-1-gRenderCameraTilePos.locV)*20, (tl.locH-gRenderCameraTilePos.locH)*20, (tl.locV-gRenderCameraTilePos.locV)*20), rect(0,0,20,20), {#ink:36})
      end if
      
    3:
      gtPos = point(32,2)
    2:
      gtPos = point(34,2)
    4:
      gtPos = point(36,2)
    5:
      gtPos = point(38,2)
    6:
      if (gDRMatFixes) then
        gtPos = point(42,2)   
      end if
    9:
      if (gDRMatFixes) then
        gtPos = point(44,2)
      end if
  end case
  
  case mat of 
    "small Pipes":
      mem = "pipeTiles2"
    "trash":
      mem = "trashTiles3"
    "largeTrash":
      mem = "largeTrashTiles"
    "megaTrash":
      mem = "largeTrashTiles"
    "dirt":
      mem = "dirtTiles"
    "Sandy Dirt":
      mem = "sandyDirtTiles"
  end case
  
  -- d = [2,11,21][layer]
  repeat with startLayer in [((layer-1)*10)+2, ((layer-1)*10)+7] then
    gtPos.locV = [2, 4, 6, 8][random(4)]
    rct = rect((gtPos.locH-1)*20, (gtPos.locV-1)*20, gtPos.locH*20, gtPos.locV*20)
    repeat with d = startLayer to startLayer + 1 then
      
      member("layer"&string(d)).image.copyPixels(member(mem).image, rect((tl.locH-1-gRenderCameraTilePos.locH)*20, (tl.locV-1-gRenderCameraTilePos.locV)*20, (tl.locH-gRenderCameraTilePos.locH)*20, (tl.locV-gRenderCameraTilePos.locV)*20)+rect(-10,-10,10,10), rct+rect(1,1,1,1)+rect(-10,-10,10,10), {#ink:36})
      --member("layer"&string(d)).image.copyPixels(member("pxl").image, rect((tl.locH-1)*20, (tl.locV-1)*20, tl.locH*20, tl.locV*20), rect(0,0,1,1))
    end repeat
  end repeat
  
  case mat of 
    "trash":
      if gLEProps.matrix[tl.locH][tl.locV][layer][1] <> 9  or (gDRMatFixes = FALSE) then
        repeat with q = 1 to 3 then
          d = [1,11,21][layer] + random(9)-1
          gt = random(48)
          gt = rect(50*(gt-1), 0, 50*gt, 50)+rect(1,1,1,1)
          rct = giveMiddleOfTile(tl-gRenderCameraTilePos) - point(11,11)+point(random(21), random(21))
          rct = rect(rct-point(25,25), rct+point(25,25))
          member("layer"&string(d)).image.copyPixels(member("assortedTrash").image, rotateToQuad(rct, random(360)), gt, {#color:[color(255,0,0), color(0,255,0), color(0,0,255)][random(3)], #ink:36})
        end repeat
      end if  
  end case
  
  
  the randomSeed = savSeed
end


on drawWVTypeTile(mat, tl, layer)
  pos = giveMiddleOfTile(tl - gRenderCameraTilePos)
  img = mat & "WVTile"
  xPos = (afaMvLvlEdit(tl, layer) - 1) * 20
  lr = (layer - 1) * 10
  repeat with d = 0 to 9
    rct = rect(xPos, d * 20, xPos + 20, (d + 1) * 20)
    member("layer" & string(lr + d)).image.copyPixels(member(img).image, rect(pos.locH - 10, pos.locV - 10, pos.locH + 10, pos.locV + 10), rct + rect(0, 1, 0, 1), {#ink:36})
  end repeat
end

--on drawWVTagTile(q, c, l, tl, frntImg, effectColorA, effectColorB, colored, sav2)
--  strt = point(q, c)
--  tlt = 7
--  case afaMvLvlEdit(strt, l) of
--    1:
--      tlt = 1
--    2:
--      tlt = 3
--    3:
--      tlt = 2
--    4:
--      tlt = 4
--    5:
--      tlt = 5
--    6:
--      tlt = 6
--  end case
--  tsz = point(1, 1)
--  if (l = 1) then
--    dp = 0
--  else if (l = 2) then
--    dp = 10
--  else
--    dp = 20
--  end if 
--  rct = rect(strt * 20, (strt + tsz) * 20) + rect(-20 * tl.bfTiles, -20 * tl.bfTiles, 20 * tl.bfTiles, 20 * tl.bfTiles) + rect(-20, -20, -20, -20)
--  gtRect = rect(0, 0, 20 + (40 * tl.bfTiles), 20 + (40 * tl.bfTiles))
--  rnd = tlt + 7 * (random(tl.rnd) - 1)
--  --frntImg.copyPixels(tileImage, rct, gtRect + rect(gtRect.width * (rnd - 1), 0, gtRect.width * (rnd - 1), 0) + rect(0, 1, 0, 1), {#ink:36})
--  d = -1
--  timg = tileImage
--  repeat with ps = 1 to tl.repeatL.count
--    trct = gtRect + rect(gtRect.width * (rnd - 1), gtRect.height * (ps - 1), gtRect.width * (rnd - 1), gtRect.height * (ps - 1)) + rect(1, 1, 1, 1)
--    repeat with ps2 = 1 to tl.repeatL[ps]
--      d = d + 1
--      if (d + dp > 29) then
--        exit repeat
--      else
--        tlr = string(d + dp)
--        member("layer" & tlr).image.copyPixels(timg, rct, trct, {#ink:36})
--        if (colored) then
--          if (effectColorA = 0) and (effectColorB = 0) then
--            member("layer" & tlr & "dc").image.copyPixels(timg, rct, trct + rect((20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0, (20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0), {#ink:36})
--          end if
--        end if  
--        if (effectColorA) then
--          member("gradientA" & tlr).image.copyPixels(timg, rct, trct + rect((20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0, (20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0), {#ink:39})
--        end if
--        if (effectColorB) then
--          member("gradientB" & tlr).image.copyPixels(timg, rct, trct + rect((20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0, (20 + (40 * tl.bfTiles)) * 7 * tl.rnd, 0), {#ink:39})
--        end if
--      end if
--    end repeat
--  end repeat
--end


on drawRockTypeTile(mat, tl, layer, trBool)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  gtPos = point(0,0)
  case gLEProps.matrix[tl.locH][tl.locV][layer][1] of
    1:
      
      nbrs = ""
      repeat with dir in [point(-1,0),point(0,-1),point(1,0),point(0,1)]then
        --if afaMvLvlEdit(tl+dir, layer)=1 then
        if (random(2)=1)and(afaMvLvlEdit(tl+dir, layer)=1) then
          nbrs = nbrs & "1"
        else
          nbrs = nbrs & string(isMyTileSetOpenToThisTile(mat, tl+dir, layer))
        end if
      end repeat
      
      case nbrs of
        "0101":
          gtPos = point(2,2)
        "1010":
          gtPos = point(4,2)
        "1111":
          gtPos = point(6,2)
        "0111":
          gtPos = point(8,2)
        "1101":
          gtPos = point(10,2)
        "1110":
          gtPos = point(12,2)
        "1011":
          gtPos = point(14,2)
        "0011":
          gtPos = point(16,2)
        "1001":
          gtPos = point(18,2)
        "1100":
          gtPos = point(20,2)
        "0110":
          gtPos = point(22,2)
        "1000":
          gtPos = point(24,2)
        "0010":
          gtPos = point(26,2)
        "0100":
          gtPos = point(28,2)
        "0001":
          gtPos = point(30,2)
        "0000":
          gtPos = point(40,2)
      end case
      
    3:
      gtPos = point(32,2)
    2:
      gtPos = point(34,2)
    4:
      gtPos = point(36,2)
    5:
      gtPos = point(38,2)
    6:
      gtPos = point(42,2)   
    9:
      gtPos = point(44,2)
  end case
  
  case mat of 
    "Rocks":
      mem = "rockTiles"
  end case
  
  d = (layer-1)*10
  gtPos.locV = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32][random(16)]
  rct = rect((gtPos.locH-1)*20, (gtPos.locV-1)*20, gtPos.locH*20, gtPos.locV*20)
  if (trBool) then
    repeat with rg = 1 to 4 then
      member("layer"&string(d+rg)).image.copyPixels(member(mem).image, rect((tl.locH-1-gRenderCameraTilePos.locH)*20, (tl.locV-1-gRenderCameraTilePos.locV)*20, (tl.locH-gRenderCameraTilePos.locH)*20, (tl.locV-gRenderCameraTilePos.locV)*20)+rect(-10,-10,10,10), rct+rect(1,1,1,1)+rect(-10,-10,10,10), {#ink:36})
    end repeat
  else
    repeat with rg = 0 to 4 then
      member("layer"&string(d+rg)).image.copyPixels(member(mem).image, rect((tl.locH-1-gRenderCameraTilePos.locH)*20, (tl.locV-1-gRenderCameraTilePos.locV)*20, (tl.locH-gRenderCameraTilePos.locH)*20, (tl.locV-gRenderCameraTilePos.locV)*20)+rect(-10,-10,10,10), rct+rect(1,1,1,1)+rect(-10,-10,10,10), {#ink:36})
    end repeat
  end if
  gtPos.locV = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32][random(16)]
  rct = rect((gtPos.locH-1)*20, (gtPos.locV-1)*20, gtPos.locH*20, gtPos.locV*20)
  repeat with rd = 5 to 9 then
    member("layer"&string(d+rd)).image.copyPixels(member(mem).image, rect((tl.locH-1-gRenderCameraTilePos.locH)*20, (tl.locV-1-gRenderCameraTilePos.locV)*20, (tl.locH-gRenderCameraTilePos.locH)*20, (tl.locV-gRenderCameraTilePos.locV)*20)+rect(-10,-10,10,10), rct+rect(1,1,1,1)+rect(-10,-10,10,10), {#ink:36})
  end repeat
  the randomSeed = savSeed
end


on drawLargeTrashTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  distanceToAir = -1
  repeat with dist = 1 to 5 then
    repeat with dir in [point(-1,0),point(0,-1),point(1,0),point(0,1)]then
      if(afaMvLvlEdit(tl+dir*dist, layer)<>1)then
        distanceToAir = dist
        exit repeat
      end if
    end repeat
    if(distanceToAir <> -1) then
      exit repeat
    end if
  end repeat
  
  
  if(distanceToAir = -1)then
    distanceToAir = 5
  end if
  
  if(distanceToAir < 5)then
    drawPipeTypeTile("trash", tl, layer)
  end if
  
  
  --  pos = 
  type pos: point
  
  if(distanceToAir < 3)then
    global gTrashPropOptions, gProps
    
    repeat with q = 1 to distanceToAir + random(2) - 1 then
      dp = restrict(((layer - 1)*10) + random(random(10))-1+random(3), 0, 29)
      
      
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
      pos = pos + point(-11+random(21), -11+random(21))
      
      if (gTrashPropOptions.count <> 0)then
        propAddress = gTrashPropOptions[random(gTrashPropOptions.count)]
        prop = gProps[propAddress.locH].prps[propAddress.locV]
        
        rct = rect(pos, pos) + rect(-prop.sz.locH*10,-prop.sz.locV*10,prop.sz.locH*10, prop.sz.locV*10)
        
        gRenderTrashProps.add([-dp, prop.nm, propAddress, rotateToQuad(rct, random(360)), [#settings:[#renderTime:0, #seed:random(1000)]]])
      end if
    end repeat
  end if
  
  if(distanceToAir > 2)then
    dp = ((layer - 1)*10)
    pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
    
    if(random(5) <= distanceToAir)then
      member("layer"&string(dp)).image.copyPixels(member("pxl").image, rect(pos.locH-10,pos.locV-10,pos.locH+10,pos.locV+10), rect(0,0,1,1), {#color:color(255,0,0)})
      var = random(14)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      frntImg.copyPixels(member("bigJunk").image, rotateToQuad(rct, random(360)), rect((var-1)*60, 0, var*60, 60)+rect(0,1,0,1), {#ink:36})
    end if
    
    repeat with q = 1 to distanceToAir then
      dp = ((layer - 1)*10) + random(10)-1
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
      var = random(14)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      member("layer"&string(dp)).image.copyPixels(member("bigJunk").image, rotateToQuad(rct, random(360)), rect((var-1)*60, 0, var*60, 60)+rect(0,1,0,1), {#ink:36})
    end repeat
    
  end if
  
  the randomSeed = savSeed
  
  
end

on drawRoughRockTile(mat, tl, layer, frntImg)
  imgR = "Not Found"
  szR = 0
  intOp = 1
  case mat of
    "Rough Rock":
      imgR = "roughRock"
      szR = 60
      intOp = 6
    "Sandy Dirt":
      szR = 20
      imgR = "sandRR"
      intOp = 2
  end case
  
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  distanceToAir = -1
  repeat with dist = 1 to 5 then
    repeat with dir in [point(-1,0),point(0,-1),point(1,0),point(0,1)]then
      if(afaMvLvlEdit(tl+dir*dist, layer)<>1)then
        distanceToAir = dist
        exit repeat
      end if
    end repeat
    if(distanceToAir <> -1) then
      exit repeat
    end if
  end repeat  
  
  if(distanceToAir = -1)then
    distanceToAir = 5
  end if
  
  if (gRRSpreadsMore) then
    distanceToAir = distanceToAir + 1
  end if
  
  if(distanceToAir < 5)then
    case mat of
      "Rough Rock":
        drawRockTypeTile("Rocks", tl, layer, TRUE)
      "Sandy Dirt":
        drawPipeTypeTile("Sandy Dirt", tl, layer)
        distanceToAir = distanceToAir + 1
    end case
  end if
  
  if(distanceToAir > 2)then
    dp = ((layer - 1)*10)
    pos = giveMiddleOfTile(tl-gRenderCameraTilePos) 
    if(random(5) <= distanceToAir)then
      member("layer"&string(dp)).image.copyPixels(member("pxl").image, rect(pos.locH-10,pos.locV-10,pos.locH+10,pos.locV+10), rect(0,0,1,1), {#color:color(255,0,0)})
      var = random(intOp)
      fat = [1,1.05,1.1][random(3)]
      rct = rect(pos, pos) + rect(-szR*fat, -szR*fat, szR*fat, szR*fat)
      frntImg.copyPixels(member(imgR).image, rotateToQuad(rct, random(360)), rect((var-1)*szR*2, 0, var*szR*2, szR*2)+rect(0,1,0,1), {#ink:36})
    end if
    dp = ((layer - 1)*10)
    pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
    var = random(intOp)
    fat = [1,1.05,1.1][random(3)]
    rct = rect(pos, pos) + rect(-szR*fat, -szR*fat, szR*fat, szR*fat)
    member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(360)), rect((var-1)*szR*2, 0, var*szR*2, szR*2)+rect(0,1,0,1), {#ink:36})
    repeat with q = 1 to distanceToAir then
      dp = ((layer - 1)*10) + random(10)-1
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
      var = random(intOp)
      fat = [1,1.05,1.1][random(3)]
      rct = rect(pos, pos) + rect(-szR*fat, -szR*fat, szR*fat, szR*fat)
      member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(360)), rect((var-1)*szR*2, 0, var*szR*2, szR*2)+rect(0,1,0,1), {#ink:36})
    end repeat
    
    if mat = "Sandy Dirt" and random(2) = 1 then
      dp = ((layer - 1)*10)
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
      if(random(5) <= distanceToAir)then
        member("layer"&string(dp)).image.copyPixels(member("pxl").image, rect(pos.locH-10,pos.locV-10,pos.locH+10,pos.locV+10), rect(0,0,1,1), {#color:color(255,0,0)})
        var = random(intOp)
        fat = [1,1.05,1.1][random(3)]
        rct = rect(pos, pos) + rect(-szR*fat, -szR*fat, szR*fat, szR*fat)
        frntImg.copyPixels(member(imgR).image, rotateToQuad(rct, random(360)), rect((var-1)*szR*2, 0, var*szR*2, szR*2)+rect(0,1,0,1), {#ink:36})
      end if   
      repeat with q = 1 to distanceToAir then
        dp = ((layer - 1)*10) + random(10)-1
        pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
        var = random(intOp)
        fat = [1,1.05,1.1][random(3)]
        rct = rect(pos, pos) + rect(-szR*fat, -szR*fat, szR*fat, szR*fat)
        member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(360)), rect((var-1)*szR*2, 0, var*szR*2, szR*2)+rect(0,1,0,1), {#ink:36})
      end repeat
    end if
  end if
  
  the randomSeed = savSeed
end

on drawSandyTypeTile(mat, tl, layer, frntImg, vars, szList, hAddList, slopeSz)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  imgR = mat & "STile"
  block = afaMvLvlEdit(tl, layer)
  if (block = 1) then
    distanceToAir = -1
    repeat with dist = 1 to 5
      repeat with dir in [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)]
        if (afaMvLvlEdit(tl + dir * dist, layer) <> 1) then
          distanceToAir = dist
          exit repeat
        end if
      end repeat
      if (distanceToAir <> -1) then
        exit repeat
      end if
    end repeat  
    if (distanceToAir = -1) then
      distanceToAir = 5
    end if
    fatFac = 1
    if (distanceToAir < 5) then
      fatFac = 2
    else  if (distanceToAir < 4) then
      fatFac = 3
    else if (distanceToAir < 3) then
      fatFac = 4
    else if (distanceToAir < 2) then
      fatFac = 5
    end if
    repeat with rep = 1 to fatFac + 4
      dp = ((layer - 1) * 10)
      pos = giveMiddleOfTile(tl - gRenderCameraTilePos) 
      if (random(5) <= distanceToAir) then
        var = random(vars)
        fatSide = szList[fatFac]
        fatAdd = hAddList[fatFac]
        halfSide = fatSide / 2
        rct = rect(pos, pos) + rect(-halfSide, -halfSide, halfSide, halfSide)
        frntImg.copyPixels(member(imgR).image, rotateToQuad(rct, random(45) - random(45)), rect(fatSide * (var - 1), fatAdd, fatSide * var, fatAdd + fatSide) + rect(0, 1, 0, 1), {#ink:36})
      end if
      repeat with q = 1 to distanceToAir then
        dp = ((layer - 1) * 10) + random(10) - 1
        fatD = fatFac * 3
        fatDD = fatD * 2 - 1
        pos = giveMiddleOfTile(tl - gRenderCameraTilePos) + point(-fatD + random(fatDD), -fatD + random(fatDD))
        var = random(vars)
        fatSide = szList[fatFac]
        fatAdd = hAddList[fatFac]
        halfSide = fatSide / 2
        rct = rect(pos, pos) + rect(-halfSide, -halfSide, halfSide, halfSide)
        member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(45) - random(45)), rect(fatSide * (var - 1), fatAdd, fatSide * var, fatAdd + fatSide) + rect(0, 1, 0, 1), {#ink:36})
      end repeat
    end repeat
  else if (block = 6) then
    lr = (layer - 1) * 10
    repeat with rep = 1 to szList.count + 2
      repeat with dp = lr + 5 to lr + 9
        ptAdd = point(random(8) - random(8), -10)
        pos = giveMiddleOfTile(tl - gRenderCameraTilePos) + point(-2 + random(3), -2 + random(3)) + ptAdd
        var = random(vars)
        rn = random(2)
        fatSide = szList[[szList.count, szList.count - 1][rn]]
        fatAdd = hAddList[[hAddList.count, hAddList.count - 1][rn]]
        halfSide = fatSide / 2
        rct = rect(pos, pos) + rect(-halfSide, -halfSide, halfSide, halfSide)
        member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(10) - random(10)), rect(fatSide * (var - 1), fatAdd, fatSide * var, fatAdd + fatSide) + rect(0, 1, 0, 1), {#ink:36})
      end repeat
    end repeat
  else if (block = 2 or 3 or 4 or 5) then
    lr = (layer - 1) * 10
    repeat with dp = lr to lr + 9
      ptAdd = point(0, 0)
      case block of
        2:
          ptAdd = point(-4, 4)
        3:
          ptAdd = point(4, 4)
        4:
          ptAdd = point(-4, -4)
        5:
          ptAdd = point(4, -4)
      end case
      pos = giveMiddleOfTile(tl - gRenderCameraTilePos) + point(-2 + random(3), -2 + random(3)) + ptAdd
      var = block - 1
      fatAdd = hAddList[hAddList.count] + szList[szList.count]
      halfSide = slopeSz / 2
      rct = rect(pos, pos) + rect(-halfSide, -halfSide, halfSide, halfSide)
      member("layer"&string(dp)).image.copyPixels(member(imgR).image, rotateToQuad(rct, random(10) - random(10)), rect(slopeSz * (var - 1), fatAdd, slopeSz * var, fatAdd + slopeSz) + rect(0, 1, 0, 1), {#ink:36})
    end repeat
  end if
  the randomSeed = savSeed
end


on drawMegaTrashTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  distanceToAir = -1
  repeat with dist = 1 to 5 then
    repeat with dir in [point(-1,0),point(0,-1),point(1,0),point(0,1)]then
      if(afaMvLvlEdit(tl+dir*dist, layer)<>1)then
        distanceToAir = dist
        exit repeat
      end if
    end repeat
    if(distanceToAir <> -1) then
      exit repeat
    end if
  end repeat
  
  if(distanceToAir = -1)then
    distanceToAir = 5
  end if
  
  if(distanceToAir < 5)then
    drawPipeTypeTile("trash", tl, layer)
  end if
  
  if(distanceToAir < 3)then
    global gMegaTrash, gProps   
    repeat with q = 1 to distanceToAir + random(2) - 1 then
      dp = restrict(((layer - 1)*10) + random(random(10))-1+random(3), 0, 29)
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
      pos = pos + point(-11+random(21), -11+random(21))
      
      if (gMegaTrash.count <> 0)then
        propAddress = gMegaTrash[random(gMegaTrash.count)]
        prop = gProps[propAddress.locH].prps[propAddress.locV]      
        rct = rect(pos, pos) + rect(-prop.sz.locH*10,-prop.sz.locV*10,prop.sz.locH*10, prop.sz.locV*10)      
        gRenderTrashProps.add([-dp, prop.nm, propAddress, rotateToQuad(rct, random(360)), [#settings:[#renderTime:0, #seed:random(1000)]]])
      end if
    end repeat
  end if
  
  if(distanceToAir > 2)then
    dp = ((layer - 1)*10)
    pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
    
    if(random(5) <= distanceToAir)then
      member("layer"&string(dp)).image.copyPixels(member("pxl").image, rect(pos.locH-10,pos.locV-10,pos.locH+10,pos.locV+10), rect(0,0,1,1), {#color:color(255,0,0)})
      var = random(14)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      frntImg.copyPixels(member("bigJunk").image, rotateToQuad(rct, random(360)), rect((var-1)*60, 0, var*60, 60)+rect(0,1,0,1), {#ink:36})
    end if
    
    repeat with q = 1 to distanceToAir then
      dp = ((layer - 1)*10) + random(10)-1
      pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
      var = random(14)
      rct = rect(pos, pos) + rect(-30, -30, 30, 30)
      member("layer"&string(dp)).image.copyPixels(member("bigJunk").image, rotateToQuad(rct, random(360)), rect((var-1)*60, 0, var*60, 60)+rect(0,1,0,1), {#ink:36})
    end repeat
  end if
  
  the randomSeed = savSeed
end

on drawDirtTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  dp = ((layer - 1)*10)
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  
  optOut = false
  if(layer > 1)then
    optOut = (afaMvLvlEdit(tl, layer-1)=1)
  end if
  
  if(optOut)then
    member("layer"&string(((layer - 1)*10))).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-14, -14, 14, 14), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
    var = random(4)
    rct = rect(pos, pos) + rect(-18, -18, 18, 18)
    member("layer"&string(dp)).image.copyPixels(member("rubbleGraf" & var).image, rotateToQuad(rct, random(360)), member("rubbleGraf" & var).image.rect, {#ink:36, #color:color(0, 255, 0)})
  else
    
    distanceToAir = 6
    ext = 0
    repeat with dist = 1 to 5 then
      repeat with dir in [point(-1,0),point(-1,-1),point(0,-1),point(1,-1),point(1,0),point(1,1),point(0,1),point(-1,1)]then
        if(afaMvLvlEdit(tl+dir*dist, layer)<>1)then
          distanceToAir = dist
          ext = 1
          exit repeat
        end if
      end repeat
      if(ext) then
        exit repeat
      end if
    end repeat
    
    distanceToAir = distanceToAir + -2 + random(3)
    
    
    
    if(distanceToAir >= 5)then
      member("layer"&string(((layer - 1)*10))).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-14, -14, 14, 14), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
      var = random(4)
      rct = rect(pos, pos) + rect(-18, -18, 18, 18)
      member("layer"&string(dp)).image.copyPixels(member("rubbleGraf" & var).image, rotateToQuad(rct, random(360)), member("rubbleGraf" & var).image.rect, {#ink:36, #color:color(0, 255, 0)})
    else
      amnt = lerp(distanceToAir, 3, 0.5)*15
      if(layer > 1)then
        amnt = distanceToAir*10
      end if
      repeat with q = 1 to amnt then
        dp = ((layer - 1)*10) + random(10)-1
        pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21))
        var = random(4)
        drawDirtClot(pos, dp, var, layer, distanceToAir)
      end repeat
      if(layer < 3) then
        repeat with dist = 1 to 3 then
          repeat with dir in [point(-1,0),point(-1,-1),point(0,-1),point(1,-1),point(1,0),point(1,1),point(0,1),point(-1,1)]then
            if(afaMvLvlEdit(tl+dir*dist, layer+1)=1)and(afaMvLvlEdit(tl+dir*dist, layer)<>1)then
              repeat with q = 1 to 10 then
                if(layer = 1)then
                  dpAdd = 6+random(4)
                else
                  dpAdd = 2+random(8)
                end if
                pos = giveMiddleOfTile(tl-gRenderCameraTilePos) + point(-11+random(21), -11+random(21)) + dir * dist * dist * dpAdd * random(85) * 0.01
                var = random(4)
                drawDirtClot(pos, ((layer - 1)*10) + dpAdd, var, layer, distanceToAir)
              end repeat
            end if
          end repeat
        end repeat
      end if
    end if
    
  end if
  
  the randomSeed = savSeed
end


on drawDirtClot(pos, dp, var, layer, distanceToAir)
  szAdd = (random(distanceToAir+1)-1)
  
  repeat with d = 0 to 2 then
    sz = 5 + szAdd + d*2
    pstDp = restrict(dp-1+d, 0, 29)
    rct = rect(pos, pos) + rect(-sz, -sz, sz, sz)
    member("layer"&string(pstDp)).image.copyPixels(member("rubbleGraf" & var).image, rotateToQuad(rct, random(360)), member("rubbleGraf" & var).image.rect, {#ink:36, #color:color(0, 255, 0)})
  end repeat
  
  
  
  -- pos2 = giveGridPos(pos + point(-10, -10))
  if((random(6)>distanceToAir)and(random(3)=1))or((afaMvLvlEdit(giveGridPos(pos + point(-10, -10))+gRenderCameraTilePos, layer)<>1)and((afaMvLvlEdit(giveGridPos(pos + point(10, 10))+gRenderCameraTilePos, layer)=1)) or (layer = 2))then
    repeat with d = 0 to 2 then
      sz = 2 + (szAdd*0.5) + d*2
      pstDp = restrict(dp-1+d, 0, 29)
      rct = rect(pos, pos) + rect(-sz, -sz, sz, sz) + rect(point(-4,-4)+point(-2*d, -2*d), point(-4,-4)+point(-2*d, -2*d))
      member("layer"&string(pstDp)).image.copyPixels(member("rubbleGraf" & var).image, rotateToQuad(rct, random(360)), member("rubbleGraf" & var).image.rect, {#ink:36, #color:color(0, 0, 255)})
    end repeat
  end if
  
  if((random(6)>distanceToAir)and(random(3)=1))or((afaMvLvlEdit(giveGridPos(pos + point(10, 10))+gRenderCameraTilePos, layer)<>1)and((afaMvLvlEdit(giveGridPos(pos + point(-10, -10))+gRenderCameraTilePos, layer)=1)) or (layer = 2))then
    repeat with d = 0 to 2 then
      sz = 2 + (szAdd*0.5) + d*2
      pstDp = restrict(dp-1+d, 0, 29)
      rct = rect(pos, pos) + rect(-sz, -sz, sz, sz) + rect(point(4,4)+point(2*d, 2*d), point(4,4)+point(2*d, 2*d))
      member("layer"&string(pstDp)).image.copyPixels(member("rubbleGraf" & var).image, rotateToQuad(rct, random(360)), member("rubbleGraf" & var).image.rect, {#ink:36, #color:color(255, 0, 0)})
    end repeat
  end if
end

on drawCeramicTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops, gEEprops, gAnyDecals
  
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  chaos = 0
  doColor = 0
  
  repeat with q = 1 to gEEprops.effects.count then
    if(gEEprops.effects[q].nm = "Ceramic Chaos")then
      case gEEprops.effects[q].options[3][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
        "1":
          dmin = 1
          dmax = 1
        "2":
          dmin = 2
          dmax = 2
        "3":
          dmin = 3
          dmax = 3
        "1:st and 2:nd":
          dmin = 1
          dmax = 2
        "2:nd and 3:rd":
          dmin = 2
          dmax = 3
        otherwise:
          dmin = 1
          dmax = 3
      end case
      if (layer >= dmin) and (layer <= dmax) then
        if(gEEprops.effects[q].mtrx[tl.loch][tl.locv] > chaos)then
          chaos = gEEprops.effects[q].mtrx[tl.loch][tl.locv]
        end if
      end if
      if(gEEprops.effects[q].Options[2][3] = "Colored")then
        doColor = true
      end if
    end if
  end repeat
  
  if(doColor)then
    gAnyDecals = true
  end if
  
  chaos = chaos * 0.01
  
  dp = ((layer - 1)*10)
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  clr = color(239, 234, 224)
  
  
  lft = 0
  rght = 0
  tp = 0
  bttm = 0
  if(afaMvLvlEdit(tl+point(-1,0), layer)<>1) and ((gDRMatFixes = FALSE) or ((afaMvLvlEdit(tl+point(-1,0), layer)<>2) and (afaMvLvlEdit(tl+point(-1,0), layer)<>3) and (afaMvLvlEdit(tl+point(-1,0), layer)<>4) and (afaMvLvlEdit(tl+point(-1,0), layer)<>5) and (afaMvLvlEdit(tl+point(-1,0), layer)<>6))) then
    lft = 1
  end if
  if(afaMvLvlEdit(tl+point(1,0), layer)<>1) and ((gDRMatFixes = FALSE) or ((afaMvLvlEdit(tl+point(1,0), layer)<>2) and (afaMvLvlEdit(tl+point(1,0), layer)<>3) and (afaMvLvlEdit(tl+point(1,0), layer)<>4) and (afaMvLvlEdit(tl+point(1,0), layer)<>5) and (afaMvLvlEdit(tl+point(1,0), layer)<>6))) then
    rght = 1
  end if
  if(afaMvLvlEdit(tl+point(0,-1), layer)<>1) and ((gDRMatFixes = FALSE) or ((afaMvLvlEdit(tl+point(0,-1), layer)<>2) and (afaMvLvlEdit(tl+point(0,-1), layer)<>3) and (afaMvLvlEdit(tl+point(0,-1), layer)<>4) and (afaMvLvlEdit(tl+point(0,-1), layer)<>5) and (afaMvLvlEdit(tl+point(0,-1), layer)<>6))) then
    tp = 1
  end if
  if(afaMvLvlEdit(tl+point(0,1), layer)<>1) and ((gDRMatFixes = FALSE) or ((afaMvLvlEdit(tl+point(0,1), layer)<>2) and (afaMvLvlEdit(tl+point(0,1), layer)<>3) and (afaMvLvlEdit(tl+point(0,1), layer)<>4) and (afaMvLvlEdit(tl+point(0,1), layer)<>5) and (afaMvLvlEdit(tl+point(0,1), layer)<>6))) then
    bttm = 1
  end if
  
  h = afaMvLvlEdit(tl, layer)
  case h of
    1:
      h2 = ""
    2:
      h2 = "NE"
    3:
      h2 = "NW"
    4:
      h2 = "SE"
    5:
      h2 = "SW"
  end case
  
  if (h = 1) or (h = 2) or (h = 3) or (h = 4) or (h = 5)then
    if (h = 1) then
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), rect(0,0,1,1), {#ink:36, #color:color(255*(1-doColor), 255*doColor, 0)})
      end repeat
    else
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCP"&h2).image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(255*(1-doColor), 255*doColor, 0)})
      end repeat
    end if
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocket"&h2).image, rect(pos,pos)+rect(-8, -8, 8, 8), member("ceramicTileSocket"&h2).image.rect, {#ink:36, #color:color(255*doColor, 255*(1-doColor), 0)})
    
    if (h = 1) or (h = 2) or (h = 4)then
      if(lft)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
          if(doColor)then
            member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:36, #color:clr})
          end if
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 3) or (h = 5)then
      if(rght)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
          if(doColor)then
            member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:36, #color:clr})
          end if
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 4) or (h = 5)then
      if(tp)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
          if(doColor)then
            member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:clr})
          end if
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 2) or (h = 3)then
      if(bttm)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, -8, 11), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
          if(doColor)then
            member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:36, #color:clr})
          end if
        end repeat
      end if
    end if
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTile"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTile"&h2).image.rect, {#ink:36})
        if(doColor)then
          member("layer"&string(((layer - 1)*10))&"dc").image.copyPixels(member("ceramicTileSilh"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:clr})
        end if
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTile"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTile"&h2).image.rect, {#ink:36})
        if(doColor)then
          member("layer"&string(((layer - 1)*10))&"dc").image.copyPixels(member("ceramicTileSilh"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:clr})
        end if
      end if
    end if
    
    the randomSeed = savSeed
    
  else if (h = 6) then
    repeat with q = 1 to 9 then
      member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCPFL").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, (10-bttm)/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(255*(1-doColor), 255*doColor, 0)})
    end repeat
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocketFL").image, rect(pos,pos)+rect(-8, -8, 8, 8/2), member("ceramicTileSocketFL").image.rect, {#ink:36, #color:color(255*doColor, 255*(1-doColor), 0)})
    
    
    if(lft)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
        if(doColor)then
          member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:36, #color:clr})
        end if
      end repeat
    end if
    
    if(rght)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
        if(doColor)then
          member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:36, #color:clr})
        end if
      end repeat
    end if
    
    if(tp)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 0, 255)})
        if(doColor)then
          member("layer"&string(((layer - 1)*10)+q)&"dc").image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:clr})
        end if
      end repeat
    end if
    
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileFL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileFL").image.rect, {#ink:36})
        if(doColor)then
          member("layer"&string(((layer - 1)*10))&"dc").image.copyPixels(member("ceramicTileSilhFL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:clr})
        end if
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileFL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileFL").image.rect, {#ink:36})
        if(doColor)then
          member("layer"&string(((layer - 1)*10))&"dc").image.copyPixels(member("ceramicTileSilhFL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:clr})
        end if
      end if
    end if
    
    the randomSeed = savSeed
  end if
end


on drawCeramicATypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops, gEEprops, gAnyDecals
  
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  chaos = 0
  
  repeat with q = 1 to gEEprops.effects.count then
    if(gEEprops.effects[q].nm = "Ceramic Chaos")then
      case gEEprops.effects[q].options[3][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
        "1":
          dmin = 1
          dmax = 1
        "2":
          dmin = 2
          dmax = 2
        "3":
          dmin = 3
          dmax = 3
        "1:st and 2:nd":
          dmin = 1
          dmax = 2
        "2:nd and 3:rd":
          dmin = 2
          dmax = 3
        otherwise:
          dmin = 1
          dmax = 3
      end case
      if (layer >= dmin) and (layer <= dmax) then
        if(gEEprops.effects[q].mtrx[tl.loch][tl.locv] > chaos)then
          chaos = gEEprops.effects[q].mtrx[tl.loch][tl.locv]
        end if
      end if
    end if
  end repeat
  
  --gAnyDecals = true
  
  chaos = chaos * 0.01
  
  dp = ((layer - 1)*10)
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  clr = color(239, 234, 224)
  
  
  lft = 0
  rght = 0
  tp = 0
  bttm = 0
  if(afaMvLvlEdit(tl+point(-1,0), layer)<>1) and (afaMvLvlEdit(tl+point(-1,0), layer)<>2) and (afaMvLvlEdit(tl+point(-1,0), layer)<>3) and (afaMvLvlEdit(tl+point(-1,0), layer)<>4) and (afaMvLvlEdit(tl+point(-1,0), layer)<>5) and (afaMvLvlEdit(tl+point(-1,0), layer)<>6)then
    lft = 1
  end if
  if(afaMvLvlEdit(tl+point(1,0), layer)<>1) and (afaMvLvlEdit(tl+point(1,0), layer)<>2) and (afaMvLvlEdit(tl+point(1,0), layer)<>3) and (afaMvLvlEdit(tl+point(1,0), layer)<>4) and (afaMvLvlEdit(tl+point(1,0), layer)<>5) and (afaMvLvlEdit(tl+point(1,0), layer)<>6)then
    rght = 1
  end if
  if(afaMvLvlEdit(tl+point(0,-1), layer)<>1) and (afaMvLvlEdit(tl+point(0,-1), layer)<>2) and (afaMvLvlEdit(tl+point(0,-1), layer)<>3) and (afaMvLvlEdit(tl+point(0,-1), layer)<>4) and (afaMvLvlEdit(tl+point(0,-1), layer)<>5) and (afaMvLvlEdit(tl+point(0,-1), layer)<>6)then
    tp = 1
  end if
  if(afaMvLvlEdit(tl+point(0,1), layer)<>1) and (afaMvLvlEdit(tl+point(0,1), layer)<>2) and (afaMvLvlEdit(tl+point(0,1), layer)<>3) and (afaMvLvlEdit(tl+point(0,1), layer)<>4) and (afaMvLvlEdit(tl+point(0,1), layer)<>5) and (afaMvLvlEdit(tl+point(0,1), layer)<>6)then
    bttm = 1
  end if
  
  h = afaMvLvlEdit(tl, layer)
  case h of
    1:
      h2 = ""
    2:
      h2 = "NE"
    3:
      h2 = "NW"
    4:
      h2 = "SE"
    5:
      h2 = "SW"
  end case
  
  if (h = 1) or (h = 2) or (h = 3) or (h = 4) or (h = 5)then
    if (h = 1) then
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
      end repeat
    else
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCP"&h2).image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(0, 255, 0)})
      end repeat
    end if
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocket"&h2).image, rect(pos,pos)+rect(-8, -8, 8, 8), member("ceramicTileSocket"&h2).image.rect, {#ink:36, #color:color(255, 0, 0)})
    
    if (h = 1) or (h = 2) or (h = 4)then
      if(lft)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 3) or (h = 5)then
      if(rght)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 4) or (h = 5)then
      if(tp)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 2) or (h = 3)then
      if(bttm)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, -8, 11), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
          member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTileSilh2"&h2).image.rect, {#ink:39})
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTileSilh2"&h2).image.rect, {#ink:39})
      end if
    end if
    
    the randomSeed = savSeed
    
  else if (h = 6) then
    repeat with q = 1 to 9 then
      member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCPFL").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, (10-bttm)/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(0, 255, 0)})
    end repeat
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocketFL").image, rect(pos,pos)+rect(-8, -8, 8, 8/2), member("ceramicTileSocketFL").image.rect, {#ink:36, #color:color(255, 0, 0)})
    
    
    if(lft)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    if(rght)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    if(tp)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(255, 0, 255)})
        member("gradientA"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilhFL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2FL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileSilh2FL").image.rect, {#ink:39})
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilhFL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(255,0,255)})
        member("gradientA"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2FL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileSilh2FL").image.rect, {#ink:39})
      end if
    end if
    
    the randomSeed = savSeed
  end if
end


on drawCeramicBTypeTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops, gEEprops, gAnyDecals
  
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  chaos = 0
  
  repeat with q = 1 to gEEprops.effects.count then
    if(gEEprops.effects[q].nm = "Ceramic Chaos")then
      case gEEprops.effects[q].options[3][3] of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
        "1":
          dmin = 1
          dmax = 1
        "2":
          dmin = 2
          dmax = 2
        "3":
          dmin = 3
          dmax = 3
        "1:st and 2:nd":
          dmin = 1
          dmax = 2
        "2:nd and 3:rd":
          dmin = 2
          dmax = 3
        otherwise:
          dmin = 1
          dmax = 3
      end case
      if (layer >= dmin) and (layer <= dmax) then
        if(gEEprops.effects[q].mtrx[tl.loch][tl.locv] > chaos)then
          chaos = gEEprops.effects[q].mtrx[tl.loch][tl.locv]
        end if
      end if
    end if
  end repeat
  
  --gAnyDecals = true
  
  chaos = chaos * 0.01
  
  dp = ((layer - 1)*10)
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  clr = color(239, 234, 224)
  
  
  lft = 0
  rght = 0
  tp = 0
  bttm = 0
  if(afaMvLvlEdit(tl+point(-1,0), layer)<>1) and (afaMvLvlEdit(tl+point(-1,0), layer)<>2) and (afaMvLvlEdit(tl+point(-1,0), layer)<>3) and (afaMvLvlEdit(tl+point(-1,0), layer)<>4) and (afaMvLvlEdit(tl+point(-1,0), layer)<>5) and (afaMvLvlEdit(tl+point(-1,0), layer)<>6)then
    lft = 1
  end if
  if(afaMvLvlEdit(tl+point(1,0), layer)<>1) and (afaMvLvlEdit(tl+point(1,0), layer)<>2) and (afaMvLvlEdit(tl+point(1,0), layer)<>3) and (afaMvLvlEdit(tl+point(1,0), layer)<>4) and (afaMvLvlEdit(tl+point(1,0), layer)<>5) and (afaMvLvlEdit(tl+point(1,0), layer)<>6)then
    rght = 1
  end if
  if(afaMvLvlEdit(tl+point(0,-1), layer)<>1) and (afaMvLvlEdit(tl+point(0,-1), layer)<>2) and (afaMvLvlEdit(tl+point(0,-1), layer)<>3) and (afaMvLvlEdit(tl+point(0,-1), layer)<>4) and (afaMvLvlEdit(tl+point(0,-1), layer)<>5) and (afaMvLvlEdit(tl+point(0,-1), layer)<>6)then
    tp = 1
  end if
  if(afaMvLvlEdit(tl+point(0,1), layer)<>1) and (afaMvLvlEdit(tl+point(0,1), layer)<>2) and (afaMvLvlEdit(tl+point(0,1), layer)<>3) and (afaMvLvlEdit(tl+point(0,1), layer)<>4) and (afaMvLvlEdit(tl+point(0,1), layer)<>5) and (afaMvLvlEdit(tl+point(0,1), layer)<>6)then
    bttm = 1
  end if
  
  h = afaMvLvlEdit(tl, layer)
  case h of
    1:
      h2 = ""
    2:
      h2 = "NE"
    3:
      h2 = "NW"
    4:
      h2 = "SE"
    5:
      h2 = "SW"
  end case
  
  if (h = 1) or (h = 2) or (h = 3) or (h = 4) or (h = 5)then
    if (h = 1) then
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 0)})
      end repeat
    else
      repeat with q = 1 to 9 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCP"&h2).image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, 10-bttm), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(0, 255, 0)})
      end repeat
    end if
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocket"&h2).image, rect(pos,pos)+rect(-8, -8, 8, 8), member("ceramicTileSocket"&h2).image.rect, {#ink:36, #color:color(255, 0, 0)})
    
    if (h = 1) or (h = 2) or (h = 4)then
      if(lft)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 3) or (h = 5)then
      if(rght)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 4) or (h = 5)then
      if(tp)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    if (h = 1) or (h = 2) or (h = 3)then
      if(bttm)and(random(120)>chaos*chaos*chaos*100)then
        repeat with q = 2 to 8 then
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, -8, 11), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
          member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, 9, 9, 11), rect(0,0,1,1), {#ink:39})
        end repeat
      end if
    end if
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(0, 255, 255)})
        member("gradientB"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2"&h2).image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9), -90.05122 + f*0.01), member("ceramicTileSilh2"&h2).image.rect, {#ink:39})
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTileSilh"&h2).image.rect, {#ink:36, #color:color(0, 255, 255)})
        member("gradientB"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2"&h2).image, rect(pos,pos)+rect(-9, -9, 9, 9), member("ceramicTileSilh2"&h2).image.rect, {#ink:39})
      end if
    end if
    
    the randomSeed = savSeed
    
  else if (h = 6) then
    repeat with q = 1 to 9 then
      member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("ceramicTileSilhCPFL").image, rect(pos,pos)+rect(-10+lft, -10+tp, 10-rght, (10-bttm)/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(0, 255, 0)})
    end repeat
    member("layer"&string(((layer - 1)*10)+1)).image.copyPixels(member("ceramicTileSocketFL").image, rect(pos,pos)+rect(-8, -8, 8, 8/2), member("ceramicTileSocketFL").image.rect, {#ink:36, #color:color(255, 0, 0)})
    
    
    if(lft)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-11, -9, -9, 9/2), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    if(rght)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, -8), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(9, -9, 11, 9/2), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    if(tp)and(random(120)>chaos*chaos*chaos*100)then
      repeat with q = 2 to 8 then
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("layer"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, -8, -9), rect(0,0,1,1), {#ink:36, #color:color(0, 255, 255)})
        member("gradientB"&string(((layer - 1)*10)+q)).image.copyPixels(member("pxl").image, rect(pos,pos)+rect(-9, -11, 9, -9), rect(0,0,1,1), {#ink:39})
      end repeat
    end if
    
    
    
    pos = pos + point(-7+random(13), -7+random(13))*chaos*chaos*chaos*random(100)*0.01
    
    if(chaos = 0)or(random(300 - 298*chaos*chaos*chaos)>1)then
      if(random(100)<chaos*100)then
        f = (random(1000 + 4000*chaos)*chaos).integer
        repeat with a = 1 to (1.0-chaos)*4 then
          f = random(f)
          if(f = 1)then
            exit repeat
          end if
        end repeat
      else
        f = 1
      end if
      if(abs(f) > 1)then
        f = f - 1
        if(random(2)=1)then
          f = f * -1
        end if
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilhFL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(0,255,255)})
        member("gradientB"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2FL").image, rotateToQuad(rect(pos,pos)+rect(-9, -9, 9, 9/2), -90.05122 + f*0.01), member("ceramicTileSilh2FL").image.rect, {#ink:39})
      else
        member("layer"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilhFL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileSilhFL").image.rect, {#ink:36, #color:color(0,255,255)})
        member("gradientB"&string(((layer - 1)*10))).image.copyPixels(member("ceramicTileSilh2FL").image, rect(pos,pos)+rect(-9, -9, 9, 9/2), member("ceramicTileSilh2FL").image.rect, {#ink:39})
      end if
    end if
    
    the randomSeed = savSeed
  end if
end

on drawDPTTile(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  pstLr = DPStartLayerOfTile(tl, layer)
  --For Dry's mat
  if(mat = "Shallow Circuits") or (mat = "Shallow Dense Pipes") then
    pstLr = layer * 10 - 10
  end if
  
  if(afaMvLvlEdit(tl, layer) > 1)then
    a = afaMvLvlEdit(tl, layer)
    var = 16 
    case a of
      2: var = 20
      3: var = 19
      4: var = 17
      5: var = 18
      6: 
        if (gDRMatFixes) then
          var = 21
        end if
      9: 
        if (gDRMatFixes) then
          var = 22
        end if
    end case
    
    repeat with q = pstLr to (layer * 10)-1 then
      if (mat = "Shallow Circuits") then
        member("layer" & q).image.copyPixels(member("circuitsImage").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1,var*40,41), {#ink:36})
      else if (mat = "Shallow Dense Pipes") then
        member("layer" & q).image.copyPixels(member("dense PipesImage").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1,var*40,41), {#ink:36})
      else
        member("layer" & q).image.copyPixels(member(mat & "image").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1,var*40,41), {#ink:36})
      end if
    end repeat
  else
    
    
    
    lst = ["0000", "1111", "0101", "1010", "0001", "1000", "0100", "0010", "1001", "1100", "0110", "0011", "1011", "1101", "1110", "0111"]
    
    lftDp = DPStartLayerOfTile(tl+point(-1,0), layer)
    rghtDp = DPStartLayerOfTile(tl+point(1,0), layer)
    tpDp = DPStartLayerOfTile(tl+point(0,-1), layer)
    bttmDp = DPStartLayerOfTile(tl+point(0,1), layer)
    
    repeat with q = pstLr to (layer * 10)-1 then
      
      lft =  solidAfaMv(tl+point(-1,0), layer) * DPCircuitConnection(tl+point(-1,0), q).locH * (lftDp<=q)
      rght = solidAfaMv(tl+point(1,0), layer) * DPCircuitConnection(tl, q).locH * (rghtDp<=q) 
      tp =  solidAfaMv(tl+point(0,-1), layer) * DPCircuitConnection(tl+point(0,-1), q).locV* (tpDp<=q) 
      bttm = solidAfaMv(tl+point(0,1), layer) * DPCircuitConnection(tl, q).locV * (bttmDp<=q) 
      -- For Dry's mat
      if(mat = "Shallow Circuits") or (mat = "Shallow Dense Pipes") then
        lft =  solidAfaMv(tl+point(-1,0), layer) * DPCircuitConnection(tl+point(-1,0), q).locH
        rght = solidAfaMv(tl+point(1,0), layer) * DPCircuitConnection(tl, q).locH
        tp =  solidAfaMv(tl+point(0,-1), layer) * DPCircuitConnection(tl+point(0,-1), q).locV 
        bttm = solidAfaMv(tl+point(0,1), layer) * DPCircuitConnection(tl, q).locV 
      end if  
      
      if(afaMvLvlEdit(tl+point(-1,0), layer)>1 and ((gDRMatFixes = FALSE) or (afaMvLvlEdit(tl+point(-1,0), layer) <> 9)))then
        lft = 1
      end if
      if(afaMvLvlEdit(tl+point(1,0), layer)>1 and ((gDRMatFixes = FALSE) or (afaMvLvlEdit(tl+point(1,0), layer) <> 9)))then
        rght = 1
      end if
      if(afaMvLvlEdit(tl+point(0,-1), layer)>1 and ((gDRMatFixes = FALSE) or (afaMvLvlEdit(tl+point(0,-1), layer) <> 9)))then
        tp = 1
      end if
      if(afaMvLvlEdit(tl+point(0,1), layer)>1 and ((gDRMatFixes = FALSE) or (afaMvLvlEdit(tl+point(0,1), layer) <> 9)))then
        bttm = 1
      end if
      
      
      var = lst.getPos((string(lft) & string(tp) & string(rght) & string(bttm)))
      rand = 1
      if(mat = "Circuits") or (mat = "Shallow Circuits")then
        rand = random(5)
      end if
      
      if (mat = "Shallow Circuits") then
        member("layer" & q).image.copyPixels(member("circuitsImage").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1+(rand-1)*40,var*40,1+rand*40), {#ink:36})
      else if (mat = "Shallow Dense Pipes") then
        member("layer" & q).image.copyPixels(member("dense PipesImage").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1+(rand-1)*40,var*40,1+rand*40), {#ink:36})
      else
        member("layer" & q).image.copyPixels(member(mat & "image").image, rect(pos-point(20,20), pos+point(20,20)), rect((var-1)*40,1+(rand-1)*40,var*40,1+rand*40), {#ink:36})
      end if
    end repeat
  end if
  
  the randomSeed = savSeed
end

on drawRandomPipesMat(mat, tl, layer, frntImg)
  savSeed = the randomSeed
  global gLOprops
  the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
  
  pos = giveMiddleOfTile(tl-gRenderCameraTilePos)
  
  if(afaMvLvlEdit(tl, layer) > 1)then
    a = afaMvLvlEdit(tl, layer)
    var = 16 
    case a of
      2: var = 20
      3: var = 19
      4: var = 17
      5: var = 18
      6: var = [21, 25][random(2)]
      9: var = 22
    end case
    
    q = (layer*10)-10
    if a = 6 then
      repeat with ld = 0 to 9 then
        member("layer" & string(q+ld)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*ld,var*20,20*(ld+1)), {#ink:36})
      end repeat
    else
      repeat with ld = 0 to 2 then
        member("layer" & string(q+ld)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*ld,var*20,20*(ld+1)), {#ink:36})
      end repeat
      repeat with tf = 3 to 6 then
        member("layer" & string(q+tf)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*3,var*20,20*4), {#ink:36}) 
      end repeat
      tf = 7
      repeat with ld = 4 to 6 then
        member("layer" & string(q+tf)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*ld,var*20,20*(ld+1)), {#ink:36})
        tf = tf + 1
      end repeat
    end if
  else
    
    
    
    lst = ["0000", "1111", "0101", "1010", "0001", "1000", "0100", "0010", "1001", "1100", "0110", "0011", "1011", "1101", "1110", "0111"]
    
    q = (layer*10)-10
    
    lft =  solidAfaMv(tl+point(-1,0), layer) * DPCircuitConnection(tl+point(-1,0), q).locH
    rght = solidAfaMv(tl+point(1,0), layer) * DPCircuitConnection(tl, q).locH
    tp =  solidAfaMv(tl+point(0,-1), layer) * DPCircuitConnection(tl+point(0,-1), q).locV
    bttm = solidAfaMv(tl+point(0,1), layer) * DPCircuitConnection(tl, q).locV
    
    if(afaMvLvlEdit(tl+point(-1,0), layer)>1 and (afaMvLvlEdit(tl+point(-1,0), layer) <> 9)) then
      lft = 1
    end if
    if(afaMvLvlEdit(tl+point(1,0), layer)>1 and (afaMvLvlEdit(tl+point(1,0), layer) <> 9)) then
      rght = 1
    end if
    if(afaMvLvlEdit(tl+point(0,-1), layer)>1 and (afaMvLvlEdit(tl+point(0,-1), layer) <> 9)) then
      tp = 1
    end if
    if(afaMvLvlEdit(tl+point(0,1), layer)>1 and (afaMvLvlEdit(tl+point(0,1), layer) <> 9)) then
      bttm = 1
    end if
    
    
    var = lst.getPos((string(lft) & string(tp) & string(rght) & string(bttm)))
    if var = 3 then
      var = [3, 23][random(2)]
    else if var = 4 then
      var = [4, 24][random(2)]
    else if var = 1 then
      var = [1,26,27][random(3)]
    end if
    
    repeat with ld = 0 to 2 then
      member("layer" & string(q+ld)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*ld,var*20,20*(ld+1)), {#ink:36})
    end repeat
    repeat with tf = 3 to 6 then
      member("layer" & string(q+tf)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*3,var*20,20*4), {#ink:36}) 
    end repeat
    tf = 7
    repeat with ld = 4 to 6 then
      member("layer" & string(q+tf)).image.copyPixels(member(mat & "Image2").image, rect(pos-point(10,10), pos+point(10,10)), rect((var-1)*20,20*ld,var*20,20*(ld+1)), {#ink:36})
      tf = tf + 1
    end repeat
  end if
  
  the randomSeed = savSeed
end

on DPCircuitConnection(tl, dpAdd)
  savSeed = the randomSeed
  the randomSeed = seedForTile(tl)+(dpAdd/2).integer*(tl.locH/3).integer-(tl.locV/2).integer
  
  if(random(2)=1)then
    pnt = point(random(2)-1, random(2)-1)
  else
    if(random(2)=1)then
      pnt = point(1, 0)
    else
      pnt = point(0, 1)
    end if
  end if
  
  
  the randomSeed = savSeed
  
  return pnt
end

on DPStartLayerOfTile(tl, layer)
  if(layer > 1)then
    if(afaMvLvlEdit(tl, layer-1)=1)then
      --  return 0
    end if
  end if
  
  distanceToAir = DistanceToAir(tl, layer)
  
  --  if(random(300)=1)then
  --  put distanceToAir
  -- end if
  
  if(distanceToAir >= 7)and(layer=1)then
    --   return 0
  end if
  
  pushIn = 6-distanceToAir
  pushIn = pushIn - (layer=1) - 3*(layer=3)
  pushIn = restrict(pushIn, -4*(layer>1)-5*(layer=3), 9-5*(layer=1))
  
  
  return (layer-1)*10 + pushIn
end

on DistanceToAir(tl, layer)
  distanceToAir = 8
  ext = 0
  repeat with dist = 1 to 7 then
    repeat with dir in [point(-1,0),point(-1,-1),point(0,-1),point(1,-1),point(1,0),point(1,1),point(0,1),point(-1,1)]then
      if(afaMvLvlEdit(tl+dir*dist, layer)<>1)and(afaMvLvlEdit(tl+dir*dist, restrict(layer-1, 1, 3))<>1)then
        distanceToAir = dist
        ext = 1
        exit repeat
      end if
    end repeat
    if(ext) then
      exit repeat
    end if
  end repeat
  return distanceToAir
end 


on drawTinySigns
  member("Tiny SignsTexture").image.copyPixels(member("pxl").image, rect(0, 0, 1080, 800), rect(0,0,1,1), {#color:color(0,255,0)})
  
  language = 2
  
  blueList = [point(1,1), point(1,0), point(0,1)]
  redList = [point(-1,-1), point(-1,0), point(0,-1)]
  
  tlSize = 8
  repeat with c = 0 to 100 then
    repeat with q = 0 to 135 then
      --putRct = rect((q-1)*8, )
      mdPnt = point((q+0.5)*tlSize, (c+0.5)*tlSize)
      
      gtPos = point(random([20,14,1][language]), language)
      
      
      
      if random(50)=1 then
        language = 2
      else if random(80)=1 then
        language = 1
      end if
      
      if random(7)=1 then
        if random(3)=1 then
          gtPos = point(1, 3)
        else
          gtPos = point(random(random(7)), 3)
          if random(5)=1 then
            language = 2
          else if random(10)=1 then
            language = 1
          end if
        end if
      end if
      
      repeat with p in redList then
        member("Tiny SignsTexture").image.copyPixels(member("tinySigns").image, rect(mdPnt, mdPnt)+rect(-3,-3,3,3)+rect(p,p), rect((gtPos.locH-1)*6,(gtPos.locV-1)*6,gtPos.locH*6,gtPos.locV*6), {#ink:36, #color:color(255,0,0)})
      end repeat
      repeat with p in blueList then
        member("Tiny SignsTexture").image.copyPixels(member("tinySigns").image, rect(mdPnt, mdPnt)+rect(-3,-3,3,3)+rect(p,p), rect((gtPos.locH-1)*6,(gtPos.locV-1)*6,gtPos.locH*6,gtPos.locV*6), {#ink:36, #color:color(0,0,255)})
      end repeat
      
      member("Tiny SignsTexture").image.copyPixels(member("tinySigns").image, rect(mdPnt, mdPnt)+rect(-3,-3,3,3), rect((gtPos.locH-1)*6,(gtPos.locV-1)*6,gtPos.locH*6,gtPos.locV*6), {#ink:36, #color:color(0,255,0)})
    end repeat
  end repeat
end





on renderTileMaterial(layer, material, frntImg)
  tlsOrdered: list = []
  repeat with q = 1 to gLOprops.size.loch
    repeat with c = 1 to gLOprops.size.locv
      LEPropqc = gLEProps.matrix[q][c][layer][1]
      if (LEPropqc <> 0) then
        addMe = 0
        TEPropqc = gTEprops.tlMatrix[q][c][layer]
        if(TEPropqc.tp = "material") then
          if(TEPropqc.data = material) then
            addMe = 1
          end if
        else if (gTEprops.defaultMaterial = material)then
          if (TEPropqc.tp = "default")then
            addMe = 1
          end if
        end if
        
        if(addMe)then
          if (LEPropqc = 1) then
            tlsOrdered.add([random(gLOprops.size.loch + gLOprops.size.locV), point(q, c)])
          else if (gDRMatFixes) or ((material <> "Tiled Stone") and (material <> "Chaotic Stone") and (material <> "Random Machines") and (material <> "3DBricks")) then
            tlsOrdered.add([random(gLOprops.size.loch + gLOprops.size.locV), point(q, c)])
          else if (point(q, c).inside(rect(gRenderCameraTilePos, gRenderCameraTilePos + point(100, 60)))) then
            frntImg = drawATileMaterial(q, c, layer, "Standard", frntImg)
          end if
        end if
      end if
    end repeat
  end repeat
  
  tlsOrdered.sort()
  tls: list = []
  repeat with q = 1 to tlsOrdered.count then
    tls.add(tlsOrdered[q][2])
  end repeat
  
  case material of
    "Chaotic Stone":
      if (gDRMatFixes) then
        repeat with tileCat = getFirstTileCat() to gTiles.count then
          if(gTiles[tileCat].nm = "LB Missing Stone")then
            exit repeat
          end if
        end repeat
        cnt =  tls.count
        repeat with q = 1 to cnt then
          tl = tls[cnt + 1 - q]
          case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
            2:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
              tls.deleteAt(cnt + 1 - q)
            3:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
              tls.deleteAt(cnt + 1 - q)
            4:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
              tls.deleteAt(cnt + 1 - q)
            5:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
              tls.deleteAt(cnt + 1 - q)
            6:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
              tls.deleteAt(cnt + 1 - q)
            0, 7, 8, 9:
              tls.deleteAt(cnt + 1 - q)
          end case
        end repeat
      end if
      stCat = 0
      repeat with st = 1 to gTiles.count then
        if(gTiles[st].nm = "Stone")then
          stCat = st
          exit repeat
        end if
      end repeat
      
      delL = []
      repeat with tl in tls then
        type tl: point
        if delL.getPos(tl)=0 then
          hts: number = 0
          repeat with dir in [point(1,0), point(0,1), point(1,1)] then
            type dir: point
            hts = hts + (tls.getPos(tl+dir)>0)*(delL.getPos(tl+dir)=0)
          end repeat
          if hts = 3 then
            if(tl.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60)))) then
              frntImg = drawATileTile(tl.loch,tl.locV,layer, gTiles[stCat].tls[2], frntImg)
            end if
            repeat with dir in [point(1,0), point(0,1), point(1,1)] then
              delL.add(tl+dir)
            end repeat
            delL.add(tl)
          end if
        end if
      end repeat
      
      repeat with del in delL then
        type del: point
        tls.deleteOne(del)
      end repeat
      
      savSeed = the randomSeed 
      type savSeed: number
      repeat while tls.count > 0 then
        the randomSeed  = gLOprops.tileSeed + tls.count
        tl = tls[random(tls.count)]
        if(tl.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60)))) then
          frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[stCat].tls[1], frntImg)
        end if
        tls.deleteOne(tl)
      end repeat
      the randomSeed  = savSeed
      
    "Tiled Stone":
      if (gDRMatFixes) then
        repeat with tileCat = getFirstTileCat() to gTiles.count then
          if(gTiles[tileCat].nm = "LB Missing Stone")then
            exit repeat
          end if
        end repeat
        cnt =  tls.count
        repeat with q = 1 to cnt then
          tl = tls[cnt + 1 - q]
          case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
            2:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
              tls.deleteAt(cnt + 1 - q)
            3:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
              tls.deleteAt(cnt + 1 - q)
            4:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
              tls.deleteAt(cnt + 1 - q)
            5:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
              tls.deleteAt(cnt + 1 - q)
            6:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
              tls.deleteAt(cnt + 1 - q)
            0, 7, 8, 9:
              tls.deleteAt(cnt + 1 - q)
          end case
        end repeat
      end if
      stCat = 0
      repeat with st = 1 to gTiles.count then
        if(gTiles[st].nm = "Stone")then
          stCat = st
          exit repeat
        end if
      end repeat
      delL = []
      repeat with tl in tls then
        if delL.getPos(tl)=0 then
          if (tl.locV mod 2)and((tl.locH+((tl.locV mod 4)=1)) mod 2) then
            hts = 0
            repeat with dir in [point(1,0), point(0,1), point(1,1)] then
              hts = hts + (tls.getPos(tl+dir)>0)*(delL.getPos(tl+dir)=0)
            end repeat
            if hts = 3 then
              frntImg = drawATileTile(tl.loch,tl.locV,layer, gTiles[stCat].tls[2], frntImg)
              repeat with dir in [point(1,0), point(0,1), point(1,1)] then
                delL.add(tl+dir)
              end repeat
              delL.add(tl)
            end if
          end if
        end if
      end repeat
      
      repeat with toDel in delL then
        tls.deleteOne(toDel)
      end repeat
      
      repeat while tls.count > 0 then
        tl = tls[random(tls.count)]
        frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[stCat].tls[1], frntImg)
        tls.deleteOne(tl)
      end repeat
      
      --    "3DBricks":
      --      repeat while tls.count > 0 then
      --        tl = tls[random(tls.count)]
      --        frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[5].tls[8], frntImg)
      --        tls.deleteOne(tl)
      --      end repeat
      
    "Random Machines":
      if (gDRMatFixes) then
        repeat with tileCat = getFirstTileCat() to gTiles.count then
          if(gTiles[tileCat].nm = "LB Missing Machine")then
            exit repeat
          end if
        end repeat
        cnt =  tls.count
        repeat with q = 1 to cnt then
          tl = tls[cnt + 1 - q]
          case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
            2:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
              tls.deleteAt(cnt + 1 - q)
            3:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
              tls.deleteAt(cnt + 1 - q)
            4:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
              tls.deleteAt(cnt + 1 - q)
            5:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
              tls.deleteAt(cnt + 1 - q)
            6:
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
              tls.deleteAt(cnt + 1 - q)
            0,7,8,9:
              tls.deleteAt(cnt + 1 - q)
          end case
        end repeat
      end if
      savSeed = the randomSeed
      
      the randomSeed = gLOprops.tileSeed + layer
      
      randomMachines = []
      repeat with w = 1 to 8 then
        lst: list = []
        repeat with h = 1 to 8 then
          lst.add([])
        end repeat
        randomMachines.add(lst)
      end repeat
      
      repeat with a = 1 to RandomMachines_grabTiles.count then
        type a: number
        repeat with q = 1 to gTiles.count then
          if(gTiles[q].nm = RandomMachines_grabTiles[a])then
            repeat with t = 1 to gTiles[q].tls.count then
              theTile = gTiles[q].tls[t]
              if(theTile.sz.locH <= 8)and(theTile.sz.locV <= 8)and(theTile.specs2 = 0)and(RandomMachines_forbidden.getPos(theTile.nm) = 0)then
                randomMachines[theTile.sz.locH][theTile.sz.locV].add(point(q,t))
              end if
            end repeat
          end if
        end repeat
      end repeat
      
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls then
        tlsBlock[tl] = 1
      end repeat
      repeat with tl in tls then
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if delL.findPos(tl)=void then
          
          randomOrderList: list = []
          repeat with w = 1 to randomMachines.count then
            repeat with h = 1 to randomMachines[w].count then
              repeat with t = 1 to randomMachines[w][h].count then
                randomOrderList.add([random(1000), randomMachines[w][h][t]])
              end repeat
            end repeat
          end repeat
          
          randomOrderList.sort()
          
          repeat with q = 1 to randomOrderList.count then 
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            
            legalToPlace: number = true
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint: point = tl + point(a,b)
                spec: number = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                
                if(tlsBlock.findPos(testPoint)=void)then
                  legalToPlace = false
                  exit repeat
                end if
                
                if(spec > -1)then
                  if(delL.findPos(testPoint)<>void)then
                    legalToPlace = false
                    exit repeat
                  end if
                  if(afaMvLvlEdit(testPoint, layer) <> spec)then
                    legalToPlace = false
                    exit repeat
                  end if
                end if
              end repeat
              if(legalToPlace = false)then
                exit repeat
              end if
            end repeat
            
            if(legalToPlace)then
              rootPos: point = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
              if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
                frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg)
              end if
              repeat with a = 0 to testTile.sz.locH-1 then
                repeat with b = 0 to testTile.sz.locV-1 then
                  spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                  if(spec > -1)then
                    delL[tl+point(a,b)] = 1
                  end if
                end repeat
              end repeat
              exit repeat
            end if
          end repeat
        end if
        
      end repeat
      
      the randomSeed = savSeed
      
    "Random Machines 2":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "LB Missing Machine")then
          exit repeat
        end if
      end repeat
      
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0,7,8,9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
      savSeed = the randomSeed
      
      the randomSeed = gLOprops.tileSeed + layer
      
      randomMachines = []
      repeat with w = 1 to 8 then
        lst = []
        repeat with h = 1 to 8 then
          lst.add([])
        end repeat
        randomMachines.add(lst)
      end repeat
      
      repeat with a = 1 to RandomMachines2_grabTiles.count then
        repeat with q = 1 to gTiles.count then
          if(gTiles[q].nm = RandomMachines2_grabTiles[a])then
            repeat with t = 1 to gTiles[q].tls.count then
              theTile = gTiles[q].tls[t]
              if(theTile.sz.locH <= 8)and(theTile.sz.locV <= 8)and(theTile.specs2 = 0)and(RandomMachines2_forbidden.getPos(theTile.nm) = 0)then
                randomMachines[theTile.sz.locH][theTile.sz.locV].add(point(q,t))
              end if
            end repeat
          end if
        end repeat
      end repeat
      
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls then
        tlsBlock[tl] = 1
      end repeat
      repeat with tl in tls then
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if delL.findPos(tl)=void then
          
          randomOrderList = []
          repeat with w = 1 to randomMachines.count then
            repeat with h = 1 to randomMachines[w].count then
              repeat with t = 1 to randomMachines[w][h].count then
                randomOrderList.add([random(1000), randomMachines[w][h][t]])
              end repeat
            end repeat
          end repeat
          
          randomOrderList.sort()
          
          repeat with q = 1 to randomOrderList.count then 
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            
            legalToPlace = true
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint = tl + point(a,b)
                spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                
                if(tlsBlock.findPos(testPoint)=void)then
                  legalToPlace = false
                  exit repeat
                end if
                
                if(spec > -1)then
                  if(delL.findPos(testPoint)<>void)then
                    legalToPlace = false
                    exit repeat
                  end if
                  if(afaMvLvlEdit(testPoint, layer) <> spec)then
                    legalToPlace = false
                    exit repeat
                  end if
                end if
              end repeat
              if(legalToPlace = false)then
                exit repeat
              end if
            end repeat
            
            if(legalToPlace)then
              rootPos = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
              if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
                frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg)
              end if
              repeat with a = 0 to testTile.sz.locH-1 then
                repeat with b = 0 to testTile.sz.locV-1 then
                  spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                  if(spec > -1)then
                    delL[tl+point(a,b)] = 1
                  end if
                end repeat
              end repeat
              exit repeat
            end if
          end repeat
        end if
        
      end repeat
      
      the randomSeed = savSeed
      
    "Small Machines":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "LB Missing Machine")then
          exit repeat
        end if
      end repeat
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0,7,8,9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
      savSeed = the randomSeed
      
      the randomSeed = gLOprops.tileSeed + layer
      
      randomMachines = []
      repeat with w = 1 to 8 then
        lst = []
        repeat with h = 1 to 8 then
          lst.add([])
        end repeat
        randomMachines.add(lst)
      end repeat
      
      repeat with a = 1 to SmallMachines_grabTiles.count then
        repeat with q = 1 to gTiles.count then
          if(gTiles[q].nm = SmallMachines_grabTiles[a])then
            repeat with t = 1 to gTiles[q].tls.count then
              theTile = gTiles[q].tls[t]
              if(theTile.sz.locH <= 8)and(theTile.sz.locV <= 8)and(theTile.specs2 = 0)and(SmallMachines_forbidden.getPos(theTile.nm) = 0)then
                randomMachines[theTile.sz.locH][theTile.sz.locV].add(point(q,t))
              end if
            end repeat
          end if
        end repeat
      end repeat
      
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls then
        tlsBlock[tl] = 1
      end repeat
      repeat with tl in tls then
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if delL.findPos(tl)=void then
          
          randomOrderList = []
          repeat with w = 1 to randomMachines.count then
            repeat with h = 1 to randomMachines[w].count then
              repeat with t = 1 to randomMachines[w][h].count then
                randomOrderList.add([random(1000), randomMachines[w][h][t]])
              end repeat
            end repeat
          end repeat
          
          randomOrderList.sort()
          
          repeat with q = 1 to randomOrderList.count then 
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            
            legalToPlace = true
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint = tl + point(a,b)
                spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                
                if(tlsBlock.findPos(testPoint)=void)then
                  legalToPlace = false
                  exit repeat
                end if
                
                if(spec > -1)then
                  if(delL.findPos(testPoint)<>void)then
                    legalToPlace = false
                    exit repeat
                  end if
                  if(afaMvLvlEdit(testPoint, layer) <> spec)then
                    legalToPlace = false
                    exit repeat
                  end if
                end if
              end repeat
              if(legalToPlace = false)then
                exit repeat
              end if
            end repeat
            
            if(legalToPlace)then
              rootPos = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
              if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
                frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg)
              end if
              repeat with a = 0 to testTile.sz.locH-1 then
                repeat with b = 0 to testTile.sz.locV-1 then
                  spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                  if(spec > -1)then
                    delL[tl+point(a,b)] = 1
                  end if
                end repeat
              end repeat
              exit repeat
            end if
          end repeat
        end if
        
      end repeat
      
      the randomSeed = savSeed
      
    "Random Metal":
      repeat with tileCat = getFirstTileCat() to gTiles.count
        if (gTiles[tileCat].nm = "LB Missing Metal") then --> this is the category for slopes, shortcut geometry and glass, added to prevent the material from crashing if applied on these geometries and to add custom ones
          exit repeat
        end if
      end repeat
      cnt =  tls.count
      repeat with q = 1 to cnt
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2: --> 2 is the geometry number (it can be 0, 1, 2, 3, 4, 5, 5, 7, 8(unused), 9)
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[1], frntImg) --> tileCat is the category mentioned above, 1 is the tile order number 
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0,7,8,9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
      savSeed = the randomSeed
      
      the randomSeed = gLOprops.tileSeed + layer
      
      randomMetal = []
      repeat with w = 1 to 8 then
        lst = []
        repeat with h = 1 to 8 then
          lst.add([])
        end repeat
        randomMetal.add(lst)
      end repeat
      -- remove the "--" to uncomment
      repeat with q = getFirstTileCat() to gTiles.count then --cat change
        repeat with t = 1 to gTiles[q].tls.count then
          theTile = gTiles[q].tls[t]
          if (theTile.tags.getPos("randomMetal") <> 0) or (DRRandomMetal_needed.getPos(theTile.nm) >= 1)then --> you can add things before "then" here, just be sure to add "and" between conditions
            -- (gTiles[q].tls[t].tags.getPos("randomMetal") <> 0) --> checks a tag; you can change the tag, just be sure to add the reight on to the tiles you want in the material mix
            -- (gTiles[q].tls[t].sz.locH <= 8) --> checks the height of the tile (value of x in #sz:point(x, y))
            -- (gTiles[q].tls[t].sz.locV <= 8) --> checks the width of the tile (value of y in #sz:point(x, y))
            -- (forbidden.getPos(gTiles[q].tls[t].nm) = 0) --> checks if the tile is forbidden (list above)
            -- (gTiles[q].tls[t].specs2 = 0) --> checks if the tile has no specs on layer 2
            randomMetal[theTile.sz.locH][theTile.sz.locV].add(point(q,t))
          end if
        end repeat
      end repeat
      
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls then
        tlsBlock[tl] = 1
      end repeat
      repeat with tl in tls then
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if delL.findPos(tl)=void then
          
          randomOrderList = []
          repeat with w = 1 to randomMetal.count then
            repeat with h = 1 to randomMetal[w].count then
              repeat with t = 1 to randomMetal[w][h].count then
                randomOrderList.add([random(1000), randomMetal[w][h][t]])
              end repeat
            end repeat
          end repeat
          
          randomOrderList.sort()
          
          repeat with q = 1 to randomOrderList.count then 
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            
            legalToPlace = true
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint = tl + point(a,b)
                spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                
                if(tlsBlock.findPos(testPoint)=void)then
                  legalToPlace = false
                  exit repeat
                end if
                
                if(spec > -1)then
                  if(delL.findPos(testPoint)<>void)then
                    legalToPlace = false
                    exit repeat
                  end if
                  if(afaMvLvlEdit(testPoint, layer) <> spec)then
                    legalToPlace = false
                    exit repeat
                  end if
                end if
              end repeat
              if(legalToPlace = false)then
                exit repeat
              end if
            end repeat
            
            if(legalToPlace)then
              rootPos = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
              if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
                frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg)
              end if
              repeat with a = 0 to testTile.sz.locH-1 then
                repeat with b = 0 to testTile.sz.locV-1 then
                  spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                  if(spec > -1)then
                    delL[tl+point(a,b)] = 1
                  end if
                end repeat
              end repeat
              exit repeat
            end if
          end repeat
        end if
        
      end repeat
      
      the randomSeed = savSeed
      
    "Chaotic Stone 2":
      repeat with tileCat = getFirstTileCat() to gTiles.count
        if (gTiles[tileCat].nm = "LB Missing Stone") then
          exit repeat
        end if
      end repeat
      cnt =  tls.count
      repeat with q = 1 to cnt
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH, tl.locV, layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0,7,8,9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      savSeed = the randomSeed
      the randomSeed = gLOprops.tileSeed + layer
      stones = []
      smSto = []
      repeat with w = 1 to 8
        lst = []
        repeat with h = 1 to 8
          lst.add([])
        end repeat
        stones.add(lst)
      end repeat
      
      repeat with q = getFirstTileCat() to gTiles.count ---cat change
        repeat with t = 1 to gTiles[q].tls.count
          tsto = gTiles[q].tls[t]
          if (((tsto.tags.getPos("chaoticStone2") <> 0) or (tsto.tags.getPos("chaoticStone2 : rare") <> 0) or (tsto.tags.getPos("chaoticStone2 : very rare") <> 0))) or (ChaoticStone2_needed.getPos(tsto.nm) >= 1) then
            if (tsto.sz.locH > 1) and (tsto.sz.locV > 1) then
              stones[tsto.sz.locH][tsto.sz.locV].add(point(q, t))
            else
              smSto.add(tsto)
            end if
          end if
        end repeat
      end repeat
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls
        tlsBlock[tl] = 1
      end repeat
      
      repeat with tlC = 1 to tls.count
        tl = tls[tlC]
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if (delL.findPos(tl) = VOID) then
          randomOrderList = []
          repeat with w = 1 to stones.count
            repeat with h = 1 to stones[w].count
              repeat with t = 1 to stones[w][h].count
                randomOrderList.add([random(500), stones[w][h][t]])
              end repeat
            end repeat
          end repeat
          randomOrderList.sort()
          repeat with q = 1 to randomOrderList.count
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            legalToPlace = TRUE
            repeat with a = 0 to testTile.sz.locH - 1
              repeat with b = 0 to testTile.sz.locV - 1
                testPoint = tl + point(a, b)
                spec = testTile.specs[(b + 1) + (a * testTile.sz.locV)]
                if (tlsBlock.findPos(testPoint) = VOID) then
                  legalToPlace = FALSE
                  exit repeat
                end if
                if (spec > -1) then
                  if (delL.findPos(testPoint) <> VOID) then
                    legalToPlace = FALSE
                    exit repeat
                  end if
                  if (afaMvLvlEdit(testPoint, layer) <> spec) then
                    legalToPlace = FALSE
                    exit repeat
                  end if
                end if
              end repeat
              if (legalToPlace = FALSE) then
                exit repeat
              end if
            end repeat
            tags2 = testTile.tags
            if ((tags2.getPos("chaoticStone2 : rare") <> 0) and (random(2) <> 1)) or ((tags2.getPos("chaoticStone2 : very rare") <> 0) and (random(4) <> 1)) or ((testTile.nm = "Big Stone Marked") and (random(2) <> 1)) then
              legalToPlace = FALSE
            end if
            if (legalToPlace) then
              rootPos = tl + point(((testTile.sz.locH.float / 2.0) + 0.4999).integer - 1, ((testTile.sz.locV.float / 2.0) + 0.4999).integer - 1)
              if (rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60)))) then
                frntImg = drawATileTile(rootPos.locH, rootPos.locV, layer, testTile, frntImg) 
              end if
              repeat with a = 0 to testTile.sz.locH - 1
                repeat with b = 0 to testTile.sz.locV - 1
                  spec = testTile.specs[(b + 1) + (a * testTile.sz.locV)]
                  if (spec > -1) then
                    delL[tl + point(a, b)] = 1
                    tls.deleteOne(tl + point(a, b))
                    --writeMessage(tl + point(a, b))
                  end if
                end repeat
              end repeat
              exit repeat
            end if
          end repeat
        end if
      end repeat
      repeat while tls.count > 0
        tl = tls[random(tls.count)]
        ptt = smSto[random(smSto.count)]
        if ((ptt.tags.getPos("chaoticStone2 : rare") <> 0) and (random(8) <> 1)) or ((ptt.tags.getPos("chaoticStone2 : very rare") <> 0) and (random(16) <> 1)) then
          ptt = smSto[random(smSto.count)]
        end if
        frntImg = drawATileTile(tl.locH, tl.locV, layer, ptt, frntImg)
        tls.deleteOne(tl)
      end repeat
      the randomSeed = savSeed
      
      --Dry's random metals
    "Random Metals":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "LB Missing Metal")then
          exit repeat
        end if
      end repeat
      
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0, 7, 8, 9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
      savSeed = the randomSeed
      
      the randomSeed = gLOprops.tileSeed + layer
      
      randomMetals = []
      repeat with w = 1 to 8 then
        lst = []
        repeat with h = 1 to 8 then
          lst.add([])
        end repeat
        randomMetals.add(lst)
      end repeat
      
      
      repeat with a = 1 to RandomMetals_grabTiles.count then
        repeat with q = 1 to gTiles.count then
          if(gTiles[q].nm = RandomMetals_grabTiles[a])then
            repeat with t = 1 to gTiles[q].tls.count then
              theTile = gTiles[q].tls[t]
              if(theTile.sz.locH <= 8)and(theTile.sz.locV <= 8)and(theTile.specs2 = 0)and(RandomMetals_allowed.getPos(theTile.nm) >= 1)then
                randomMetals[theTile.sz.locH][theTile.sz.locV].add(point(q,t))
              end if
            end repeat
          end if
        end repeat
      end repeat
      
      delL = [:]
      tlsBlock = [:]
      repeat with tl in tls then
        tlsBlock[tl] = 1
      end repeat
      repeat with tl in tls then
        the randomSeed = seedForTile(tl, gLOprops.tileSeed + layer)
        if delL.findPos(tl)=void then
          
          randomOrderList = []
          repeat with w = 1 to randomMetals.count then
            repeat with h = 1 to randomMetals[w].count then
              repeat with t = 1 to randomMetals[w][h].count then
                randomOrderList.add([random(1000), randomMetals[w][h][t]])
              end repeat
            end repeat
          end repeat
          
          randomOrderList.sort()
          
          repeat with q = 1 to randomOrderList.count then 
            testTile = gTiles[randomOrderList[q][2].locH].tls[randomOrderList[q][2].locV]
            
            legalToPlace = true
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint = tl + point(a,b)
                spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                
                if(tlsBlock.findPos(testPoint)=void)then
                  legalToPlace = false
                  exit repeat
                end if
                
                if(spec > -1)then
                  if(delL.findPos(testPoint)<>void)then
                    legalToPlace = false
                    exit repeat
                  end if
                  if(afaMvLvlEdit(testPoint, layer) <> spec)then
                    legalToPlace = false
                    exit repeat
                  end if
                end if
              end repeat
              if(legalToPlace = false)then
                exit repeat
              end if
            end repeat
            
            if(legalToPlace)then
              rootPos = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
              if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
                frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg)
              end if
              repeat with a = 0 to testTile.sz.locH-1 then
                repeat with b = 0 to testTile.sz.locV-1 then
                  spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                  if(spec > -1)then
                    delL[tl+point(a,b)] = 1
                  end if
                end repeat
              end repeat
              
              exit repeat
            end if
          end repeat
        end if
        
      end repeat
      
      the randomSeed = savSeed
      
      --Dry's mat, improved by LB
    "Dune Sand":
      savSeed = the randomSeed
      the randomSeed = gLOprops.tileSeed + layer
      duneSand = []
      repeat with a = getFirstTileCat() to gTiles.count -- cat change
        repeat with b = 1 to gTiles[a].tls.count
          theTile = gTiles[a].tls[b]
          if (theTile.tp = "voxelStructSandType") and (theTile.sz.locH = 1) and (theTile.sz.locV = 1) then
            duneSand.add(theTile)
          end if
        end repeat
      end repeat
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        if (afaMvLvlEdit(point(tl.locH, tl.locV), layer) <> 1) then
          tls.deleteAt(cnt + 1 - q)
        else
          frntImg = drawATileTile(tl.locH, tl.locV, layer, duneSand[random(duneSand.count)], frntImg)
          tls.deleteAt(cnt + 1 - q)
        end if
      end repeat
      the randomSeed = savSeed
      
    "Temple Stone":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "Temple Stone")then
          exit repeat
        end if
      end repeat
      
      global templeStoneCorners
      templeStoneCorners = [[], [], [], []]
      
      tls2 = tls.duplicate()
      
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[6], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[7], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[8], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0, 7, 8:
            tls.deleteAt(cnt + 1 - q)
          9:
            if (gDRMatFixes) then
              tls.deleteAt(cnt + 1 - q)
            end if
        end case
      end repeat
      
      repeat with q = 1 to tls2.count then
        tl = tls2[q]
        if((tl.locV mod 4) = 0)then
          if((tl.locH mod 6) = 0)then
            attemptDrawTempleStone(tl, tls, 2, layer, frntImg, tileCat)
            --else if((tl.locH mod 6) = 3)then
            --  attemptDrawTempleStone(tl, tls, 3, layer, frntImg, tileCat)
          end if
        end if
        if((tl.locV mod 4) = 2)then
          if((tl.locH mod 6) = 3)then
            attemptDrawTempleStone(tl, tls, 2, layer, frntImg, tileCat)
            --  else if((tl.locH mod 6) = 0)then
            --   attemptDrawTempleStone(tl, tls, 3, layer, frntImg, tileCat)
          end if
        end if
      end repeat
      
      repeat with q = 1 to templeStoneCorners[1].count then
        ind = templeStoneCorners[1].count + 1 - q
        if(templeStoneCorners[3].getPos(templeStoneCorners[1][ind]) > 0)then
          --  templeStoneCorners[3].deleteOne(templeStoneCorners[1][ind])
          tls.deleteOne(templeStoneCorners[1][ind])
          --  templeStoneCorners[1].deleteAt(ind)
        end if
      end repeat
      
      repeat with q = 1 to templeStoneCorners[2].count then
        ind = templeStoneCorners[2].count + 1 - q
        if(templeStoneCorners[4].getPos(templeStoneCorners[2][ind]) > 0)then
          --  templeStoneCorners[4].deleteOne(templeStoneCorners[2][ind])
          tls.deleteOne(templeStoneCorners[2][ind])
          --  templeStoneCorners[2].deleteAt(ind)
        end if
      end repeat
      
      
      
      
      repeat while tls.count > 0 then
        tl = tls[random(tls.count)]
        drawn = false
        if(templeStoneCorners[1].getPos(tl) > 0)then
          frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[7], frntImg)
          drawn = true
        else if(templeStoneCorners[2].getPos(tl) > 0)then
          frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[8], frntImg)
          drawn = true
        else if(templeStoneCorners[3].getPos(tl) > 0)then
          frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
          drawn = true
        else if(templeStoneCorners[4].getPos(tl) > 0)then
          frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[6], frntImg)
          drawn = true
        end if
        
        if(drawn = false)then
          occupy = [point(-1,0), point(-1,1), point(0,0), point(0,1), point(1,0), point(1,1)]
          drawn = true
          repeat with q = 1 to occupy.count then
            if(checkIfATileIsSolidAndSameMaterial(tl + occupy[q], layer, "Temple Stone") = false) then
              drawn = false
              exit repeat
            end if
            repeat with a = 1 to 4 then
              if(templeStoneCorners[a].getPos(tl + occupy[q]) > 0) then
                drawn = false
                exit repeat
              end if
            end repeat
            if(drawn = false)then
              exit repeat
            end if
            if(tls.getPos(tl + occupy[q]) = 0)then
              drawn = false
              exit repeat
            end if
          end repeat
          if(drawn)then
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[9], frntImg)
            repeat with q = 1 to occupy.count then
              tls.deleteOne(tl + occupy[q])
            end repeat
          end if
        end if
        
        if( drawn = false)then
          if(checkIfATileIsSolidAndSameMaterial(tl + point(-1,0), layer, "Temple Stone") and tls.getPos(tl + point(-1,0)) > 0) and(templeStoneCorners[1].getPos(tl+point(-1,0)) = 0)and(templeStoneCorners[2].getPos(tl+point(-1,0)) = 0)and(templeStoneCorners[3].getPos(tl+point(-1,0)) = 0)and(templeStoneCorners[4].getPos(tl+point(-1,0)) = 0)then
            frntImg = drawATileTile(tl.locH-1,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteOne(tl + point(-1,0))
          else if(checkIfATileIsSolidAndSameMaterial(tl + point(1,0), layer, "Temple Stone") and tls.getPos(tl + point(1,0)) > 0)and(templeStoneCorners[1].getPos(tl+point(1,0)) = 0)and(templeStoneCorners[2].getPos(tl+point(1,0)) = 0)and(templeStoneCorners[3].getPos(tl+point(1,0)) = 0)and(templeStoneCorners[4].getPos(tl+point(1,0)) = 0)then
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteOne(tl + point(1,0))
          else
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
          end if
        end if
        
        tls.deleteOne(tl)
      end repeat
      
      templeStoneCorners = []
      
      
    "4Mosaic":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "LB 4Mosaic")then
          exit repeat
        end if
      end repeat
      
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
            tls.deleteAt(cnt + 1 - q)
          3:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
            tls.deleteAt(cnt + 1 - q)
          4:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
            tls.deleteAt(cnt + 1 - q)
          5:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
            tls.deleteAt(cnt + 1 - q)
          6:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[6], frntImg)
            tls.deleteAt(cnt + 1 - q)
          1:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0, 7, 8, 9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
    "3DBricks":
      repeat with tileCat = getFirstTileCat() to gTiles.count then
        if(gTiles[tileCat].nm = "LB Missing 3DBricks")then
          exit repeat
        end if
      end repeat
      
      cnt =  tls.count
      repeat with q = 1 to cnt then
        tl = tls[cnt + 1 - q]
        case (afaMvLvlEdit(point(tl.locH, tl.locV), layer)) of
          2:
            if (gDRMatFixes) then
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[2], frntImg)
              tls.deleteAt(cnt + 1 - q)
            end if
          3:
            if (gDRMatFixes) then
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[3], frntImg)
              tls.deleteAt(cnt + 1 - q)
            end if
          4:
            if (gDRMatFixes) then
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[5], frntImg)
              tls.deleteAt(cnt + 1 - q)
            end if
          5:
            if (gDRMatFixes) then
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[4], frntImg)
              tls.deleteAt(cnt + 1 - q)
            end if
          6:
            if (gDRMatFixes) then
              frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[6], frntImg)
              tls.deleteAt(cnt + 1 - q)
            end if
          1:
            frntImg = drawATileTile(tl.locH,tl.locV,layer, gTiles[tileCat].tls[1], frntImg)
            tls.deleteAt(cnt + 1 - q)
          0, 7, 8, 9:
            tls.deleteAt(cnt + 1 - q)
        end case
      end repeat
      
    "Chaotic Greeble":
      -- Cursed material by Alduris
      savSeed = the randomSeed
      the randomSeed = gLOprops.tileSeed + layer
      
      -- Collect tiles that aren't completely air
      allTiles = []
      repeat with tlGrp in gTiles then
        repeat with tlCG in tlGrp.tls then
          if tlCG.tags <> VOID then
            if tlCG.tags.getPos("notChaos") > 0 then
              next repeat
            end if
          end if
          
          repeat with spec in tlCG.specs then
            if spec > 0 then
              allTiles.add(tlCG)
              exit repeat
            end if
          end repeat
        end repeat
      end repeat
      
      -- Do things!!
      cnt = tls.count
      repeat with q = 1 to cnt then
        if (tls.count = 0) then exit repeat
        tl = tls[random(tls.count)]
        
        -- Shuffle tiles
        randomTiles = []
        repeat with thisTl in allTiles then
          randomTiles.append([random(10000), thisTl])
        end repeat
        randomTiles.sort()
        
        -- Find a tile to place
        repeat with t = 1 to randomTiles.count then
          testTile = randomTiles[t][2]
          
          -- Determine legality of placement
          legalToPlace = true
          repeat with a = 0 to testTile.sz.locH-1 then
            repeat with b = 0 to testTile.sz.locV-1 then
              testPoint: point = tl + point(a,b)
              spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
              
              if spec <= 0 then next repeat -- ignore air and buffer
              
              if (tls.getPos(testPoint) = 0) then -- areas where material is not placed
                legalToPlace = false
                exit repeat
              end if
              
              geoSpec = afaMvLvlEdit(testPoint, layer)
              if (geoSpec <> spec) and (geoSpec <> 1) and (geoSpec <> 7)then
                -- spec does not match on non-solid tile
                legalToPlace = false
                exit repeat
              end if
            end repeat
            if (not legalToPlace) then exit repeat
          end repeat
          
          if legalToPlace then
            -- Place tile
            rootPos: point = tl + point(((testTile.sz.locH.float/2.0) + 0.4999).integer-1, ((testTile.sz.locV.float/2.0) + 0.4999).integer-1)
            if(rootPos.inside(rect(gRenderCameraTilePos, gRenderCameraTilePos+point(100, 60))))then
              frntImg = drawATileTile(rootPos.loch,rootPos.locV,layer,testTile, frntImg, [])
            end if
            
            -- Remove tile ref
            repeat with a = 0 to testTile.sz.locH-1 then
              repeat with b = 0 to testTile.sz.locV-1 then
                testPoint = tl + point(a,b)
                spec = testTile.specs[(b+1) + (a*testTile.sz.locV)]
                if spec > 0 then
                  tls.deleteAt(tls.getPos(testPoint))
                end if
              end repeat
            end repeat
            exit repeat
          end if
        end repeat
      end repeat
      
      the randomSeed = savSeed
  end case
  
  return frntImg
end

on attemptDrawTempleStone(tlPos, tilesList, templeStoneType, layer, frntImg, tileCat)
  global templeStoneCorners
  occupy = []
  
  case templeStoneType of
    2:
      occupy = [point(-1,0), point(0, -1), point(0,0), point(0,1), point(1,-1), point(1,0), point(1,1), point(2,0)]
    3:
      occupy = [point(0,0), point(1,0)]
  end case
  
  
  repeat with q = 1 to occupy.count then
    if(checkIfATileIsSolidAndSameMaterial(tlPos + occupy[q], layer, "Temple Stone") = 0)then
      return tilesList
    end if
  end repeat
  
  frntImg = drawATileTile(tlPos.locH,tlPos.locV,layer, gTiles[tileCat].tls[templeStoneType], frntImg)
  
  if(templeStoneType = 2)then
    templeStoneCorners[1].add(tlPos + point(-1, -1))
    templeStoneCorners[2].add(tlPos + point(2, -1))
    templeStoneCorners[3].add(tlPos + point(2, 1))
    templeStoneCorners[4].add(tlPos + point(-1, 1))
  end if
  
  repeat with q = 1 to occupy.count then
    tilesList.deleteOne(tlPos + occupy[q])
  end repeat
  return tilesList
end 

--on IsTileADoubleInChaoticStone(tl, lr)
--  if(tl.loch < 0)or(tl.locv < 0) then 
--    return false
--  end if
--  
--  if (checkIfATileIsSolidAndSameMaterial(tl, lr, "Chaotic Stone")) then
--    
--    savseed = the randomSeed
--    the randomSeed = SeedOfTile(tl)
--    rtrn = false
--    
--    if (random(3)>1) then
--      rtrn = true
--      repeat with dir in [point(1,0), point(0,1), point(1,1)] then
--     --   if(IsTileADoubleInChaoticStone(tl-dir, lr)) then return false
--        if (checkIfATileIsSolidAndSameMaterial(tl+dir, lr, "Chaotic Stone") = 0) then
--          rtrn = false
--          exit repeat
--        end if
--      end repeat
--    end if
--    
--    the randomSeed = savseed
--    return rtrn
--    
--    
--  else
--    return false  
--  end if
--end


on checkIfTileHasMaterialRenderTypeTiles(tl, lr)
  retrn = 0
  
  if (checkIfATileIsSolidAndSameMaterial(tl, lr, "Chaotic Stone"))or(checkIfATileIsSolidAndSameMaterial(tl, lr, "Tiled Stone"))then
    retrn = 1
  end if
  
  return retrn
end








on renderHarvesterDetails(q, c, l, tl, frntImg, dt)
  mdPnt = giveMiddleOfTile(point(q,c))
  
  big = (dt[2] = "Harvester B")
  put dt[2] && big
  if (big) then
    letter = "B"
    mdPnt.locH = mdPnt.locH + 10
    eyePoint = point(75, -126)
    armPoint = point(105, 108)
  else
    letter = "A"
    eyePoint = point(37, -85)
    armPoint = point(58, 60)
  end if
  
  actualQ = q + gRenderCameraTilePos.locH
  actualC = c + gRenderCameraTilePos.locV
  lowerPart = point(0,0)
  repeat with h = actualC to gTEprops.tlMatrix[actualQ].count then
    if (gTEprops.tlMatrix[actualQ][h][l].tp = "tileHead")then
      if(gTEprops.tlMatrix[actualQ][h][l].data[2] = "Harvester Arm " & letter)then
        lowerPart = point(q, h - gRenderCameraTilePos.locV)
      end if
    end if
  end repeat
  
  if(lowerPart <> point(0,0))then
    lowerPartPos = giveMiddleOfTile(lowerPart)
    if big then 
      lowerPartPos.locH = lowerPartPos.locH + 10
    end if
  end if
  
  repeat with side = 1 to 2 then
    dr = [-1, 1][side]
    eyePastePos = mdPnt + point(eyePoint.locH*dr, eyePoint.locV)
    mem = member("Harvester" & letter & "Eye")
    qd = rotateToQuad(rect(eyePastePos, eyePastePos) + rect(-mem.width/2, -mem.height/2, mem.width/2, mem.height/2), random(360))
    
    repeat with dpth = ((l-1)*10)+3 to ((l-1)*10)+6 then
      member("layer" & dpth).image.copyPixels(mem.image, qd, mem.image.rect, {#ink:36, #color:color(0, 255, 0)})
    end repeat 
  end repeat
end


on renderBeveledImage(img, dp, qd, bevel)
  
  boundrect = rect(10000, 10000, -10000, -10000)
  mrgn = 10
  repeat with pnt in qd then 
    if(pnt.locH-mrgn < boundrect.left)then
      boundrect.left = pnt.locH-mrgn
    end if
    if(pnt.locH+mrgn > boundrect.right)then
      boundrect.right = pnt.locH+mrgn
    end if
    if(pnt.locV-mrgn < boundrect.top)then
      boundrect.top = pnt.locV-mrgn
    end if
    if(pnt.locV+mrgn > boundrect.bottom)then
      boundrect.bottom = pnt.locV+mrgn
    end if
  
  end repeat
  
  qdOffset = [point(boundrect.left, boundrect.top),point(boundrect.left, boundrect.top),point(boundrect.left, boundrect.top),point(boundrect.left, boundrect.top)]
  
  dumpImg = image(boundrect.width,  boundrect.height, 1)
  dumpImg.copyPixels(img, qd-qdOffset, img.rect)
  inverseImg = makeSilhoutteFromImg(dumpImg, 1)
  
  
  dumpImg = image(boundrect.width,  boundrect.width, 32)
  dumpImg.copyPixels(member("pxl").image, dumpImg.rect, rect(0,0,1,1), {#color:color(0, 255, 0)})
  
  --  member("HEJHEJ").image = inverseImg
  repeat with b = 1 to bevel then
    repeat with a in [[color(255, 0, 0), point(-1, -1)],[color(255, 0, 0), point(0, -1)],[color(255, 0, 0), point(-1, 0)], [color(0, 0, 255), point(1, 1)],[color(0, 0, 255), point(0, 1)],[color(0, 0, 255), point(1, 0)]] then
      dumpImg.copyPixels(inverseImg, dumpImg.rect+rect(a[2]*b, a[2]*b), inverseImg.rect, {#color:a[1], #ink:36})
    end repeat
  end repeat
  
  dumpImg.copyPixels(inverseImg, dumpImg.rect, inverseImg.rect, {#color:color(255, 255, 255), #ink:36})
  
  
  -- inverseImg = image( dumpImg.width,  dumpImg.height, 1)
  -- inverseImg.copyPixels(member("pxl").image, inverseImg.rect, rect(0,0,1,1))
  -- inverseImg.copyPixels(member("pxl").image, inverseImg.rect, rect(0,0,1,1), {#color:color(255, 255, 255)})
  
  -- dumpImg.copyPixels(inverseImg, dumpImg.rect, inverseImg.rect, {#color:color(255, 255, 255), #ink:36})
  
  member("layer"&string(dp)).image.copyPixels(dumpImg, boundrect, dumpImg.rect, {#ink:36})
  
  
  
end






















