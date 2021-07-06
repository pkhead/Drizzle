global gTEprops, gLEProps, gTiles, gEEProps, gEffects, lstSpace, gLOprops, gEnvEditorProps, gDirectionKeys


on exitFrame me
  
  repeat with q = 1 to 4 then
    
    if (_key.keyPressed([86, 91, 88, 84][q]))and(gDirectionKeys[q] = 0) then
      
      gLEProps.camPos = gLEProps.camPos + [point(-1, 0), point(0,-1), point(1,0), point(0,1)][q] * (1 + 9 * _key.keyPressed(83))
      repeat with l = 1 to 3 then
        lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
        TEdraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), l)
      end repeat
      drawShortCutsImg(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 16)
      
      me.drawEfMtrx(gEEprops.editEffect)
      
    end if
    gDirectionKeys[q] = _key.keyPressed([86, 91, 88, 84][q])
  end repeat
  
  if gEnvEditorProps.waterLevel = -1 then
    sprite(11).rect = rect(0,0,0,0)
  else
    rct = rect(0, gLOprops.size.locv-gEnvEditorProps.waterLevel-gLOProps.extraTiles[4], gLOprops.size.loch, gLOprops.size.locv) - rect(gLEProps.camPos, gLEProps.camPos)
    sprite(11).rect = ((rct.intersect(rect(0,0,52,40))+rect(1, 1, 1, 1))*rect(16,16,16,16))+rect(0, -8, 0, 0)
  end if
  
  msTile = (_mouse.mouseLoc/point(16.0, 16.0))-point(0.4999, 0.4999)
  msTile = point(msTile.loch.integer, msTile.locV.integer) 
  msTile = msTile + gLEProps.camPos
  
  actn = 0
  actn2 = 0
  
  gEEprops.keys.m1 = _mouse.mouseDown
  if (gEEprops.keys.m1)and(gEEprops.lastKeys.m1=0) then
    actn = 1
  end if
  gEEprops.lastKeys.m1 = gEEprops.keys.m1
  gEEprops.keys.m2 = _mouse.rightmouseDown
  if (gEEprops.keys.m2)and(gEEprops.lastKeys.m2=0) then
    actn2 = 1
  end if
  gEEprops.lastKeys.m2 = gEEprops.keys.m2
  if msTile <> gEEprops.lstMsPs then
    actn = gEEprops.keys.m1
    actn2 = gEEprops.keys.m2 
  end if
  gEEprops.lstMsPs = msTile
  if actn then
    me.useBrush(msTile, 1)
  end if
  if actn2 then
    me.useBrush(msTile, -1)
  end if
  
  if me.checkKey("N") then
    me.initMode("createNew")
  end if
  if me.checkKey("E") then
    me.initMode("chooseEffect")
  end if
  
  case gEEprops.mode of 
    "createNew":
      if me.checkKey("W") then
        me.updateEffectsMenu(point(0, -1))
      end if
      if me.checkKey("S") then
        me.updateEffectsMenu(point(0, 1))
      end if
      if me.checkKey("A") then
        me.updateEffectsMenu(point(-1, 0))
      end if
      if me.checkKey("D") then
        me.updateEffectsMenu(point(1, 0))
      end if
      
      if _key.keyPressed(" ") then
        me.newEffect()
        gEEprops.editEffect = gEEprops.effects.count
        gEEprops.selectEditEffect = gEEprops.effects.count
        me.initMode("editEffect")
      end if
      
      sprite(21).rect = rect(-100, -100, -100, -100)
    "chooseEffect":
      if me.checkKey("W") then
        me.updateEffectsL(-1)
      end if
      if me.checkKey("S") then
        me.updateEffectsL(1)
      end if
      if (_key.keyPressed(" "))and(lstSpace=0)then
        gEEprops.editEffect = gEEprops.selectEditEffect
        me.initMode("editEffect")
        me.updateEffectsL(0)
      end if
      
      sprite(21).rect = rect(-100, -100, -100, -100)
    "editEffect":
      if me.checkKey("r") then
        gEEprops.brushSize = restrict(gEEprops.brushSize + 1, 1, 10)
      end if
      if me.checkKey("f") then
        gEEprops.brushSize = restrict(gEEprops.brushSize - 1, 1, 10)
      end if
      
      if me.checkKey("W") then
        me.updateEditEffect(point(0, -1))
      end if
      if me.checkKey("S") then
        me.updateEditEffect(point(0, 1))
      end if
      if me.checkKey("A") then
        me.updateEditEffect(point(-1, 0))
      end if
      if me.checkKey("D") then
        me.updateEditEffect(point(1, 0))
      end if
      
      if gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][1] = "seed" then
        me.changeOption()
      else
        if (_key.keyPressed(" "))and(lstSpace=0)then
          me.changeOption()
        end if
      end if
      
      
      
      
      sizeAdd = rect(-gEEprops.brushSize+1, -gEEprops.brushSize+1, gEEprops.brushSize-1, gEEprops.brushSize-1) * rect(16,16,16,16)
      --   put sizeAdd
      sprite(21).rect = (rect(msTile-gLEProps.camPos, msTile-gLEProps.camPos) * rect(16,16,16,16)) + rect(0, 0, 16, 16) + sizeAdd
      
  end case
  
  sprite(15).rect = (rect(msTile-gLEProps.camPos, msTile-gLEProps.camPos) * rect(16,16,16,16)) + rect(0, 0, 16, 16)
  
  --put msTile
  
  lstSpace = _key.keyPressed(" ")
  --if _key.keyPressed("G")=0 then
  script("levelOverview").goToEditor()
  go the frame
  -- end if
