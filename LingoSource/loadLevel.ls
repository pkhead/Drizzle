global projects, ldPrps, gTEprops, gTiles, gLEProps, gEEprops, gLightEProps
global gLEVEL, gLOprops, gLoadedName, gCameraProps, gEnvEditorProps, gPEprops, gLOADPATH, showControls


on exitFrame me
  if (showControls) then
    sprite(32).blend = 100
  else
    sprite(32).blend = 0
  end if
  
  if _key.keyPressed(56) and _key.keyPressed(48) and _movie.window.sizeState <> #minimized then
    _player.appMinimize()
    
  end if
  if checkExit() then
    _player.quit()
  end if
  
  txt = "Use the up and down keys to select a project. Use enter to open it."
  put RETURN after txt
  repeat with f in gLOADPATH then
    put f & "/" after txt
  end repeat
  put RETURN after txt
  put RETURN after txt
  repeat with q = ldPrps.listScrollPos to ldPrps.listScrollPos + ldPrps.listShowTotal  then
    if q > projects.count then
      exit repeat
    else
      if q <> ldPrps.currProject then
        put projects[q] after txt
      else
        put "<"&&projects[q]&&">" after txt
      end if
      put RETURN after txt
    end if
  end repeat
  
  member("ProjectsL").text = txt
  
  --lstKeys
  -- ldPrps
  up = _key.keyPressed(126)
  dwn = _key.keyPressed(125)
  lft = _key.keyPressed(123)
  rgth = _key.keyPressed(124)
  if _movie.window.sizeState = #minimized then
    up = false
    dwn = false
    lft = false
    rgth = false
  end if
  
  if (up) and (ldPrps.lstUp=0) then
    ldPrps.currProject = ldPrps.currProject -1
    if ldPrps.currProject < 1 then
      ldPrps.currProject = projects.count
    end if
  end if
  if (dwn) and (ldPrps.lstdwn=0) then
    ldPrps.currProject = ldPrps.currProject +1
    if ldPrps.currProject > projects.count then
      ldPrps.currProject = 1
    end if
  end if
  
  if ldPrps.currProject < ldPrps.listScrollPos then
    ldPrps.listScrollPos = ldPrps.currProject
  else if ldPrps.currProject > ldPrps.listScrollPos + ldPrps.listShowTotal then
    ldPrps.listScrollPos  = ldPrps.currProject - ldPrps.listShowTotal
  end if
  
  if(rgth)and(ldPrps.rgth = 0)and(projects.count > 0)then
    if(chars(projects[ldPrps.currProject], 1, 1) = "#")then
      me.loadSubFolder(projects[ldPrps.currProject])
    end if
  else if(lft)and(ldPrps.lft = 0)then
    if(gLOADPATH.count > 0)then
      gLOADPATH.deleteAt(gLOADPATH.count)
      _movie.go(2)
    end if
  end if
  
  ldPrps.lstUp = up
  ldPrps.lstDwn = dwn
  ldPrps.lft = lft
  ldPrps.rgth = rgth
  
  if _key.keyPressed("N") and _movie.window.sizeState <> #minimized then
    gLoadedName = "New Project"
    member("level Name").text = "New Project"
    _movie.go(7)
  else if (_key.keyPressed(36))and(projects.count > 0) and _movie.window.sizeState <> #minimized then
    if(chars(projects[ldPrps.currProject], 1, 1) <> "#")then
      me.loadLevel(projects[ldPrps.currProject])
      _movie.go(7)
    end if
  end if
  go the frame
  
end

on loadSubFolder me, fldrName
  gLOADPATH.add(chars(fldrName, 2, fldrName.length))
  _movie.go(2)
end 

