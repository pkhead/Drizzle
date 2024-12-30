global gSaveProps, gTEprops, gTiles, gLEProps, gFullRender, gEEprops, gEffects, gLightEProps, lvlPropOutput, gLEVEL, gLOprops, gLoadedName, gViewRender, gMassRenderL, gCameraProps, gImgXtra, gEnvEditorProps, gPEprops, altGrafLG, gMegaTrash, showControls, gProps, gLOADPATH, gTrashPropOptions, solidMtrx, INT_EXIT, INT_EXRD, DRCustomMatList, DRLastTL, gCustomEffects

on exitFrame me
  hadException: number = 0
  
  --  clearAsObjects()
  --  clearCache
  --  _global.clearGlobals()
  --  _movie.halt()
  member("editorConfig").importFileInto("editorConfig.txt")
  if (member("editorConfig").text = VOID) or (member("editorConfig").text = "") or (member("editorConfig").text.line[1] <> member("baseConfig").text.line[1]) then
    fileCo = new xtra("fileio")
    fileCo.createFile(the moviePath & "editorConfig.txt")
    fileCo.openFile(the moviePath & "editorConfig.txt", 0)
    fileCo.writeString(member("baseConfig").text)
    fileCo.writeReturn(#windows)
    member("editorConfig").text = member("baseConfig").text
    _movie.go(1)
    return
  end if
  
  clearLogs()
  if checkMinimize() then
    _player.appMinimize()
  end if
  _global.clearGlobals()
  _movie.exitLock = TRUE
  lvlPropOutput = FALSE
  initDRInternal()
  gFullRender = 1
  gViewRender = 1
  DRLastTL = 1
  gMassRenderL = []
  gLOADPATH = []
  
  gLEVEL = [#timeLimit:4800, #defaultTerrain:1, #maxFlies:10, #flySpawnRate:50, #lizards:[], #ambientSounds:[], #music:"NONE", #tags:[], #lightType:"Static", #waterDrips:1, #lightRect:rect(0,0,1040,800), #matrix:[]]
  
  _movie.window.appearanceOptions.border = #none
  _movie.window.resizable = FALSE
  
  gLoadedName = "New Project"
  member("level Name").text = "New Project"
  
  gImgXtra = xtra("ImgXtra").new()
  
  g: number = 21
  if (g=2) then
    gSaveProps = [baScreenInfo("width"), baScreenInfo("height"), baScreenInfo("depth")]
    
    fac: number = gSaveProps[1].float/gSaveProps[2] .float
    
    screenResolutionPoint = _system.deskTopRectList
    baSetDisplay(screenResolutionPoint.locH,screenResolutionPoint.locV,32,"temp", false)
    
    screenSize = _system.deskTopRectList/2
    
    midPos: point = screenResolutionPoint/2
    windowRect: rect = rect(midPos-screenSize, midPos+screenSize)
    _movie.window.rect = windowRect
    _movie.stage.drawRect = windowRect
  else
    gSaveProps = [1,1,1]
  end if
  
  solidMtrx = []
  
  -- LEVELEDITOR!!!!!
  cols: number = 72--gLOprops.size.loch
  rows: number = 43--gLOprops.size.locv
  
  gLEProps = [#matrix:[] , #levelEditors:[] , #toolMatrix:[],#camPos:point(0,0)]
  
  gLEProps.toolMatrix.add(["inverse", "paintWall", "paintAir", "slope"])
  gLEProps.toolMatrix.add(["floor", "squareWall", "squareAir", "move"])
  gLEProps.toolMatrix.add(["rock", "spear", "crack", ""])
  gLEProps.toolMatrix.add(["horBeam", "verBeam", "glass", "copyBack"])
  gLEProps.toolMatrix.add(["shortCutEntrance", "shortCut", "lizardHole", "playerSpawn"])
  gLEProps.toolMatrix.add(["forbidbats", "", "hive", "waterFall"])
  gLEProps.toolMatrix.add(["scavengerHole", "WHAMH", "garbageHole", "wormGrass"])
  gLEProps.toolMatrix.add(["workLayer","flip", "mirrorToggle", "setMirrorPoint"])
  
  
  
  ResetgEnvEditorProps()
  repeat with q = 1 to cols then
    ql: list = []
    repeat with c = 1 to rows then
      ql.add([[1, []], [1, []], [0, []]])
    end repeat
    gLEProps.matrix.add(ql)
  end repeat
  
  --TILEEDITOR!!!
  
  gTEprops = [#lastKeys:[], #keys:[], #workLayer:1, #lstMsPs:point(0,0), #tlMatrix:[], #defaultMaterial:"Concrete", #toolType:"material", #toolData:"Big Metal",\
  tmPos:point(1,1), #tmSavPosL:[], #specialEdit:0]
  
  repeat with q = 1 to cols then
    l: list = []
    repeat with c = 1 to rows then
      l.add([[#tp:"default", #data:0], [#tp:"default", #data:0], [#tp:"default", #data:0]])
    end repeat
    gTEprops.tlMatrix.add(l)
  end repeat
  member("layerText").text = "Layer:1"
  
  gTiles = []
  --CAT CHANGE
  gTiles.add([#nm:"Materials", #tls:[]])
  tilesInCat = gTiles[1].tls
  tilesInCat.add([#nm:"Standard", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(150,150,150)])
  tilesInCat.add([#nm:"Concrete", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(150,255,255)])
  tilesInCat.add([#nm:"RainStone", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(0,0,255)])
  tilesInCat.add([#nm:"Bricks", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(200,150,100)])
  tilesInCat.add([#nm:"BigMetal", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(255,0,0)])
  tilesInCat.add([#nm:"Tiny Signs", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(255,200,255)])
  tilesInCat.add([#nm:"Scaffolding", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(60,60,40)])
  tilesInCat.add([#nm:"Dense Pipes", #sz:point(1,1), #specs:[0], #renderType:"densePipeType", #color:color(0,0,150)])
  tilesInCat.add([#nm:"SuperStructure", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(160,180,255)])
  tilesInCat.add([#nm:"SuperStructure2", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(190,160,0)])
  tilesInCat.add([#nm:"Tiled Stone", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(100,0,255)])
  tilesInCat.add([#nm:"Chaotic Stone", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(255,0,255)])
  tilesInCat.add([#nm:"Small Pipes", #sz:point(1,1), #specs:[0], #renderType:"pipeType", #color:color(255,255,0)])
  tilesInCat.add([#nm:"Trash", #sz:point(1,1), #specs:[0], #renderType:"pipeType", #color:color(90,255,0)])
  tilesInCat.add([#nm:"Invisible", #sz:point(1,1), #specs:[0], #renderType:"invisibleI", #color:color(200,200,200)])
  tilesInCat.add([#nm:"LargeTrash", #sz:point(1,1), #specs:[0], #renderType:"largeTrashType", #color:color(175,30,255)])
  tilesInCat.add([#nm:"3DBricks", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(255,150,0)])
  tilesInCat.add([#nm:"Random Machines", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(72, 116, 80)])
  tilesInCat.add([#nm:"Dirt", #sz:point(1,1), #specs:[0], #renderType:"dirtType", #color:color(124, 72, 52)])
  tilesInCat.add([#nm:"Ceramic Tile", #sz:point(1,1), #specs:[0], #renderType:"ceramicType", #color:color(60, 60, 100)])
  tilesInCat.add([#nm:"Temple Stone", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(0, 120, 180)])
  tilesInCat.add([#nm:"Circuits", #sz:point(1,1), #specs:[0], #renderType:"densePipeType", #color:color(0,150,0)])
  tilesInCat.add([#nm:"Ridge", #sz:point(1, 1), #specs:[0], #renderType:"ridgeType", #color:color(200, 15, 60)])
  
  gTiles.add([#nm:"LB Materials", #tls:[]])
  tilesInCat = gTiles[2].tls
  tilesInCat.add([#nm:"Steel", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(220,170,195)])
  tilesInCat.add([#nm:"4Mosaic", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(227, 76, 13)])
  tilesInCat.add([#nm:"Color A Ceramic", #sz:point(1,1), #specs:[0], #renderType:"ceramicAType", #color:color(120, 0, 90)])
  tilesInCat.add([#nm:"Color B Ceramic", #sz:point(1,1), #specs:[0], #renderType:"ceramicBType", #color:color(0, 175, 175)])
  tilesInCat.add([#nm:"Random Pipes", #sz:point(1,1), #specs:[0], #renderType:"randomPipesType", #color:color(80,0,140)])
  tilesInCat.add([#nm:"Rocks", #sz:point(1,1), #specs:[0], #renderType:"rockType", #color:color(185,200,0)])
  tilesInCat.add([#nm:"Rough Rock", #sz:point(1,1), #specs:[0], #renderType:"roughRock", #color:color(155,170,0)])
  tilesInCat.add([#nm:"Random Metal", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(180, 10, 10)])
  tilesInCat.add([#nm:"Cliff", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(75, 75, 75)])
  tilesInCat.add([#nm:"Non-Slip Metal", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(180, 80, 80)])
  tilesInCat.add([#nm:"Stained Glass", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(180, 80, 180)])
  tilesInCat.add([#nm:"Sandy Dirt", #sz:point(1,1), #specs:[0], #renderType:"sandy", #color:color(180, 180, 80)])
  tilesInCat.add([#nm:"MegaTrash", #sz:point(1,1), #specs:[0], #renderType:"megaTrashType", #color:color(135,10,255)])
  tilesInCat.add([#nm:"Shallow Dense Pipes", #sz:point(1,1), #specs:[0], #renderType:"densePipeType", #color:color(13,23,110)])
  tilesInCat.add([#nm:"Sheet Metal", #sz:point(1, 1), #specs:[0], #renderType:"wv", #color:color(145, 135, 125)])
  tilesInCat.add([#nm:"Chaotic Stone 2", #sz:point(1, 1), #specs:[0], #renderType:"tiles", #color:color(90, 90, 90)])
  tilesInCat.add([#nm:"Asphalt", #sz:point(1, 1), #specs:[0], #renderType:"unified", #color:color(115, 115, 115)])
  
  gTiles.add([#nm:"Community Materials", #tls:[]])
  tilesInCat = gTiles[3].tls
  tilesInCat.add([#nm:"Shallow Circuits", #sz:point(1,1), #specs:[0], #renderType:"densePipeType", #color:color(15,200,155)])
  tilesInCat.add([#nm:"Random Machines 2", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(116, 116, 80)])
  tilesInCat.add([#nm:"Small Machines", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(80, 116, 116)])
  tilesInCat.add([#nm:"Random Metals", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(255, 0, 80)])
  tilesInCat.add([#nm:"ElectricMetal", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(255,0,100)])
  tilesInCat.add([#nm:"Grate", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(190,50,190)])
  tilesInCat.add([#nm:"CageGrate", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(50,190,190)])
  tilesInCat.add([#nm:"BulkMetal", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(50,19,190)])
  tilesInCat.add([#nm:"MassiveBulkMetal", #sz:point(1,1), #specs:[0], #renderType:"unified", #color:color(255,19,19)])
  tilesInCat.add([#nm:"Dune Sand", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(255, 255, 100)])
  tilesInCat.add([#nm:"Chaotic Greeble", #sz:point(1,1), #specs:[0], #renderType:"tiles", #color:color(100,100,100)])
  
  savLM = member("matInit")
  member("matInit").importFileInto("Materials" & the dirSeparator & "Init.txt")
  savLM.name = "matInit"
  DRCustomMatList = []
  if (savLM.text <> VOID) and (savLM.text <> "") then
    repeat with ln = 1 to the number of lines in savLM.text
      lin = savLM.text.line[ln]
      if (lin <> "") then
        if (lin.char[1] = "-") then
          gTiles.add([#nm:lin.char[2..lin.length], #tls:[]])
          repeat with efLn = ln + 1 to the number of lines in savLM.text
            efLin = savLM.text.line[efLn]
            if (efLin.char[1] = "-") then
              exit repeat
            else if (efLin <> "") then
              gtlCnt = gTiles[gTiles.count]
              gtlCnt.tls.add(value(efLin))
              matTl = gtlCnt.tls[gtlCnt.tls.count]
              matTl[#sz] = point(1, 1)
              matTl[#specs] = [0]
              if matTl.findPos(#autofit) then matTl[#renderType] = "customAutofit"
              else matTl[#renderType] = "customUnified"
              DRCustomMatList.add(matTl)
              
              -- Deal with autofit material
              if (matTl[#renderType] = "customAutofit") then
                afMat = member("initImport")
                afMat.text = ""
                member("initImport").importFileInto("Materials" & the dirSeparator & matTl.nm & ".txt")
                afMat.name = "initImport"
                
                -- Make sure parts are correct
                if (not ilk(matTl.autofit, #proplist)) then matTl.autofit = [:]
                if (not matTl.autofit.findPos(#categories)) then matTl.autofit[#categories] = []
                if (not matTl.autofit.findPos(#tiles)) then matTl.autofit[#tiles] = []
                if (not matTl.autofit.findPos(#ignoreTiles)) then matTl.autofit[#ignoreTiles] = []      
                
                -- Import information
                importPart = 0
                repeat with matLnNo = 1 to the number of lines in afMat.text
                  matLn = afMat.text.line[matLnNo]
                  if (matLn = "-Categories") then
                    importPart = 1
                  else if (matLn = "-Tiles") then
                    importPart = 2
                  else if (matLn = "-Ignore Tiles") then
                    importPart = 3
                  else if (matLn <> "") then
                    case importPart of
                      1:
                        matTl.autofit.categories.append(matLn)
                      2:
                        matTl.autofit.tiles.append(matLn)
                      3:
                        matTl.autofit.ignoreTiles.append(matLn)
                    end case
                  end if
                end repeat
              end if
            end if
          end repeat
          ln = efLn - 1
        end if
      end if
    end repeat
    if (gTiles.count >= 1) then
      repeat with del = 1 to gTiles.count
        if (gTiles[del].tls.count < 1) then
          gTiles.deleteAt(del)
        end if
      end repeat
    end if
  end if
  setLastMatCat(gTiles.count)
  
  gTiles.add([#nm:"Special", #tls:[]])
  tilesInCat = gTiles[gTiles.count].tls
  tilesInCat.add([#nm:"Rect Clear", #sz:point(1,1), #specs:[0], #placeMethod:"rect", #color:color(255, 0, 0)])
  tilesInCat.add([#nm:"SH pattern box", #sz:point(1,1), #specs:[0], #placeMethod:"rect", #color:color(210, 0, 255)])
  tilesInCat.add([#nm:"SH grate box", #sz:point(1,1), #specs:[0], #placeMethod:"rect", #color:color(160, 0, 255)])
  -- LB
  tilesInCat.add([#nm:"Alt Grate Box", #sz:point(1,1), #specs:[0], #placeMethod:"rect", #color:color(75, 75, 240)])
  setFirstTileCat(gTiles.count + 1)
  
  sav = member("initImport")
  member("initImport").importFileInto("Graphics" & the dirSeparator & "Init.txt")
  sav.text = sav.text&RETURN&RETURN&member("Drought Needed Init").text
  sav.name = "initImport"
  
  member("previewTiles").image = image(60000, 500, 1)
  ptPos = 1
  member("previewTilesDR").image = image(1, 1, 1)
  drPos = 1
  
  if (getBoolConfig("More tile previews")) then
    member("previewTilesDR").image = image(60000, 500, 1)
  end if
  
  moreTilePreviews = getBoolConfig("More tile previews")
  prevw = member("previewTiles").image
  drprevw = member("previewTilesDR").image
  repeat with q = 1 to the number of lines in sav.text then
    savTextLine: string = sav.text.line[q]
    if (savTextLine <> "") then
      if (savTextLine.char[1] = "-") then
        vl = value(savTextLine.char[2..savTextLine.length])
        if (vl = VOID) then
          writeException("Tile Init Error", "Line " && q && " is malformed in the Init.txt file from your Graphics folder.")
          hadException = 1
        else
          gTiles.add([#nm:vl[1], #clr:vl[2], #tls:[]])
        end if
      else if (value(savTextLine) = VOID) then
        writeException("Tile Init Error", "Line " && q && " is malformed in the Init.txt file from your Graphics folder.")
        hadException = 1
      else
        if checkIsDrizzleRendering() then
          -- Optimization for when only rendering, we don't need to copy previews. So long as it gets implemented, that is.
          ad = value(savTextLine)
          if (ad.tags.getPos("notTile") = 0) then
            gTiles[gTiles.count].tls.add(ad)
          end if
        else
          -- Import tile preview
          ad = value(savTextLine)
          if ad.findPos("ptPos") = 0 then
            -- add if missing
            ad[#ptPos] = 0
          end if
          
          sav2 = member("previewImprt")
          member("previewImprt").importFileInto("Graphics" & the dirSeparator & ad.nm & ".png")
          sav2.name = "previewImprt"
          --INTERNAL
          if (checkDRInternal(ad.nm)) then
            sav2.image = member(ad.nm).image
          end if
          calculatedHeight = sav2.image.rect.height
          vertSZ = 16 * ad.sz.locV
          horiSZ = 16 * ad.sz.locH
          if (ad.tp = "voxelStruct") then
            calculatedHeight = 1 + vertSZ + (20 * (ad.sz.locV + (ad.bfTiles * 2)) * ad.repeatL.count)
          end if
          rct = rect(0, calculatedHeight - vertSZ, horiSZ, calculatedHeight)
          if ((ptPos + horiSZ + 1) > prevw.width) and (moreTilePreviews) then
            drprevw.copyPixels(sav2.image, rect(drPos, 0, drPos + horiSZ, vertSZ), rct)
            ad.ptPos = drPos + 60000
            ad.addProp(#category, gTiles.count)
            if (ad.tags.getPos("notTile") = 0) then
              gTiles[gTiles.count].tls.add(ad)
            end if
            drPos = drPos + horiSZ + 1
          else
            prevw.copyPixels(sav2.image, rect(ptPos, 0, ptPos + horiSZ, vertSZ), rct)
            ad.ptPos = ptPos
            ad.addProp(#category, gTiles.count)
            if (ad.tags.getPos("notTile") = 0) then
              gTiles[gTiles.count].tls.add(ad)
            end if
            ptPos = ptPos + horiSZ + 1  
          end if
        end if
      end if
    end if
  end repeat
  
  altGrafLG = "1"
  gProps = []
  
  resetPropEditorProps()
  
  global gPEcolors
  gPEcolors = []
  sav = member("initImport")
  member("initImport").importFileInto("Props" & the dirSeparator & "propColors.txt")
  sav.name = "initImport"
  repeat with q = 1 to the number of lines in sav.text then
    if sav.text.line[q] <> "" then
      gPEcolors.add(value(sav.text.line[q]))
    end if
  end repeat
  
  sav = member("initImport")
  member("initImport").importFileInto("Props" & the dirSeparator & "Init.txt")
  sav.name = "initImport"
  
  repeat with q = 1 to 1000 ---- PJB fix 2000 --> 1000
    (member q of castLib 2).erase()
  end repeat
  
  repeat with q = 1 to the number of lines in sav.text
    savTextLine = sav.text.line[q]
    if (savTextLine <> "") then
      if (savTextLine.char[1] = "-") then
        vl = value(savTextLine.char[2..savTextLine.length])
        if (vl = VOID) then
          writeException("Prop Init Error", "Line " && q && " is malformed in the Init.txt file from your Props folder.")
          hadException = 1
        else
          gProps.add([#nm:vl[1], #clr:vl[2], #prps:[]])
        end if
      else if (value(savTextLine) = VOID) then
        writeException("Prop Init Error", "Line " && q && " is malformed in the Init.txt file from your Props folder.")
        hadException = 1
      else
        ad = value(savTextLine)
        ad.addProp(#category, gProps.count)
        if (ad.tp = "standard") or (ad.tp = "variedStandard") then
          dp: number = 0
          repeat with i = 1 to ad.repeatL.count
            dp = dp + ad.repeatL[i]
          end repeat
          ad.addProp(#depth, dp)
        end if
        gProps[gProps.count].prps.add(ad)
      end if
    end if
  end repeat
  
  gPageCount = 0
  gPageTick = 0
  
  --CAT CHANGE
  rndDisF = getBoolConfig("voxelStructRandomDisplace for tiles as props")
  tAsPFixes = getBoolConfig("Tiles as props fixes")
  repeat with q = getFirstTileCat() to gTiles.count
    repeat with c = 1 to gTiles[q].tls.count
      if gPageTick = 0 then
        gPageTick = 21
        gPageCount = gPageCount + 1
        gProps.add([#nm:"Tiles as props " & gPageCount, #clr:color(255, 0,0), #prps:[]])
      end if
      tl = gTiles[q].tls[c]
      if((tl.tp = "voxelStruct") or (tl.tp = "voxelStructRandomDisplaceVertical" and rndDisF) or (tl.tp = "voxelStructRandomDisplaceHorizontal" and rndDisF))and(tl.tags.getPos("notProp") = 0)then
        --Ugly part Ik
        eCAT = ""
        eCBT = ""
        dcT = ""
        cCT = ""
        cCRT = ""
        rRT = ""
        rFXT = ""
        rFYT = ""
        cST = ""
        cSBT = ""
        lST = ""
        lSBT = ""
        dRT = ""
        INTE = ""
        NMTP = ""
        if (tl.tags.getPos("notMegaTrashProp") > 0) then
          NMTP = "notMegaTrashProp"
        end if
        if(tl.tags.getPos("effectColorA") > 0) then
          eCAT = "effectColorA"
        end if
        if(tl.tags.getPos("effectColorB") > 0) then
          eCBT = "effectColorB"
        end if
        if(tl.tags.getPos("colored") > 0) then
          dcT = "colored"
        end if
        if(tl.tags.getPos("customColor") > 0) then
          cCT = "customColor"
        end if
        if(tl.tags.getPos("customColorRainbow") > 0) then
          cCRT = "customColorRainbow"
        end if
        if(tl.tags.getPos("randomRotat") > 0) then
          rRT = "randomRotat"
        end if
        if(tl.tags.getPos("randomFlipX") > 0) then
          rFXT = "randomFlipX"
        end if
        if(tl.tags.getPos("randomFlipY") > 0) then
          rFYT = "randomFlipY"
        end if
        if(tl.tags.getPos("Circular Sign") > 0) then
          cST = "Circular Sign"
        end if
        if(tl.tags.getPos("Circular Sign B") > 0) then
          cSBT = "Circular Sign B"
        end if
        if(tl.tags.getPos("Larger Sign") > 0) then
          lST = "Larger Sign"
        end if
        if(tl.tags.getPos("Larger Sign B") > 0) then
          lSBT = "Larger Sign B"
        end if
        if(tl.tags.getPos("notTrashProp") > 0)then
          nTP = "notTrashProp"
        end if
        if(tl.tags.getPos("INTERNAL") > 0)then
          INTE = "INTERNAL"
        end if
        --End ugly part
        if (tAsPFixes) then
          if (tl.rnd > 1)then
            ad = [#nm:tl.nm, #tp:"variedStandard", #colorTreatment:"standard", #sz:tl.sz + point(tl.bfTiles*2, tl.bfTiles*2), #depth:10 + (tl.specs2 <> [])*10, #repeatL:tl.repeatL, #vars:tl.rnd, #random:1, #tags:["Tile", nTP, eCAT, eCBT, dcT, cCT, cCRT, rRT, rFXT, rFYT, cST, cSBT, lST, lSBT, INTE, NMTP], #layerExceptions:[], #notes:["Tile as prop"]]
          else
            ad = [#nm:tl.nm, #tp:"standard", #colorTreatment:"standard", #sz:tl.sz + point(tl.bfTiles*2, tl.bfTiles*2), #depth:10 + (tl.specs2 <> [])*10, #repeatL:tl.repeatL, #tags:["Tile", nTP, eCAT, eCBT, dcT, cCT, cCRT, rRT, rFXT, rFYT, cST, cSBT, lST, lSBT, INTE, NMTP], #layerExceptions:[], #notes:["Tile as prop"]]
          end if
        else
          ad = [#nm:tl.nm, #tp:"standard", #colorTreatment:"standard", #sz:tl.sz + point(tl.bfTiles*2, tl.bfTiles*2), #depth:10 + (tl.specs2 <> [])*10, #repeatL:tl.repeatL, #tags:["Tile", nTP, INTE, NMTP], #layerExceptions:[], #notes:["Tile as prop"]]
        end if
        ad.addProp(#category, gProps.count)
        gProps[gProps.count].prps.add(ad)
        gPageTick = gPageTick - 1
      end if
    end repeat
  end repeat
  
  repeat with prq = 1 to gProps.count
    if (gProps[prq].prps.count <= 0) then
      gProps.deleteAt(prq)
    end if
  end repeat
  
  gProps.add([#nm:"Rope type props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Wire", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:3, #collisionDepth:0, #segRad:1, #grav:0.5, #friction:0.5, #airFric:0.9, #stiff:0, #previewColor:color(255,0, 0), #previewEvery:4, #edgeDirection:0, #rigid:0, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"Tube", #tp:"rope", #depth:4, #tags:[], #notes:[], #segmentLength:10, #collisionDepth:2, #segRad:4.5, #grav:0.5, #friction:0.5, #airFric:0.9, #stiff:1, #previewColor:color(0,0, 255), #previewEvery:2, #edgeDirection:5, #rigid:1.6, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"ThickWire", #tp:"rope", #depth:3, #tags:[], #notes:[], #segmentLength:4, #collisionDepth:1, #segRad:2, #grav:0.5, #friction:0.8, #airFric:0.9, #stiff:1, #previewColor:color(255,255, 0), #previewEvery:2, #edgeDirection:0, #rigid:0.2, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"RidgedTube", #tp:"rope", #depth:4, #tags:[], #notes:[], #segmentLength:5, #collisionDepth:2, #segRad:5, #grav:0.5, #friction:0.3, #airFric:0.7, #stiff:1, #previewColor:color(255,0,255), #previewEvery:2, #edgeDirection:0, #rigid:0.1, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"Fuel Hose", #tp:"rope", #depth:5, #tags:[], #notes:[], #segmentLength:16, #collisionDepth:1, #segRad:7, #grav:0.5, #friction:0.8, #airFric:0.9, #stiff:1, #previewColor:color(255,150,0), #previewEvery:1, #edgeDirection:1.4, #rigid:0.2, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"Broken Fuel Hose", #tp:"rope", #depth:6, #tags:[], #notes:[], #segmentLength:16, #collisionDepth:1, #segRad:7, #grav:0.5, #friction:0.8, #airFric:0.9, #stiff:1, #previewColor:color(255,150,0), #previewEvery:1, #edgeDirection:1.4, #rigid:0.2, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"Large Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:28, #collisionDepth:3, #segRad:9.5, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(0,255,0), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  propsInCat.add([#nm:"Large Chain 2", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:28, #collisionDepth:3, #segRad:9.5, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(20,205,0), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  propsInCat.add([#nm:"Bike Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:38, #collisionDepth:3, #segRad:16.5, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(100,100,100), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:16.5, #sourcePush:0])
  propsInCat.add([#nm:"Zero-G Tube", #tp:"rope", #depth:4, #tags:[], #notes:[], #segmentLength:10, #collisionDepth:2, #segRad:4.5, #grav:0, #friction:0.5, #airFric:0.9, #stiff:1, #previewColor:color(0,255, 0), #previewEvery:2, #edgeDirection:0, #rigid:0.6, #selfPush:2, #sourcePush:0.5])
  propsInCat.add([#nm:"Zero-G Wire", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:8, #collisionDepth:0, #segRad:1, #grav:0, #friction:0.5, #airFric:0.9, #stiff:1, #previewColor:color(255,0, 0), #previewEvery:2, #edgeDirection:0.3, #rigid:0.5, #selfPush:1.2, #sourcePush:0.5])
  propsInCat.add([#nm:"Fat Hose", #tp:"rope", #depth:6, #tags:[], #notes:[], #segmentLength:40, #collisionDepth:3, #segRad:20, #grav:0.9, #friction:0.6, #airFric:0.95, #stiff:1, #previewColor:color(0,100,150), #previewEvery:1, #edgeDirection:0.1, #rigid:0.2, #selfPush:10, #sourcePush:0.1])
  propsInCat.add([#nm:"Wire Bunch", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:50, #collisionDepth:3, #segRad:20, #grav:0.9, #friction:0.6, #airFric:0.95, #stiff:1, #previewColor:color(255,100,150), #previewEvery:1, #edgeDirection:0.1, #rigid:0.2, #selfPush:10, #sourcePush:0.1])
  propsInCat.add([#nm:"Wire Bunch 2", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:50, #collisionDepth:3, #segRad:20, #grav:0.9, #friction:0.6, #airFric:0.95, #stiff:1, #previewColor:color(255,100,150), #previewEvery:1, #edgeDirection:0.1, #rigid:0.2, #selfPush:10, #sourcePush:0.1])
  
  gProps.add([#nm:"LB Rope Props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Big Big Pipe", #tp:"rope", #depth:6, #tags:[], #notes:[], #segmentLength:40, #collisionDepth:3, #segRad:20, #grav:0.9, #friction:0.6, #airFric:0.95, #stiff:1, #previewColor:color(50,150,210), #previewEvery:1, #edgeDirection:0.1, #rigid:0.2, #selfPush:10, #sourcePush:0.1])
  propsInCat.add([#nm:"Ring Chain", #tp:"rope", #depth:6, #tags:[], #notes:[], #segmentLength:40, #collisionDepth:3, #segRad:20, #grav:0.9, #friction:0.6, #airFric:0.95, #stiff:1, #previewColor:color(100,200,0), #previewEvery:1, #edgeDirection:0.1, #rigid:0.2, #selfPush:10, #sourcePush:0.1])
  propsInCat.add([#nm:"Christmas Wire", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:17, #collisionDepth:0, #segRad:8.5, #grav:0.5, #friction:0.5, #airFric:0.9, #stiff:0, #previewColor:color(200,0, 200), #previewEvery:1, #edgeDirection:0, #rigid:0, #selfPush:0, #sourcePush:0])
  propsInCat.add([#nm:"Ornate Wire", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:17, #collisionDepth:0, #segRad:8.5, #grav:0.5, #friction:0.5, #airFric:0.9, #stiff:0, #previewColor:color(0,200, 200), #previewEvery:1, #edgeDirection:0, #rigid:0, #selfPush:0, #sourcePush:0])
  
  gProps.add([#nm:"Alduris Rope Props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Small Chain", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:22, #collisionDepth:0, #segRad:3, #grav:0.5, #friction:0.65, #airFric:0.95, #stiff:1, #previewColor:color(255,0,150), #previewEvery:2, #edgeDirection:0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  propsInCat.add([#nm:"Fat Chain", #tp:"rope", #depth:0, #tags:[], #notes:[], #segmentLength:44, #collisionDepth:0, #segRad:8, #grav:0.5, #friction:0.65, #airFric:0.95, #stiff:1, #previewColor:color(255,0,150), #previewEvery:2, #edgeDirection:0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  
  gProps.add([#nm:"Dakras Rope Props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Big Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:56, #collisionDepth:3, #segRad:19, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(0,255,40), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  propsInCat.add([#nm:"Chunky Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:28, #collisionDepth:3, #segRad:19, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(0,255,40), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:6.5, #sourcePush:0])
  propsInCat.add([#nm:"Big Bike Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:76, #collisionDepth:3, #segRad:33, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(100,150,100), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:33, #sourcePush:0])
  propsInCat.add([#nm:"Huge Bike Chain", #tp:"rope", #depth:9, #tags:[], #notes:[], #segmentLength:152, #collisionDepth:3, #segRad:66, #grav:0.9, #friction:0.8, #airFric:0.95, #stiff:1, #previewColor:color(100,200,100), #previewEvery:1, #edgeDirection:0.0, #rigid:0.0, #selfPush:66, #sourcePush:0])
  
  gProps.add([#nm:"Long props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Cabinet Clamp", #tp:"long", #depth:0, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Drill Suspender", #tp:"long", #depth:5, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Thick Chain", #tp:"long", #depth:0, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Drill", #tp:"long", #depth:10, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Piston", #tp:"long", #depth:4, #tags:[], #notes:[]])
  
  gProps.add([#nm:"LB Long Props", #clr:color(0, 255, 0), #prps:[]])
  propsInCat = gProps[gProps.count].prps
  propsInCat.add([#nm:"Stretched Pipe", #tp:"long", #depth:0, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Twisted Thread", #tp:"long", #depth:0, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Stretched Wire", #tp:"long", #depth:0, #tags:[], #notes:[]])
  propsInCat.add([#nm:"Long Barbed Wire", #tp:"long", #depth:0, #tags:[], #notes:[]])
  
  gTrashPropOptions = []
  gMegaTrash = []
  ntrashPFix = getBoolConfig("notTrashProp fix")
  repeat with q = 1 to gProps.count then
    repeat with c = 1 to gProps[q].prps.count then
      gProps[q].prps[c].addProp(#settings, [:])
      gProps[q].prps[c].settings.addProp(#renderOrder, 0)
      gProps[q].prps[c].settings.addProp(#seed, 500)
      gProps[q].prps[c].settings.addProp(#renderTime, 0)
      case gProps[q].prps[c].tp of
        "standard", "variedStandard":
          
          if(gProps[q].prps[c].colorTreatment = "bevel")then
            gProps[q].prps[c].notes.add("The highlights and shadows on this prop are generated by code, so it can be rotated to any degree and they will remain correct.")
          else
            gProps[q].prps[c].notes.add("Be aware that shadows and highlights will not rotate with the prop, so extreme rotations may cause incorrect shading.")
          end if
          
          if gProps[q].prps[c].tp = "variedStandard" then
            gProps[q].prps[c].settings.addProp(#variation, (gProps[q].prps[c].random = 0))
            
            if(gProps[q].prps[c].random)then
              gProps[q].prps[c].notes.add("Will put down a random variation. A specific variation can be selected from settings ('N' key).")
            else
              gProps[q].prps[c].notes.add("This prop comes with many variations. Which variation can be selected from settings ('N' key).")
            end if
            
          else
            if(gProps[q].prps[c].sz.locH < 5)and(gProps[q].prps[c].sz.locV < 5) and (gProps[q].prps[c].tags.getPos("INTERNAL") = 0) and (gProps[q].prps[c].tags.getPos("notTrashProp") = 0 or ntrashPFix = FALSE) then
              gTrashPropOptions.add(point(q,c))
              if(gProps[q].prps[c].sz.locH < 3)or(gProps[q].prps[c].sz.locV < 3)then
                gTrashPropOptions.add(point(q,c))
              end if
            end if
            if(gProps[q].prps[c].sz.locH >= 4)and(gProps[q].prps[c].sz.locV >= 4)and(gProps[q].prps[c].sz.locH <= 20)and(gProps[q].prps[c].sz.locV <= 20)and(gProps[q].prps[c].tags.getPos("colored") = 0)and(gProps[q].prps[c].tags.getPos("effectColorB") = 0)and(gProps[q].prps[c].tags.getPos("effectColorA") = 0)and(gProps[q].prps[c].tags.getPos("notMegaTrashProp") = 0)then
              gMegaTrash.add(point(q,c))
            end if
          end if
          
        "rope":
          gProps[q].prps[c].settings.addProp(#release, 0)
        "customRope":
          gProps[q].prps[c].settings.addProp(#release, 0)
          if (gProps[q].prps[c].colorTreatment = "bevel") then
            gProps[q].prps[c].notes.add("The highlights and shadows on this prop are generated by code, so it can be rotated to any degree and they will remain correct.")
          else
            gProps[q].prps[c].notes.add("Be aware that shadows and highlights will not rotate with the prop, so extreme rotations may cause incorrect shading.")
          end if
        "variedDecal", "variedSoft":
          gProps[q].prps[c].settings.addProp(#variation, (gProps[q].prps[c].random = 0))
          gProps[q].prps[c].settings.addProp(#customDepth, gProps[q].prps[c].depth)
          
          if(gProps[q].prps[c].random)then
            gProps[q].prps[c].notes.add("Will put down a random variation. A specific variation can be selected from settings ('N' key).")
          else
            gProps[q].prps[c].notes.add("This prop comes with many variations. Which variation can be selected from settings ('N' key).")
          end if
          
          if(gProps[q].prps[c].tp = "variedSoft") or (gProps[q].prps[c].tp = "coloredSoft")then
            if(gProps[q].prps[c].colorize)then
              gProps[q].prps[c].settings.addProp(#applyColor, 1)
              gProps[q].prps[c].notes.add("It's recommended to render this prop after the effects if the color is activated, as the effects won't affect the color layers.")
            end if
          end if
          
        "simpleDecal", "soft", "softEffect", "antimatter", "coloredSoft":
          gProps[q].prps[c].settings.addProp(#customDepth, gProps[q].prps[c].depth)
      end case
      
      if(gProps[q].prps[c].tp = "soft")or(gProps[q].prps[c].tp = "softEffect")or(gProps[q].prps[c].tp = "variedSoft")or(gProps[q].prps[c].tp = "coloredSoft")then
        if(gProps[q].prps[c].selfShade = 1)then
          gProps[q].prps[c].notes.add("The highlights and shadows on this prop are generated by code, so it can be rotated to any degree and they will remain correct.")
        else
          gProps[q].prps[c].notes.add("Be aware that shadows and highlights will not rotate with the prop, so extreme rotations may cause incorrect shading.")
        end if
      end if
      
      case gProps[q].prps[c].nm of
        "wire", "Zero-G Wire", "Straight wire", "Straight Zero-G Wire":
          gProps[q].prps[c].settings.addProp(#thickness, 2)
          gProps[q].prps[c].notes.add("The thickness of the wire can be set in settings.")
        "Zero-G Tube", "Straight Zero-G Tube":
          gProps[q].prps[c].settings.addProp(#applyColor, 0)
          gProps[q].prps[c].notes.add("The tube can be colored white through the settings.")
      end case
      
      repeat with t in gProps[q].prps[c].tags then
        case t of
          "customColor":
            gProps[q].prps[c].settings.addProp(#color, 0)
            gProps[q].prps[c].notes.add("Custom color available")
          "customColorRainBow":
            gProps[q].prps[c].settings.addProp(#color, 1)
            gProps[q].prps[c].notes.add("Custom color available")
        end case
      end repeat
      
    end repeat
  end repeat
  
  --EFFECTS EDITOR!
  gEffects = []
  savEf = member("effectsInit")
  member("effectsInit").importFileInto("effectsInit.txt")
  savEf.name = "effectsInit"
  if (savEf.text = VOID) or (savEf.text = "") or (savEf.text.line[1] <> member("baseEffectsInit").text.line[1]) then
    fileEf = new xtra("fileio")
    fileEf.createFile(the moviePath & "effectsInit.txt")
    fileEf.openFile(the moviePath & "effectsInit.txt", 0)
    fileEf.writeString(member("baseEffectsInit").text)
    fileEf.writeReturn(#windows)
    savEf.text = member("baseEffectsInit").text
  end if
  repeat with ln = 1 to the number of lines in savEf.text
    lin = savEf.text.line[ln]
    if (lin <> "") then
      if (lin.char[1] = "-") then
        gEffects.add([#nm:lin.char[2..lin.length], #efs:[]])
        repeat with efLn = ln + 1 to the number of lines in savEf.text
          efLin = savEf.text.line[efLn]
          if (efLin.char[1] = "-") then
            exit repeat
          else if (efLin <> "") then
            gEffects[gEffects.count].efs.add([#nm:efLin])
          end if
        end repeat
        ln = efLn - 1
      end if
    end if
  end repeat
  if (gEffects.count >= 1) then
    repeat with del = 1 to gEffects.count
      if (gEffects[del].efs.count < 1) then
        gEffects.deleteAt(del)
      end if
    end repeat
  end if
  if (gEffects.count < 1) then
    gEffects.add([#nm:"Natural", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Slime"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Melt"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Rust"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Barnacles"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Rubble"]    )
    gEffects[gEffects.count].efs.add( [#nm:"DecalsOnlySlime"]    )
    
    gEffects.add([#nm:"Erosion", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Roughen"]    )
    gEffects[gEffects.count].efs.add( [#nm:"SlimeX3"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Super Melt"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Destructive Melt"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Erode"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Super Erode"]    )
    gEffects[gEffects.count].efs.add( [#nm:"DaddyCorruption"]    )
    
    gEffects.add([#nm:"Artificial", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Wires"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Chains"]    )
    
    gEffects.add([#nm:"Plants", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Root Grass"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Seed Pods"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Growers"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Cacti"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Rain Moss"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Hang Roots"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Grass"]    )
    
    gEffects.add([#nm:"Plants2", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Arm Growers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Horse Tails"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Circuit Plants"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Feather Plants"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Thorn Growers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Rollers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Garbage Spirals"]   )
    
    gEffects.add([#nm:"Plants3", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Thick Roots"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Shadow Plants"]   )
    
    gEffects.add([#nm:"Plants (Individual)", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Fungi Flowers"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Lighthouse Flowers"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Fern"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Giant Mushroom"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Sprawlbush"]    )
    gEffects[gEffects.count].efs.add( [#nm:"featherFern"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Fungus Tree"]    )
    
    gEffects.add([#nm:"Paint Effects", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"BlackGoo"]    )
    gEffects[gEffects.count].efs.add( [#nm:"DarkSlime"]    )
    
    gEffects.add([#nm:"Restoration", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Restore As Scaffolding"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Ceramic Chaos"]    )
    
    gEffects.add([#nm:"LB Plants", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Colored Hang Roots"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Thick Roots"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Shadow Plants"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Lighthouse Flowers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Fungi Flowers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Root Plants"]   )
    
    gEffects.add([#nm:"LB Plants 2", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Foliage"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Mistletoe"]   )
    gEffects[gEffects.count].efs.add( [#nm:"High Fern"]   )
    gEffects[gEffects.count].efs.add( [#nm:"High Grass"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Little Flowers"]   )
    gEffects[gEffects.count].efs.add( [#nm:"Wastewater Mold"]   )
    
    gEffects.add([#nm:"LB Plants 3", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Spinets"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Small Springs"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Mini Growers"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Clovers"]   )
    gEffects[gEffects.count].efs.add([#nm:"Reeds"])
    gEffects[gEffects.count].efs.add([#nm:"Lavenders"])
    gEffects[gEffects.count].efs.add([#nm:"Dense Mold"])
    
    gEffects.add([#nm:"LB Erosion", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Ultra Super Erode"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Impacts"]    )
    
    gEffects.add([#nm:"LB Paint Effects", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Super BlackGoo"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Stained Glass Properties"]    )
    
    gEffects.add([#nm:"LB Natural", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Colored Barnacles"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Rubble"]    )
    gEffects[gEffects.count].efs.add([#nm:"Fat Slime"])
    gEffects[gEffects.count].efs.add([#nm:"Sand"])
    
    gEffects.add([#nm:"LB Artificial", #efs:[]])
    gEffects[gEffects.count].efs.add( [#nm:"Assorted Trash"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Wires"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Colored Chains"]    )
    gEffects[gEffects.count].efs.add( [#nm:"Ring Chains"]    )
    
    gEffects.add([#nm:"Dakras Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Left Facing Kelp"])
    gEffects[gEffects.count].efs.add([#nm:"Right Facing Kelp"])
    gEffects[gEffects.count].efs.add([#nm:"Mixed Facing Kelp"])
    gEffects[gEffects.count].efs.add([#nm:"Bubble Grower"])
    gEffects[gEffects.count].efs.add([#nm:"Moss Wall"])
    gEffects[gEffects.count].efs.add([#nm:"Club Moss"])
    gEffects[gEffects.count].efs.add([#nm:"Dandelions"])
    
    gEffects.add([#nm:"Leo Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Ivy"])
    
    gEffects.add([#nm:"Nautillo Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Fuzzy Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Leaf Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Meat Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Hyacinths"])
    gEffects[gEffects.count].efs.add([#nm:"Seed Grass"])
    gEffects[gEffects.count].efs.add([#nm:"Orb Plants"])
    gEffects[gEffects.count].efs.add([#nm:"Storm Plants"])
    
    gEffects.add([#nm:"Nautillo Plants 2", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Coral Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Horror Growers"])
    
    gEffects.add([#nm:"Tronsx Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Thunder Growers"])
    
    gEffects.add([#nm:"Intrepid Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Ice Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Grass Growers"])
    gEffects[gEffects.count].efs.add([#nm:"Fancy Growers"])
    
    gEffects.add([#nm:"LudoCrypt Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Mushroom Stubs"])
    
    gEffects.add([#nm:"Alduris Effects", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Mosaic Plants"])
    gEffects[gEffects.count].efs.add([#nm:"Lollipop Mold"])
    gEffects[gEffects.count].efs.add([#nm:"Cobwebs"])
    gEffects[gEffects.count].efs.add([#nm:"Fingers"])
    
    gEffects.add([#nm:"April Plants", #efs:[]])
    gEffects[gEffects.count].efs.add([#nm:"Grape Roots"])
    gEffects[gEffects.count].efs.add([#nm:"Og Grass"])
    gEffects[gEffects.count].efs.add([#nm:"Hand Growers"])
  end if
  
  -- Custom effects
  sav = member("initImport")
  sav.text = ""
  member("initImport").importFileInto("Effects" & the dirSeparator & "Init.txt")
  sav.name = "initImport"
  
  didNewHeading = 0
  gCustomEffects = []
  repeat with q = 1 to the number of lines in sav.text
    savTextLine = sav.text.line[q]
    if (savTextLine <> "") then
      if (savTextLine.char[1] = "-") then
        didNewHeading = 1
        vl = savTextLine.char[2..savTextLine.length]
        gEffects.add([#nm:vl, #efs:[]])
      else if (value(savTextLine) = VOID) then
        writeException("Effects Init Error", "Line " && q && " is malformed in the Init.txt file from your Effects folder.")
        hadException = 1
      else
        ad = value(savTextLine)
        if ad.findPos("nm") > 0 and ad.findPos("tp") > 0 then
          -- New heading if needed
          if didNewHeading = 0 then
            gEffects.add([#nm:"Custom Effects", #efs:[]])
            writeException("Effects Init Error", "Effects/Init.txt does not begin with a category. Creating temporary category, but please create one yourself.")
            hadException = 1
            didNewHeading = 1
          end if
          
          -- Ok add the effect
          gEffects[gEffects.count].efs.add(ad)
          gCustomEffects.append(ad.nm)
        else
          writeException("Effects Init Error", "Line " && q && " is missing #nm or #tp in the Init.txt file from your Effects folder.")
          hadException = 1
        end if
      end if
    end if
  end repeat
  -- Remove empty categories
  repeat with q = gEffects.count down to 1 then
    if gEffects[q].efs.count = 0 then
      writeException("Effects Init Error", "Category '" & gEffects[q].nm & "' was empty! Removing.")
      hadException = 1
      gEffects.deleteAt(q)
    end if
  end repeat
  
  gEEprops = [#lastKeys:[], #keys:[], #lstMsPs:point(0,0), #effects:[], emPos:point(1,1), #editEffect:0, #selectEditEffect:0, #mode:"createNew", #brushSize:5]
  
  
  --Light editor
  gLightEProps = [#pos:point(1040/2, 800/2), rot:0, #sz:point(50, 70), #col:1, #keys:0, #lastKeys:0, #lastTm:0, #lightAngle:180, #flatness:1, #lightRect:rect(1000, 1000, -1000, -1000), #paintShape:"pxl"]
  
  
  
  gLOprops = [#mouse:0, #lastMouse:0, #mouseClick:0, #pal:1, pals:[[#detCol:color(255, 0, 0)]], #eCol1:1, #eCol2:2, #totEcols:5, #tileSeed:random(400), #colGlows:[0,0], #size:point(cols, rows), #extraTiles:[12,3,12,5], #light:1]
  
  new(script"levelEdit_parentscript", 1)
  --new(script"levelEdit_parentscript", 2)
  
  gCameraProps = [#cameras:[point(gLOprops.size.locH*10, gLOprops.size.locV*10)-point(35*20, 20*20)], #selectedCamera:0, #quads:[[[0,0], [0,0], [0,0], [0,0]]], #keys:[#n:0, #d:0, #e:0, #p:0], #lastKeys:[#n:0, #d:0, #e:0, #p:0]]
  
  repeat with mem in ["rainBowMask","blackOutImg1","blackOutImg2"] then
    member(mem).image = image(1, 1, 1)
  end repeat
  
  member("lightImage").image = image((gLOprops.size.locH*20)+300,(gLOprops.size.locV*20)+300, 1)
  
  repeat with i = 0 to 29 then
    member("layer"&i).image = image(1,1,1)
    member("layer"&i&"sh").image = image(1,1,1)
    member("gradientA" & i).image =  image(1,1,1)
    member("gradientB" & i).image =  image(1,1,1)
    member("layer" & i & "dc").image =  image(1,1,1)
    member("dumpImage").image = image(1,1,1)
    member("finalDecalImage").image  = image(1,1,1)
    member("GradientOutput").image  = image(1,1,1)
  end repeat
  
  if (getBoolConfig("Large trash debug log")) then
    repeat with tr = 1 to gTrashPropOptions.count
      member("DEBUGTR").text = member("DEBUGTR").text & RETURN & gProps[gTrashPropOptions[tr].locH].prps[gTrashPropOptions[tr].locV].nm
    end repeat
    fileOpener = new xtra("fileio")
    fileOpener.openFile(the moviePath & "largeTrashLog.txt", 0)
    fileOpener.writeString(member("DEBUGTR").text)
    fileOpener.writeReturn(#windows)
  end if
  --exportAll()
  
  -- Warn the user if an exception was encountered
  if hadException = 1 then
    popupWarning("Init Issues", "Encountered issues while reading inits! See editorExceptionLog.txt for more info.")
  end if
end




