end





on checkKey me, key
  rtrn = 0
  gEEprops.keys[symbol(key)] = _key.keyPressed(key)
  if (gEEprops.keys[symbol(key)])and(gEEprops.lastKeys[symbol(key)]=0) then
    rtrn = 1
  end if
  gEEprops.lastKeys[symbol(key)] = gEEprops.keys[symbol(key)]
  return rtrn
end



on updateEffectsMenu me, mv
  gEEprops.emPos = gEEprops.emPos + mv
  
  if gEEprops.emPos.locH < 1 then
    gEEprops.emPos.locH = gEffects.count
  else if gEEprops.emPos.locH > gEffects.count then
    gEEprops.emPos.locH = 1
  end if 
  
  if gEEprops.emPos.locV < 1 then
    gEEprops.emPos.locV = gEffects[gEEprops.emPos.locH].efs.count
  else if gEEprops.emPos.locV > gEffects[gEEprops.emPos.locH].efs.count then
    gEEprops.emPos.locV = 1
  end if
  
  txt = ""
  put "[" && gEffects[gEEprops.emPos.locH].nm && "]" after txt
  put RETURN after txt
  
  
  repeat with tl = 1 to gEffects[gEEprops.emPos.locH].efs.count then
    if tl = gEEprops.emPos.locV then
      put "-" && gEffects[gEEprops.emPos.locH].efs[tl].nm && "-" && RETURN after txt
    else
      put gEffects[gEEprops.emPos.locH].efs[tl].nm && RETURN after txt
    end if
  end repeat
  
  member("tileMenu").text = txt
  
end


on updateEffectsL me, mv
  txt = ""
  if gEEprops.effects.count <> 0 then
    gEEprops.selectEditEffect = gEEprops.selectEditEffect + mv
    if gEEprops.selectEditEffect < 1 then
      gEEprops.selectEditEffect = gEEprops.effects.count
    else if gEEprops.selectEditEffect > gEEprops.effects.count then
      gEEprops.selectEditEffect = 1
    end if
    
    
    put "<EFFECTS>" after txt
    put RETURN after txt
    
    repeat with ef = 1 to gEEprops.effects.count then
      
      if ef = gEEprops.editEffect then
        put string(ef)&". *"&gEEprops.effects[ef].nm&"*" after txt
        member("editEffectName").text = gEEprops.effects[ef].nm && "("&string(ef)&")"
      else if ef = gEEprops.selectEditEffect then
        put string(ef)&". -"&gEEprops.effects[ef].nm&"-" after txt
      else
        put string(ef)&". "&gEEprops.effects[ef].nm after txt
      end if
      put RETURN after txt
    end repeat
    
    me.drawEfMtrx(gEEprops.selectEditEffect)
  else
    member("editEffectName").text = "No effects added"
    put "<EFFECTS>" after txt
    put RETURN after txt
    put "No effects added" after txt
  end if
  member("effectsL").text = txt