on loadLevel me, lvlName, fullPath
  
  if(fullPath)then
    pth = ""
  else
    pth = the moviePath & "LevelEditorProjects" & the dirSeparator
    repeat with f in gLOADPATH then
      pth = pth & f & the dirSeparator
    end repeat
  end if
  
  objFileio = new xtra("fileio")
  --createFile (objFileio, the moviePath&"\LevelEditorProjects\"&levelName&".txt")
  objFileio.openFile(pth&lvlName&".txt", 0)
  if(fullPath = 1)then
    gLoadedName = ""
    lastBackSlash = 0
    repeat with q = 1 to lvlName.length then
      if(chars(lvlName, q, q) = the dirSeparator)then
        lastBackSlash = q
      end if
    end repeat
    gLoadedName = chars(lvlName, lastBackSlash+1, lvlName.length)
    put gLoadedName
  else
    
    gLoadedName = lvlName
  end if
  member("level Name").text = lvlName
  --objFileio.writeString(string(l))
  l2 = objFileio.readFile()
  objFileio.closeFile()
  
  sv2 = gLOprops.duplicate()
  
  
  
  
  l1 = value(l2.line[1])
  gLEProps.matrix = l1
  l1 = value(l2.line[2])
  gTEProps = l1
  l1 = value(l2.line[3])
  gEEprops = l1
  l1 = value(l2.line[4])
  gLightEProps = l1
  l1 = value(l2.line[5])
  gLEVEL = l1
  l1 = value(l2.line[6])
  
  gLOprops = l1
  
  
  
  --    if gLOprops = 0 then
  --       sv1 = [1, 1, 1]
  --    else
  if gLOprops.findpos(#light) = void then
    gLOprops.addProp(#light, 1)
  end if
  
  if gTEProps.findpos(#specialEdit) = void then
    gTEProps.addProp(#specialEdit, 0)
  end if
  
  if gLOprops.findpos(#size) = void then
    gLOprops.addProp(#size, point(52, 40))
  end if
  
  if gLOprops.findpos(#extraTiles) = void then
    gLOprops.addProp(#extraTiles, [1,1,1,3])
  end if
  
  gLOprops.pals = [[#detCol:color(255, 0, 0)]]
  
  if value(l2.line[7]) = void then
    gCameraProps.cameras = [point(gLOprops.size.locH*10, gLOprops.size.locV*10)-point(35*20, 20*20)]
  else
    gCameraProps = value(l2.line[7])
  end if
  
  valEnv = value(l2.line[8])
  if (valEnv = void)sor(ilk(valEnv) <> #proplist)sor(valEnv.findpos(#waterLevel) = void) then
    resetgEnvEditorProps()
  else
    gEnvEditorProps = valEnv
  end if
  
  if (value(l2.line[9]) = void)or(chars(l2.line[9], 1, 6) <> "[#prop")then -- = " color") then
    --  if (value(l2.line[9]) = void)or(chars(l2.line[9], 1, 6) = " color") then
    resetPropEditorProps()
  else
    gPEprops = value(l2.line[9])
  end if
  
  if gPEprops.findpos(#color) = void then
    gPEprops.addProp(#color, 0)
  end if
  
  if gPEprops.findpos(#props) = void then
    gPEprops.addProp(#props, [])
  end if
  
  --sv1 = [gLOprops.pal, gLOprops.eCol1, gLOprops.eCol2, gLOprops.colGlows, gLOprops.size, gLOprops.extraTiles]
  --gLOprops = sv2
  --gLOprops.pal = sv1[1]
  -- gLOprops.eCol1 = sv1[2]
  --gLOprops.eCol2 = sv1[3]
  --gLOprops.colGlows = sv1[4]
  --gLOprops.size = sv1[5]
  --gLOprops.extraTiles = sv1[6]
  
  gTEprops.tmPos = point(2,1)
  
  me.versionFix()
  
  member("lightImage").image = image((gLOprops.size.loch*20)+300, (gLOprops.size.locv*20)+300, 1)
  sav = member("lightImage")
  
  member("lightImage").importFileInto(pth & lvlName & ".png")
  sav.name = "lightImage"
  
  if (member("lightImage").image.rect <> rect(0,0,(gLOprops.size.loch*20)+300, (gLOprops.size.locv*20)+300) ) then
    wantedRect = rect(0,0,(gLOprops.size.loch*20)+300, (gLOprops.size.locv*20)+300)
    img = image(wantedRect.width, wantedRect.height, 1)
    img.copyPixels(member("lightImage").image, rect(wantedRect.width/2, wantedRect.height/2, wantedRect.width/2, wantedRect.height/2) + rect(-member("lightImage").rect.width/2, -member("lightImage").image.rect.height/2, member("lightImage").image.rect.width/2, member("lightImage").image.rect.height/2), member("lightImage").image.rect)
    member("lightImage").image = img
    put "Adapted light rect"  
  end if
  
  global gLASTDRAWWASFULLANDMINI
  gLASTDRAWWASFULLANDMINI = 0
  
  
  put pth & the dirSeparator & lvlName & ".png"
  
end


on versionFix me
  --  gTEprops.tlMatrix[(tl[2])][(tl[3])][layer].data
  repeat with q = 1 to gLOprops.size.loch then
    repeat with c = 1 to gLOprops.size.locv then
      repeat with d = 1 to 3 then
        if gTEprops.tlMatrix[q][c][d].tp = "tileHead" then
          huntNew = ""
          if gTEprops.tlMatrix[q][c][d].data.count < 2 then
            huntNew = gTEprops.tlMatrix[q][c][d].data.nm
          else
            pnt = gTEprops.tlMatrix[q][c][d].data[1]
            if gTiles.count >= pnt.locH then
              if gTiles[pnt.locH].tls.count >= pnt.locV then
                if gTiles[pnt.locH].tls[pnt.locV].nm <> gTEprops.tlMatrix[q][c][d].data[2] then
                  huntNew = gTEprops.tlMatrix[q][c][d].data[2]
                  --  put huntNew  
                end if
              else
                huntNew = gTEprops.tlMatrix[q][c][d].data[2]
              end if
            else
              huntNew = gTEprops.tlMatrix[q][c][d].data[2]
            end if
          end if
          
          -->changed fix to PJB's one
          found = 0
          if huntNew <> "" then
            gTEprops.tlMatrix[q][c][d].data = [point(2, 1), "NOT FOUND"]
            repeat with cat = 1 to gTiles.count then
              repeat with tl = 1 to gTiles[cat].tls.count then
                if gTiles[cat].tls[tl].nm = huntNew then
                  gTEprops.tlMatrix[q][c][d].data = [point(cat, tl), huntNew]
                  found = 1
                  exit repeat
                end if
              end repeat
              if found then 
                exit repeat
              end if
            end repeat
            if not found then
              writeException("Tile Not Found", "the tile "&QUOTE& huntNew &QUOTE&" is missing in the Init.txt file from your Graphics folder.")
              put "Warning: unknown tile '" & huntNew & "' in map file. Replacing with default material."
              gTEprops.tlMatrix[q][c][d] = [#tp: "default", #data: 0]
            end if
          end if
          --          if gTEprops.tlMatrix[q][c][d].data = [point(2, 1), "NOT FOUND"] then
          --            writeException("Tile Not Found", "the tile "&QUOTE& huntNew &QUOTE&" is missing in the Init.txt file from your Graphics folder.")
          --            gTEprops.tlMatrix[q][c][d].data = [point(3, 1), "Small Stone"]
          --          end if
        end if
      end repeat 
    end repeat
  end repeat
  
  repeat with q = 1 to gLEProps.toolMatrix.count then
    repeat with c = 1 to gLEProps.toolMatrix[1].count then
      if gLEProps.toolMatrix[q][c] = "save" then
        gLEProps.toolMatrix[q][c] = ""
      end if
    end repeat
  end repeat
  
  global gProps
  repeat with q = 1 to gPEprops.props.count then
    correctReference = true
    if(gPEprops.props[q][3].locH > gProps.count)then
      correctReference = false
    else if(gPEprops.props[q][3].locV > gProps[gPEprops.props[q][3].locH].prps.count)then
      correctReference = false
    else if (gProps[gPEprops.props[q][3].locH].prps[gPEprops.props[q][3].locV].nm <> gPEprops.props[q][2]) then
      correctReference = false
    end if
    
    if(correctReference = false)then
      repeat with a = 1 to gProps.count then
        repeat with b = 1 to gProps[a].prps.count then
          if(gProps[a].prps[b].nm = gPEprops.props[q][2])then
            correctReference = true
            gPEprops.props[q][3] = point(a,b)
            exit repeat
          end if
        end repeat
        if correctReference = true then
          exit repeat
        end if
      end repeat
    end if
    
    if gPEprops.props[q].count = 4 then
      gPEprops.props[q].add([#settings:gProps[gPEprops.props[q][3].locH].prps[gPEprops.props[q][3].locV].settings.duplicate()])
    end if
    
    if(correctReference = false)then
      writeException("Prop Not Found", "the prop "&QUOTE& string(gPEprops.props[q][2]) &QUOTE&" is missing in the Init.txt file from your Props folder.")
      gPEprops.props[q][3] = point(1,1)
    end if
  end repeat
  
  repeat with lz in gLevel.lizards then
    if lz.count = 3 then
      lz.add(1)
    end if
  end repeat
  
  if gLEVEL.findpos(#waterDrips) = void then
    gLEVEL.addProp(#waterDrips, 1)
  end if
  if gLEVEL.findpos(#tags) = void then
    gLEVEL.addProp(#tags, [])
  end if
  if gLEVEL.findpos(#lightDynamic) <> void then
    gLEVEL.deleteProp(#lightDynamic)
    gLEVEL.addProp(#lightType, "Static")
  end if
  if gLEVEL.findpos(#lightBlend) <> void then
    gLEVEL.deleteProp(#lightBlend)
  end if
  
  if gLOprops.findpos(#tileSeed) = void then
    gLOprops.addProp(#tileSeed, random(400))
  end if
  
  if gLOprops.findpos(#colGlows) = void then
    gLOprops.addProp(#colGlows, [0,0])
  end if
  
  if gLEprops.findpos(#camPos) = void then
    gLEprops.addProp(#camPos, point(0,0))
  end if
  
  if gCameraProps.findpos(#quads) = void then
    gCameraProps.addProp(#quads, [])
    repeat with q = 1 to gCameraProps.cameras.count then
      gCameraProps.quads.add([[0,0],[0,0],[0,0],[0,0]])
    end repeat
  end if
  
  
  
  
  if gLEVEL.findpos(#music) = void then
    gLEVEL.addProp(#music, "NONE")
  end if
  
  repeat with ef in gEEprops.effects then
    sd = 0
    repeat with op in ef.options then
      if op[1] = "seed" then
        sd = 1
        exit repeat
      end if
    end repeat
    if sd = 0 then
      ef.options.add(["Seed", [], random(500)])
    end if
    
    rotOp = 0
    repeat with op in ef.options
      if (op[1] = "Rotate") then
        rotOp = 1
        exit repeat
      end if
    end repeat
    if (rotOp = 0) and (ef.nm = "Little Flowers") then
      ef.options.add(["Rotate", ["On", "Off"], "Off"])
    end if
    
    lay = 0
    repeat with op2 in ef.options then
      if op2[1] = "Layers" then
        lay = 1
        if op2[2] <> ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]then
          op2[2] = ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
        end if
        exit repeat
      end if
    end repeat
    if (lay = 0) and (["BlackGoo", "Super BlackGoo", "Stained Glass Properties"].getPos(ef.nm)=0)then
      if (["Fungi Flowers", "Lighthouse Flowers", "Colored Fungi Flowers", "Colored Lighthouse Flowers", "Fern", "Giant Mushroom", "Sprawlbush", "featherFern", "Fungus Tree"].getPos(ef.nm)>0)then
        ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "1"])
      else
        ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      end if
    end if
    
    clr = 0
    repeat with op3 in ef.options then
      if op3[1] = "Color" then
        clr = 1
        if op3[2] <> ["Color1", "Color2", "Dead"] then
          op3[2] = ["Color1", "Color2", "Dead"]
        end if
        exit repeat
      end if
    end repeat
    if (clr = 0) and (["DaddyCorruption"].getPos(ef.nm)>0)then
      ef.options.add(["Color", ["Color1", "Color2", "Dead"], "Color2"])
    end if
    
    gaf = 0
    repeat with grd in ef.options then
      if grd[1] = "Affect Gradients and Decals" then
        gaf = 1
        exit repeat
      end if
    end repeat
    if gaf = 0 and (["Melt", "Super Melt", "Destructive Melt", "Rust", "Barnacles"].getPos(ef.nm)>0) then
      ef.options.add(["Affect Gradients and Decals", ["Yes", "No"], "No"])
    end if
    if gaf = 0 and (["Slime", "SlimeX3", "Fat Slime"].getPos(ef.nm)>0) then
      ef.options.add(["Affect Gradients and Decals", ["Yes", "No"], "Yes"])
    end if
    
    if ef.findPos(#crossScreen) = void then
      ef.addProp(#crossScreen, 0)
      if(["Hang Roots","Growers","Wires","Chains"].getPos(ef.nm)>0)then
        ef.crossScreen = 1
      end if
    end if
    ----Effect update
    if(["Arm Growers", "Growers", "Mini Growers", "Rollers", "Thorn Growers", "Garbage Spirals", "Fuzzy Growers", "Spinets", "Small Springs", "Wires", "Chains", "Colored Wires", "Colored Chains", "Hang Roots", "Thick Roots", "Shadow Plants", "Colored Hang Roots", "Colored Thick Roots", "Colored Shadow Plants", "Root Plants", "Coral Growers", "Leaf Growers", "Meat Growers", "Horror Growers", "Thunder Growers", "Ice Growers", "Grass Growers", "Fancy Growers"].getPos(ef.nm)>0)then
      ef.crossScreen = 1
    else
      ef.crossScreen = 0
    end if
    if(["Slime", "Fat Slime", "Scales", "SlimeX3", "DecalsOnlySlime", "Melt", "Rust", "Barnacles", "Colored Barnacles", "Clovers", "Erode", "Sand", "Super Erode", "Ultra Super Erode", "Roughen", "Impacts", "Super Melt", "Destructive Melt"].getPos(ef.nm)>0)then
      ef.tp = "standardErosion"
    else
      ef.tp = "nn"
    end if
    if(["Slime", "DecalsOnlySlime"].getPos(ef.nm)>0)then
      ef.repeats = 130
      ef.affectOpenAreas = 0.5
    end if
    if(["Fat Slime"].getPos(ef.nm)>0)then
      ef.repeats = 200
      ef.affectOpenAreas = 0.5
    end if
    if(["Scales"].getPos(ef.nm)>0)then
      ef.repeats = 200
      ef.affectOpenAreas = 0.05
    end if
    if(["SlimeX3"].getPos(ef.nm)>0)then
      ef.repeats = 130*3
      ef.affectOpenAreas = 0.5
    end if
    if(["Melt", "Super Erode", "Ultra Super Erode"].getPos(ef.nm)>0)then
      ef.repeats = 60
      ef.affectOpenAreas = 0.5
    end if
    if(["Rust"].getPos(ef.nm)>0)then
      ef.repeats = 60
      ef.affectOpenAreas = 0.2
    end if
    if(["Barnacles", "Colored Barnacles"].getPos(ef.nm)>0)then
      ef.repeats = 60
      ef.affectOpenAreas = 0.3
    end if
    if(["Clovers"].getPos(ef.nm)>0)then
      ef.repeats = 20
      ef.affectOpenAreas = 0.2
    end if
    if(["Erode", "Sand"].getPos(ef.nm)>0)then
      ef.repeats = 80
      ef.affectOpenAreas = 0.5
    end if
    if(["Roughen"].getPos(ef.nm)>0)then
      ef.repeats = 30
      ef.affectOpenAreas = 0.05
    end if
    if(["Impacts"].getPos(ef.nm)>0)then
      ef.repeats = 75
      ef.affectOpenAreas = 0.05
    end if
    if(["Super Melt", "Destructive Melt"].getPos(ef.nm)>0)then
      ef.repeats = 50
      ef.affectOpenAreas = 0.5
    end if
  end repeat
end