end


on newEffect me
  ef = [#nm:gEffects[gEEprops.emPos.locH].efs[gEEprops.emPos.locV].nm, #tp:"nn", #crossScreen:0, #mtrx:[], #options: [["Delete/Move", ["Delete", "Move Back", "Move Forth"], ""]] ]
  
  
  fillWith = 0
  
  case ef.nm of
    "slime":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 130)
      ef.addProp(#affectOpenAreas, 0.5)
      ef.options.add(["3D", ["Off", "On"], "Off"])
    "slimeX3":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 130*3)
      ef.addProp(#affectOpenAreas, 0.5)
      ef.options.add(["3D", ["Off", "On"], "Off"])
    "DecalsOnlySlime":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 130)
      ef.addProp(#affectOpenAreas, 0.5)
    "melt":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 60)
      ef.addProp(#affectOpenAreas, 0.5)
      
    "rust":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 60)
      ef.addProp(#affectOpenAreas, 0.2)
      ef.options.add(["3D", ["Off", "On"], "Off"])
      
    "barnacles":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 60)
      ef.addProp(#affectOpenAreas, 0.3)
      ef.options.add(["3D", ["Off", "On"], "Off"])
      
    "erode":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 80)
      ef.addProp(#affectOpenAreas, 0.5)
      
    "Super Erode":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 60)
      ef.addProp(#affectOpenAreas, 0.5)
      
    "Roughen":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 30)
      ef.addProp(#affectOpenAreas, 0.05)
      
    "Super Melt":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 50)
      ef.addProp(#affectOpenAreas, 0.5)
      ef.options.add(["3D", ["Off", "On"], "Off"])
      
    "Destructive Melt":
      ef.tp = "standardErosion"
      ef.addProp(#repeats, 50)
      ef.addProp(#affectOpenAreas, 0.5)
      ef.options.add(["3D", ["Off", "On"], "Off"])
      
    "Rubble":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      
    "Fungi Flowers", "Lighthouse Flowers":
      ef.options.add(["Layers", ["1", "2", "3"], "1"])
      
    "Fern", "Giant Mushroom", "sprawlBush", "featherFern", "Fungus Tree":
      ef.options.add(["Layers", ["1", "2", "3"], "1"])
      ef.options.add(["Color", ["Color1", "Color2", "Dead"], "Color2"])
      
    "Root Grass", "Growers", "Cacti", "Rain Moss", "Seed Pods", "Grass", "Arm Growers", "Horse Tails", "Circuit Plants", "Feather Plants":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      ef.options.add(["Color", ["Color1", "Color2", "Dead"], "Color2"])
      
      if(["Arm Growers", "Growers"].getPos( ef.nm ) > 0 )then
        ef.crossScreen = 1
      end if
      
    "Rollers", "Thorn Growers", "Garbage Spirals":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      ef.options.add(["Color", ["Color1", "Color2", "Dead"], "Color2"])
      ef.crossScreen = 1
      
    "wires":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      ef.options.add(["Fatness", ["1px", "2px", "3px", "random"], "2px"])
      crossScreen = 1
      
    "chains":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      ef.options.add(["Size", ["Small", "FAT"], "Small"])
      ef.crossScreen = 1
    "blackGoo":
      fillWith = 100
    "Hang Roots", "Thick Roots", "Shadow Plants":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      ef.crossScreen = 1
      
    "Restore As Scaffolding":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      
    "Restore As Pipes":
      ef.options.add(["Layers", ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"], "All"])
      
    "Ceramic Chaos":
      ef.options.add(["Colored", ["None", "White"], "White"])
      
    "DaddyCorruption":
      
  end case
  
  repeat with q = 1 to gLOprops.size.loch then
    ql = []
    repeat with c = 1 to gLOprops.size.locv then
      ql.add(fillWith)
    end repeat
    ef.mtrx.add(ql)
  end repeat
  
  ef.options.add(["Seed", [], random(500)])
  
  
  
  gEEprops.effects.add(ef)
  
  
  
  me.updateEffectsL(0)
end





on useBrush me, pnt, fac
  if  gEEprops.mode = "editEffect" then
    strength = 10 + (90* _key.keyPressed("T"))
    if ["BlackGoo", "Fungi Flowers", "Lighthouse Flowers", "Fern", "Giant Mushroom", "Sprawlbush", "featherFern", "Fungus Tree", "Restore As Scaffolding", "Restore As Pipes"].getPos(gEEprops.effects[gEEprops.editEffect].nm)>0 then
      strength = 10000
      if  gEEprops.effects[gEEprops.editEffect].nm <> "BlackGoo" then
        gEEprops.brushSize = 1
      end if
    end if
    
    rct = rect(pnt, pnt)+rect(-gEEprops.brushSize, -gEEprops.brushSize, gEEprops.brushSize, gEEprops.brushSize)
    repeat with q = rct.left to rct.right then
      repeat with c = rct.top to rct.bottom then
        if point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))then
          val = gEEprops.effects[gEEprops.editEffect].mtrx[q][c]
          digFac = 1.0-(diag(point(q,c), pnt).float/gEEprops.brushSize)
          if digFac > 0 then
            
            val = restrict(val + strength*digFac*fac, 0, 100)
            gEEprops.effects[gEEprops.editEffect].mtrx[q][c] = val
            
            me.updateEffectGraph(point(q,c), val)
            
          end if
        end if
      end repeat
    end repeat
  end if
end


on drawEfMtrx me, l
  --  if (gEEprops.effects.count > 0)and(l>0) then
  --        repeat with q = rct.left to rct.right then
  --          repeat with c = rct.top to rct.bottom then
  --            if point(q,c).inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1))then
  --              val = gEEprops.effects[l].mtrx[q][c]/100.0
  --              member("effectsMatrix").image.setPixel(q-1, c-1, color(255-val*255, 255*val, 255-val*255))
  --            end if
  --          end repeat
  --        end repeat
  --  else
  --    member("effectsMatrix").image.copyPixels(member("pxl").image, member("effectsMatrix").image.rect, member("pxl").image.rect)
  --  end if
  
  
  if (gEEprops.effects.count > 0)and(l>0) then
    repeat with a = gLEProps.camPos.locH to gLEProps.camPos.locH + 52 then
      repeat with b = gLEProps.camPos.locV to gLEProps.camPos.locV + 40 then
        if(a > 0)and(a<=gLOprops.size.loch)and(b>0)and(b<=gLOprops.size.locV)then
          me.updateEffectGraph(point(a,b), gEEprops.effects[l].mtrx[a][b])
        else
          me.updateEffectGraph(point(a,b), -1)
        end if
      end repeat
    end repeat
  else
    member("effectsMatrix").image.copyPixels(member("pxl").image, member("effectsMatrix").image.rect, member("pxl").image.rect)
  end if
end 

on updateEffectGraph me, tile, strength
  if (strength = -1) then
    member("effectsMatrix").image.setPixel(tile.locH-gLEProps.camPos.locH-1, tile.locV-gLEProps.camPos.locV-1, color(0, 0, 0))
  else
    
    strength = strength / 100.0
    member("effectsMatrix").image.setPixel(tile.locH-gLEProps.camPos.locH-1, tile.locV-gLEProps.camPos.locV-1, color(255-strength*255, 255*strength, 255-strength*255))
  end if
end


on initMode me, md
  case md of
      
    "chooseEffect":
      if gEEprops.effects.count > 0 then
        gEEprops.selectEditEffect = gEEprops.editEffect
        --   me.updateEffectsL(0)
        sprite(20).rect = rect((53*16)+8, 10*16, 1024-8, 41*16)
        member("EEhelp").text = "Use W, S and the spacebar to select an effect to edit"
      else
        --   me.updateEffectsL(0)
      end if
    "editEffect":
      -- me.updateEffectsL(0)
      sprite(20).rect = rect(8, 42*16, 1024-8, 768-8)
      member("EEhelp").text = "Edit effect: Use WASD to change the settings of the effect. Use the left and right mouse buttons to change the effect matrix"
      -- me.drawEfMtrx(rect(1,1,52,40), gEEprops.editEffect)
    "createNew":
      -- me.drawEfMtrx(rect(1,1,52,40), 0)
      sprite(20).rect = rect((53*16)+8, 8, 1024-8, 10*16)
      member("EEhelp").text = "Create new: Use the WASD keys and the spacebar to select an effect to add"    
    otherwise:
      sprite(20).rect = rect(-1, -1, -1, -1)
      member("EEhelp").text = "---"    
  end case
  gEEprops.mode = md
  me.updateAllText()
end





on updateEditEffect me, mv
  
  if gEEprops.effects <> [] then
    if gEEprops.editEffect > gEEprops.effects.count then
      gEEprops.editEffect = gEEprops.effects.count
    end if
    
    gEEprops.emPos = gEEprops.emPos + mv
    if gEEprops.emPos.locV > gEEprops.effects[gEEprops.editEffect].options.count then
      gEEprops.emPos.locV = 1
    else  if gEEprops.emPos.locV < 1 then
      gEEprops.emPos.locV = gEEprops.effects[gEEprops.editEffect].options.count
    end if
    if gEEprops.emPos.locH > gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2].count then
      gEEprops.emPos.locH = 1
    else  if gEEprops.emPos.locH < 1 then
      gEEprops.emPos.locH = gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2].count
    end if
    
    txt = ""
    put "["&& gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][1] && "]:" && gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] after txt
    put RETURN after txt
    repeat with ef = 1 to gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2].count then
      if ef = gEEprops.emPos.locH then
        put "-"&& gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2][ef] && "-   " after txt
      else
        put gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2][ef] && "    " after txt
      end if
    end repeat
    
    member("effectOptions").text = txt
  else
    member("effectOptions").text = ""
  end if
end 


on changeOption me
  -- put gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][1]
  -- put gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][gEEprops.emPos.locH]
  case gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][1] of
    "Delete/Move":
      case gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2][gEEprops.emPos.locH] of
        "Delete":
          gEEprops.effects.deleteAt(gEEprops.editEffect)
          --  me.updateEffectsL(0)
          me.initMode("chooseEffect")
          gEEprops.editEffect = gEEprops.effects.count
          me.updateAllText()
        "Move Back":
          sv =  gEEprops.effects[gEEprops.editEffect].duplicate()
          gEEprops.effects.deleteAt(gEEprops.editEffect)
          gEEprops.editEffect = restrict(gEEprops.editEffect-1, 1, gEEprops.effects.count)
          gEEprops.effects.addAt(gEEprops.editEffect, sv)
          gEEprops.selectEditEffect =  gEEprops.editEffect
          me.updateEffectsL(0)
        "Move Forth":
          sv =  gEEprops.effects[gEEprops.editEffect].duplicate()
          gEEprops.effects.deleteAt(gEEprops.editEffect)
          gEEprops.editEffect = restrict(gEEprops.editEffect+1, 1, gEEprops.effects.count+1)
          gEEprops.effects.addAt(gEEprops.editEffect, sv)
          gEEprops.selectEditEffect =  gEEprops.editEffect
          me.updateEffectsL(0)
      end case
    "Seed":
      if _key.keyPressed("A") then
        gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] = gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] -1
      end if
      if _key.keyPressed("D") then
        gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] = gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] +1
      end if
      gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] = restrict(gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3], 1, 500)
      
      
    "Color", "Fatness", "Size", "Layers", "3D", "Colored":
      gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][3] = gEEprops.effects[gEEprops.editEffect].options[gEEprops.emPos.locV][2][gEEprops.emPos.locH]

      
      
  end case
  
  me.updateEditEffect(point(0,0))
end






on updateAllText me
  me.updateEffectsL(0)
  me.updateEditEffect(point(0,0))
  me.updateEffectsMenu(point(0,0))
  
end

























