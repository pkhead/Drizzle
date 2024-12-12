global vertRepeater, r, gEEprops, solidMtrx, gLEprops, colr, colrDetail, colrInd, gdLayer, gdDetailLayer, gdIndLayer, gLOProps, gLevel, gEffectProps, gViewRender, keepLooping, gRenderCameraTilePos, effectSeed, lrSup, chOp, fatOp, gradAf, effectIn3D, gAnyDecals, gRotOp, slimeFxt, DRDarkSlimeFix, DRWhite, DRPxl, DRPxlRect, colrIntensity, fruitDensity, leafDensity, mshrSzW, mshrSz, hasFlowers, effSide, fingerLen, fingerSz, gCustomEffects, gEffects, gLastImported

on exitFrame(me)
  if (checkMinimize()) then
    _player.appMinimize()
  end if
  if (checkExit()) then
    _player.quit()
  end if
  if (gViewRender) then
    if (checkExitRender()) then
      _movie.go(9)
    end if
    me.newFrame()
    if (keepLooping) then
      go the frame
    end if
  else
    repeat while keepLooping
      me.newFrame()
    end repeat
  end if
end

on newFrame(me)
  vertRepeater = vertRepeater + 1
  efcnt = gEEprops.effects.count
  if (efcnt = 0) then
    keepLooping = 0
    exit
  else if (r = 0) then
    vertRepeater = 1
    r = 1
    me.initEffect()
  end if
  efcsc = gEEprops.effects[r].crossScreen
  if ((vertRepeater > 60) and (efcsc = 0)) or ((vertRepeater > gLOprops.size.locV) and (efcsc = 1)) then
    me.exitEffect()
    r = r + 1
    if (r > efcnt) then
      keepLooping = 0
      exit
    else
      me.initEffect()
      vertRepeater = 1
    end if
  end if
  effectr = gEEprops.effects[r]
  if (effectr.crossScreen = 0) then
    sprite(59).locV = vertRepeater * 20
    repeat with q = 1 to 100
      q2 = q + gRenderCameraTilePos.locH
      c2 = vertRepeater + gRenderCameraTilePos.locV
      if (q2 > 0) then
        if (q2 <= gLOprops.size.locH) then
          if (c2 > 0) then
            if (c2 <= gLOprops.size.locV) then
              me.effectOnTile(q, vertRepeater, q2, c2, effectr)
            end if
          end if
        end if
      end if
    end repeat
  else
    repmcam = vertRepeater - gRenderCameraTilePos.locV
    sprite(59).locV = repmcam * 20
    repeat with q2 = 1 to gLOprops.size.locH
      me.effectOnTile(q2 - gRenderCameraTilePos.locH, repmcam, q2, vertRepeater, effectr)
    end repeat
  end if
end

on effectOnTile me, q, c, q2, c2, effectr
  if effectr.mtrx[q2][c2] > 0 then
    efname = effectr.nm
    savSeed = the randomSeed
    the randomSeed = seedForTile(point(q2, c2), effectSeed)
    case efname of
      "Slime", "Rust", "Barnacles", "Erode", "Melt", "Roughen", "SlimeX3", "Destructive Melt", "Super Melt", "Super Erode", "DecalsOnlySlime", "Ultra Super Erode", "Colored Barnacles", "Sand", "Impacts", "Fat Slime":
        me.applyStandardErosion(q,c,0, efname, effectr)
      "Root Grass", "Cacti", "Rubble", "Rain Moss", "Dandelions", "Seed Pods", "Grass", "Horse Tails", "Circuit Plants", "Feather Plants", "Storm Plants", "Colored Rubble", "Reeds", "Lavenders", "Seed Grass", "Hyacinths", "Orb Plants", "Lollipop Mold", "Og Grass":
        me.applyStandardPlant(q,c,0, efname)
      "LSlime":
        DRFSlimeApply(q, c, effectr)
      "Dense Mold":
        me.applyWLPlant(q, c)
      "Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.applyhugeflower(q,c,0)
        end if
      "Mini Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1)then
          me.applyMiniGrowers(q,c,0)
        end if
      "Arm Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.ApplyArmGrower(q,c,0)
        end if
      "Fungi Flowers":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyFungiFlower(q,c)
        end if
      "Colored Fungi Flowers":
        if (gdLayer = "C") then
          if effectr.mtrx[q2][c2] > 0 then
            me.applyFungiFlower(q,c)
          end if
        else
          if effectr.mtrx[q2][c2] > 0 then
            me.applyColoredFungiFlower(q,c)
          end if
        end if
      "Lighthouse Flowers":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyLHFlower(q,c)
        end if
      "Colored Lighthouse Flowers":
        if (gdLayer = "C") then
          if effectr.mtrx[q2][c2] > 0 then
            me.applyLHFlower(q,c)
          end if
        else
          if effectr.mtrx[q2][c2] > 0 then
            me.applyColoredLHFlower(q,c)
          end if
        end if
      "Foliage":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyFoliage(q,c)
        end if
      "Assorted Trash":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyAssortedTrash(q,c)
        end if
      "High Grass":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyHighGrass(q,c)
        end if
      "Small Springs":
        if effectr.mtrx[q2][c2] > 0 then
          me.applySmallSprings(q,c)
        end if
      "High Fern":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyHighFern(q,c)
        end if
      "Mistletoe":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyMistletoe(q,c)
        end if
      "Fern", "Giant Mushroom":
        if effectr.mtrx[q2][c2] > 0 then
          me.applyBigPlant(q,c)
        end if
      "Sprawlbush", "featherFern", "Fungus Tree":
        if effectr.mtrx[q2][c2] > 0 then
          me.apply3Dsprawler(q,c, efname)
        end if
      "hang roots":
        repeat with r2 = 1 to 3 then
          if (random(100)<effectr.mtrx[q2][c2]) then
            me.applyHangRoots(q,c,0)
          end if
        end repeat
      "Colored Hang Roots":
        if (gdLayer = "C") then
          repeat with r2 = 1 to 3 then
            if (random(100)<effectr.mtrx[q2][c2]) then
              me.applyHangRoots(q,c,0)
            end if
          end repeat
        else
          repeat with r2 = 1 to 3 then
            if (random(100)<effectr.mtrx[q2][c2]) then
              me.applyColoredHangRoots(q,c,0)
            end if
          end repeat
        end if
      "Ivy":
        repeat with r2 = 1 to 3 then
          if (random(100)<effectr.mtrx[q2][c2]) then
            me.applyIvy(q,c,0)
          end if
        end repeat
      "Clovers":
        me.applyResRoots(q,c)
        me.applyStandardErosion(q,c,0, efname, effectr)
      "Wires":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.applyWire(q,c,0)
        end if
      "Chains":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.applyChain(q,c,0)
        end if
      "Colored Wires":
        if (gdIndLayer = "C") then
          if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
            me.applyWire(q,c,0)
          end if
        else
          if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
            me.applyColoredWires(q,c,0)
          end if
        end if
      "Colored Chains":
        if (gdIndLayer = "C") then
          if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
            me.applyChain(q,c,0)
          end if
        else
          if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
            me.applyColoredChains(q,c,0)
          end if
        end if
      "Ring Chains":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.applyRingChains(q,c,0)
        end if
      "BlackGoo":
        me.applyBlackGoo(q,c,0)
      "DarkSlime":
        me.applyDarkSlime(q,c, effectr)
      "Restore As Scaffolding", "Restore As Pipes":
        me.applyRestoreEffect(q,c, q2, c2, efname)
      "Rollers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(5)=1) then
          me.ApplyRoller(q,c,0)
        end if
      "Thorn Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyThornGrower(q,c,0)
        end if
      "Horror Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyHorrorGrower(q,c,0)
        end if
      "Spinets":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplySpinets(q,c,0)
        end if
      "Garbage Spirals":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(6)=1) then
          me.ApplyGarbageSpiral(q,c,0)
        end if
      "Thick Roots":
        if (random(100)<effectr.mtrx[q2][c2]) then
          me.applyThickRoots(q,c,0)
        end if
      "Colored Thick Roots":
        if (gdLayer = "C") then
          if (random(100)<effectr.mtrx[q2][c2]) then
            me.applyThickRoots(q,c,0)
          end if
        else
          if (random(100)<effectr.mtrx[q2][c2]) then
            me.applyColoredThickRoots(q,c,0)
          end if
        end if
      "Shadow Plants":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)=1) then
          me.applyShadowPlants(q,c,0)
        end if
      "Colored Shadow Plants":
        if (gdLayer = "C") then
          if (random(100)<effectr.mtrx[q2][c2]) and (random(3)=1) then
            me.applyShadowPlants(q,c,0)
          end if
        else
          if (random(100)<effectr.mtrx[q2][c2]) and (random(3)=1) then
            me.applyColoredShadowPlants(q,c,0)
          end if
        end if
      "Root Plants":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)=1) then
          me.applyRootPlants(q,c,0)
        end if
      "DaddyCorruption":
        me.applyDaddyCorruption(q,c,effectr.mtrx[q2][c2])
      "Corruption No Eye":
        me.applyCorruptionNoEye(q,c,effectr.mtrx[q2][c2])
      "Slag":-->to support older projects
        me.applyCorruptionNoEye(q,c,effectr.mtrx[q2][c2])
      "Wastewater Mold":
        if (gdLayer = "C") then
          me.applyCorruptionNoEye(q,c,effectr.mtrx[q2][c2])
        else
          me.applyWastewaterMold(q,c,effectr.mtrx[q2][c2])
        end if
      "Little Flowers":
        me.applyFlowers(q,c,effectr.mtrx[q2][c2])
        --dakras stuff      
      "Left Facing Kelp":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.ApplySideKelp(q,c)
        end if
      "Right Facing Kelp":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.ApplyFlipSideKelp(q,c)
        end if
      "Mixed Facing Kelp":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.ApplyMixKelp(q,c)
        end if
      "Bubble Grower":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(2)=1) then
          me.ApplyBubbleGrower(q,c)
        end if
      "Moss Wall":
        me.applyMossWall(q,c,effectr.mtrx[q2][c2])
      "Club Moss":
        me.applyClubMoss(q,c,effectr.mtrx[q2][c2])
      "Fuzzy Growers":
        if (random(100) < effectr.mtrx[q2][c2]) and (random(3) > 1) then
          me.ApplyFuzzyGrower(q, c)
        end if
      "Coral Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyCoralGrower(q,c,0)
        end if
      "Leaf Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyLeafGrower(q,c,0)
        end if
      "Meat Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyMeatGrower(q,c,0)
        end if
      "Thunder Growers":
        if (random(100) < effectr.mtrx[q2][c2]) and (random(3) > 1) then
          me.ApplyThunderGrower(q,c,0)
        end if
      "Fancy Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyFancyGrower(q,c,0)
        end if 
      "Ice Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyIceGrower(q,c,0)
        end if
      "Grass Growers":
        if (random(100)<effectr.mtrx[q2][c2]) and (random(3)>1) then
          me.ApplyGrassGrower(q,c,0)
        end if
      "Mushroom Stubs":
        me.applyMushroomStubs(q,c,effectr.mtrx[q2][c2])
      "Mosaic Plants":
        me.ApplyMosaicPlant(q, c)
      "Cobwebs":
        me.ApplyCobweb(q, c)
      "Fingers":
        me.ApplyFingers(q, c)
      "Grape Roots":
        repeat with r2 = 1 to 3
          if (random(100) < effectr.mtrx[q2][c2]) then
            me.applyGrapeRoots(q, c, 0)
          end if
        end repeat
      "Hand Growers":
        me.applyHandGrowers(q, c, 0)
      otherwise:
        if (gCustomEffects.getPos(efname) > 0) then
          me.ApplyCustomEffect(q, c, effectr, efname)
        end if
    end case
    the randomSeed = savSeed
  end if
end

on initEffect me
  effectr = gEEprops.effects[r]
  efopts =  effectr.options
  effectSeed = 0
  repeat with a = 1 to efopts.count
    curop = efopts[a]
    if(curop[1] = "Seed")then
      effectSeed = curop[3]
      exit repeat
    end if
  end repeat
  
  effectIn3D = false
  gRotOp = false
  repeat with op in efopts
    case op[1] of 
      "Layers":
        lrSup = ["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"][["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"].getPos(op[3])]
      "Color":
        colr = [color(255, 0, 255), color(0, 255, 255), color(0, 255, 0)][["Color1", "Color2", "Dead"].getPos(op[3])]
        gdLayer = ["A", "B", "C"][["Color1", "Color2", "Dead"].getPos(op[3])]
      "Detail Color":
        colrDetail = [color(255, 0, 255), color(0, 255, 255), color(0, 255, 0)][["Color1", "Color2", "Dead"].getPos(op[3])]
        gdDetailLayer = ["A", "B", "C"][["Color1", "Color2", "Dead"].getPos(op[3])]
      "Effect Color":
        colrInd = [color(255, 0, 255), color(0, 255, 255), color(0, 255, 0)][["EffectColor1", "EffectColor2", "None"].getPos(op[3])]
        gdIndLayer = ["A", "B", "C"][["EffectColor1", "EffectColor2", "None"].getPos(op[3])]
      "Seed":
        the randomSeed = op[3]
      "3D":
        effectIn3D = (op[3] = "On")
      "Rotate":
        gRotOp = (op[3] = "On")
      "Fatness": 
        fatOp = ["1px", "2px", "3px", "random"][["1px", "2px", "3px", "random"].getPos(op[3])]
      "Size":
        chOp = ["Small", "FAT"][["Small", "FAT"].getPos(op[3])]
      "Affect Gradients and Decals":
        gradAf = (op[3] = "Yes")
      "Color Intensity":
        colrIntensity  = ["H","M","L","N","R"][["High","Medium","Low","None","Random"].getPos(op[3])]
      "Fruit Density":
        fruitDensity = ["H","M","L","N"][["High","Medium","Low","None"].getPos(op[3])]
      "Leaf Density":
        leafDensity = op[3]
      "Mushroom Size":
        mshrSz  = ["S", "M", "R"][["Small", "Medium", "Random"].getPos(op[3])]
      "Mushroom Width":
        mshrSzW  = ["S", "M", "L", "R"][["Small", "Medium", "Wide", "Random"].getPos(op[3])]
      "Flowers":
        hasFlowers = (op[3] = "On")
      "Side":
        effSide = ["?", "L", "R", "T", "B"][["Left", "Right", "Top", "Bottom"].getPos(op[3]) + 1]
      "Finger Thickness":
        fingerSz = ["?", "S", "M", "L"][["Small", "Medium", "FAT"].getPos(op[3]) + 1]
      "Finger Length":
        fingerLen = ["?", "S", "M", "L"][["Short", "Medium", "Tall"].getPos(op[3]) + 1]
    end case
  end repeat
  
  case effectr.nm of
    "BlackGoo":
      cols = 100
      rows = 60
      
      member("blackOutImg1").image = image(cols*20, rows*20, 32)
      blk1 = member("blackOutImg1").image
      blk1.copyPixels(DRPxl, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      member("blackOutImg2").image = image(cols*20, rows*20, 32)
      blk2 = member("blackOutImg2").image
      blk2.copyPixels(DRPxl, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      sprite(57).visibility = 1
      sprite(58).visibility = 1
      
      global gRenderCameraTilePos, gRenderCameraPixelPos
      
      repeat with q = 1 to 100
        repeat with c = 1 to 60
          q2 = q + gRenderCameraTilePos.locH
          c2 = c + gRenderCameraTilePos.locV
          if(q2 < 1)or(q2 > gLOprops.size.locH)or(c2 < 1)or(c2 > gLOprops.size.locV)then
            blk1.copyPixels(DRPxl, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
            blk2.copyPixels(DRPxl, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
          end if
        end repeat
      end repeat
      
      blobImg = member("blob").image
      rct = blobImg.rect
      repeat with q2 = 1 to cols then
        repeat with c2 = 1 to rows then
          if(q2+gRenderCameraTilePos.locH > 0)and(q2+gRenderCameraTilePos.locH <= gLOprops.size.locH)and(c2+gRenderCameraTilePos.locV > 0)and(c2+gRenderCameraTilePos.locV <= gLOprops.size.locV)then
            tile = point(q2,c2)+gRenderCameraTilePos
            
            if (effectr.mtrx[tile.locH][tile.locV] = 0) then
              sPnt = giveMiddleOfTile(point(q2,c2))+point(-10,-10)--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              
              repeat with d = 1 to 10
                repeat with e = 1 to 10
                  ps = point(sPnt.locH + d*2, sPnt.locV + e*2)
                  blk1.copyPixels(blobImg, rect(ps.locH-6-random(random(11)),ps.locV-6-random(random(11)),ps.locH+6+random(random(11)),ps.locV+6+random(random(11))), rct, {#color:0, #ink:36})
                  blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(14)),ps.locV-7-random(random(14)),ps.locH+7+random(random(14)),ps.locV+7+random(random(14))), rct, {#color:0, #ink:36})
                  -- end if 
                end repeat
              end repeat
            else if ((gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(5) > 0)or(gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(4) > 0))and(gLEProps.matrix[tile.locH][tile.locV][2][1]=1) then
              ps = giveMiddleOfTile(point(q2,c2))--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              blk1.copyPixels(blobImg, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
              blk1.copyPixels(blobImg, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
            end if
          end if
        end repeat
      end repeat
      
    "Super BlackGoo":
      cols = 100
      rows = 60
      
      member("blackOutImg1").image = image(cols*20, rows*20, 32)
      blk1 = member("blackOutImg1").image
      member("blackOutImg1").image.copyPixels(DRPxl, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      member("blackOutImg2").image = image(cols*20, rows*20, 32)
      blk2 = member("blackOutImg2").image
      member("blackOutImg2").image.copyPixels(DRPxl, rect(0,0,cols*20, rows*20), rect(0,0,1,1), {#color:255})
      sprite(57).visibility = 1
      sprite(58).visibility = 1
      
      global gRenderCameraTilePos, gRenderCameraPixelPos
      
      repeat with q = 1 to 100
        repeat with c = 1 to 60
          q2 = q + gRenderCameraTilePos.locH
          c2 = c + gRenderCameraTilePos.locV
          if(q2 < 1)or(q2 > gLOprops.size.locH)or(c2 < 1)or(c2 > gLOprops.size.locV)then
            blk1.copyPixels(DRPxl, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
            blk2.copyPixels(DRPxl, rect((q-1)*20, (c-1)*20, q*20, c*20), rect(0,0,1,1), {#color:color(255, 255, 255)})
          end if
        end repeat
      end repeat
      
      blobImg = member("blob").image
      rct = blobImg.rect
      repeat with q2 = 1 to cols
        repeat with c2 = 1 to rows
          if(q2+gRenderCameraTilePos.locH > 0)and(q2+gRenderCameraTilePos.locH <= gLOprops.size.locH)and(c2+gRenderCameraTilePos.locV > 0)and(c2+gRenderCameraTilePos.locV <= gLOprops.size.locV)then
            tile = point(q2,c2)+gRenderCameraTilePos
            
            if (gEEprops.effects[r].mtrx[tile.locH][tile.locV] = 0) then
              sPnt = giveMiddleOfTile(point(q2,c2))+point(-10,-10)--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              
              repeat with d = 1 to 10
                repeat with e = 1 to 10
                  ps = point(sPnt.locH + d*2, sPnt.locV + e*2)
                  -- if member("layer0").image.getPixel(ps) = color(255, 255, 255) then
                  blk1.copyPixels(blobImg, rect(ps.locH-6-random(random(11)),ps.locV-6-random(random(11)),ps.locH+6+random(random(11)),ps.locV+6+random(random(11))), rct, {#color:0, #ink:36})
                  blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(14)),ps.locV-7-random(random(14)),ps.locH+7+random(random(14)),ps.locV+7+random(random(14))), rct, {#color:0, #ink:36})
                  -- end if 
                end repeat
              end repeat
            else if ((gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(5) > 0)or(gLEProps.matrix[tile.locH][tile.locV][1][2].getPos(4) > 0))and(gLEProps.matrix[tile.locH][tile.locV][2][1]=1) then
              ps = giveMiddleOfTile(point(q2,c2))--+gRenderCameraPixelPos--gRenderCameraTilePos-gRenderCameraPixelPos
              blk1.copyPixels(blobImg, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
              blk1.copyPixels(blobImg, rect(ps.locH-4-random(random(9)),ps.locV-4-random(random(9)),ps.locH+4+random(random(9)),ps.locV+4+random(random(9))), rct, {#color:0, #ink:36})
              blk2.copyPixels(blobImg, rect(ps.locH-7-random(random(9)),ps.locV-7-random(random(9)),ps.locH+7+random(random(9)),ps.locV+7+random(random(9))), rct, {#color:0, #ink:36})
            end if
          end if
        end repeat
      end repeat
      
    "Fungi Flowers":
      
      l = [2,3,4,5]
      l2 = []
      repeat with a = 1 to 4 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Colored Fungi Flowers":
      
      l = [2,3,4,5]
      l2 = []
      repeat with a = 1 to 4 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Lighthouse Flowers":
      
      l = [1,2,3,4,5,6,7,8]
      l2 = []
      repeat with a = 1 to 8 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Colored Lighthouse Flowers":
      
      l = [1,2,3,4,5,6,7,8]
      l2 = []
      repeat with a = 1 to 8 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Foliage":
      
      l = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
      l2 = []
      repeat with a = 1 to 28 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Assorted Trash":
      
      l = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]
      l2 = []
      repeat with a = 1 to 48 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "High Grass":
      
      l = [1,2,3,4]
      l2 = []
      repeat with a = 1 to 4 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Small Springs":
      
      l = [1,2,3,4,5,6,7]
      l2 = []
      repeat with a = 1 to 7 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "High Fern":
      
      l = [1,2]
      l2 = []
      repeat with a = 1 to 2 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Mistletoe":
      
      l = [1,2,3,4,5,6]
      l2 = []
      repeat with a = 1 to 6 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "Fern", "Giant Mushroom", "Springs":
      l = [1,2,3,4,5,6,7]
      l2 = []
      repeat with a = 1 to 7 then
        val = l[random(l.count)]
        l2.add(val)
        l.deleteOne(val)
      end repeat
      gEffectProps = [#list:l2, #listPos:1]
      
    "DaddyCorruption":
      global daddyCorruptionHoles
      daddyCorruptionHoles = []
      
    "Mosaic Plants":
      global mosaicPlantStarts
      mosaicPlantStarts = []
      me.InitMosaicPlants()
  end case
  
  
  txt = ""
  put "<APPLYING EFFECTS>" after txt
  put RETURN after txt
  
  repeat with ef = 1 to gEEprops.effects.count then
    
    if ef = r then
      put string(ef)&". ->"&gEEprops.effects[ef].nm after txt
    else
      put string(ef)&". "&gEEprops.effects[ef].nm after txt
    end if
    put RETURN after txt
  end repeat
  
  member("effectsL").text = txt
end

on exitEffect me
  case gEEprops.effects[r].nm of
    "BlackGoo":
      
      lr0 = member("layer0").image
      lr0.copyPixels(member("blackOutImg1").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(0, 255, 0)})
      lr0.copyPixels(member("blackOutImg2").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(255, 0, 0)})
      
      
      member("blackOutImg1").image = image(1, 1, 1)
      -- member("blackOutImg2").image = image(1, 1, 1)
      sprite(58).visibility = 0
      sprite(57).visibility = 0
      
    "Super BlackGoo":
      
      lr0 = member("layer0").image
      lr0.copyPixels(member("blackOutImg1").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(0, 255, 0)})
      lr0.copyPixels(member("blackOutImg2").image, rect(0,0,100*20, 60*20), rect(0,0,100*20, 60*20), {#ink:36, #color:color(255, 0, 0)})
      
      
      member("blackOutImg1").image = image(1, 1, 1)
      -- member("blackOutImg2").image = image(1, 1, 1)
      sprite(58).visibility = 0
      sprite(57).visibility = 0
      
    "DaddyCorruption":
      global daddyCorruptionHoles
      repeat with i = 1 to daddyCorruptionHoles.count then
        qd = rotateToQuad(rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2],-daddyCorruptionHoles[i][2],daddyCorruptionHoles[i][2],daddyCorruptionHoles[i][2]), daddyCorruptionHoles[i][3])
        repeat with d = 0 to 1 then
          member("layer"&string(daddyCorruptionHoles[i][4]+d)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 255, 255), #ink:36})
        end repeat
        if(random(2)=1)and(random(100)>daddyCorruptionHoles[i][5])then
          member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 0, 0), #ink:36})
        else
          case gdLayer of
            "A":
              member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(255, 0, 255), #ink:36})
              copyPixelsToEffectColor("A", daddyCorruptionHoles[i][4]+2, rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2]*1.5,-daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5), "softBrush1", member("softBrush1").rect, 0.5, lerp(random(50)*0.01, 1.0, random(daddyCorruptionHoles[i][5])*0.01))
            "B":
              member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(0, 255, 255), #ink:36})
              copyPixelsToEffectColor("B", daddyCorruptionHoles[i][4]+2, rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2]*1.5,-daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5), "softBrush1", member("softBrush1").rect, 0.5, lerp(random(50)*0.01, 1.0, random(daddyCorruptionHoles[i][5])*0.01))
            otherwise:
              member("layer"&string(daddyCorruptionHoles[i][4]+2)).image.copyPixels(member("DaddyBulb").image, qd, rect(60, 1, 134, 74), {#color:color(0, 255, 255), #ink:36})
              copyPixelsToEffectColor("B", daddyCorruptionHoles[i][4]+2, rect(daddyCorruptionHoles[i][1], daddyCorruptionHoles[i][1])+rect(-daddyCorruptionHoles[i][2]*1.5,-daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5,daddyCorruptionHoles[i][2]*1.5), "softBrush1", member("softBrush1").rect, 0.5, lerp(random(50)*0.01, 1.0, random(daddyCorruptionHoles[i][5])*0.01))       
          end case
        end if
      end repeat
      daddyCorruptionHoles = []
      
  end case
end


on ApplyCustomEffect(me, q, c, effectr, efname)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  mtrx = effectr.mtrx
  
  -- Find the effect
  cEff = VOID
  if (gCustomEffects.getPos(efname) > 0) then
    repeat with i = 1 to gEffects.count
      iefs = gEffects[i].efs
      repeat with j = 1 to iefs.count
        jef = iefs[j]
        if (jef.nm = efname) then
          cEff = jef
          exit repeat
        end if
      end repeat
      if (cEff <> VOID) then exit repeat
    end repeat
  end if
  
  -- Draw the effect
  if (cEff <> VOID) then
    effGraf = member("previewImprt")
    if (gLastImported <> cEff.nm) then
      member("previewImprt").importFileInto("Effects\" & cEff.nm & ".png")
      effGraf.name = "previewImprt"
      gLastImported = cEff.nm
    end if
    effGraf = effGraf.image
    
    case cEff.tp of
      "standardPlant": -- standard plant effect
        -- Get potential layers
        case lrSup of
          "All":
            lsL = [1, 2, 3]
          "1":
            lsL = [1]
          "2":
            lsL = [2]
          "3":
            lsL = [3]
          "1:st and 2:nd":
            lsL = [1, 2]
          "2:nd and 3:rd":
            lsL = [2, 3]
          otherwise:
            lsL = [1, 2, 3]
        end case
        
        -- Get amount
        amount = 17
        if (cEff.findPos("placeAmt") > 0) then
          amount = cEff.placeAmt
        end if
        
        -- Now we place the effect
        repeat with layer in lsL
          if solidMtrx[q2][c2][layer]=0 and solidAfaMv(point(q2,c2+1),layer)=1 then
            repeat with i = 1 to mtrx[q2][c2] * 0.01 * amount then
              pnt = me.giveGroundPos(q,c,layer)
              d = random(9) + ((layer-1)*10)
              
              var = random(cEff.vars)
              if cEff.findPos("strengthAffectVar") then var = random(restrict((cEff.vars*(mtrx[q2][c2]-11+random(21))*0.01).integer, 1, cEff.vars))
              grab = rect(cEff.pxlSz.locH * (var-1), 1, cEff.pxlSz.locH * var, 1+cEff.pxlSz.locV)
              rot = 0
              if cEff.findPos("randRot") then rot = random(cEff.randRot * 2 + 1) - cEff.randRot
              
              sz = (random(41) + 79) / 100.0 -- default range: 0.8 to 1.2 (inclusive)
              if cEff.findPos("szVar") then
                if cEff.szVar[1] = cEff.szVar[2] then
                  sz = cEff.szVar[1]
                else if cEff.findPos("strengthAffectSize") then
                  sz = cEff.szVar[1] * (1.0 - power(mtrx[q2][c2] / 100.0, 0.85)) + cEff.szVar[2] * power(mtrx[q2][c2] / 100.0, 0.85)
                else
                  sz = (random((cEff.szVar[2] * 1000.0 - cEff.szVar[1] * 1000.0)) / 1000.0) + cEff.szVar[1]
                end if
              end if
              
              rot = 0
              if cEff.findPos("rotVar") then
                rot = random(cEff.rotVar * 2 + 1) - cEff.rotVar
              end if
              
              flp = 0
              if cEff.findPos("randomFlip") then
                if cEff.randomFlip then flp = random(2)-1
              end if
              rootAmt = 5
              if cEff.findPos("rootAmt") then rootAmt = cEff.rootAmt
              qd = rect(pnt, pnt) + rect(-(cEff.pxlSz.locH/2.0)*sz, -cEff.pxlSz.locV*sz, (cEff.pxlSz.locH/2.0)*sz, rootAmt)
              qd = rotateToQuadFix(qd, rot)
              if flp then qd = flipQuadH(qd)
              
              useEffCol = 0
              if cEff.findPos("pickColor") then
                if cEff.pickColor then useEffCol = 1
              end if
              
              if useEffCol then
                member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#color:colr, #ink:36})
                if colr <> color(0,255,0) then
                  if cEff.findPos("hasGrad") then
                    if cEff.hasGrad then grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
                  end if
                  copyPixelsToEffectColor(gdLayer, d, qd, "previewImprt", grab, 0.5, VOID)
                end if
              else
                member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#ink:36})
                if cEff.findPos("forceGrad") then
                  if cEff.forceGrad then
                    grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
                    copyPixelsToEffectColor("A", d, qd, "previewImprt", grab, 0.5, VOID)
                    copyPixelsToEffectColor("B", d, qd, "previewImprt", grab, 0.5, VOID)
                  end if
                end if
              end if
            end repeat
          end if
        end repeat
        
      "grower", "hanger", "clinger": -- grower effect and its extended family
        if (random(100) < mtrx[q2][c2]) and (random(3) > 1) then
          
          case lrSup of
            "All":
              d = random(29)
            "1":
              d = random(9)
            "2":
              d = random(10) - 1 + 10
            "3":
              d = random(10) - 1 + 20
            "1:st and 2:nd":
              d = random(19)
            "2:nd and 3:rd":
              d = random(20) - 1 + 10
            otherwise:
              d = random(29)
          end case
          lr = 1 + (d > 9) + (d > 19)
          
          -- Figure out grow direction
          case cEff.tp of
            "grower": -- the normal kind.
              growDir = 180
            "hanger": -- growers but they grow upside down.
              growDir = 0
            "clinger": -- growers but they grow from the sides. how fancy!
              side = random(2)-1
              if effSide = "L" then side = 0
              else if effSide = "R" then side = 1
              if side = 1 then growDir = 90
              else growDir = 270
          end case
          
          -- Do we have a tip? If so, do setup
          doingTip = 0
          if cEff.findPos("tipGraf") then
            doingTip = 1
            effGraf = member("previewImprt")
            if gLastImported <> cEff.tipGraf then
              member("previewImprt").importFileInto("Effects\" & cEff.tipGraf & ".png")
              effGraf.name = "previewImprt"
              gLastImported = cEff.tipGraf
            end if
            effGraf = effGraf.image
          end if
          
          -- Set up other variables
          sz = 1.0
          blnd = 1.0
          blnd2 = 1.0
          varBias = 0
          if cEff.findPos("heightAffectVar") > 0 then
            if cEff.heightAffectVar < 0 then
              varBias = 1
            end if
          end if
          mdPnt = giveMiddleOfTile(point(q,c))
          pnt = mdPnt + point(random(21)-11, random(21)-11)
          lastDir = growDir + random(cEff.initRotVar * 2 + 1) - cEff.initRotVar
          
          if cEff.findPos("szChange") then
            sz = cEff.szChange[1]
          end if
          
          -- Draw loop: as with every grower, draw from tip to ground (or void)
          repeat while (pnt.locV < gLOprops.size.locV * 20 + 100) and (pnt.locV > -100) and (pnt.locH < gLOprops.size.locH * 20 + 100) and (pnt.locH > -100) then
            if doingTip = 1 then
              vars = cEff.tipVars
              pxlSz = cEff.tipPxlSz
              moveAmt = cEff.tipMoveAmt
            else
              vars = cEff.vars
              pxlSz = cEff.pxlSz
              moveAmt = cEff.segmentMoveAmt
            end if
            
            -- Figure out grow direction and take a step in that direction. The area between the step is the segment.
            dir = growDir + random(cEff.segmentRotVar * 2 + 1) - cEff.segmentRotVar
            dir = lerp(lastDir, dir, cEff.segmentRotPull)
            lastPnt = pnt
            pnt = pnt + degToVec(dir) * moveAmt
            lastDir = dir
            
            -- Set up the quad
            qd = (lastPnt + pnt) / 2.0
            qd = rect(qd, qd) + rect(-pxlSz.locH*sz/2.0,-pxlSz.locV/2.0, pxlSz.locH*sz/2.0, pxlSz.locV/2.0)
            qd = rotateToQuadFix(qd, lookAtpoint(lastPnt, pnt))
            
            flp = 0
            if cEff.findPos("randomFlip") then
              if cEff.randomFlip then flp = random(2)-1
            end if
            if flp then qd = flipQuadH(qd)
            
            -- Figure out variation and effect color
            var = random(vars)
            if cEff.findPos("heightAffectVar") and (doingTip <> 1) then
              varBias = restrict(varBias + cEff.heightAffectVar, 0, 1)
              var = random(restrict((cEff.vars*varBias).integer, 1, cEff.vars))
            end if
            grab = rect(pxlSz.locH*(var-1), 1, pxlSz.locH*var, 1+pxlSz.locV)
            
            useEffCol = 0
            if cEff.findPos("pickColor") then
              if cEff.pickColor then useEffCol = 1
            end if
            
            -- Draw the damn thing
            if useEffCol then
              member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#color:colr, #ink:36})
              if colr <> color(0,255,0) then
                if cEff.findPos("hasGrad") then
                  if cEff.hasGrad then grab = grab + rect(0, pxlSz.locV, 0, pxlSz.locV)
                end if
                copyPixelsToEffectColor(gdLayer, d, qd, "previewImprt", grab, 0.5, blnd)
                
                if cEff.findPos("effectFadeOut2") and blnd2 > 0 and doingTip = 0 then
                  qd = (lastPnt + pnt) / 2.0
                  qd = rect(qd, qd) + rect(-pxlSz.locH*sz/1.6,-pxlSz.locV/1.6, pxlSz.locH*sz/1.6, pxlSz.locV/1.6)
                  qd = rotateToQuadFix(qd, lookAtpoint(lastPnt, pnt))
                  if flp then qd = flipQuadH(qd)
                  copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
                end if
              end if
            else
              member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#ink:36})
              if cEff.findPos("forceGrad") then
                if cEff.forceGrad then
                  grab = grab + rect(0, pxlSz.locV, 0, pxlSz.locV)
                  copyPixelsToEffectColor("A", d, qd, "previewImprt", grab, 0.5, blnd)
                  copyPixelsToEffectColor("B", d, qd, "previewImprt", grab, 0.5, blnd)
                end if
              end if
            end if
            
            -- Adjust per-segment variables
            if cEff.findPos("effectFadeOut") then blnd = blnd * cEff.effectFadeOut
            else blnd = blnd * 0.85
            
            if cEff.findPos("effectFadeOut2") then blnd2 = max(0.0, blnd2 - cEff.effectFadeOut2)
            
            if cEff.findPos("szChange") then
              sz = restrict(sz + random(1000)/1000.0 * cEff.szChange[3], min(cEff.szChange[1], cEff.szChange[2]), max(cEff.szChange[1], cEff.szChange[2]))
            end if
            
            -- Switch graphic and reset after tip
            if doingTip = 1 then
              doingTip = 0
              effGraf = member("previewImprt")
              if gLastImported <> cEff.nm then
                member("previewImprt").importFileInto("Effects\" & cEff.nm & ".png")
                effGraf.name = "previewImprt"
                gLastImported = cEff.nm
              end if
              effGraf = effGraf.image
            end if
            
            -- Stop once we hit solid ground
            tlPos = giveGridPos(pnt) + gRenderCameraTilePos
            if solidAfaMv(tlPos, lr) then exit repeat
          end repeat
        end if
        
      "individual": -- individual plant effect
        case lrSup of
          "All":
            d = random(29)
          "1":
            d = random(9)
          "2":
            d = random(10) - 1 + 10
          "3":
            d = random(10) - 1 + 20
          "1:st and 2:nd":
            d = random(19)
          "2:nd and 3:rd":
            d = random(20) - 1 + 10
          otherwise:
            d = random(29)
        end case
        lr = 1 + (d > 9) + (d > 19)
        
        if solidMtrx[q2][c2][lr]=0 and solidAfaMv(point(q2,c2+1),lr)=1 then
          -- Figure out variables
          mdPnt = giveMiddleOfTile(point(q,c))
          pnt = mdPnt + point(random(21)-11, 10)
          
          var = random(cEff.vars)
          if cEff.findPos("strengthAffectVar") then var = random(restrict((cEff.vars*(mtrx[q2][c2]-11+random(21))*0.01).integer, 1, cEff.vars))
          grab = rect(cEff.pxlSz.locH*(var-1), 1, cEff.pxlSz.locH*var, 1+cEff.pxlSz.locV)
          
          sz = (random(41) + 79) / 100.0 -- default range: 0.8 to 1.2 (inclusive)
          if cEff.findPos("szVar") then
            if cEff.szVar[1] = cEff.szVar[2] then
              sz = cEff.szVar[1]
            else 
              sz = (random((cEff.szVar[2] * 1000.0 - cEff.szVar[1] * 1000.0)) / 1000.0) + cEff.szVar[1]
            end if
          end if
          
          rot = 0
          if cEff.findPos("rotVar") then
            rot = random(cEff.rotVar * 2 + 1) - cEff.rotVar
          end if
          
          flp = 0
          if cEff.findPos("randomFlip") then
            if cEff.randomFlip then flp = random(2)-1
          end if
          rootAmt = 5
          if cEff.findPos("rootAmt") then rootAmt = cEff.rootAmt
          
          qd = rect(pnt, pnt) + rect(-(cEff.pxlSz.locH/2.0)*sz, -cEff.pxlSz.locV*sz, (cEff.pxlSz.locH/2.0)*sz, rootAmt)
          qd = rotateToQuadFix(qd, rot)
          if flp then qd = flipQuadH(qd)
          
          -- Draw the thing
          useEffCol = 0
          if cEff.findPos("pickColor") then
            if cEff.pickColor then useEffCol = 1
          end if
          
          if useEffCol then
            member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              if cEff.findPos("hasGrad") then
                if cEff.hasGrad then grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
              end if
              copyPixelsToEffectColor(gdLayer, d, qd, "previewImprt", grab, 0.5, VOID)
            end if
          else
            member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#ink:36})
            if cEff.findPos("forceGrad") then
              if cEff.forceGrad then
                grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
                copyPixelsToEffectColor("A", d, qd, "previewImprt", grab, 0.5, VOID)
                copyPixelsToEffectColor("B", d, qd, "previewImprt", grab, 0.5, VOID)
              end if
            end if
          end if
          
        end if
        
      "wall": -- things that get placed on wall
        case lrSup of
          "All":
            dmin = 0
            dmax = 29
          "1":
            dmin = 0
            dmax = 9
          "2":
            dmin = 10
            dmax = 19
          "3":
            dmin = 20
            dmax = 29
          "1:st and 2:nd":
            dmin = 0
            dmax = 19
          "2:nd and 3:rd":
            dmin = 10
            dmax = 29
          otherwise:
            dmin = 0
            dmax = 29
        end case
        
        mdPnt = giveMiddleOfTile(point(q,c))
        amount = 20
        if cEff.findPos("placeAmt") > 0 then
          amount = cEff.placeAmt
        end if
        
        repeat with k = 1 to max(1, (amount * mtrx[q2][c2] / 100.0).integer) then
          -- Figure out where and how big (we need ow big to figure out depth believe it or not)
          pnt = mdPnt + point(random(21)-11, random(21)-11)
          
          sz = (random(41) + 79) / 100.0 -- default range: 0.8 to 1.2 (inclusive)
          if cEff.findPos("szVar") then
            if cEff.szVar[1] = cEff.szVar[2] then
              sz = cEff.szVar[1]
            else if cEff.findPos("strengthAffectSize") then
              x = restrict(mtrx[q2][c2]-11+random(21),1,100)
              sz = cEff.szVar[1] * (1.0 - power(x / 100.0, 0.85)) + cEff.szVar[2] * power(x / 100.0, 0.85)
            else
              sz = (random((cEff.szVar[2] * 1000.0) - (cEff.szVar[1] * 1000.0)+1)-1) / 1000.0 + cEff.szVar[1]
            end if
          end if
          
          -- Figure out depth and if we can actually place it
          canPlace = 0
          d = -1
          lr = 0
          cl = color(255,255,255)
          repeat with dp = dmin to dmax then
            rad = sz/2.0
            repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)] then
              tempPt = point((pnt.locH + dr.locH*rad).integer, (pnt.locV + dr.locV*rad).integer)
              if (member("layer"&string(dp)).getPixel(tempPt.locH, tempPt.locV) <> color(255,255,255)) then
                canPlace = 1
                cl = member("layer"&string(dp)).getPixel(tempPt.locH, tempPt.locV)
                if (cEff.findPos("can3D")>0) then
                  if cEff.can3D = 1 or (cEff.can3D = 2 and effectIn3D) then
                    d = max(0, dp - 2)
                  else
                    d = dp
                  end if
                else
                  d = dp
                end if
                lr = 1 + (d > 9) + (d > 19)
                exit repeat
              end if
            end repeat
            if canPlace = 1 then exit repeat
          end repeat
          
          if (canPlace=1) and (cEff.findPos("requireSolid") > 0) then
            if cEff.requireSolid = 1 then
              canPlace = solidAfaMv(point(q2,c2),lr)
            end if
          end if
          
          -- Now draw it if we can
          if canPlace = 1 and d > -1 then
            d = restrict(d - 1 + random(2), dmin, dmax)
            
            var = random(cEff.vars)
            if cEff.findPos("strengthAffectVar") then var = random(restrict((cEff.vars*(mtrx[q2][c2]-11+random(21))*0.01).integer, 1, cEff.vars))
            grab = rect(cEff.pxlSz.locH*(var-1), 1, cEff.pxlSz.locH*var, 1+cEff.pxlSz.locV)
            
            rot = 0
            if cEff.findPos("randomRotat") then
              if cEff.randomRotat then rot = random(361) - 1
            end if
            
            flp = 0
            if cEff.findPos("randomFlip") then
              if cEff.randomFlip then flp = random(2)-1
            end if
            
            qd = rect(pnt, pnt) + rect(-(cEff.pxlSz/2.0), cEff.pxlSz/2.0)
            qd = rotateToQuadFix(qd, rot)
            if flp then qd = flipQuadH(qd)
            
            useEffCol = 0
            if cEff.findPos("pickColor") then
              if cEff.pickColor then useEffCol = 1
            end if
            
            if cEff.findPos("outline") then -- outline, if wanted
              if cEff.outline then
                repeat with jlist in [[point(-1,-1), color(0,0,255)], [point(-0,-1), color(0,0,255)], [point(-1,-0), color(0,0,255)], [point(1,1), color(255,0,0)],[point(0,1), color(255,0,0)],[point(1,0), color(255,0,0)]] then
                  oqd = [qd[1] + jlist[1], qd[2] + jlist[1], qd[3] + jlist[1], qd[4] + jlist[1]]
                  member("layer"&string(d)).image.copyPixels(effGraf, oqd, grab, {#color:jlist[2], #ink:36})
                end repeat
              end if
            end if
            
            if useEffCol then -- actually drawing
              member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#color:colr, #ink:36})
              if colr <> color(0,255,0) then
                if cEff.findPos("hasGrad") then
                  if cEff.hasGrad then grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
                end if
                copyPixelsToEffectColor(gdLayer, d, qd, "previewImprt", grab, 0.5, VOID)
              end if
            else
              member("layer"&string(d)).image.copyPixels(effGraf, qd, grab, {#ink:36})
              if cEff.findPos("forceGrad") then
                if cEff.forceGrad then
                  grab = grab + rect(0, cEff.pxlSz.locV, 0, cEff.pxlSz.locV)
                  copyPixelsToEffectColor("A", d, qd, "previewImprt", grab, 0.5, VOID)
                  copyPixelsToEffectColor("B", d, qd, "previewImprt", grab, 0.5, VOID)
                end if
              end if
            end if
          end if
        end repeat
        
      "texture": --things that add textures to the wall
        case lrSup of
          "All":
            dmin = 0
            dmax = 29
          "1":
            dmin = 0
            dmax = 9
          "2":
            dmin = 10
            dmax = 19
          "3":
            dmin = 20
            dmax = 29
          "1:st and 2:nd":
            dmin = 0
            dmax = 19
          "2:nd and 3:rd":
            dmin = 10
            dmax = 29
          otherwise:
            dmin = 0
            dmax = 29
        end case
        
        clrMask = 2
        
        if (cEff.findPos("clrMask")) then -- masking to specific colours, ie 'only apply this to green pixels'
          clrMask = cEff.clrMask
        end if
        
        maskRed = (bitAnd(clrMask, 1) = 1)
        maskGreen = (bitAnd(clrMask, 2) = 2)
        maskBlue = (bitAnd(clrMask, 4) = 4)
        maskEffA = (bitAnd(clrMask, 8) = 8)
        maskEffB = (bitAnd(clrMask, 16) = 16)
        
        bleed = 0
        
        useEffCol = 0
        if cEff.findPos("pickColor") then
          if cEff.pickColor then useEffCol = 1
        end if
        
        if (cEff.findPos("bleed")) then -- 'bleed' being if the texture can apply through layers
          bleed = cEff.bleed
        end if
        
        placeAmt = 20
        if (cEff.findPos("placeAmt")) then
          placeAmt = cEff.placeAmt
        end if
        
        affop = 0.05
        if (cEff.findPos("affectOpenAreas")) then
          affop = cEff.affectOpenAreas
        end if
        
        requireSolid = 0
        if (cEff.findPos("requireSolid")) then
          requireSolid = cEff.requireSolid
        end if
        
        fc = affop + (1.0-affop)* (1-((1-solidAfaMv(point(q2,c2), 3)) * requireSolid))
        
        repeat with dt = 1 to 30
          lr = 30-dt
          
          if (lr = 9) or (lr = 19) then
            lraddc = 1+(dt>9)+(dt>19)
            sld = (1-((1-solidMtrx[q2][c2][lraddc]) * requireSolid))
            fc = affop + (1.0 - affop) * (1-((1-solidAfaMv(point(q2,c2), lraddc)) * requireSolid))
          end if
          
          deepEffect = 0
          if (lr = 0) or (lr = 10) or (lr = 20) or (sld = 0) then
            deepEffect = 1
          end if
          
          effSt = mtrx[q2][c2]
          
          placeCount = effSt * (0.2 + (0.8 * deepEffect)) * 0.01 * placeAmt * fc
          
          if (lr >= dmin) and (lr <= dmax) then
            repeat with placed = 1 to placeCount then
              pnt = giveMiddleOfTile(point(q,c)) + point(random(21)-11, random(21)-11)
              
              if deepEffect then
                pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
              else
                if random(2)=1 then
                  pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
                else 
                  pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
                end if
              end if
              
              var = random(cEff.vars)
          
              if (cEff.findPos("strengthAffectVar")) then
                if cEff.strengthAffectVar then
                  var = random(restrict((cEff.vars*(effSt-11+random(21))*0.01).integer, 1, cEff.vars))
                end if
              end if
              
              repeat with lr2 = lr to restrict(lr + bleed, dmin, 29) then
                
                layerlr = member("layer"&string(lr2)).image
                
                repeat with lch = 0 to (cEff.pxlSz.locH - 1) then
                  repeat with lcv = 0 to (cEff.pxlSz.locV - 1) then
                    lrClr = layerlr.getPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv)
                    
                    if doesColorFitMask(lrClr, maskRed, maskGreen, maskBlue, maskEffA, maskEffB) then
                      gtCl = effGraf.getPixel(lch + (var - 1) * cEff.pxlSz.locH, lcv + 1)
                      if (gtCl <> DRWhite) then
                        --layerlr.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, gtCl)
                        
                        
                        if useEffCol then
                          layerlr.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, colr)
                          if (cEff.findPos("hasGrad")) then
                            if cEff.hasGrad then
                              gradClr = effGraf.getPixel(lch + (var - 1) * cEff.pxlSz.locH, lcv + 1 + cEff.pxlSz.locV)
                              if (gdLayer <> "C") then
                                member("gradient"&gdLayer&string(lr2)).image.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, gradClr)
                              end if
                            end if
                          end if
                        else
                          layerlr.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, gtCl)
                          
                          if (cEff.findPos("forceGrad")) then
                            if (cEff.forceGrad) then
                              gradClr = effGraf.getPixel(lch + (var - 1) * cEff.pxlSz.locH, lcv + 1 + cEff.pxlSz.locV)
                              member("gradientA"&string(lr2)).image.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, gradClr)
                              member("gradientB"&string(lr2)).image.setPixel(pnt.locH - (cEff.pxlSz.locH / 2) + lch, pnt.locV - (cEff.pxlSz.locV / 2) + lcv, gradClr)
                            end if
                          end if
                        end if
                      end if
                    end if
                  end repeat
                end repeat
              end repeat
            end repeat
          end if
        end repeat
    end case
  end if
end

on doesColorFitMask clr, maskRed, maskGreen, maskBlue, maskEffA, maskEffB -- if a color fits the mask specified
  if maskRed and clr = color(255, 0, 0) then
    return true
  end if
  
  if maskGreen and clr = color(0, 255, 0) then
    return true
  end if
  
  if maskBlue and clr = color(0, 0, 255) then
    return true
  end if
  
  if maskEffA then
    if maskRed and clr = color(150, 0, 150) then
      return true
    end if
    if maskGreen and clr = color(255, 0, 255) then
      return true
    end if
    if maskBlue and clr = color(255, 150, 255) then
      return true
    end if
  end if
  
  if maskEffB then
    if maskRed and clr = color(0, 150, 150) then
      return true
    end if
    if maskGreen and clr = color(0, 255, 255) then
      return true
    end if
    if maskBlue and clr = color(150, 255, 255) then
      return true
    end if
  end if
  
  return false
end


on applyStandardErosion me, q, c, eftc, tp, effectr
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  affop = effectr.affectOpenAreas
  fc = affop + (1.0-affop)* (     solidAfaMv(point(q2,c2), 3)   )
  
  repeat with d = 1 to 30
    lr = 30-d
    case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
      "All":
        --lrb = lr
        dmin = 0
        dmax = 29
      "1":
        --lrb = restrict(lr, 0, 9)
        dmin = 0
        dmax = 9
      "2":
        --lrb = restrict(lr, 10, 19)
        dmin = 10
        dmax = 19
      "3":
        --lrb = restrict(lr, 20, 29)
        dmin = 20
        dmax = 29
      "1:st and 2:nd":
        --lrb = restrict(lr, 0, 19)
        dmin = 0
        dmax = 19
      "2:nd and 3:rd":
        --lrb = restrict(lr, 10, 29)
        dmin = 10
        dmax = 29
      otherwise:
        --lrb = lr
        dmin = 0
        dmax = 29
    end case
    if (lr = 9)or(lr=19) then
      lraddc = 1+(d>9)+(d>19)
      sld = (solidMtrx[q2][c2][lraddc])
      fc = affop + (1.0-affop)* ( solidAfaMv(point(q2,c2), lraddc) )
    end if
    deepEffect = 0
    
    if (lr = 0)or(lr=10)or(lr=20)or(sld=0)then
      deepEffect = 1
    end if
    mtrxq2c2 = effectr.mtrx[q2][c2]
    strlr = string(lr)
    layerlr = member("layer" & strlr).image
    galr = member("gradientA" & strlr).image
    gblr = member("gradientB" & strlr).image
    dclr = member("layer" & strlr & "dc").image
    endofloop = mtrxq2c2*(0.2 + (0.8*deepEffect))*0.01*effectr.repeats*fc
    repeat with cntr = 1 to endofloop
      if deepEffect then
        pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
      else
        if random(2)=1 then
          pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
        else 
          pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
        end if
      end if
      
      case tp of
        "Rust",  "Barnacles", "Colored Barnacles", "Clovers":
          pnt = pnt+degToVec(random(360))*4
          if (lr > dmax) or (lr < dmin) then
            cl = DRWhite
            clA = DRWhite
            clB = DRWhite
            clDc = DRWhite
          else
            cl = layerlr.getPixel(pnt)
            clA = galr.getPixel(pnt)
            clB = gblr.getPixel(pnt)
            clDc = dclr.getPixel(pnt)
          end if
        "Erode", "Ultra Super Erode":
          pnt = pnt+degToVec(random(360))*2
          if (layerlr.getPixel(pnt) = DRWhite) or (random(108)=1) then
            cl = "G"
          else
            cl = DRWhite
          end if
          if (layerlr.getPixel(pnt) = DRWhite) then
            cl = "N"
          end if
        "Super Erode":
          pnt = pnt+degToVec(random(360))*2
          if (layerlr.getPixel(pnt) = DRWhite) then
            cl = "G"
          else
            cl = DRWhite
          end if
          if (layerlr.getPixel(pnt) = DRWhite) then
            cl = "N"
          end if
        "Destructive Melt", "Impacts":
          if (lr > dmax) or (lr < dmin) then
            cl = DRWhite
            clA = DRWhite
            clB = DRWhite
            clDc = DRWhite
          else
            cl = layerlr.getPixel(pnt)
            clA = galr.getPixel(pnt)
            clB = gblr.getPixel(pnt)
            clDc = dclr.getPixel(pnt)
          end if
          if(cl = DRWhite)then
            cl = "W"
          end if
          if(clA = DRWhite)then
            clA = "W"
          end if
          if(clB = DRWhite)then
            clB = "W"
          end if
          if(clDc = DRWhite)then
            clDc = "W"
          end if
        otherwise:
          if (lr > dmax) or (lr < dmin) then
            cl = DRWhite
            clA = DRWhite
            clB = DRWhite
            clDc = DRWhite
          else
            cl = layerlr.getPixel(pnt)
            clA = galr.getPixel(pnt)
            clB = gblr.getPixel(pnt)
            clDc = dclr.getPixel(pnt)
          end if
      end case
      
      case tp of
        "Slime", "SlimeX3":
          if (cl <> DRWhite) then
            ofst = random(2) - 1
            lgt = 3 + random(random(random(6)))
            if (effectIn3D) then
              nwLr = get3DLr(lr)
            else
              case lrSup of
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if (nwLr > 29) then
              nwLr = 29
            else if (nwLr < 0) then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            layernwlr = member("layer" & strnwlr).image
            if (gradAf) then
              ondc = (clDc <> DRWhite)
              ona = (clA <> DRWhite)
              onb = (clB <> DRWhite)
              slmRect = rect(pnt, pnt) + rect(0 + ofst, 0, 1 + ofst, lgt)
              layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
              if (ondc) then
                dcnwlr = member("layer" & strnwlr & "dc").image
                dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
              end if
              if (ona) then
                ganwlr = member("gradientA" & strnwlr).image
                ganwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clA})
              end if
              if (onb) then
                gbnwlr = member("gradientB" & strnwlr).image
                gbnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clB})
              end if
              if (random(2) = 1) then
                slmRect = rect(pnt, pnt) + rect(0 + ofst + 1, 1 ,1 + ofst + 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
                if (ondc) then
                  dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
                end if
                if (ona)then
                  ganwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clA})
                end if
                if (onb)then
                  gbnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clB})
                end if
              else
                slmRect = rect(pnt, pnt) + rect(0 + ofst - 1, 1, 1 + ofst - 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
                if (ondc) then
                  dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
                end if
                if (ona) then
                  ganwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clA})
                end if
                if (onb) then
                  gbnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clB})
                end if
              end if
            else if (slimeFxt) then
              slmRect = rect(pnt, pnt) + rect(0 + ofst, 0, 1 + ofst, lgt)
              layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
              ondc = (clDc <> DRWhite)
              if (ondc) then
                dcnwlr = member("layer" & strnwlr & "dc").image
                dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
              end if
              if (random(2) = 1) then
                slmRect = rect(pnt, pnt) + rect(0 + ofst + 1, 1 ,1 + ofst + 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
                if (ondc) then
                  dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
                end if
              else
                slmRect = rect(pnt, pnt) + rect(0 + ofst - 1, 1, 1 + ofst - 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
                if (ondc) then
                  dcnwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:clDc})
                end if
              end if
            else
              slmRect = rect(pnt, pnt) + rect(0 + ofst, 0, 1 + ofst, lgt)
              layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
              if (random(2) = 1) then
                slmRect = rect(pnt, pnt) + rect(0 + ofst + 1, 1 ,1 + ofst + 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
              else
                slmRect = rect(pnt, pnt) + rect(0 + ofst - 1, 1, 1 + ofst - 1, lgt - 1)
                layernwlr.copyPixels(DRPxl, slmRect, DRPxlRect, {#color:cl})
              end if
            end if
          end if
          
        "DecalsOnlySlime":
          if (cl <> DRWhite) and (lr >= dmin) and (lr <= dmax) then
            ofst = random(2)-1
            lgt = 3 + random(random(random(6)))
            ondc = (clDc <> DRWhite)
            onga = (clA <> DRWhite)
            ongb = (clB <> DRWhite)
            if (ondc)then
              dclr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), DRPxlRect, {#color:clDc})
            end if
            if (onga)then
              galr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), DRPxlRect, {#color:clA})
            end if
            if (ongb)then
              gblr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,1+ofst,lgt), DRPxlRect, {#color:clB})
            end if
            
            if random(2)=1 then
              if (ondc)then
                dclr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), DRPxlRect, {#color:clDc})
              end if
              if (onga)then
                galr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), DRPxlRect, {#color:clA})
              end if
              if (ongb)then
                gblr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,1+ofst+1,lgt-1), DRPxlRect, {#color:clB})
              end if
            else
              if (ondc)then
                dclr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), DRPxlRect, {#color:clDc})
              end if
              if (onga)then
                galr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), DRPxlRect, {#color:clA})
              end if
              if (ongb)then
                gblr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,1+ofst-1,lgt-1), DRPxlRect, {#color:clB})
              end if
            end if
          end if
          
        "Rust":
          if (cl <> DRWhite) then
            ofst = random(2)-1
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              -- nwLr = lr
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            rustdot = member("rustDot").image
            member("layer"&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:cl, #ink:36})
            if(gradAf)then
              if (clDc <> DRWhite)then
                member("layer"&strnwlr&"dc").image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clDc, #ink:36})
              end if
              if (clA <> DRWhite)then
                member("gradientA"&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clA, #ink:36})--comment below
              end if
              if (clB <> DRWhite)then
                member("gradientB"&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clB, #ink:36})--not using 39-darker here because 36 makes things look better
              end if
            end if
          end if
        "Barnacles":
          if (cl <> DRWhite) then
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            layernwlr = member("layer" & strnwlr).image
            if random(2)-1 then
              b1 = member("barnacle1").image
              b2 = member("barnacle2").image
              layernwlr.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:cl, #ink:36})
              if(gradAf)then
                if (clDc <> DRWhite)then
                  member("layer"&strnwlr&"dc").image.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:clDc, #ink:36})
                end if
                if (clA <> DRWhite)then
                  member("gradientA"&strnwlr).image.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:clA, #ink:36})
                end if
                if (clB <> DRWhite)then
                  member("gradientB"&strnwlr).image.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:clB, #ink:36})
                end if
              end if
              layernwlr.copyPixels(b2, rect(pnt, pnt)+rect(-2,-2,3,3), b2.rect, {#color:color(255,0,0), #ink:36})
            else
              rustdot = member("rustDot").image
              ofst = random(2)-1
              layernwlr.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:[color(255,0,0),cl][random(2)], #ink:36})
              if(gradAf)then
                if (clDc <> DRWhite)then
                  member("layer"&strnwlr&"dc").image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clDc, #ink:36})
                end if
                if (clA <> DRWhite)then
                  member("gradientA"&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clA, #ink:36})
                end if
                if (clB <> DRWhite)then
                  member("gradientB"&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:clB, #ink:36})
                end if --same use of 36 and not 39 as rust
              end if
            end if
          end if
          
        "Colored Barnacles":
          if (cl <> DRWhite) then
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            layernwlr = member("layer" & strnwlr).image
            if (gdIndLayer = "C") then
              if random(2)-1 then
                b1 = member("barnacle1").image
                b2 = member("barnacle2").image
                layernwlr.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:cl, #ink:36})
                layernwlr.copyPixels(b2, rect(pnt, pnt)+rect(-2,-2,3,3), b2.rect, {#color:color(255,0,0), #ink:36})
              else
                ofst = random(2)-1
                rustdot = member("rustDot").image
                layernwlr.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:[color(255,0,0),cl][random(2)], #ink:36})
              end if
            else
              if random(2)-1 then
                b1 = member("barnacle1").image
                b2 = member("barnacle2").image
                layernwlr.copyPixels(b1, rect(pnt, pnt)+rect(-3,-3,4,4), b1.rect, {#color:cl, #ink:36})
                layernwlr.copyPixels(b2, rect(pnt, pnt)+rect(-2,-2,3,3), b2.rect, {#color:colrInd, #ink:36})
                member("gradient"&gdIndLayer&strnwlr).image.copyPixels(b2, rect(pnt, pnt)+rect(-2,-2,3,3), b2.rect, {#ink:39})
              else
                ofst = random(2)-1
                rustdot = member("rustDot").image
                layernwlr.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:colrInd, #ink:36})
                member("gradient"&gdIndLayer&strnwlr).image.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#ink:39})
              end if
            end if
          end if
          
        "Clovers":
          if (cl <> color(255, 255, 255)) then
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            if nwLr <= 9 then
              str = 1
            else
              str = random(2)
            end if
            if str = 1 then
              strnwlr = string(nwLr)
              layernwlr = member("layer"&strnwlr).image
              if (gdLayer = "C") then
                n = [1,1,1,1,1,1,2,1.5][random(8)]
                h1 = -5*n
                h2 = 6*n
                nRect = rotateToQuad(rect(pnt, pnt)+rect(h1,h1,h2,h2), random(360))
                if (random(60) = 1) then
                  LC4 = member("4LCloverGraf").image
                  layernwlr.copyPixels(LC4, nRect, LC4.rect, {#color:[color(255,0,0), color(0,255,0), color(0,0,255)][random(3)], #ink:36})
                else
                  LC3 = member("3LCloverGraf").image
                  layernwlr.copyPixels(LC3, nRect, LC3.rect, {#color:[color(255,0,0), color(0,255,0), color(0,0,255)][random(3)], #ink:36})
                end if
              else
                n = [1,1,1,1,1,1,2,1.5][random(8)]
                h1 = -5*n
                h2 = 6*n
                nRect = rotateToQuad(rect(pnt, pnt)+rect(h1,h1,h2,h2), random(360))
                gradnwlr = member("gradient"&gdLayer&strnwlr).image
                if (random(60) = 1) then
                  LC4 = member("4LCloverGraf").image
                  LCG4 = member("4LCloverGrad").image
                  layernwlr.copyPixels(LC4, nRect, LC4.rect, {#color:colr, #ink:36})
                  gradnwlr.copyPixels(LCG4, nRect, LCG4.rect, {#ink:39})
                else
                  LC3 = member("3LCloverGraf").image
                  LCG3 = member("3LCloverGrad").image
                  layernwlr.copyPixels(LC3, nRect, LC3.rect, {#color:colr, #ink:36})
                  gradnwlr.copyPixels(LCG3, nRect, LCG3.rect, {#ink:39})
                end if
              end if
            end if
          end if
          
        "Erode":
          if (cl <> DRWhite) then
            if(random(6)>1)then
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr + 1, 0, 29)
                "1":
                  nwLr = restrict(lr + 1, 0, 9)
                "2":
                  nwLr = restrict(lr + 1, 10, 19)
                "3":
                  nwLr = restrict(lr + 1, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr + 1, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr + 1, 10, 29)
                otherwise:
                  nwLr = restrict(lr + 1, 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            layernwlr = member("layer"&string(nwLr)).image
            rustdot = member("rustDot").image
            repeat with a = 1 to 6
              pnt = pnt + point(-3+random(5), -3+random(5))
              ofst = random(2)-1
              layernwlr.copyPixels(rustdot, rect(pnt, pnt)+rect(-2+ofst,-2,2+ofst,2), rustdot.rect, {#color:DRWhite, #ink:36})
            end repeat
          end if
          
        "Sand":
          if (cl <> DRWhite) then
            if (random(6) > 1) then
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr + 1, 0, 29)
                "1":
                  nwLr = restrict(lr + 1, 0, 9)
                "2":
                  nwLr = restrict(lr + 1, 10, 19)
                "3":
                  nwLr = restrict(lr + 1, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr + 1, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr + 1, 10, 29)
                otherwise:
                  nwLr = restrict(lr + 1, 0, 29)
              end case
            end if
            if (nwLr > 29) then
              nwLr = 29
            else if (nwLr < 0) then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            layernwlr = member("layer" & strnwlr).image
            if (gdIndLayer = "A") then
              Cgrad = 1
              ganwlr = member("gradientA" & strnwlr).image
            else if (gdIndLayer = "B") then
              Cgrad = 2
              gbnwlr = member("gradientB" & strnwlr).image
            else
              Cgrad = 0
              redC = (cl = color(255, 0, 0))
              greenC = (cl = color(0, 255, 0))
              blueC = (cl = color(0, 0, 255))
            end if
            repeat with a = 1 to 6
              pnt = pnt + point(random(5) - 3, random(5) - 3)
              ofst = random(2) -- can't remove, would change rng
              prectsn = rect(pnt, pnt) + rect(-0.5, -0.5, 0.5, 0.5)
              if (Cgrad = 0) then
                if (redC) then
                  layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(0, 255, 0), color(0, 0, 255), color(0, 150, 0), color(0, 0, 150)][random(4)], #ink:36})
                else if (greenC) then
                  layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(255, 0, 0), color(0, 0, 255), color(150, 0, 0), color(0, 0, 150)][random(4)], #ink:36})
                else if (blueC) then
                  layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(255, 0, 0), color(0, 255, 0), color(150, 0, 0), color(0, 150, 0)][random(4)], #ink:36})
                else
                  layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(150, 0, 0), color(0, 150, 0), color(0, 0, 150)][random(6)], #ink:36})
                end if
              else if (Cgrad = 1) then
                layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(255, 0, 255), color(150, 0, 150)][random(2)], #ink:36})
                ganwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#ink:39})
              else
                layernwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#color:[color(0, 255, 255), color(0, 150, 150)][random(2)], #ink:36})
                gbnwlr.copyPixels(DRPxl, prectsn, DRPxlRect, {#ink:39})
              end if
            end repeat
          end if
          
        "Super Erode":
          if (cl <> DRWhite) then
            if(random(40 + 4 * lr * (lr > 19))>1)then
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -2 + random(3), 0, 29)
                "1":
                  nwLr = restrict(lr -2 + random(3), 0, 9)
                "2":
                  nwLr = restrict(lr -2 + random(3), 10, 19)
                "3":
                  nwLr = restrict(lr -2 + random(3), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -2 + random(3), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -2 + random(3), 10, 29)
                otherwise:
                  nwLr = restrict(lr -2 + random(3), 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            layernwlr = member("layer"&string(nwLr)).image
            ermask = member("SuperErodeMask").image
            repeat with a = 1 to 6
              pnt = pnt + point(-4+random(7), -4+random(7))
              layernwlr.copyPixels(ermask, rect(pnt, pnt)+rect(-4, -4, 4, 4), ermask.rect, {#color:DRWhite, #ink:36})
            end repeat
          end if
          
        "Ultra Super Erode":
          if(random(40 + 4 * lr * (lr > 19))>1)then
            case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
              "All":
                nwLr = lr
              "1":
                nwLr = restrict(lr, 0, 9)
              "2":
                nwLr = restrict(lr, 10, 19)
              "3":
                nwLr = restrict(lr, 20, 29)
              "1:st and 2:nd":
                nwLr = restrict(lr, 0, 19)
              "2:nd and 3:rd":
                nwLr = restrict(lr, 10, 29)
              otherwise:
                nwLr = lr
            end case
          else
            case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
              "All":
                nwLr = restrict(lr -2 + random(3), 0, 29)
              "1":
                nwLr = restrict(lr -2 + random(3), 0, 9)
              "2":
                nwLr = restrict(lr -2 + random(3), 10, 19)
              "3":
                nwLr = restrict(lr -2 + random(3), 20, 29)
              "1:st and 2:nd":
                nwLr = restrict(lr -2 + random(3), 0, 19)
              "2:nd and 3:rd":
                nwLr = restrict(lr -2 + random(3), 10, 29)
              otherwise:
                nwLr = restrict(lr -2 + random(3), 0, 29)
            end case
          end if
          if nwLr > 29 then
            nwLr = 29
          else if nwLr < 0 then
            nwLr = 0
          end if
          blob = member("Blob").image
          layernwlr = member("layer"&string(nwLr)).image
          repeat with a = 1 to 6 then
            pnt = pnt + point(-4+random(7), -4+random(7))
            rctdel = rect(pnt, pnt)+rect(-8, -8, 8, 8)
            layernwlr.copyPixels(blob, rctdel, blob.rect, {#color:DRWhite, #ink:36})
            layernwlr.copyPixels(blob, rctdel, blob.rect, {#color:DRWhite, #ink:36})
          end repeat
          
        "Melt":
          if (cl <> DRWhite) and (lr >= dmin) and (lr <= dmax) then
            cp = image(4,4,32)
            rct = rect(pnt,pnt)+rect(-2,-2,2,2)
            cp.copyPixels(layerlr, rect(0,0,4,4), rct)
            cp.setPixel(point(0,0), DRWhite)
            cp.setPixel(point(3,0), DRWhite)
            cp.setPixel(point(0,3), DRWhite)
            cp.setPixel(point(3,3), DRWhite)
            layerlr.copyPixels(cp, rct+rect(0,1,0,1), rect(0,0,4,4), {#ink:36})
            member("tst").image = cp
            if (gradAf)then
              cpA = image(4,4,32)
              cpA.copyPixels(galr, rect(0,0,4,4), rct)
              cpA.setPixel(point(0,0), DRWhite)
              cpA.setPixel(point(3,0), DRWhite)
              cpA.setPixel(point(0,3), DRWhite)
              cpA.setPixel(point(3,3), DRWhite)
              galr.copyPixels(cpA, rct+rect(0,1,0,1), rect(0,0,4,4), {#ink:39})
              member("tstGradA").image = cpA
              cpB = image(4,4,32)
              cpB.copyPixels(gblr, rect(0,0,4,4), rct)
              cpB.setPixel(point(0,0), DRWhite)
              cpB.setPixel(point(3,0), DRWhite)
              cpB.setPixel(point(0,3), DRWhite)
              cpB.setPixel(point(3,3), DRWhite)
              gblr.copyPixels(cpB, rct+rect(0,1,0,1), rect(0,0,4,4), {#ink:39})
              member("tstGradB").image = cpB
              cpDc = image(4,4,32)
              cpDc.copyPixels(dclr, rect(0,0,4,4), rct)
              cpDc.setPixel(point(0,0), DRWhite)
              cpDc.setPixel(point(3,0), DRWhite)
              cpDc.setPixel(point(0,3), DRWhite)
              cpDc.setPixel(point(3,3), DRWhite)
              dclr.copyPixels(cpDc, rct+rect(0,1,0,1), rect(0,0,4,4), {#ink:36})
              member("tstDc").image = cpDc
            end if
          end if
          
        "Fat Slime":
          if (cl <> DRWhite) then
            ofst = random(2)-1
            lgt = 3 + random(random(random(6)))
            big = random(3)
            fat = random(2)
            if  effectIn3D then
              nwLr = get3DLr(lr)
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            layernwlr = member("layer"&strnwlr).image
            layernwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,big+ofst,fat+lgt), DRPxl.rect, {#color:[cl, cl, cl, cl, cl, cl, cl, color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)][random(10)]})--cl
            if(gradAf)then
              ondc = (clDc <> DRWhite)
              onga = (clA <> DRWhite)
              ongb = (clB <> DRWhite)
              if (ondc)then
                dcnwlr = member("layer"&strnwlr&"dc").image
                dcnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,big+ofst,fat+lgt), DRPxlRect, {#color:clDc})
              end if
              if (onga)then
                ganwlr = member("gradientA"&strnwlr).image
                ganwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,big+ofst,fat+lgt), DRPxlRect, {#color:clA})
              end if
              if (ongb)then
                gbnwlr = member("gradientB"&strnwlr).image
                gbnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst,0,big+ofst,fat+lgt), DRPxlRect, {#color:clB})
              end if
            end if
            if random(2)=1 then
              layernwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,big+ofst+1,fat+lgt-1), DRPxlRect, {#color:[cl, cl, cl, cl, cl, cl, cl, color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)][random(10)]})--cl
              if(gradAf)then
                if (ondc)then
                  dcnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,big+ofst+1,fat+lgt-1), DRPxlRect, {#color:clDc})
                end if
                if (onga)then
                  ganwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,big+ofst+1,fat+lgt-1), DRPxlRect, {#color:clA})
                end if
                if (ongb)then
                  gbnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst+1,1,big+ofst+1,fat+lgt-1), DRPxlRect, {#color:clB})
                end if
              end if
            else
              layernwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,big+ofst-1,fat+lgt-1), DRPxlRect, {#color:[cl, cl, cl, cl, cl, cl, cl, color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)][random(10)]})--cl
              if(gradAf)then
                if (ondc)then
                  dcnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,big+ofst-1,fat+lgt-1), DRPxlRect, {#color:clDc})
                end if
                if (onga)then
                  ganwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,big+ofst-1,fat+lgt-1), DRPxlRect, {#color:clA})
                end if
                if (ongb)then
                  gbnwlr.copyPixels(DRPxl, rect(pnt, pnt)+rect(0+ofst-1,1,big+ofst-1,fat+lgt-1), DRPxlRect, {#color:clB})
                end if
              end if
            end if
          end if
          
          
        "Roughen":
          if (lr >= dmin) and (lr <= dmax) then
            if(cl = color(0, 255, 0))then
              roughenImg = member("roughenTexture").image
              var = random(20)
              repeat with lch = 0 to 6
                repeat with lcv = 0 to 6
                  if(layerlr.getPixel(pnt.locH-3+lch, pnt.locV-3+lcv) = color(0, 255, 0))then
                    gtCl = roughenImg.getPixel(lch+(var-1)*7, lcv)
                    if gtCl <> DRWhite then
                      layerlr.setPixel(pnt.locH-3+lch, pnt.locV-3+lcv, gtCl)
                    end if
                  end if
                end repeat
              end repeat
            end if
          end if
          
          
        "Super Melt":
          if (cl <> DRWhite) and (lr >= dmin) and (lr <= dmax) then
            maskImg = member("destructiveMeltMask").image
            pntCal = point(maskImg.width,maskImg.height)/2.0
            cpImg = image(maskImg.width,maskImg.height,32)
            rct = rect(pnt-pntCal, pnt+pntCal)
            cpImg.copyPixels(layerlr, cpImg.rect, rct)
            cpImg.copyPixels(maskImg, cpImg.rect, maskImg.rect, {#ink:36, #color:DRWhite})
            mvDown = random(7)*(mtrxq2c2/100.0)
            if (gradAf) then
              cpAImg = image(maskImg.width,maskImg.height,32)
              cpBImg = image(maskImg.width,maskImg.height,32)
              cpDcImg = image(maskImg.width,maskImg.height,32)
              cpAImg.copyPixels(galr, cpAImg.rect, rct)
              cpAImg.copyPixels(maskImg, cpAImg.rect, maskImg.rect, {#ink:36, #color:DRWhite})
              cpBImg.copyPixels(gblr, cpBImg.rect, rct)
              cpBImg.copyPixels(maskImg, cpBImg.rect, maskImg.rect, {#ink:36, #color:DRWhite})
              cpDcImg.copyPixels(dclr, cpDcImg.rect, rct)
              cpDcImg.copyPixels(maskImg, cpDcImg.rect, maskImg.rect, {#ink:36, #color:DRWhite})
            end if
            if (effectIn3D) then
              nwLr = get3DLr(lr)
            else
              case lrSup of
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if((lr > 6)and(nwLr <= 6))or((nwLr > 6)and(lr <= 6))then
              case lrSup of
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            end if
            if (nwLr > 29) then
              nwLr = 29
            else if (nwLr < 0) then
              nwLr = 0
            end if
            nwRect = rct + rect(0, 0, 0, mvDown)
            strnwlr = string(nwLr)
            member("layer"&strnwlr).image.copyPixels(cpImg, nwRect, cpImg.rect, {#ink:36})
            if (gradAf)then
              member("gradientA"&strnwlr).image.copyPixels(cpAImg, nwRect, cpAImg.rect, {#ink:39})
              member("gradientB"&strnwlr).image.copyPixels(cpBImg, nwRect, cpBImg.rect, {#ink:39})
              member("layer"&strnwlr&"dc").image.copyPixels(cpDcImg, nwRect, cpDcImg.rect, {#ink:36})
            end if
          end if
          
        "Destructive Melt":
          if (cl <> DRWhite) and (lr >= dmin) and (lr <= dmax) then
            maskImg = member("destructiveMeltMask").image
            cpImg = image(maskImg.width,maskImg.height,32)
            rct = rect(pnt-point(maskImg.width,maskImg.height)/2.0, pnt+point(maskImg.width,maskImg.height)/2.0)
            
            cpImg.copyPixels(layerlr, cpImg.rect, rct)
            if (gradAf) then
              cpAImg = image(maskImg.width,maskImg.height,32)
              cpAImg.copyPixels(galr, cpAImg.rect, rct)
              cpBImg = image(maskImg.width,maskImg.height,32)
              cpBImg.copyPixels(gblr, cpBImg.rect, rct)
              cpDcImg = image(maskImg.width,maskImg.height,32)
              cpDcImg.copyPixels(dclr, cpDcImg.rect, rct)
            end if
            pnt = point(-2+random(3), -2+random(3))
            rct = rct + rect(pnt, pnt)
            mvDown = random(7)*(mtrxq2c2/100.0)
            if effectIn3D then
              nwLr = get3DLr(lr)
            else
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = restrict(lr -1 + random(2), 0, 29)
                "1":
                  nwLr = restrict(lr -1 + random(2), 0, 9)
                "2":
                  nwLr = restrict(lr -1 + random(2), 10, 19)
                "3":
                  nwLr = restrict(lr -1 + random(2), 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr -1 + random(2), 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr -1 + random(2), 10, 29)
                otherwise:
                  nwLr = restrict(lr -1 + random(2), 0, 29)
              end case
            end if
            if((lr > 6)and(nwLr <= 6))or((nwLr > 6)and(lr <= 6))then
              case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
                "All":
                  nwLr = lr
                "1":
                  nwLr = restrict(lr, 0, 9)
                "2":
                  nwLr = restrict(lr, 10, 19)
                "3":
                  nwLr = restrict(lr, 20, 29)
                "1:st and 2:nd":
                  nwLr = restrict(lr, 0, 19)
                "2:nd and 3:rd":
                  nwLr = restrict(lr, 10, 29)
                otherwise:
                  nwLr = lr
              end case
            end if
            if nwLr > 29 then
              nwLr = 29
            else if nwLr < 0 then
              nwLr = 0
            end if
            strnwlr = string(nwLr)
            destroyImg = member("destructiveMeltDestroy").image
            destroyMask = destroyImg.createMask()
            layerlr.copyPixels(cpImg, rct + rect(0, 0, 0, mvDown), cpImg.rect, {#mask:destroyMask})
            member("layer"&strnwlr).image.copyPixels(cpImg, rct + rect(0, 0, 0, mvDown*0.5), cpImg.rect, {#mask:destroyMask, #ink:36})
            if(cl = "W")then
              layerlr.copyPixels(destroyImg,  rect(rct.left, rct.top, rct.right, rct.bottom+mvDown), destroyImg.rect, {#ink:36, #color: DRWhite})
            end if
            if (gradAf) then
              galr.copyPixels(cpAImg, rct + rect(0, 0, 0, mvDown), cpAImg.rect, {#mask:destroyMask})
              member("gradientA"&strnwlr).image.copyPixels(cpAImg, rct + rect(0, 0, 0, mvDown*0.5), cpAImg.rect, {#mask:destroyMask, #ink:39})
              if(clA = "W")then
                galr.copyPixels(destroyImg, rect(rct.left, rct.top, rct.right, rct.bottom+mvDown), destroyImg.rect, {#ink:36, #color: DRWhite})
              end if
              gblr.copyPixels(cpBImg, rct + rect(0, 0, 0, mvDown), cpBImg.rect, {#mask:destroyMask})
              member("gradientB"&strnwlr).image.copyPixels(cpBImg, rct + rect(0, 0, 0, mvDown*0.5), cpBImg.rect, {#mask:destroyMask, #ink:39})
              if(clB = "W")then
                gblr.copyPixels(destroyImg, rect(rct.left, rct.top, rct.right, rct.bottom+mvDown), destroyImg.rect, {#ink:36, #color: DRWhite})
              end if
              dclr.copyPixels(cpDcImg, rct + rect(0, 0, 0, mvDown), cpDcImg.rect, {#mask:destroyMask})
              member("layer"&strnwlr&"dc").image.copyPixels(cpDcImg, rct + rect(0, 0, 0, mvDown*0.5), cpDcImg.rect, {#mask:destroyMask, #ink:36})
              if(clDc = "W")then
                dclr.copyPixels(destroyImg, rect(rct.left, rct.top, rct.right, rct.bottom+mvDown), destroyImg.rect, {#ink:36, #color: DRWhite})
              end if
            end if
          end if
          
        "Impacts":
          if (lr >= dmin) and (lr <= dmax) then
            chance = random(110)
            if lr <= 9 then
              chance = random(6)
            else if lr <= 19 then
              chance = random(90)
            end if
            if (chance=1) then
              if(cl <> DRWhite)then
                var = random(8)
                repeat with lch = 0 to 19
                  repeat with lcv = 1 to 20
                    if(layerlr.getPixel((pnt.locH-15+lch), (pnt.locV-15+lcv)) <> DRWhite)then
                      repeat with iVar = 1 to 3
                        gtCl = member("Impact"&string(iVar)).image.getPixel(lch+(var-1)*20, lcv)
                        if gtCl <> DRWhite then
                          member("layer"&string(restrict(lr+iVar-1, dmin, dmax))).image.setPixel((pnt.locH-15+lch), (pnt.locV-15+lcv), DRWhite)
                        end if
                      end repeat
                    end if
                  end repeat
                end repeat
              end if
            end if
          end if
      end case
    end repeat
  end repeat
end

on ApplyFuzzyGrower(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1 + (d > 9) + (d > 19)
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    mdPnt = giveMiddleOfTile(point(q, c))
    headPos = mdPnt + point(-11 + random(21), -11 + random(21))
    pnt = point(headPos.locH, headPos.locV)
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    wdth = 0.3
    searchBase = 50
    repeat while pnt.locV < 30000
      dir = 180 - 150 + random(300)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir) * 30.0
      if (searchBase > 0) then
        moveDir = point(0, 0)
        repeat with tst in [point(-1, 0), point(1, 0), point(1, 1), point(0, 1), point(-1, 1)]
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if (tstPnt.locH > 0) and (tstPnt.locH < gLOprops.size.locH - 1) and (tstPnt.locV > 0) and (tstPnt.locV < gLOprops.size.locV - 1) then
            moveDir = moveDir + tst * gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir / 100.0) * searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      lastDir = dir
      rct = (lastPnt + pnt) / 2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10 * wdth, -25, 10 * wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if (random(2) = 1) then
        qd = flipQuadH(qd)
      end if
      wdth = wdth + (random(1000) / 1000.0) / 5.0
      if (wdth > 1) then
        wdth = 1
      end if
      var = random(13)
      tdRect = rect((var - 1) * 20, 1, var * 20, 51)
      member("layer" & string(d)).image.copyPixels(member("fuzzyBushGraf").image, qd, tdRect, {#color:colr, #ink:36})
      copyPixelsToEffectColor(gdLayer, d, qd, "fuzzyBushGrad", tdRect, 0.5, blnd)
      blnd = blnd * 0.5
      if (blnd2 > 0) then
        rctR = (lastPnt + pnt) / 2.0
        rct = rect(rctR, rctR) + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        blnd2 = blnd2 - 0.15
      end if
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
        exit repeat
      else if (solidAfaMv(tlPos, lr) = 1) then
        exit repeat
      end if   
    end repeat
  end if
end


on get3DLr(lr)
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      nwLr = restrict(lr -2 + random(3), 0, 29)
    "1":
      nwLr = restrict(lr -2 + random(3), 0, 9)
    "2":
      nwLr = restrict(lr -2 + random(3), 10, 19)
    "3":
      nwLr = restrict(lr -2 + random(3), 20, 29)
    "1:st and 2:nd":
      nwLr = restrict(lr -2 + random(3), 0, 19)
    "2:nd and 3:rd":
      nwLr = restrict(lr -2 + random(3), 10, 29)
    otherwise:
      nwLr = restrict(lr -2 + random(3), 0, 29)
  end case
  if (lr = 6) and (nwLr = 5) then
    nwLr = 6
  else if (lr = 5) and (nwLr = 6) then
    nwLr = 5
  end if
  if (nwLr > 29) then
    return 29
  else if (nwLr < 0) then
    return 0
  end if
  return nwLr
end 

on applyDarkSlime me, q, c, effectR
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  cls = [color(255, 0,0), color(0,255, 0), color(0,0,255)]
  
  fc = solidAfaMv(point(q2,c2), 1)
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 9
    "2":
      dmin = 10
      dmax = 19
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 19
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  repeat with d = 0 to 29
    case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
      "All":
        lr = d
      "1":
        lr = restrict(d, 0, 9)
      "2":
        lr = restrict(d, 10, 19)
      "3":
        lr = restrict(d, 20, 29)
      "1:st and 2:nd":
        lr = restrict(d, 0, 19)
      "2:nd and 3:rd":
        lr = restrict(d, 10, 29)
      otherwise:
        lr = d
    end case
    if (lr=0)or(lr = 10)or(lr=20) then
      lraddc = 1+(lr>9)+(lr>19)
      sld = (solidMtrx[q2][c2][ lraddc ])
      if (DRDarkSlimeFix) then
        fc = solidAfaMv(point(q2,c2), lraddc)
      else
        fc = solidAfaMv(point(q2,c2)+gRenderCameraTilePos, lraddc)
      end if
    end if
    deepEffect = 0
    
    if (lr = 0)or(lr=10)or(lr=20)or(sld=0)then
      deepEffect = 1
    end if
    endofloop = effectR.mtrx[q2][c2]*(0.2 + (0.8*deepEffect))*0.01*80*fc
    repeat with cntr = 1 to endofloop
      if deepEffect then
        pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
      else
        if random(2)=1 then
          pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
        else 
          pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
        end if
      end if
      layerd = member("layer"&string(d)).image
      if (layerd.getPixel(pnt) <> DRWhite) and (d >= dmin) and (d <= dmax) then
        lgt = random(40)
        if (layerd.getPixel(pnt+point(0,lgt)) <> DRWhite)  and (d >= dmin) and (d <= dmax) then
          clr = cls[random(3)]
          layerlr = member("layer"&string(lr)).image
          layerlr.copyPixels(DRPxl, rect(pnt, pnt+point(1, lgt)), DRPxlRect, {#color:clr})
          if random(2)=1 then
            layerlr.copyPixels(DRPxl, rect(pnt, pnt+point(1, lgt))+rect(-1, 1, -1, -1), DRPxlRect, {#color:clr})
          else
            layerlr.copyPixels(DRPxl, rect(pnt, pnt+point(1, lgt))+rect(1, 1, 1, -1), DRPxlRect, {#color:clr})
          end if
        end if
      end if
    end repeat
  end repeat
end

on giveAnEffectPos me, q, c, d, sld
  pnt = point(0,0)
  if (d = 0)or(d=9)or(d=19)or(sld)then
    pnt = (point(q-1, c-1)*20)+point(random(20), random(20))
  else
    if random(2)=1 then
      pnt = (point(q-1, c-1)*20)+point(1 + 19*(random(2)-1), random(20))
    else 
      pnt = (point(q-1, c-1)*20)+point(random(20), 1 + 19*(random(2)-1))
    end if
  end if
  
  return pnt
end

on ApplyFancyGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.5
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 50 + random(100)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("fancyBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "fancyBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

on applyWLPlant(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV 
  amount = 20
  case lrSup of
    "All":
      lsL = [1,2,3]
    "1":
      lsL = [1]
    "2":
      lsL = [2]
    "3":
      lsL = [3]
    "1:st and 2:nd":
      lsL = [1,2]
    "2:nd and 3:rd":
      lsL = [2,3]
    otherwise:
      lsL = [1,2,3]
  end case
  bldr = gEEprops.effects[r].mtrx[q2][c2] * 1.5
  repeat with layer in lsL
    editM = afaMvLvlEdit(point(q2, c2), layer)
    if (editM = 1) or (editM = 2) or (editM = 3) or (editM = 4) or (editM = 5) or (editM = 6) then
      repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2] * 0.01 * amount
        pnt = giveMiddleOfTile(point(q, c)) - point([-1, 1, -2, 2][random(4)], [-1, 1, -2, 2][random(4)])
        edit = afaMvLvlEdit(point(q2, c2 + 1), layer)
        bttmR = ((edit = 0) or (edit = 7) or (edit = 8) or (edit = 9) or (edit = -1) or (edit = 6))
        edit = afaMvLvlEdit(point(q2, c2 - 1), layer)
        tpR = ((edit = 0) or (edit = 7) or (edit = 8) or (edit = 9) or (edit = -1) or (edit = 6))
        edit = afaMvLvlEdit(point(q2 + 1, c2), layer)
        rghtR = ((edit = 0) or (edit = 7) or (edit = 8) or (edit = 9) or (edit = -1) or (edit = 6))
        edit = afaMvLvlEdit(point(q2 - 1, c2), layer)
        lftR = ((edit = 0) or (edit = 7) or (edit = 8) or (edit = 9) or (edit = -1) or (edit = 6))
        case editM of
          2:
            tpR = 0
            rghtR = 0
            slp1 = random(21) - 11
            rand2 = random(2)
            baseRect = rect(pnt, pnt) + rect(-1 + slp1, -1 + slp1, 1 + slp1, 1 + slp1) + rect(-rand2, -rand2, rand2, rand2)
            repeat with rep = 2 to 9
              rct = rotateToQuad(baseRect, random(360))
              rubbl = random(4)
              varLr = (layer - 1) * 10 + rep
              member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
              if (gdLayer <> "C") then
                member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
              end if                           
            end repeat
          3:
            tpR = 0
            lftR = 0
            slp1 = random(21) - 11
            rand2 = random(2)
            baseRect = rect(pnt, pnt) + rect(-1 + slp1, -1 - slp1, 1 + slp1, 1 - slp1) + rect(-rand2, -rand2, rand2, rand2)
            repeat with rep = 2 to 9
              rct = rotateToQuad(baseRect, random(360))
              rubbl = random(4)
              varLr = (layer - 1) * 10 + rep
              member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
              if (gdLayer <> "C") then
                member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
              end if                           
            end repeat
          4:
            bttmR = 0
            rghtR = 0
            slp1 = random(21) - 11
            rand2 = random(2)
            baseRect = rect(pnt, pnt) + rect(-1 - slp1, -1 + slp1, 1 - slp1, 1 + slp1) + rect(-rand2, -rand2, rand2, rand2)
            repeat with rep = 2 to 9
              rct = rotateToQuad(baseRect, random(360))
              rubbl = random(4)
              varLr = (layer - 1) * 10 + rep
              member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
              if (gdLayer <> "C") then
                member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
              end if                           
            end repeat
          5:
            bttmR = 0
            lftR = 0
            slp1 = random(21) - 11
            rand2 = random(2)
            baseRect = rect(pnt, pnt) + rect(-1 - slp1, -1 - slp1, 1 - slp1, 1 - slp1) + rect(-rand2, -rand2, rand2, rand2)
            repeat with rep = 2 to 9
              rct = rotateToQuad(baseRect, random(360))
              rubbl = random(4)
              varLr = (layer - 1) * 10 + rep
              member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
              if (gdLayer <> "C") then
                member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
              end if                           
            end repeat
          6:
            tpR = 0
            lftR = 0
            bttmR = 0
            rghtR = 0
            rand = random(10) - random(10)
            rand2 = random(2)
            baseRect = rect(pnt, pnt) + rect(-1 + rand, -11, 1 + rand, -9) + rect(-rand2, -rand2, rand2, rand2)
            repeat with rep = 7 to 9
              rct = rotateToQuad(baseRect, random(360))
              rubbl = random(4)
              varLr = (layer - 1) * 10 + rep
              member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
              if (gdLayer <> "C") then
                member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
              end if                         
            end repeat
        end case
        if (rghtR = 1) then
          rand = random(10) - random(10)
          rand2 = random(2)
          baseRect = rect(pnt, pnt) + rect(9, -1 + rand, 11, 1 + rand) + rect(-rand2, -rand2, rand2, rand2)
          repeat with rep = 2 to 9
            rct = rotateToQuad(baseRect, random(360))
            rubbl = random(4)
            varLr = (layer - 1) * 10 + rep
            member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
            if (gdLayer <> "C") then
              member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
            end if                           
          end repeat
        end if
        if (lftR = 1) then
          rand = random(10) - random(10)
          rand2 = random(2)
          baseRect = rect(pnt, pnt) + rect(-11, -1 + rand, -9, 1 + rand) + rect(-rand2, -rand2, rand2, rand2)
          repeat with rep = 2 to 9
            rct = rotateToQuad(baseRect, random(360))
            rubbl = random(4) - 1
            varLr = (layer - 1) * 10 + rep
            member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
            if (gdLayer <> "C") then
              member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
            end if              
          end repeat
        end if
        if (bttmR = 1) then
          rand = random(10) - random(10)
          rand2 = random(2)
          baseRect = rect(pnt, pnt) + rect(-1 + rand, 9, 1 + rand, 11) + rect(-rand2, -rand2, rand2, rand2)
          repeat with rep = 2 to 9
            rct = rotateToQuad(baseRect, random(360))
            rubbl = random(4)
            varLr = (layer - 1) * 10 + rep
            member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
            if (gdLayer <> "C") then
              member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
            end if                          
          end repeat
        end if
        if (tpR = 1) then
          rand = random(10) - random(10)
          rand2 = random(2)
          baseRect = rect(pnt, pnt) + rect(-1 + rand, -11, 1 + rand, -9) + rect(-rand2, -rand2, rand2, rand2)
          repeat with rep = 2 to 9
            rct = rotateToQuad(baseRect, random(360))
            rubbl = random(4)
            varLr = (layer - 1) * 10 + rep
            member("layer" & string(varLr)).image.copyPixels(member("denseMoldGraf").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#color:colr, #ink:36})
            if (gdLayer <> "C") then
              member("gradient" & gdLayer & string(varLr)).image.copyPixels(member("denseMoldGrad").image, rct, rect(0 + 10 * rubbl, 1, 10 + 10 * rubbl, 11), {#ink:39, #blend:bldr})
            end if                         
          end repeat
        end if
      end repeat
    end if
  end repeat
end

on applyStandardPlant me, q, c, eftc, tp
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  amount = 17
  case tp of
    "Root Grass":
      amount = 12
    "Grass":
      amount = 10
    "Dandelions":
      amount = random(10)
    "Seed Pods":
      amount = random(5)
    "Cacti":
      amount = 3
    "Rain Moss":
      amount = 9
    "rubble":
      amount = 11
    "Colored Rubble":
      amount = 11
    "Horse Tails":
      amount = 1 + random(3)
    "Circuit Plants":
      amount = 2
    "Feather Plants":
      amount = 4
    "Reeds":
      amount = 2
    "Lavenders", "Storm Plants":
      amount = 5
    "Hyacinths":
      amount = 5
    "Seed Grass":
      amount = 5
    "Orb Plants":
      amount = 5
    "Lollipop Mold":
      amount = 5
    "Og Grass":
      amount = 7
  end case
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      lsL = [1,2,3]
    "1":
      lsL = [1]
    "2":
      lsL = [2]
    "3":
      lsL = [3]
    "1:st and 2:nd":
      lsL = [1,2]
    "2:nd and 3:rd":
      lsL = [2,3]
    otherwise:
      lsL = [1,2,3]
  end case
  
  -- gradImg = image(10,30,16)
  -- mskImg = image(10,30,16)
  
  repeat with layer in lsL then
    if (solidMtrx[q2][c2][layer]<>1) and (solidAfaMv(point(q2,c2+1), layer)=1) then
      -- mdPnt = giveMiddleOfTile(point(q,c))
      repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2]*0.01*amount then
        pnt = me.giveGroundPos(q, c, layer)
        lr = random(9) + (layer-1)*10
        
        
        case tp of
          "Grass":
            freeSides = 0
            if (solidAfaMv(point(q2-1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=3) then
              --freeSides = freeSides + 1
              amount = amount/2
            end if
            if (solidAfaMv(point(q2+1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=2) then
              -- freeSides = freeSides + 1
              amount = amount/2
            end if
            
            rct = rect(pnt, pnt) + rect(-10,-20,10, 10)
            
            rnd = random(20)
            
            flp = random(2)-1
            if flp then
              rct = vertFlipRect(rct)
            end if
            
            gtRect = rect((rnd-1)*20, 0, rnd*20, 30)+rect(1,0,1,0)
            member("layer"&string(lr)).image.copyPixels(member("GrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              -- pnt = depthPnt(pnt, lr-5)
              rct = rect(pnt, pnt) + rect(-10,-20,10, 10)
              if flp then
                rct = vertFlipRect(rct)
              end if
              
              copyPixelsToEffectColor(gdLayer, lr, rct, "GrassGrad", gtRect, 0.5)
            end if   
            
          "Root Grass":
            freeSides = 0
            if (solidAfaMv(point(q2-1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=3) then
              freeSides = freeSides + 1
            end if
            if (solidAfaMv(point(q2+1,c2+1), layer)=0)then--or(afaMvLvlEdit(point(q,c), layer)=2) then
              freeSides = freeSides + 1
            end if
            
            rct = rect(pnt, pnt) + rect(-5,-17,5, 3)
            if (freeSides > 0) or (amount<0.5) then
              rnd = 10+random(5)
            else
              rnd = random(10)
            end if
            
            flp = random(2)-1
            if flp then
              rct = vertFlipRect(rct)
            end if
            
            gtRect = rect((rnd-1)*10, 0, rnd*10, 30)+rect(1,0,1,0)
            member("layer"&string(lr)).image.copyPixels(member("RootGrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              rct = rect(pnt, pnt) + rect(-5,-17,5, 3)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "RootGrassGrad", gtRect, 0.5)
            end if   
            
          "Seed Pods":
            rnd = random(7)
            rct = rect(pnt, pnt) + rect(-10,-77,10, 3)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 80)+rect(1,0,1,0)
            if flp then
              rct = vertFlipRect(rct)
            end if
            member("layer"&string(lr)).image.copyPixels(member("SeedPodsGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              rct = rect(pnt, pnt) + rect(-10,-77,10, 3)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "SeedPodsGrad", gtRect, 0.5)
            end if 
            
          "Dandelions":
            rnd = random(15)
            rct = rect(pnt, pnt) + rect(-6,-28,6, 0)
            flp = random(2)-1
            gtRect = rect((rnd-1)*12, 0, rnd*12, 28)+rect(1,0,1,0)
            if flp then
              rct = vertFlipRect(rct)
            end if
            member("layer"&string(lr)).image.copyPixels(member("dandelionsGraf").image, rct, gtRect, {#color:colr, #ink:36})
            copyPixelsToEffectColor(gdLayer, lr, rct, "dandelionsGrad", gtRect, 0.5)
            
          "Reeds":
            rnd = random(4)
            rndSz = random(30)
            rct = rect(pnt, pnt) + rect(-60, -190 - rndSz * 2, 60, 10)
            flp = random(2) - 1
            gtRect = rect((rnd - 1) * 120, 1, rnd * 120, 201)
            if (flp) then
              rct = vertFlipRect(rct)
            end if
            member("layer" & string(lr)).image.copyPixels(member("reedsGraf2").image, rct, gtRect, {#color:colr, #ink:36})
            if (gdLayer <> "C") then
              member("gradient" & gdLayer & string(lr)).image.copyPixels(member("reedsGrad2").image, rct, gtRect, {#ink:39})
            end if
            
          "Lavenders":
            rnd = random(3)
            rndSz = random(20)
            rct = rect(pnt, pnt) + rect(-4, -103 - rndSz * 2, 4, 3)
            flp = random(2) - 1
            gtRect = rect((rnd - 1) * 8, 1, rnd * 8, 107)
            if (flp) then
              rct = vertFlipRect(rct)
            end if
            member("layer" & string(lr)).image.copyPixels(member("lavendersGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if (colr <> color(0, 255, 0)) then
              copyPixelsToEffectColor(gdLayer, lr, rct, "lavendersGrad", gtRect, 0.5)
            end if
            repeat with cal = 0 to 2
              repeat with rep = -1 to 1
                caler = 0
                if (cal = 2) then
                  caler = 1
                end if
                rand = random(5)
                getRct = rect((rand - 1) * 10, 1 + 10 * caler, rand * 10, 11 + 10 * caler)
                nRect = rect(pnt, pnt) + rect(-5, -105 + cal * 10 - rndSz * 2, 5, -95 + cal * 10 - rndSz * 2)
                newLr = restrict(lr + rep, 0, 29)
                member("layer" & string(newLr)).image.copyPixels(member("lavendersFlowers").image, nRect, getRct, {#color:colr, #ink:36})
                if (colr <> color(0, 255, 0)) then
                  member("gradient" & gdLayer & string(newLr)).image.copyPixels(member("lavendersFlowers").image, nRect, getRct, {#ink:39})
                end if
              end repeat
            end repeat
            
          "Hyacinths":
            rnd = random(15)
            rct = rect(pnt, pnt) + rect(-10,-77,10, 3)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 80)+rect(1,0,1,0)
            rct = rotateToQuad(rct, random(50) - 25)
            member("layer"&string(lr)).image.copyPixels(member("hyacinthGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              copyPixelsToEffectColor(gdLayer, lr, rct, "hyacinthGrad", gtRect, 0.5)
            end if   
            
          "Seed Grass":
            rnd = random(15)
            rct = rect(pnt, pnt) + rect(-10,-47,10, 3)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 50)+rect(0,1,0,1)
            rct = rotateToQuad(rct, random(50) - 25)
            member("layer"&string(lr)).image.copyPixels(member("seedGrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              copyPixelsToEffectColor(gdLayer, lr, rct, "seedGrassGrad", gtRect, 0.5)
            end if    
            
          "Orb Plants":
            rnd = random(15)
            rct = rect(pnt, pnt) + rect(-20,-57,20, 3)
            flp = random(2)-1
            gtRect = rect((rnd-1)*40, 0, rnd*40, 60)+rect(1,0,1,0)
            rct = rotateToQuad(rct, random(50) - 25)
            member("layer"&string(lr)).image.copyPixels(member("orbPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              copyPixelsToEffectColor(gdLayer, lr, rct, "orbPlantGrad", gtRect, 0.5)
            end if    
            
          "Circuit Plants":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              rnd = random(restrict((20*(gEEprops.effects[r].mtrx[q2][c2]-11+random(21))*0.01).integer, 1, 16))
              sz = 0.15+0.85*power(gEEprops.effects[r].mtrx[q2][c2]*0.01, 0.85)
              rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
              flp = random(2)-1
              gtRect = rect((rnd-1)*40, 0, rnd*40, 100)+rect(1,0,1,0)
              if flp then
                rct = vertFlipRect(rct)
              end if
              member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
              if(sz < 0.75)then
                member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct+rect(1,0,1,0), gtRect, {#color:colr, #ink:36})
                member("layer"&string(lr)).image.copyPixels(member("CircuitPlantGraf").image, rct+rect(0,1,0,1), gtRect, {#color:colr, #ink:36})
              end if
              if colr <> color(0,255,0) then
                rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
                if flp then
                  rct = vertFlipRect(rct)
                end if
                copyPixelsToEffectColor(gdLayer, lr, rct, "CircuitPlantGrad", gtRect, 0.5)
              end if 
            end if
            
          "Storm Plants":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              rnd = random(restrict((20*(gEEprops.effects[r].mtrx[q2][c2]-11+random(21))*0.01).integer, 1, 16))
              sz = 0.15+0.85*power(gEEprops.effects[r].mtrx[q2][c2]*0.01, 0.85)
              rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
              flp = random(2)-1
              gtRect = rect((rnd-1)*40, 0, rnd*40, 100)+rect(1,0,1,0)
              if flp then
                rct = vertFlipRect(rct)
              end if
              member("layer"&string(lr)).image.copyPixels(member("StormPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
              if(sz < 0.75)then
                member("layer"&string(lr)).image.copyPixels(member("StormPlantGraf").image, rct+rect(1,0,1,0), gtRect, {#color:colr, #ink:36})
                member("layer"&string(lr)).image.copyPixels(member("StormPlantGraf").image, rct+rect(0,1,0,1), gtRect, {#color:colr, #ink:36})
              end if
              if colr <> color(0,255,0) then
                rct = rect(pnt, pnt) + rect(-20*sz,-95*sz,20*sz, 5)
                if flp then
                  rct = vertFlipRect(rct)
                end if
                copyPixelsToEffectColor(gdLayer, lr, rct, "StormPlantGrad", gtRect, 0.5)
              end if 
            end if
            
          "Feather Plants":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              leanDir = 0
              if(q2 > 1)then
                if(afaMvLvlEdit(point(q2-1,c2), layer)=0)and(afaMvLvlEdit(point(q2-1,c2+1), layer)=1)then
                  leanDir = leanDir + gEEprops.effects[r].mtrx[q2-1][c2]
                else if (afaMvLvlEdit(point(q2-1,c2), layer)=1) then
                  leanDir = leanDir - 90
                end if
              end if
              if(q2 < gLOprops.size.locH-1)then
                if(afaMvLvlEdit(point(q2+1,c2), layer)=0)and(afaMvLvlEdit(point(q2+1,c2+1), layer)=1)then
                  leanDir = leanDir - gEEprops.effects[r].mtrx[q2+1][c2]
                else if (afaMvLvlEdit(point(q2+1,c2), layer)=1) then
                  leanDir = leanDir + 90
                end if
              end if
              
              rnd = random(restrict((20*(gEEprops.effects[r].mtrx[q2][c2]-11+random(21))*0.01).integer, 1, 16))
              sz = 1--0.2+0.8*power(gEEprops.effects[r].mtrx[q2][c2]*0.01, 0.85)
              rct = rect(pnt, pnt) + rect(-20*sz,-90*sz,20*sz, 100*sz)
              gtRect = rect((rnd-1)*40, 0, rnd*40, 190)+rect(1,0,1,0)
              
              rct = rotateToQuad(rct, (65.0*((leanDir - 11 + random(21))/100.0))+0.1)
              
              checkForSolid = (rct[1]+rct[2]+rct[3]+rct[4])/4.0
              if(   member("layer"&string(lr)).image.getPixel(checkForSolid.locH, checkForSolid.locV) <> color(255, 255, 255))then
                
                if(leanDir - 11 + random(21) > 0) then
                  rct = flipQuadH(rct)
                end if
                
                member("layer"&string(lr)).image.copyPixels(member("FeatherPlantGraf").image, rct, gtRect, {#color:colr, #ink:36})
                if colr <> color(0,255,0) then
                  copyPixelsToEffectColor(gdLayer, lr, rct, "FeatherPlantGrad", gtRect, 0.5)
                end if 
              end if
            end if
            
          "Horse Tails":
            rnd = restrict(random(3+(20*gEEprops.effects[r].mtrx[q2][c2]*0.01).integer), 1, 14)
            rct = rect(pnt, pnt) + rect(-10,-48,10, 2)
            flp = random(2)-1
            gtRect = rect((rnd-1)*20, 0, rnd*20, 50)+rect(1,0,1,0)
            if flp then
              rct = vertFlipRect(rct)
            end if
            member("layer"&string(lr)).image.copyPixels(member("HorseTailGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              rct = rect(pnt, pnt) + rect(-10,-48,10, 2)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "HorseTailGrad", gtRect, 0.5)
            end if 
            
          "Cacti":
            repeat with rep = 1 to random(random(3)) then
              sz = 0.5+(random(gEEprops.effects[r].mtrx[q2][c2]*0.7)*0.01)
              rotat = -45+random(90)
              if (solidAfaMv(point(q2-1,c2+1), layer)=0)or(afaMvLvlEdit(point(q2,c2), layer)=3) then
                rotat = rotat - 10-random(30)
              end if
              if (solidAfaMv(point(q2+1,c2+1), layer)=0)or(afaMvLvlEdit(point(q2,c2), layer)=2) then
                rotat = rotat + 10+random(30)
              end if
              tpPnt = pnt + degToVec(rotat)*15*sz
              
              rct = rotateToQuad( rect((pnt+tpPnt)*0.5,(pnt+tpPnt)*0.5)+rect(-4*sz,-7*sz,4*sz,8*sz) ,lookAtPoint(pnt, tpPnt))
              member("layer"&string(lr)).image.copyPixels(member("bigCircle").image, rct, member("bigCircle").image.rect, {#color:colr, #ink:36})
              if colr <> color(0,255,0) then
                rct = rect(tpPnt,tpPnt)+rect(-9*sz,-6*sz,9*sz,13*sz)+rect(-3,-3,3,3)
                copyPixelsToEffectColor(gdLayer, lr, rct, "softBrush1", member("softBrush1").image.rect, 0.5)
              end if
            end repeat
          "Rubble":
            rct = rect(pnt,pnt)+rect(-3,-3,3,3)+rect(-random(3),-random(3), random(3), random(3))
            rct = rotateToQuad(rct,random(360))
            rubbl = random(4)
            repeat with rep = 1 to 4 then
              if lr+rep-1 > 29 then
                exit repeat
              else
                member("layer"&string(lr+rep-1)).image.copyPixels(member("rubbleGraf"&string(rubbl)).image, rct, member("rubbleGraf"&string(rubbl)).image.rect, {#color:color(0,255,0), #ink:36})
              end if                
            end repeat
            
          "Colored Rubble":
            rct = rect(pnt,pnt)+rect(-3,-3,3,3)+rect(-random(3),-random(3), random(3), random(3))
            rct = rotateToQuad(rct,random(360))
            rubbl = random(4)
            repeat with rep = 1 to 4 then
              if lr+rep-1 > 29 then
                exit repeat
              else
                member("layer"&string(lr+rep-1)).image.copyPixels(member("rubbleGraf"&string(rubbl)).image, rct, member("rubbleGraf"&string(rubbl)).image.rect, {#color:colrInd, #ink:36})
                if (gdIndLayer <> "C") then
                  member("gradient"&gdIndLayer&string(lr+rep-1)).image.copyPixels(member("rubbleGraf"&string(rubbl)).image, rct, member("rubbleGraf"&string(rubbl)).image.rect, {#ink:39})
                end if
              end if                
            end repeat
            
          "Rain Moss":
            pnt = pnt + degToVec(random(360)) * random(random(100)) * 0.04
            rct = rect(pnt, pnt) + rect(-12, -12, 13, 13)
            rct = rotateToQuad(rct, ((random(4) - 1) * 90) + 1)
            gtRect = random(4)
            gtRect = rect((gtRect - 1) * 25, 0, gtRect * 25, 25)
            member("layer" & string(lr)).image.copyPixels(member("rainMossGraf").image, rct, gtRect, {#color:colr, #ink:36})
            if (colr <> color(0,255,0)) then
              tpPnt = depthPnt(pnt, lr - 5) + degToVec(random(360)) * random(6)
              rct = rect(tpPnt, tpPnt) + rect(-20, -20, 20, 20) + rect(0, 0, -15, -15)
              copyPixelsToEffectColor(gdLayer, lr, rct, "softBrush1", member("softBrush1").image.rect, 0.5)
            end if
            
          "Lollipop Mold":
            if(random(300) > gEEprops.effects[r].mtrx[q2][c2])then
              grafSz = point(20,20)
              rnd = random(3)-1
              if (gEEprops.effects[r].mtrx[q2][c2] > 60) then
                rnd = random(5)-1
              end if
              
              sz = 0.5+(random(gEEprops.effects[r].mtrx[q2][c2]*0.5)*0.01)
              ang = random(31)-16.0 -- range: -15 to 15 inclusive
              len = (random(8)+12) / 2.0
              
              -- stem
              pnt = pnt - point(0, len)
              rct = rotateToQuadFix(rect(pnt, pnt) + rect(-0.75, -len, 0.75, len), ang)
              member("layer"&string(lr)).image.copyPixels(DRPxl, rct, rect(0,0,1,1), {#color:color(150,0,0), #ink:36}) -- stems forced as shaded color
              
              -- orb
              pnt = pnt - (point(cos((ang+90) * PI / 180.0), sin((ang+90) * PI / 180.0)) * (len + (10*sz) - 2))
              rct = rotateToQuadFix(rect(pnt, pnt) + (rect(-10,-10,10,10) * sz), ang)
              member("layer"&string(lr)).image.copyPixels(member("lollipopMoldGraf").image, rct, rect(20*rnd, 1, 20*(rnd+1), 20), {#color:colr, #ink:36})
              if (colr <> color(0,255,0)) then
                copyPixelsToEffectColor(gdLayer, lr, rct, "lollipopMoldGraf", rect(20*rnd, 21, 20*(rnd+1), 39), 0.5, (random(20) + 80.0) / 100.0)
              end if
            end if
            
          "Og Grass":
            freeSides = 0
            if (solidAfaMv(point(q2-1,c2+1), layer)=0)then
              freeSides = freeSides + 1
            end if
            if (solidAfaMv(point(q2+1,c2+1), layer)=0)then
              freeSides = freeSides + 1
            end if
            rand = random (3)
            rct = rect(pnt, pnt) + rect(-5*rand,-17*rand,5*rand, 3*rand)
            if (freeSides > 0) or (amount<0.5) then
              rnd = 10+random(5)
            else
              rnd = random(15)
            end if
            flp = random(2)-1
            if flp then
              rct = vertFlipRect(rct)
            end if
            gtRect = rect((rnd-1)*20, 0, rnd*19, 50)+rect(1,0,1,0)
            member("layer"&string(lr)).image.copyPixels(member("grassoggraf").image, rct, gtRect, {#color:colr, #ink:36})
            if colr <> color(0,255,0) then
              rct = rect(pnt, pnt) + rect(-5*rand,-17*rand,5*rand, 3*rand)
              if flp then
                rct = vertFlipRect(rct)
              end if
              copyPixelsToEffectColor(gdLayer, lr, rct, "RootGrassGrad", gtRect, 0.5)
            end if 
        end case
      end repeat
    end if
  end repeat
end

on giveGroundPos me, q, c,l
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  mdPnt = giveMiddleOfTile(point(q,c))
  pnt = mdPnt + point(-11+random(21), 10)
  if (gLEprops.matrix[q2][c2][l][1]=3) then
    pnt.locV = pnt.locv - (pnt.locH-mdPnt.locH) - 5
  else if (gLEprops.matrix[q2][c2][l][1]=2) then
    pnt.locV = pnt.locv - (mdPnt.locH-pnt.locH) - 5
  end if
  return pnt
end

on applyHugeFlower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    
    h = pnt.locV
    
    repeat while h < 30000 then
      h = h + 1
      pnt.locH = pnt.locH -2 + random(3)
      member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH+2, h+2), member("pxl").image.rect, {#color:colr})
      tlPos = giveGridPos(point(pnt.locH, h)) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
  end if
end

on applyMiniGrowers me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    --member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    
    h = pnt.locV
    
    repeat while h < 30000 then
      h = h + 1
      pnt.locH = pnt.locH -2 + random(3)
      member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH, h+2), member("pxl").image.rect, {#color:colr})
      tlPos = giveGridPos(point(pnt.locH, h)) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
  end if
end

on ApplyThunderGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.2
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 170 + random(300)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("thunderBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "thunderBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if 
    end repeat
  end if
end

on ApplyHorrorGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 0.75
    
    wdth = 0.5
    
    searchBase = 250
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 250 + random(500)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("fuzzyBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "fuzzyBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.1
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.09
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

--dakras
on ApplySideKelp(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
  end case
  lr = 1 + (d > 9) + (d > 19)
  blnd = 1
  blnd2 = 1
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    mdPnt = giveMiddleOfTile(point(q, c))
    headPos = mdPnt + point(-11 + random(21), -11 + random(21))
    pnt = point(headPos.locH, headPos.locV)
    lastDir = 180 - 101 + random(201)
    points = [pnt]
    repeat while pnt.locV < 30000
      dir = 180 - 31 + random(61)
      dir = lerp(lastDir, dir, 0.75)
      lastPnt = pnt
      pnt = pnt + degToVec(dir) * 30.0
      lastDir = dir
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-30, -25, 30, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      points.add(pnt)
      var = random(13)
      rectDk = rect((var - 1) * 40, 1, var * 40, 51)
      member("layer" & string(d)).image.copyPixels(member("sidekelpgraf").image, qd, rectDk, {#color:colr, #ink:36})
      copyPixelsToEffectColor(gdLayer, d, qd, "sidekelpgrad", rectDk, 0.5, blnd)
      blnd = blnd * 0.85
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
    end repeat
    if (blnd2 > 0) then
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-12, -36, 12, 36)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
      blnd2 = blnd2 - 0.15
    end if
  end if
end

on ApplyFlipSideKelp(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
  end case
  lr = 1 + (d > 9) + (d > 19)
  blnd = 1
  blnd2 = 1
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    mdPnt = giveMiddleOfTile(point(q, c))
    headPos = mdPnt + point(-11 + random(21), -11 + random(21))
    pnt = point(headPos.locH, headPos.locV)
    lastDir = 180 - 101 + random(201)
    points = [pnt]
    repeat while pnt.locV < 30000
      dir = 180 - 31 + random(61)
      dir = lerp(lastDir, dir, 0.75)
      lastPnt = pnt
      pnt = pnt + degToVec(dir) * 30.0
      lastDir = dir
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-30, -25, 30, 25)
      qd = flipQuadH(rotateToQuad(rct, lookAtPoint(lastPnt, pnt)))
      points.add(pnt)
      var = random(13)
      rectDk = rect((var - 1) * 40, 1, var * 40, 51)
      member("layer" & string(d)).image.copyPixels(member("sidekelpgraf").image, qd, rectDk, {#color:colr, #ink:36})
      copyPixelsToEffectColor(gdLayer, d, qd, "sidekelpgrad", rectDk, 0.5, blnd)
      blnd = blnd * 0.85
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
    end repeat
    if (blnd2 > 0) then
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-12, -36, 12, 36)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
      blnd2 = blnd2 - 0.15
    end if
  end if
end

on ApplyMixKelp(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
  end case
  lr = 1 + (d > 9) + (d > 19)
  blnd = 1
  blnd2 = 1
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    mdPnt = giveMiddleOfTile(point(q, c))
    headPos = mdPnt + point(-11 + random(21), -11 + random(21))
    pnt = point(headPos.locH, headPos.locV)
    lastDir = 180 - 101 + random(201)
    points = [pnt]
    repeat while pnt.locV < 30000
      dir = 180 - 31 + random(61)
      dir = lerp(lastDir, dir, 0.75)
      lastPnt = pnt
      pnt = pnt + degToVec(dir) * 30.0
      lastDir = dir
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-30, -25, 30, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if (random(2) = 1) then
        qd = flipQuadH(qd)
      end if
      points.add(pnt)
      var = random(13)
      rectDk = rect((var - 1) * 60, 1, var * 60, 51)
      member("layer" & string(d)).image.copyPixels(member("fsidekelpgraf").image, qd, rectDk, {#color:colr, #ink:36})
      copyPixelsToEffectColor(gdLayer, d, qd, "fsidekelpgrad", rectDk, 0.5, blnd)
      blnd = blnd * 0.85
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
    end repeat
    if (blnd2 > 0) then
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-12, -36, 12, 36)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
      blnd2 = blnd2 - 0.15
    end if
  end if
end

on ApplyBubbleGrower(me, q, c)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
  end case
  lr = 1 + (d > 9) + (d > 19)
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    mdPnt = giveMiddleOfTile(point(q, c))
    headPos = mdPnt + point(-11 + random(21), -11 + random(21))
    pnt = point(headPos.locH, headPos.locV)
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    wdth = 0.5
    searchBase = 50
    repeat while pnt.locV < 30000
      dir = 180 - 61 + random(121)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir) * 30.0
      if (searchBase > 0) then
        moveDir = point(0, 0)
        repeat with tst in [point(-1, 0), point(1, 0), point(1, 1), point(0, 1), point(-1, 1)]
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if (tstPnt.locH > 0) and (tstPnt.locH < gLOprops.size.locH - 1) and (tstPnt.locV > 0) and (tstPnt.locV < gLOprops.size.locV - 1) then
            moveDir = moveDir + tst * gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir / 100.0) * searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      lastDir = dir
      rctR = (lastPnt + pnt) / 2.0
      rct = rect(rctR, rctR) + rect(-10 * wdth, -25, 10 * wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if (random(2) = 1) then
        qd = flipQuadH(qd)
      end if
      wdth = wdth + (random(2000) / 400.0) / 2.5 - 0.5
      if (wdth > 1.7) then
        wdth = 1.7
      else if (wdth < 0.3) then
        wdth = 0.3
      end if
      var = random(13)
      rectDk = rect((var - 1) * 20, 1, var * 20, 50 + 1)
      member("layer" & string(d)).image.copyPixels(member("bubblegrowergraf").image, qd, rectDk, {#color:colr, #ink:36})
      copyPixelsToEffectColor(gdLayer, d, qd, "bubblegrowergrad", rectDk, 0.5, blnd)
      blnd = blnd * 0.90
      if (blnd2 > 0) then
        rctR = (lastPnt + pnt) / 2.0
        rct = rect(rctR, rctR) + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        blnd2 = blnd2 - 0.4
      end if
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
        exit repeat
      else if (solidAfaMv(tlPos, lr) = 1) then
        exit repeat
      end if     
    end repeat
  end if
end

--end dakras


on ApplyArmGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 101 + random(201)
    
    points = [pnt]
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 31 + random(61)
      dir = lerp(lastDir, dir, 0.75)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10, -25, 10, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      points.add(pnt)
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("ArmGrowerGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    if(points.count > 2)then
      repeat with p = 1 to points.count-1 then
        rct = (points[p] + points[p+1])/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(points[p], points[p+1]))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, power((points.count-p.float+1)/points.count.float, 1.5))
      end repeat
    end if
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end


on ApplyThornGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.5
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 61 + random(121)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("thornBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "thornBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end

on ApplyIceGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 40 + random(80)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.2
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 1 + random(2)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("iceBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "iceBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

on ApplyGrassGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.3
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 1 + random(2)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("grassBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "grassBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

on ApplyMeatGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 100 + random(200)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.3
    
    searchBase = 100
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 200 + random(400)
      dir = lerp(lastDir, dir, 0.25)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-30*wdth, -25, 30*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("meatGrowGraf").image, qd, rect((var-1)*60, 1, var*60, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "meatGrowGrad", rect((var-1)*60, 1, var*60, 50+1), 0.5, blnd)
      blnd = blnd * 0.90
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat 
  end if
end


on ApplyLeafGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 100 + random(200)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.65
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 61 + random(121)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("leafBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "leafBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

on ApplyCoralGrower me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 10 + random(20)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.35
    
    searchBase = 100
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 30 + random(60)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-15*wdth, -25, 15*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("coralBushGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, d, qd, "coralBushGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.7
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
  end if
end

on ApplySpinets me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    lastDir = 180 - 61 + random(121)
    blnd = 1
    blnd2 = 1
    
    wdth = 0.5
    
    searchBase = 50
    
    repeat while pnt.locV < 30000 then
      dir = 180 - 61 + random(121)
      dir = lerp(lastDir, dir, 0.35)
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*30.0
      
      if(searchBase > 0)then
        moveDir = point(0,0)
        repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
          tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst
          if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
            moveDir = moveDir + tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV]
          end if
        end repeat
        pnt = pnt + (moveDir/100.0)*searchBase
        searchBase = searchBase - 1.5
        pnt = lastPnt + moveToPoint(lastPnt, pnt, 30.0)
      end if
      
      lastDir = dir
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-10*wdth, -25, 10*wdth, 25)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      if(random(2)=1)then
        qd = flipQuadH(qd)
      end if
      
      wdth = wdth + (random(1000)/1000.0)/5.0
      if(wdth > 1)then
        wdth = 1
      end if
      
      var = random(13)
      
      member("layer"&string(d)).image.copyPixels(member("spinetsGraf").image, qd, rect((var-1)*20, 1, var*20, 50+1), {#color:colr, #ink:36} )
      copyPixelsToRootEffectColor(gdLayer, d, qd, "spinetsGrad", rect((var-1)*20, 1, var*20, 50+1), 0.5, blnd)
      blnd = blnd * 0.85
      
      if(blnd2 > 0)then
        rct = (lastPnt + pnt)/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-12, -36, 12, 36)
        qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
        
        copyPixelsToEffectColor(gdLayer, d, qd, "softBrush1", member("softBrush1").image.rect, 0.5, blnd2)
        
        blnd2 = blnd2 - 0.15
      end if
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end

on ApplyGarbageSpiral me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 1
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(29)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "1":
      d = random(9)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    dir = random(360)
    dirAdd = 40+random(20)
    if(random(2)=1)then
      dirAdd = -dirAdd
    end if
    
    grav = -0.7
    
    spiralWait = 15 + random(15)
    spiral = 1.0
    searchBase = -8--12
    
    loseSpiralTime = 60 + random(300)
    
    spiralFac = lerp(0.95, 0.91, (gEEprops.effects[r].mtrx[q2][c2]/100.0) * (random(1000)/1000.0))
    
    dpthSpeed = lerp(-1.0, 1.0, random(1000)/1000.0)/20.0
    
    conPoints = [[pnt, d, 0]]
    points = [[pnt, d, 1]]
    
    cntr = 0
    repeat while pnt.locV < 30000 then
      cntr = cntr + 1
      dir = dir + dirAdd
      
      dirAdd = dirAdd * spiralFac
      spiralFac = spiralFac + 0.0013
      if(spiralFac > 0.993)then
        spiralFac = 0.993
      end if
      
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*3.0*power(spiral, 0.5)
      
      spiralWait = spiralWait - 1
      if(spiralWait < 0)then
        moveDir = point(0,0)
        repeat with dst = 1 to 7 then
          repeat with tst in [point(-1,0), point(1,0), point(1,1), point(0,1), point(-1, 1)] then
            tstPnt = giveGridPos(lastPnt) + gRenderCameraTilePos + tst*dst
            if(tstPnt.locH > 0)and(tstPnt.locH < gLOprops.size.locH-1)and(tstPnt.locV > 0)and(tstPnt.locV < gLOprops.size.locV-1)then
              moveDir = moveDir + (tst*gEEprops.effects[r].mtrx[tstPnt.locH][tstPnt.locV])
            end if
          end repeat
        end repeat
        pnt = pnt + (moveDir/4600.0)*searchBase*(1.0-power(spiral, 0.5))
        searchBase = searchBase + 0.15
        if(searchBase > 12)then
          searchBase = 12
        end if
        
        
        pnt.locV = pnt.locV + grav * (1.0-power(spiral, 0.5))
        grav = grav + 0.2 * (1.0-power(spiral, 0.5))--(abs(grav) + 0.8) * 0.009 * (1.0-power(spiral, 0.5))
        
        
        spiral = spiral - (1.0/loseSpiralTime.float)
        if(spiral < 0)then
          spiral = 0
          d = d + dpthSpeed
          if(d < frontWall)then
            d = frontWall
          else if (d > backWall) then
            d = backWall
          end if
          
        end if
      end if
      
      if(random(1000) < power(spiral, 4.0)*1000)then
        conPoints.add([pnt, d, cntr])
      end if
      
      pnt = lastPnt + moveToPoint(lastPnt, pnt, 3.0)
      
      points.add([pnt, d, spiral])
      
      
      
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    repeat with cntr = 1 to conPoints.count then
      a = conPoints[random(conPoints.count)][1]
      blnd = (1.0-power(restrict(conPoints[cntr][3].float / points.count, 0, 1), 1.3))
      useD = restrict(conPoints[cntr][2].integer, frontWall, backWall)
      if(random(10)=1)then
        qd = rect(a.locH, a.locV, a.locH+1, a.locv+random(random(100)))
        member("layer"&string(points[1][2])).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      else
        b = conPoints[random(conPoints.count)][1]
        dir = moveToPoint(a, b, 1.0)
        perp = giveDirFor90degrToLine(-dir, dir)*0.5
        qd = [a - perp, a + perp, b + perp, b-perp]
        member("layer"&string(points[1][2])).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      end if
    end repeat
    
    lastPnt = points[1][1]
    lastUseD = points[1][2]
    repeat with q = 1 to points.count then
      pnt = points[q][1]
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-1, -2, 1, 2)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      
      useD = restrict(points[q][2].integer, frontWall, backWall)
      blnd = 1.0-power(restrict(q.float / points.count, 0, 1), 1.3)
      blnd = lerp(blnd, 0.5, points[q][3])
      member("layer"&string(useD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
      copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      
      if(lastUseD <> useD)then
        member("layer"&string(lastUseD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr, #ink:36} )
        copyPixelsToEffectColor(gdLayer, lastUseD, qd, "pxl", rect(0,0,1,1), 0.5, blnd)
      end if
      
      lastUseD = useD
      lastPnt = pnt
    end repeat
    
    
    
    -- copyPixelsToEffectColor(gdLayer, d, rect(headPos.locH-37, headPos.locV-37, headPos.locH+37, h+10), "hugeFlowerMaskMask", member("hugeFlowerMask").image.rect, 0.8)
    
  end if
end




on ApplyRoller me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 1
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"
    "All":
      d = random(29)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "1":
      d = random(9)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(19)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(29)
      if(d <= 5)then
        backWall = 5
      else if (d >= 6)then
        frontWall = 6
      end if
  end case
  lr = 1+(d>9)+(d>19)
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    dir = random(360)
    dirAdd = (10+random(30))*0.3
    if(random(2)=1)then
      dirAdd = -dirAdd
    end if
    
    dspeed = (-11+random(21))/100.0
    
    lastUseD = d
    
    grav = 0.7
    
    points = [[pnt, d]]
    
    seedChance = 1.0
    
    repeat while pnt.locV < 30000 then
      dir = dir - 11 + random(21) + dirAdd
      
      dspeed = restrict(dspeed + (-11+random(21))/1000.0, -0.1, 0.1)
      
      d = d + dspeed
      if(d < frontWall)then
        d = frontWall
        dspeed = random(10)/100.0
      else if (d > backWall)then
        d = backWall
        dspeed = -random(10)/100.0
      end if
      
      lastPnt = pnt
      pnt = pnt + degToVec(dir)*5.0
      pnt.locV = pnt.locV + grav
      
      grav = grav + 0.001
      
      
      
      rct = (lastPnt + pnt)/2.0
      rct = rect(rct, rct)
      rct = rct + rect(-1.5, -3.5, 1.5, 3.5)
      qd = rotateToQuad(rct, lookAtPoint(lastPnt, pnt))
      --      if(random(2)=1)then
      --        qd = flipQuadH(qd)
      --      end if
      
      
      --  var = random(13)
      
      useD = restrict(d.integer, frontWall, backWall)
      
      if(seedChance > 0)then
        repeat with a = 1 to 8 then
          if(random(1000)<power(seedChance, 1.5)*1000)then
            seedPos = pnt + MoveToPoint(pnt, lastPnt, (diag(pnt, lastPnt)*random(1000)).float/1000.0) + degToVec(random(360))*random(3)
            seedLr = restrict(useD - 2 + random(3), frontWall, backWall)
            member("layer"&string(seedLr)).image.copyPixels(member("rustDot").image, rect(seedPos,seedPos)+rect(-2, -2, 2, 2), member("rustDot").image.rect, {#color:colr, #ink:36} )
            copyPixelsToEffectColor(gdLayer, seedLr, rect(seedPos,seedPos)+rect(-2, -2, 2, 2), "rustDot", member("rustDot").image.rect, 0.8, 1)
            
            if(random(3) > 1)then
              seedLr = restrict(seedLr - 1, frontWall, backWall)
              member("layer"&string(seedLr)).image.copyPixels(member("pxl").image, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), member("pxl").image.rect, {#color:colr} )
              copyPixelsToEffectColor(gdLayer, seedLr, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), "pxl", member("pxl").image.rect, 0.8, 1)
            else
              member("layer"&string(seedLr)).image.copyPixels(member("pxl").image, rect(seedPos,seedPos)+rect(-1, -1, 1, 1), member("pxl").image.rect, {#color:color(255, 0, 0)} )
            end if
          end if
        end repeat
      end if
      seedChance = seedChance - random(100).float/2200.0
      
      points.add([pnt, useD])
      
      member("layer"&string(useD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr} )
      
      
      if(lastUseD <> useD)then
        member("layer"&string(lastUseD)).image.copyPixels(member("pxl").image, qd, rect(0,0,1,1), {#color:colr} )
      end if
      
      lastUseD = useD
      
      tlPos = giveGridPos(pnt) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, 1 + (useD > 9) + (useD > 19)) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    if(points.count > 2)then
      repeat with p = 1 to points.count-1 then
        rct = (points[p][1] + points[p+1][1])/2.0
        rct = rect(rct, rct)
        rct = rct + rect(-1.5, -3.5, 1.5, 3.5)
        qd = rotateToQuad(rct, lookAtPoint(points[p][1], points[p+1][1]))
        --  copyPixelsToEffectColor(gdLayer, useD, qd, "pxl", rect(0,0,1,1), 0.8)
        copyPixelsToEffectColor(gdLayer, points[p][2], qd, "pxl", rect(0,0,1,1), 0.8, power((points.count-p.float+1)/points.count.float, 1.5))
      end repeat
    end if
    
    
  end if
end




on applyHangRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    -- member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    lftBorder = mdPnt.locH-10
    rgthBorder =  mdPnt.locH+10
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      -- member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH+2, h+2), member("pxl").image.rect, {#color:colr})
      lstPos = pnt
      pnt = pnt + degToVec(-45+random(90))*(2+random(6))
      pnt.locH = restrict(pnt.locH, lftBorder, rgthBorder)
      dir = moveToPoint(pnt, lstPos, 1.0)
      crossDir = giveDirFor90degrToLine(-dir, dir)
      qd = [pnt-crossDir, pnt+crossDir, lstPos+crossDir, lstPos-crossDir]
      member("layer"&string(d)).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:color(255, 0, 0)})
      
      if solidAfaMv(giveGridPos(lstPos) + gRenderCameraTilePos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
  end if
end


on applyThickRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
    otherwise:
      d = random(30)-1
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 0
    
    floatDpth = d
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      floatDpth = floatDpth + lerp(-0.3, 0.3, random(1000)/1000.0)
      if(floatDpth < frontWall)then
        floatDpth = frontWall
      else if(floatDpth > backWall)then
        floatDpth = backWall
      end if
      d = restrict(floatDpth.integer, frontWall, backWall)
      
      lstPos = pnt
      dir = lerp(dir, -45+random(90), 0.5)
      pnt = pnt + degToVec(dir)*(2+random(6))
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (gridPos.locH + q > 0)and(gridPos.locH + q < gEEprops.effects[r].mtrx.count)and(gridPos.locV-1 > 0)and(gridPos.locV-1 < gEEprops.effects[r].mtrx[1].count) and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV-1 > 0)and(lstGridPos.locV-1 < gEEprops.effects[r].mtrx[1].count)then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV-1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*2.0
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      if(lstGridPos.locH <> gridPos.locH) then
        if (gridPos.locH > 0)and(gridPos.locH < gEEprops.effects[r].mtrx.count)and(gridPos.locV > 0)and(gridPos.locV < gEEprops.effects[r].mtrx[1].count) and (lstGridPos.locH > 0)and(lstGridPos.locH < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV > 0)and(lstGridPos.locV < gEEprops.effects[r].mtrx[1].count) then
          if (gEEprops.effects[r].mtrx[gridPos.locH][gridPos.locV] = 0)and(gEEprops.effects[r].mtrx[lstGridPos.locH][lstGridPos.locV] > 0) then
            pnt.locH = restrict(pnt.locH, giveMiddleOfTile(giveGridPos(lstPos)).locH-9, giveMiddleOfTile(giveGridPos(lstPos)).locH+9)
          end if
        end if
      end if
      
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:color(0,255,0)})
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
    
    
    
  end if
end



on applyShadowPlants me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
    otherwise:
      d = random(30)-1
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 180
    
    -- floatDpth = d
    
    
    
    cycle = lerp(6.0, 12.0, random(10000)/10000.0)
    cntr = random(50)
    
    tltFac = 0.0
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      cntr = cntr + 1
      --      floatDpth = floatDpth + lerp(-0.3, 0.3, random(1000)/1000.0)
      --      if(floatDpth < frontWall)then
      --        floatDpth = frontWall
      --      else if(floatDpth > backWall)then
      --        floatDpth = backWall
      --      end if
      --      d = restrict(floatDpth.integer, frontWall, backWall)
      
      lstPos = pnt
      dir = lerp(dir, 180-45+random(90), 0.1)
      dir = dir + sin((cntr/cycle)*PI*2.0)*8
      cycle = cycle + 0.1
      if(cycle > 35) then cycle = 35
      pnt = pnt + degToVec(dir)*3
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV+1 > 0)and(lstGridPos.locV+1 < gEEprops.effects[r].mtrx[1].count) then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV+1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*lerp(-2.0, 1.0, power(tltFac, 0.85))
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tltFac = tltFac + 0.002
      if(tltFac > 1.0)then tltFac = 1.0
      --      
      --      
      --      if(lstGridPos.locH <> gridPos.locH) then
      --        if (gridPos.locH > 0)and(gridPos.locH < gEEprops.effects[r].mtrx.count)and(gridPos.locV > 0)and(gridPos.locV < gEEprops.effects[r].mtrx[1].count) then
      --          if (lstGridPos.locH  > 0)and(lstGridPos.locH < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV > 0)and(lstGridPos.locV < gEEprops.effects[r].mtrx[1].count) then
      --            if (gEEprops.effects[r].mtrx[gridPos.locH][gridPos.locV] = 0)and(gEEprops.effects[r].mtrx[lstGridPos.locH][lstGridPos.locV] > 0) then
      --              pnt.locH = restrict(pnt.locH, giveMiddleOfTile(giveGridPos(lstPos)).locH-9, giveMiddleOfTile(giveGridPos(lstPos)).locH+9)
      --            end if
      --          end if
      --        end if
      --      end if
      
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    fuzzLength = 20+random(50)
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    thickness = lerp(thickness, restrict(points.count.float, 20.0, 180.0)/180.0, 0.5)
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      --rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      f =  sin(f*PI*0.5)
      rad = 1.1 + f*7.0*(points[q][3].float/6.0)*lerp(thickness, 0.5, 0.2)
      
      
      
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:color(0,0,255)})
          
          if(random(30) = 1)then
            me.sporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 15 + random(50) * (1.0-f), d - c[1], color(0,0,255))
          end if
          
          if(q < fuzzLength) and(random(fuzzLength) > q)and(random(6)=1) then
            f2 = q.float / fuzzLength.float
            me.sporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 65 + random(50) * (1.0-f2), d - c[1], color(0,0,255))
          end if
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
    
    
    
  end if
end


on applyColoredHangRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      -- frontWall = 1 
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
      -- frontWall = 1 
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
      -- frontWall = 1 
  end case
  
  --  if(d > 5)then
  --    frontWall = 5+3
  --    d = restrict(d, frontWall, 29)
  --  else
  --    backWall = 5
  --  end if
  
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    -- member("layer"&string(d)).image.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    lftBorder = mdPnt.locH-10
    rgthBorder =  mdPnt.locH+10
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      -- member("layer"&string(d)).image.copyPixels(member("pxl").image, rect(pnt.locH-1, h, pnt.locH+2, h+2), member("pxl").image.rect, {#color:colr})
      lstPos = pnt
      pnt = pnt + degToVec(-45+random(90))*(2+random(6))
      pnt.locH = restrict(pnt.locH, lftBorder, rgthBorder)
      dir = moveToPoint(pnt, lstPos, 1.0)
      crossDir = giveDirFor90degrToLine(-dir, dir)
      qd = [pnt-crossDir, pnt+crossDir, lstPos+crossDir, lstPos-crossDir]
      member("layer"&string(d)).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:colr, #ink:10})
      if (gdLayer <> "C") then
        member("gradient" & gdLayer & string(d)).image.copyPixels(member("pxlDR200").image, qd, member("pxlDR200").image.rect, {ink:39})
      end if
      --copyPixelsToRootEffectColor(gdLayer, d, qd, "pxl", member("pxl").image.rect, 0.5)
      
      if solidAfaMv(giveGridPos(lstPos) + gRenderCameraTilePos, lr) = 1 then
        exit repeat
      end if
      
    end repeat
    
    
    
  end if
end

on applyMushroomStubs me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of
    "All":
      dmin = 1
      dmax = 29
    "1":
      dmin = 1
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 1
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 1
      dmax = 29
  end case
  
  fullamount = amount
  
  case mshrSz of
    "S":
      dij = 0
      dj = 0
    "M":
      dij = 1
      dj = 1
    "R":
      dij = 0
      dj = 1
      fullamount = amount/3
    otherwise:
      dij = 1
      dj = 1
  end case
  
  case mshrSzW of
    "S":
      wminscale = 0.2
      wmaxscale = 0.5
    "M":
      wminscale = 0.5
      wmaxscale = 1.0
    "L":
      wminscale = 1.0
      wmaxscale = 1.3
    "R":
      wminscale = 0.5
      wmaxscale = 1.0
    otherwise:
      wminscale = 0.5
      wmaxscale = 1.0
  end case
  
  repeat with di = dij to dj then
    case di of
      0:
        mminsize = 10
        mmaxsize = 20
      1:
        mminsize = 20
        mmaxsize = 40
      otherwise:
        mminsize = 20
        mmaxsize = 40
    end case
    
    repeat with a = 1 to fullamount/(mmaxsize/10.0) then
      dp = random(28)-1
      if(dp > 3)then
        dp = dp + 2
      end if
      
      lr = 3
      
      rad = lerp(mminsize, mmaxsize, random(90)/120.0)
      
      radw = lerp(wminscale, wmaxscale, random(100)/100.0)
      
      if(dp < 10)then
        lr = 1
      else if (dp < 20) then
        lr = 2
      end if
      
      startPos = mdPnt+(point(-11+random(21), -11+random(21)))
      
      solid = 0
      
      if(solidAfaMv(point(q2,c2), lr) = 1)then
        solid = 1
      end if
      
      if(dp-1 >= 0) then
        pixelColor = member("layer"&string(dp)).image.getPixel(startPos)
        if pixelColor <> rgb(255, 255, 255) then
          pixelColor = member("layer"&string(dp-1)).image.getPixel(startPos)
          if pixelColor = rgb(255, 255, 255) then
            solid = 0
          end if
        end if
      end if
      
      if(solid = 1)then
        repeat with d = 0 to 2 then
          if(dp+d <= dmax) and (dp+d >= dmin) then
            if(rad <= 10)then
              member("layer"&string(dp+d)).image.copyPixels(member("mushroomStubsGraf").image, rect(startPos, startPos)+(rect(-rad,-rad,rad,rad) * rect(radw, 1, radw, 1)), rect(0, 1+d*20, 20, 1+(d+1)*20), {#color:colr, #ink:36})
              if gdLayer <> "C" then
                member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("mushroomStubsGrad").image, rect(startPos, startPos)+(rect(-rad,-rad,rad,rad) * rect(radw, 1, radw, 1)), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:39})
              end if
            else
              member("layer"&string(dp+d)).image.copyPixels(member("mushroomStubsGraf").image, rect(startPos, startPos)+(rect(-rad,-rad,rad,rad) * rect(radw, 1, radw, 1)), rect(20, 1+d*40, 60, 1+(d+1)*40), {#color:colr, #ink:36})
              if gdLayer <> "C" then
                member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("mushroomStubsGrad").image, rect(startPos, startPos)+(rect(-rad,-rad,rad,rad) * rect(radw, 1, radw, 1)), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:39})
              end if 
            end if
          else
            exit repeat
          end if
        end repeat
      end if
    end repeat
  end repeat
  
end


on applyColoredThickRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
      -- frontWall = 1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      -- frontWall = 1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
    otherwise:
      d = random(30)-1
      -- frontWall = 1
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then--and(afaMvLvlEdit(point(q,c+1), 1)=1) then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 0
    
    floatDpth = d
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      
      floatDpth = floatDpth + lerp(-0.3, 0.3, random(1000)/1000.0)
      if(floatDpth < frontWall)then
        floatDpth = frontWall
      else if(floatDpth > backWall)then
        floatDpth = backWall
      end if
      d = restrict(floatDpth.integer, frontWall, backWall)
      
      lstPos = pnt
      dir = lerp(dir, -45+random(90), 0.5)
      pnt = pnt + degToVec(dir)*(2+random(6))
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (gridPos.locH + q > 0)and(gridPos.locH + q < gEEprops.effects[r].mtrx.count)and(gridPos.locV-1 > 0)and(gridPos.locV-1 < gEEprops.effects[r].mtrx[1].count) and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV-1 > 0)and(lstGridPos.locV-1 < gEEprops.effects[r].mtrx[1].count)then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV-1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*2.0
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      
      if(lstGridPos.locH <> gridPos.locH) then
        if (gridPos.locH > 0)and(gridPos.locH < gEEprops.effects[r].mtrx.count)and(gridPos.locV > 0)and(gridPos.locV < gEEprops.effects[r].mtrx[1].count) and (lstGridPos.locH > 0)and(lstGridPos.locH < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV > 0)and(lstGridPos.locV < gEEprops.effects[r].mtrx[1].count)then
          if (gEEprops.effects[r].mtrx[gridPos.locH][gridPos.locV] = 0)and(gEEprops.effects[r].mtrx[lstGridPos.locH][lstGridPos.locV] > 0) then
            pnt.locH = restrict(pnt.locH, giveMiddleOfTile(giveGridPos(lstPos)).locH-9, giveMiddleOfTile(giveGridPos(lstPos)).locH+9)
          end if
        end if
      end if
      
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:colr, ink:36})
          if (gdLayer <> "C") then
            member("gradient" & gdLayer & string(d - c[1])).image.copyPixels(member("pxlDR200").image, qd, member("pxlDR200").image.rect, {ink:39})
          end if
          --copyPixelsToRootEffectColor(gdLayer, d, qd, "pxl", member("pxl").image.rect, 0.5)
          -- headPos), health, thickness, tlt, lastRad, rad, perp, lastPerp, gridPos, lstPos, lstGridpos, dir, pnt, floatDpth, mdPnt, q2, q, c2, c, frontWall), backWall)
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
    
    
    
  end if
end



on applyColoredShadowPlants me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(9)-1
      -- frontWall = 1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      -- frontWall = 1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
    otherwise:
      d = random(30)-1
      -- frontWall = 1
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 180
    
    cycle = lerp(6.0, 12.0, random(10000)/10000.0)
    cntr = random(50)
    
    tltFac = 0.0
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      cntr = cntr + 1
      
      lstPos = pnt
      dir = lerp(dir, 180-45+random(90), 0.1)
      dir = dir + sin((cntr/cycle)*PI*2.0)*8
      cycle = cycle + 0.1
      if(cycle > 35) then cycle = 35
      pnt = pnt + degToVec(dir)*3
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV+1 > 0)and(lstGridPos.locV+1 < gEEprops.effects[r].mtrx[1].count) then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV+1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*lerp(-2.0, 1.0, power(tltFac, 0.85))
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tltFac = tltFac + 0.002
      if(tltFac > 1.0)then tltFac = 1.0
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    fuzzLength = 20+random(50)
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    thickness = lerp(thickness, restrict(points.count.float, 20.0, 180.0)/180.0, 0.5)
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      --rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      f =  sin(f*PI*0.5)
      rad = 1.1 + f*7.0*(points[q][3].float/6.0)*lerp(thickness, 0.5, 0.2)
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:colr, ink:36})
          if (gdLayer <> "C") then
            member("gradient" & gdLayer & string(d - c[1])).image.copyPixels(member("pxlDR200").image, qd, member("pxlDR200").image.rect, {ink:39})
          end if
          --copyPixelsToRootEffectColor(gdLayer, d, qd, "pxl", member("pxl").image.rect, 0.5)
          
          if(random(30) = 1)then
            me.coloredSporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 15 + random(50) * (1.0-f), d - c[1], colr)
          end if
          
          if(q < fuzzLength) and(random(fuzzLength) > q)and(random(6)=1) then
            f2 = q.float / fuzzLength.float
            me.coloredSporeGrower(pnt + MoveToPoint(pnt, lstPos, diag(pnt, lstPos)*random(10000)/10000.0), 65 + random(50) * (1.0-f2), d - c[1], colr)
          end if
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
  end if
end

on sporeGrower me, pos, lngth, layer, col
  dir = point(0, -1)
  
  repeat with q = 1 to lngth then
    otherCol = member("layer"&layer).image.getPixel(pos.locH-1, pos.locV-1)
    if(otherCol <> col)and(otherCol <> color(255, 255, 255))then
      exit repeat
    else
      member("layer"&layer).image.setPixel(pos.locH-1, pos.locV-1, col)
      pos = pos + dir
      
      if(dir.locV = -1)and(random(2)=1)then
        if(random(2)=1)then
          dir = point(-1, 0)
        else
          dir = point(1, 0)
        end if
      else 
        dir = point(0, -1)
      end if
    end if
  end repeat
end

on coloredSporeGrower me, pos, lngth, layer, col
  dir = point(0, -1)
  
  repeat with q = 1 to lngth then
    otherCol = member("layer"&layer).image.getPixel(pos.locH-1, pos.locV-1)
    if(otherCol <> col)and(otherCol <> color(255, 255, 255))then
      exit repeat
    else
      member("layer"&layer).image.setPixel(pos.locH-1, pos.locV-1, col)
      if (gdLayer <> "C") then
        member("gradient"&gdLayer&layer).image.setPixel(pos.locH-1, pos.locV-1, color(50, 50, 50))
      end if
      pos = pos + dir
      
      
      if(dir.locV = -1)and(random(2)=1)then
        if(random(2)=1)then
          dir = point(-1, 0)
        else
          dir = point(1, 0)
        end if
      else 
        dir = point(0, -1)
      end if
    end if
  end repeat
end

on applyRootPlants me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  frontWall = 0
  backWall = 29
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(9)-1
      -- frontWall = 1
      backWall = 9
    "2":
      d = random(10)-1 + 10
      frontWall = 10
      backWall = 19
    "3":
      d = random(10)-1 + 20
      frontWall = 20
    "1:st and 2:nd":
      d = random(20)-1
      -- frontWall = 1
      backWall = 19
    "2:nd and 3:rd":
      d = random(20)-1 + 10
      frontWall = 10
    otherwise:
      d = random(30)-1
      -- frontWall = 1
  end case
  
  if(d > 5)then
    frontWall = 5+3
    d = restrict(d, frontWall, 29)
  else
    backWall = 5
  end if
  
  if (gLEprops.matrix[q2][c2][(1+(d>9)+(d>19))][1]=0)then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    
    health = 6
    points = [[pnt, d, health]]
    
    dir = 180
    
    cycle = lerp(6.0, 12.0, random(10000)/10000.0)
    cntr = random(50)
    
    tltFac = 0.0
    
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      cntr = cntr + 1
      
      lstPos = pnt
      dir = lerp(dir, 180-45+random(90), 0.1)
      dir = dir + sin((cntr/cycle)*PI*2.0)*8
      cycle = cycle + 0.1
      if(cycle > 35) then cycle = 35
      pnt = pnt + degToVec(dir)*3
      
      lstGridPos = giveGridPos(lstPos) + gRenderCameraTilePos
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tlt = 0
      repeat with q = -1 to 1 then
        if (q<>0)and (lstGridPos.locH + q > 0)and(lstGridPos.locH + q < gEEprops.effects[r].mtrx.count)and(lstGridPos.locV+1 > 0)and(lstGridPos.locV+1 < gEEprops.effects[r].mtrx[1].count) then
          tlt = tlt + gEEprops.effects[r].mtrx[lstGridPos.locH+q][lstGridPos.locV+1]*q
        end if
      end repeat
      pnt.locH = pnt.locH + (tlt/100.0)*lerp(-2.0, 1.0, power(tltFac, 0.85))
      gridPos = giveGridPos(pnt) + gRenderCameraTilePos
      
      tltFac = tltFac + 0.002
      if(tltFac > 1.0)then tltFac = 1.0
      
      points.add([pnt, d, health])
      
      if solidAfaMv(lstGridPos, (1+(d>9)+(d>19))) = 1 then
        health = health - 1
        if(health < 1) then
          exit repeat
        end if
      else
        health = restrict(health+1, 0, 6)
      end if
      
    end repeat
    
    fuzzLength = 20+random(50)
    
    thickness = (gEEprops.effects[r].mtrx[q2][c2]/100.0)*power(random(10000)/10000.0, 0.3)
    thickness = lerp(thickness, restrict(points.count.float, 20.0, 180.0)/180.0, 0.5)
    
    lstPos = points[1][1] + point(0,1)
    lastRad = 0
    lastPerp = point(0,0)
    repeat with q = 1 to points.count then
      f = q.float / points.count.float
      pnt = points[q][1]
      d = points[q][2]
      dir = moveToPoint(pnt, lstPos, 1.0)
      perp = giveDirFor90degrToLine(-dir, dir)
      --rad = 0.6 + f*8.0*(points[q][3].float/6.0)*lerp(0.8, 1.2, random(1000)/1000.0)*lerp(thickness, 0.5, 0.2)
      f =  sin(f*PI*0.5)
      rad = 1.1 + f*7.0*(points[q][3].float/6.0)*lerp(thickness, 0.5, 0.2)
      
      repeat with c in [[0, 1.0], [1, 0.7], [2, 0.3]] then
        if(d - c[1] >= 0)and((rad*c[2] > 0.8)or(c[1]=0))then
          qd = [pnt-perp*rad*c[2], pnt+perp*rad*c[2], lstPos+dir+lastPerp*lastRad*c[2], lstPos+dir-lastPerp*lastRad*c[2]]
          member("layer"&string(d - c[1])).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:colr})
          if (gdLayer <> "C") then
            member("gradient" & gdLayer & string(d - c[1])).image.copyPixels(member("pxlDR200").image, qd, member("pxlDR200").image.rect, {ink:39})
          end if
          --copyPixelsToRootEffectColor(gdLayer, d, qd, "pxl", member("pxl").image.rect, 0.5)
        end if
      end repeat
      
      lstPos = pnt
      lastPerp = perp
      lastRad = rad
    end repeat
  end if
end


on applyDaddyCorruption me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  global daddyCorruptionHoles
  
  extraHoleChance = 1
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      dmin = 0
      dmax = 29
      dmax2 = 26
    "1":
      dmin = 0
      dmax = 6
      dmax2 = 6
    "2":
      dmin = 10
      dmax = 16
      dmax2 = 16
    "3":
      dmin = 20
      dmax = 29
      dmax2 = 26
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
      dmax2 = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
      dmax2 = 26
    otherwise:
      dmin = 0
      dmax = 29
      dmax2 = 26
  end case
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255))then --lingo sometimes returns number for some reason but drizzle doesn't!
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d <= dmax) and (dp+d >= dmin) then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("DaddyBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:36})
          else
            member("layer"&string(dp+d)).image.copyPixels(member("DaddyBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:36})
          end if
        else
          exit repeat
        end if
      end repeat
      
      if((random(3) = 1)or(extraHoleChance=1))and(dp <= dmax2) and (dp >= dmin)then
        daddyCorruptionHoles.add([startPos, rad * (50+random(50))*0.01, random(360), dp, amount])
        extraHoleChance = 0
      end if
    end if
  end repeat  
end

on applyCorruptionNoEye me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255))then --do not -1
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d <= dmax) and (dp+d >= dmin) then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("CNEBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:36})
          else
            member("layer"&string(dp+d)).image.copyPixels(member("CNEBulb").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:36})
          end if
        else
          exit repeat
        end if
      end repeat
    end if
  end repeat
end

on applyWastewaterMold me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255)) then --do not -1
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d <= dmax) and (dp+d >= dmin) then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("wastewaterMoldGraf").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#color:colr, #ink:36})
            if gdLayer <> "C" then
              member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("wastewaterMoldGrad").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:39})
            end if
          else
            member("layer"&string(dp+d)).image.copyPixels(member("wastewaterMoldGraf").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#color:colr, #ink:36})
            if gdLayer <> "C" then
              member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("wastewaterMoldGrad").image, rect(startPos, startPos)+rect(-rad,-rad,rad,rad), rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:39})
            end if 
          end if
        else
          exit repeat
        end if
      end repeat
    end if
  end repeat
end

--dakras
on applyClubMoss me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255))then --do not -1
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      if(dp <= dmax) and (dp >= dmin) then
        vari = random(13)
        rtRect = rotateToQuad(rect(startPos, startPos) + rect(-rad, -rad, rad, rad), random(360))
        dtRect = rect((vari - 1) * 20, 1, vari * 20, 14)
        member("layer" & string(dp)).image.copyPixels(member("clubMossGraf").image, rtRect, dtRect, {#color:colr, #ink:36})
        if (gdLayer <> "C") then
          member("gradient" & gdLayer & string(dp)).image.copyPixels(member("clubMossGrad").image, rtRect, dtRect, {#ink:39})
        end if 
      end if
    end if
  end repeat
end

on applyMossWall me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255))then --do not -1
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 1)then
      if(dp <= dmax) and (dp >= dmin) then
        vari = random(13)
        nRn = random(90) --needed to prevent RND change
        rtRect = rect(startPos, startPos) + rect(-rad, -rad, rad, rad)
        dtRect = rect((vari - 1) * 20, 1, vari * 20, 12)
        member("layer"&string(dp)).image.copyPixels(member("mossSideGraf").image, rtRect, dtRect, {#color:colr, #ink:36})
        if (gdLayer <> "C") then
          member("gradient"&gdLayer&string(dp)).image.copyPixels(member("mossSideGrad").image, rtRect, dtRect, {#ink:39})
        end if
      end if
    end if
  end repeat
end
--end dakras
on applyFlowers me, q, c, amount
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  mdPnt = giveMiddleOfTile(point(q,c))
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      dmin = 0
      dmax = 29
    "1":
      dmin = 0
      dmax = 6
    "2":
      dmin = 10
      dmax = 16
    "3":
      dmin = 20
      dmax = 29
    "1:st and 2:nd":
      dmin = 0
      dmax = 16
    "2:nd and 3:rd":
      dmin = 10
      dmax = 29
    otherwise:
      dmin = 0
      dmax = 29
  end case
  
  
  repeat with a = 1 to amount/2 then
    dp = random(28)-1
    if(dp > 3)then
      dp = dp + 2
    end if
    
    lr = 3
    rad = random(100)*0.2*lerp(0.2, 1.0, amount/100)
    
    if(dp < 10)then
      lr = 1
    else if (dp < 20) then
      lr = 2
    end if
    
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    
    solid = 0
    
    if(solidAfaMv(point(q2,c2), lr) = 1)then
      solid = 1
    end if
    
    if(solid = 0)and(lr < 3)and(dp - (lr-1)*10 > 6)then
      if(solidAfaMv(point(q2,c2), lr+1) = 1)then
        solid = 1
      end if
    end if
    
    if(solid = 0)then
      repeat with dr in [point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if(solidAfaMv(giveGridPos(startPos + dr*rad)+gRenderCameraTilePos, lr) = 1)then
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    
    if(solid = 0)and(dp < 27)and(rad > 1.2)then
      repeat with dr in [point(0,0), point(-1,0), point(0,-1), point(0,1), point(1,0)]then
        if( member("layer"&string(dp+2)).getPixel(startPos.locH + dr.locH*rad*0.5, startPos.locV + dr.locV*rad*0.5) <> color(255,255,255))then --do not -1
          rad = rad / 2
          solid = 1
          exit repeat
        end if
      end repeat
    end if
    randRot1 = rect(startPos, startPos)+rect(-rad,-rad,rad,rad)
    randRot2 = rect(startPos, startPos)+rect(-rad,-rad,rad,rad)
    if (gRotOp) then
      randRot1 = rotateToQuad(randRot1, random(360))
      randRot2 = rotateToQuad(randRot2, random(360))
    end if  
    if(solid = 1)then
      repeat with d = 0 to 2 then
        if(dp+d <= dmax) and (dp+d >= dmin) then
          if(rad <= 10)then
            member("layer"&string(dp+d)).image.copyPixels(member("flowerGraf2").image, randRot1, rect(0, 1+d*20, 20, 1+(d+1)*20), {#color:colr, #ink:36})
            if gdLayer <> "C" then
              member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("flowerGrad2").image, randRot1, rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:39}) 
            end if
            member("layer"&string(dp+d)).image.copyPixels(member("flowerGraf1").image, randRot2, rect(0, 1+d*20, 20, 1+(d+1)*20), {#color:colrDetail, #ink:36})
            if gdDetailLayer <> "C" then
              member("gradient"&gdDetailLayer&string(dp+d)).image.copyPixels(member("flowerGrad1").image, randRot2, rect(0, 1+d*20, 20, 1+(d+1)*20), {#ink:39})
            end if
          else
            member("layer"&string(dp+d)).image.copyPixels(member("flowerGraf2").image, randRot1, rect(20, 1+d*40, 60, 1+(d+1)*40), {#color:colr, #ink:36})
            if gdLayer <> "C" then
              member("gradient"&gdLayer&string(dp+d)).image.copyPixels(member("flowerGrad2").image, randRot1, rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:39}) 
            end if
            member("layer"&string(dp+d)).image.copyPixels(member("flowerGraf1").image, randRot2, rect(20, 1+d*40, 60, 1+(d+1)*40), {#color:colrDetail, #ink:36})
            if gdDetailLayer <> "C" then
              member("gradient"&gdDetailLayer&string(dp+d)).image.copyPixels(member("flowerGrad1").image, randRot2, rect(20, 1+d*40, 60, 1+(d+1)*40), {#ink:39})
            end if
          end if
        else
          exit repeat
        end if
      end repeat
    end if
  end repeat
end

on applyWire(me, q, c, eftc)
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  global gCurrentRenderCamera
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30) - 1
    "1":
      d = random(10) - 1
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(20) - 1
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
    otherwise:
      d = random(30) - 1
  end case
  lr = 1 + (d > 9) + (d > 19)
  if (gLEprops.matrix[q2][c2][lr][1] = 0) then
    layerd = member("layer" & string(d)).image
    member("wireImage").image = image(layerd.width, layerd.height, 1)
    wireImg = member("wireImage").image
    mdPnt = giveMiddleOfTile(point(q, c))
    startPos = mdPnt+point(-11 + random(21), -11 + random(21))
    myCamera = me.closestCamera(startPos + gRenderCameraTilePos * 20)
    if (myCamera = 0) then
      exit
    end if
    fatness = 1
    case fatOp of
      "2px":
        fatness = 2
      "3px":
        fatness = 3
      "random":
        fatness = random(3)
    end case
    a = 1.0 + random(100) + random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a * keepItFromToForty) + 40.0) / (keepItFromToForty + 1.0)
    addNRct = rect(-(fatness > 1), -(fatness > 1), (fatness = 3), (fatness = 3))
    wireImg.copypixels(DRPxl, rect(startPos.locH, startPos.locV - 1, startPos.locH + 1, startPos.locV + 1) + addNRct, rect(0, 0, 1, 1), {#color:color(0, 0, 0)})
    goodStops = 0
    repeat with dir = 0 to 1
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      repeat with rep = 1 to 1000
        pnt.locH = startPos.locH + (-1 + 2 * dir) * rep
        pnt.locV = startPos.locV + a - (power(2.71828183, rep / a) + power(2.71828183, -rep / a)) * (a / 2.0)
        dr = moveToPoint(lastPnt, pnt, fatness.float)
        wireImg.copypixels(DRPxl, rect(pnt.locH, pnt.locV, pnt.locH + 1, lastPnt.locV + 1) + addNRct, rect(0, 0, 1, 1), {#color:color(0, 0, 0)})
        lastPnt = point(pnt.locH, pnt.locV)
        tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
        if (tlPos.inside(rect(1, 1, gLOprops.size.loch + 1, gLOprops.size.locv + 1)) = 0) then
          exit repeat
        else 
          if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
            if (gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1) then
              if (layerd.getPixel(pnt) <> DRWhite) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          else
            if (solidAfaMv(tlPos, lr)) then
              goodStops = goodStops + 1
              exit repeat
            end if
          end if
        end if
      end repeat
    end repeat
    if (goodStops = 2) then
      layerd.copyPixels(wireImg, wireImg.rect, wireImg.rect, {#color:color(255, 0, 0), #ink:36})
    end if
  end if
end

on applyChain me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  
  
  lr = 1+(d>9)+(d>19)
  
  big = 0
  
  case chOp of
    "FAT":
      big = 1
  end case
  
  
  --repeat with lmao = 0 to 100 then
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    if big then
      a = a + 10
    end if
    
    origOrnt = random(2)-1
    
    goodStops = 0
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      if dir = 0 then
        ornt = origOrnt
      else
        ornt = 1-origOrnt
      end if
      repeat with rep = 1 to 4000 then
        checkterrain = 0
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep*0.25
        pnt.locV = startPos.locV + a - (power(2.71828183, (rep*0.25)/a)+power(2.71828183, -(rep*0.25)/a))*(a/2.0)
        
        if big = 0 then
          if diag(pnt, lastPnt)>=7 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-3,-5,3,5)
              gtRect = rect(0,0,6,10)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-1,-5,1,5)
              gtRect = rect(7,0,8,10)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("chainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        else
          if diag(pnt, lastPnt)>=12 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-6,-10,6,10)
              gtRect = rect(0,0,12,20)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-2,-10,2,10)
              gtRect = rect(13,0,16,20)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("bigChainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        end if
        
        if checkterrain then
          tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
          if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
            exit repeat
          else 
            if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
              if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
                if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                  goodStops = goodStops + 1
                  exit repeat
                end if
              end if
            else
              if solidAfaMv(tlPos, lr) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          end if
        end if
        
        
      end repeat
    end repeat
    
    
    if goodStops = 2 then
      member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:color(255, 0, 0), #ink:36})
    end if
  end if
  --end repeat
end

on applyColoredWires me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case lrSup of
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    fatness = 1
    case fatOp of
      "2px":
        fatness = 2
      "3px":
        fatness = 3
      "random":
        fatness = random(3)
    end case
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    member("wireImage").image.copypixels(member("pxl").image, rect(startPos.locH, startPos.locV-1, startPos.locH+1, startPos.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:color(0,0,0)})
    goodStops = 0
    
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      repeat with rep = 1 to 1000 then
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep
        pnt.locV = startPos.locV + a - (power(2.71828183, rep/a)+power(2.71828183, -rep/a))*(a/2.0)
        
        dr = moveToPoint(lastPnt, pnt, fatness.float)
        
        member("wireImage").image.copypixels(member("pxl").image, rect(pnt.locH, pnt.locV, pnt.locH+1, lastPnt.locV+1)+rect(-(fatness>1), -(fatness>1), (fatness=3), (fatness=3)), rect(0,0,1,1), {#color:color(0,0,0)})
        
        lastPnt = point(pnt.locH, pnt.locV)
        
        
        
        
        
        tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
        if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
          exit repeat
        else 
          if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
            if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
              if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          else
            if solidAfaMv(tlPos, lr) then
              goodStops = goodStops + 1
              exit repeat
            end if
          end if
        end if
        
      end repeat
    end repeat
    
    if goodStops = 2 then
      member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:colrInd, #ink:36})
      member("gradient"&gdIndLayer&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#ink:39})
    end if
  end if
end

on applyColoredChains me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case lrSup of
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  
  
  lr = 1+(d>9)+(d>19)
  
  big = 0
  
  case chOp of
    "FAT":
      big = 1
  end case
  
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    if big then
      a = a + 10
    end if
    
    origOrnt = random(2)-1
    
    goodStops = 0
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      if dir = 0 then
        ornt = origOrnt
      else
        ornt = 1-origOrnt
      end if
      repeat with rep = 1 to 4000 then
        checkterrain = 0
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep*0.25
        pnt.locV = startPos.locV + a - (power(2.71828183, (rep*0.25)/a)+power(2.71828183, -(rep*0.25)/a))*(a/2.0)
        
        if big = 0 then
          if diag(pnt, lastPnt)>=7 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-3,-5,3,5)
              gtRect = rect(0,0,6,10)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-1,-5,1,5)
              gtRect = rect(7,0,8,10)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("chainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        else
          if diag(pnt, lastPnt)>=12 then
            if ornt then
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-6,-10,6,10)
              gtRect = rect(0,0,12,20)
              ornt = 0
            else
              pos = (pnt+lastPnt)*0.5
              rct = rect(pos,pos)+rect(-2,-10,2,10)
              gtRect = rect(13,0,16,20)
              ornt = 1
            end if
            member("wireImage").image.copypixels(member("bigChainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
            lastPnt = point(pnt.locH, pnt.locV)
            checkterrain = 1
          end if
        end if
        
        if checkterrain then
          tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
          if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
            exit repeat
          else 
            if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
              if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
                if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                  goodStops = goodStops + 1
                  exit repeat
                end if
              end if
            else
              if solidAfaMv(tlPos, lr) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          end if
        end if
        
        
      end repeat
    end repeat
    
    
    if goodStops = 2 then
      member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:colrInd, #ink:36})
      member("gradient"&gdIndLayer&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#ink:39})
    end if
  end if
end

on applyRingChains me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  global gCurrentRenderCamera
  
  case lrSup of
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  
  
  lr = 1+(d>9)+(d>19)
  
  big = 0
  
  
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    member("wireImage").image = image(member("layer"&string(d)).image.width, member("layer"&string(d)).image.height, 1)
    mdPnt = giveMiddleOfTile(point(q,c))
    startPos = mdPnt+point(-11+random(21), -11+random(21))
    
    myCamera = me.closestCamera(startPos+gRenderCameraTilePos*20)
    if(myCamera = 0)then
      exit
    end if
    
    
    a = 1.0+random(100)+random(random(random(900)))
    keepItFromToForty = random(30)
    a = ((a*keepItFromToForty)+40.0)/(keepItFromToForty+1.0)
    
    if big then
      a = a + 10
    end if
    
    origOrnt = random(2)-1
    
    goodStops = 0
    repeat with dir = 0 to 1 then
      pnt = point(startPos.locH, startPos.locV)
      lastPnt = point(startPos.locH, startPos.locV)
      if dir = 0 then
        ornt = origOrnt
      else
        ornt = 1-origOrnt
      end if
      repeat with rep = 1 to 4000 then
        checkterrain = 0
        
        pnt.locH = startPos.locH +(-1 + 2*dir)*rep*0.25
        pnt.locV = startPos.locV + a - (power(2.71828183, (rep*0.25)/a)+power(2.71828183, -(rep*0.25)/a))*(a/2.0)
        
        if diag(pnt, lastPnt)>=12 then
          if ornt then
            pos = (pnt+lastPnt)*0.5
            rct = rect(pos,pos)+rect(-7,-9,7,9)
            gtRect = rect(0,0,14,14)
            ornt = 0
          else
            pos = (pnt+lastPnt)*0.5
            rct = rect(pos,pos)+rect(-2,-9,2,9)
            gtRect = rect(15,0,18,14)
            ornt = 1
          end if
          member("wireImage").image.copypixels(member("ringChainSegment").image, rotateToQuad(rct, lookAtPoint(lastPnt,pnt)), gtRect, {#color:color(0,0,0), #ink:36})
          lastPnt = point(pnt.locH, pnt.locV)
          checkterrain = 1
        end if
        
        if checkterrain then
          tlPos = giveGridPos(point(pnt.locH, pnt.locV)) + gRenderCameraTilePos
          if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
            exit repeat
          else 
            if(myCamera = gCurrentRenderCamera)and(me.seenByCamera(myCamera, pnt + gRenderCameraTilePos)=1) then
              if gLEprops.matrix[tlPos.locH][tlPos.locV][lr][1] = 1 then
                if member("layer"&string(d)).image.getPixel(pnt) <> color(255,255,255) then
                  goodStops = goodStops + 1
                  exit repeat
                end if
              end if
            else
              if solidAfaMv(tlPos, lr) then
                goodStops = goodStops + 1
                exit repeat
              end if
            end if
          end if
        end if
        
        
      end repeat
    end repeat
    
    
    if goodStops = 2 then
      if (gdIndLayer <> "C") then
        member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:colrInd, #ink:36})
        member("gradient"&gdIndLayer&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#ink:39})
      else
        member("layer"&string(d)).image.copyPixels(member("wireImage").image, member("wireImage").image.rect, member("wireImage").image.rect, {#color:color(255, 0, 0), #ink:36})
      end if
    end if
  end if
end

on applyFungiFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  
  
  
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    rnd = 0
    if (afaMvLvlEdit(point(q2,c2+1), layer)=1) then
      rnd = gEffectProps.list[gEffectProps.listPos]
      flp = random(2)-1
      closestEdge = 1000
      repeat with a = - 5 to 5 then
        if (afaMvLvlEdit(point(q2+a,c2+1), layer)<>1) then
          if abs(a) <= abs(closestEdge) then
            flp = (a>0)
            closestEdge = a
            if a = 0 then
              flp = random(2)-1
            end if
          end if
        end if
      end repeat
      
      pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    else if (afaMvLvlEdit(point(q2+1,c2), layer)=1) then
      rnd = 1
      flp = 0
      pnt = giveMiddleOfTile(point(q,c))+point(10, -random(10))
    else if (afaMvLvlEdit(point(q2-1,c2), layer)=1) then
      rnd = 1
      flp = 1
      pnt = giveMiddleOfTile(point(q2,c2))+point(-10, -random(10))
    end if
    
    
    if rnd <> 0 then
      rct = rect(pnt, pnt) + rect(-80, -80, 80, 80)
      gtRect = rect((rnd-1)*160, 0, rnd*160, 160)+rect(1,0,1,0)
      if flp then
        rct = vertFlipRect(rct)
      end if
      member("layer"&string(lr)).image.copyPixels(member("fungiFlowersGraf").image, rct, gtRect, {#ink:36})
    end if
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [2,3,4,5]
    l2 = []
    repeat with a = 1 to 4 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 


on applyColoredFungiFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  
  
  
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    rnd = 0
    if (afaMvLvlEdit(point(q2,c2+1), layer)=1) then
      rnd = gEffectProps.list[gEffectProps.listPos]
      flp = random(2)-1
      closestEdge = 1000
      repeat with a = - 5 to 5 then
        if (afaMvLvlEdit(point(q2+a,c2+1), layer)<>1) then
          if abs(a) <= abs(closestEdge) then
            flp = (a>0)
            closestEdge = a
            if a = 0 then
              flp = random(2)-1
            end if
          end if
        end if
      end repeat
      
      pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    else if (afaMvLvlEdit(point(q2+1,c2), layer)=1) then
      rnd = 1
      flp = 0
      pnt = giveMiddleOfTile(point(q,c))+point(10, -random(10))
    else if (afaMvLvlEdit(point(q2-1,c2), layer)=1) then
      rnd = 1
      flp = 1
      pnt = giveMiddleOfTile(point(q2,c2))+point(-10, -random(10))
    end if
    
    
    if rnd <> 0 then
      rct = rect(pnt, pnt) + rect(-80, -80, 80, 80)
      gtRect = rect((rnd-1)*160, 0, rnd*160, 160)+rect(1,0,1,0)
      if flp then
        rct = vertFlipRect(rct)
      end if
      member("layer"&string(lr)).image.copyPixels(member("fungiFlowersGraf2").image, rct, gtRect, {#color:colr, #ink:36})
      copyPixelsToRootEffectColor(gdLayer, lr, rct, "fungiFlowersGrad", gtRect, 0.5)
    end if
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [2,3,4,5]
    l2 = []
    repeat with a = 1 to 4 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end

on applyLHFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("lightHouseFlowersGraf").image, rct, gtRect, {#ink:36})
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8]
    l2 = []
    repeat with a = 1 to 8 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyColoredLHFlower me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    --writeMessage(q)
    --writeMessage(c)
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("lightHouseFlowersGraf2").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "lightHouseFlowersGrad", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8]
    l2 = []
    repeat with a = 1 to 8 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyAssortedTrash me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  repeat with varAttr = 0 to 2 then
    if (afaMvLvlEdit(point(q2,c2), layer)=0) then
      
      rnd = gEffectProps.list[gEffectProps.listPos]
      flp = random(2)-1 --unused but can't remove because it would change rng
      pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
      
      rct = rect(pnt, pnt) + rect(-25, -25, 25, 25)
      rct2 = rotateToQuad(rct, random(360))
      gtRect = rect((rnd-1)*50, 0, rnd*50, 50)+rect(1,0,1,0)
      if (gdIndLayer = "C") then
        member("layer"&string(lr)).image.copyPixels(member("assortedTrash").image, rct2, gtRect, {#color:[color(255,0,0), color(0,255,0), color(0,0,255)][random(3)], #ink:36})
      else
        member("layer"&string(lr)).image.copyPixels(member("assortedTrash").image, rct2, gtRect, {#color:colrInd, ink:36})
        member("gradient"&gdIndLayer&string(lr)).image.copyPixels(member("assortedTrash").image, rct2, gtRect, {#ink:39})
      end if
    end if
  end repeat
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48]
    l2 = []
    repeat with a = 1 to 48 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end

on applyResRoots me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of
    "All":
      lrmin = 1 
      lrmax = 3
    "1":
      lrmin = 1
      lrmax = 1
    "2":
      lrmin = 2
      lrmax = 2
    "3":
      lrmin = 3
      lrmax = 3
    "1:st and 2:nd":
      lrmin = 1
      lrmax = 2
    "2:nd and 3:rd":
      lrmin = 2
      lrmax = 3
    otherwise:
      lrmin = 1 
      lrmax = 3
  end case
  sourceRect = member("CloverRoot1").rect
  if (gdLayer = "C") then
    repeat with tr = lrmin to lrmax
      if (afaMvLvlEdit(point(q2,c2), tr)<>0) and (gEEprops.effects[r].mtrx[q2][c2] >= 50)then
        pnt = giveMiddleOfTile(point(q,c))
        rct = rect(pnt, pnt)+ rect(-10, -10, 10, 10)
        rct2 = rect(pnt, pnt)+ [rect(-15, -15, 5, 5), rect(-5, -5, 15, 15)][random(2)]
        rct3 = rect(pnt, pnt)+ rect(-5, -5, 15, 15)
        lay = member("layer"&string((tr-1)*10)).image
        lay.copyPixels(member("CloverRoot" & string(random(6))).image, rct, sourceRect, {#color:color(0,0,255), #ink:36})
        lay.copyPixels(member("CloverRoot" & string(random(6))).image, rct2, sourceRect, {#color:color(0,0,255), #ink:36})
        lay = member("layer"&string((tr-1)*10+5)).image
        lay.copyPixels(member("CloverRoot" & string(random(6))).image, rct, sourceRect, {#color:color(0,0,255), #ink:36})
        lay.copyPixels(member("CloverRoot" & string(random(6))).image, rct2, sourceRect, {#color:color(0,0,255), #ink:36})
      end if
    end repeat
  else
    repeat with tr = lrmin to lrmax
      if (afaMvLvlEdit(point(q2,c2), tr)<>0) and (gEEprops.effects[r].mtrx[q2][c2] >= 15)then
        pnt = giveMiddleOfTile(point(q,c))
        rct = rect(pnt, pnt)+ rect(-10, -10, 10, 10)
        rct2 = rect(pnt, pnt)+ [rect(-15, -15, 5, 5), rect(-5, -5, 15, 15)][random(2)]
        rct3 = rect(pnt, pnt)+ rect(-5, -5, 15, 15)
        var1 = "CloverRoot" & string(random(6))
        var2 = "CloverRoot" & string(random(6))
        var3 = "CloverRoot" & string(random(6))
        var4 = "CloverRoot" & string(random(6))
        strtr = string((tr-1)*10)
        lay = member("layer"&strtr).image
        grd = member("gradient"&gdLayer&strtr).image
        lay.copyPixels(member(var1).image, rct, sourceRect, {#color:colr, #ink:36})
        grd.copyPixels(member(var1 & "G").image, rct, sourceRect, {#ink:39})
        lay.copyPixels(member(var2).image, rct2, sourceRect, {#color:colr, #ink:36})
        grd.copyPixels(member(var2 & "G").image, rct2, sourceRect, {#ink:39})
        strtr = string((tr-1)*10 + 5)
        lay = member("layer"&strtr).image
        grd = member("gradient"&gdLayer&strtr).image
        lay.copyPixels(member(var3).image, rct, sourceRect, {#color:colr, #ink:36})
        grd.copyPixels(member(var3 & "G").image, rct, sourceRect, {#ink:39})
        lay.copyPixels(member(var4).image, rct2, sourceRect, {#color:colr, #ink:36})
        grd.copyPixels(member(var4 & "G").image, rct2, sourceRect, {#ink:39})
      end if
    end repeat
  end if
end

on applyFoliage me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-80, -320, 80, 40)
    gtRect = rect((rnd-1)*160, 0, rnd*160, 360)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("foliageGraf3").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "foliageGrad3", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
    l2 = []
    repeat with a = 1 to 28 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyMistletoe me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-80, -320, 80, 40)
    gtRect = rect((rnd-1)*160, 0, rnd*160, 360)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("mistletoeGraf2").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "mistletoeGrad2", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6]
    l2 = []
    repeat with a = 1 to 6 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyHighFern me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("highFernGraf").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "highFernGrad3", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2]
    l2 = []
    repeat with a = 1 to 2 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applyHighGrass me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("highGrassGraf").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "highGrassGrad3", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4]
    l2 = []
    repeat with a = 1 to 4 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 

on applySmallSprings me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-40, -160, 40, 20)
    gtRect = rect((rnd-1)*80, 0, rnd*80, 180)+rect(1,0,1,0)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member("smallSpringsGraf").image, rct, gtRect, {#color:colr, #ink:36})
    copyPixelsToRootEffectColor(gdLayer, lr, rct, "smallSpringsGrad", gtRect, 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7]
    l2 = []
    repeat with a = 1 to 7 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end

--leo
on applyIvy me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    lftBorder = mdPnt.locH-10
    rgthBorder =  mdPnt.locH+10
    ivygrad = member("IvyLeafGradMed").image
    fruitpercent = 50
    case fruitDensity of
      "H":
        fruitpercent = 75
      "M":
        fruitpercent = 50
      "L":
        fruitpercent = 25
      "N":
        fruitpercent = 0
    end case
    case colrIntensity of
      "H":
        ivygrad = member("IvyLeafGraf").image
      "M":
        ivygrad = member("IvyLeafGradMed").image
      "L":
        ivygrad = member("IvyLeafGradLow").image
      "N":
        ivygrad = member("pxl").image
      "R":
        if(colrIntensity="R")then
          ivyrngrad = Random(4)
          case ivyrngrad of
            1:
              ivygrad = member("IvyLeafGraf").image
            2:
              ivygrad = member("IvyLeafGradMed").image
            3:
              ivygrad = member("IvyLeafGradLow").image
            4:
              ivygrad = member("pxl").image
          end case
        end if
    end case
    ivyrandom = Random(100)
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100 then
      ivyrandom = Random(100)
      fruitrandom = Random(100)
      lstPos = pnt
      pnt = pnt + degToVec(-45+random(90))*(2+random(6))
      pnt.locH = restrict(pnt.locH, lftBorder, rgthBorder)
      dir = moveToPoint(pnt, lstPos, 1.0)
      crossDir = giveDirFor90degrToLine(-dir, dir)
      qd = [pnt-crossDir, pnt+crossDir, lstPos+crossDir, lstPos-crossDir]
      test = [pnt-crossDir-2, pnt+crossDir, lstPos+crossDir-2, lstPos-crossDir]
      fruitytest = [pnt-crossDir-1, pnt+crossDir, lstPos+crossDir-1, lstPos-crossDir]
      fuck = test + member("IvyLeafGraf").image.rect
      fruity = fruitytest + member("IvyFruit").image.rect
      member("layer"&string(d)).image.copyPixels(member("pxl").image, qd, member("pxl").image.rect, {#color:colr, #ink:10})
      if(fruitrandom<fruitpercent)then
        member("layer"&string(d)).image.copyPixels(member("IvyFruit").image, fruity, member("IvyFruit").image.rect, {#color:color(255, 0, 255), #ink:10})
        member("gradientA"&string(d)).image.copyPixels(member("IvyFruit").image, fruity, member("IvyFruit").image.rect, {ink:39}) 
      end if
      if(ivyrandom<leafDensity)then
        member("layer"&string(d)).image.copyPixels(member("IvyLeafGraf").image, fuck, member("IvyLeafGraf").image.rect, {#color:colr, #ink:10})
        if (colrIntensity <> "N" and gdLayer <> "C") then
          member("gradient"&gdLayer&string(d)).image.copyPixels(ivygrad, fuck, ivygrad.rect, {ink:39}) 
        end if
      end if
      if(colrIntensity="R")then
        ivyrngrad = Random(4)
        case ivyrngrad of
          1:
            ivygrad = member("IvyLeafGraf").image
          2:
            ivygrad = member("IvyLeafGradMed").image
          3:
            ivygrad = member("IvyLeafGradLow").image
          4:
            ivygrad = member("pxl").image
        end case
      end if
      if solidAfaMv(giveGridPos(lstPos) + gRenderCameraTilePos, lr) = 1 then
        exit repeat
      end if
    end repeat
  end if
end
-- end leo

on applyBigPlant me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  lr = 1
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      layer = random(3)
    "1":
      layer = 1
    "2":
      layer = 2
    "3":
      layer = 3
    "1:st and 2:nd":
      layer = random(2)
    "2:nd and 3:rd":
      layer = random(2) + 1
    otherwise:
      layer = random(3)
  end case
  
  mem = "fern"
  case gEEprops.effects[r].nm of
    "Fern":
    "Giant Mushroom":
      mem = "giantMushroom"
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  if (afaMvLvlEdit(point(q2,c2), layer)=0) then
    
    rnd = gEffectProps.list[gEffectProps.listPos]
    flp = random(2)-1
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    rct = rect(pnt, pnt) + rect(-50, -80, 50, 20)
    gtRect = rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1)
    if flp then
      rct = vertFlipRect(rct)
    end if
    member("layer"&string(lr)).image.copyPixels(member(mem&"Graf").image, rct, gtRect, {#ink:36, #color:colr})
    
    pnt = depthPnt(pnt, lr-5)
    rct = rect(pnt, pnt) + rect(-50, -80, 50, 20)
    if flp then
      rct = vertFlipRect(rct)
    end if
    copyPixelsToEffectColor(gdLayer, lr, rct, mem&"Grad",rect((rnd-1)*100, 0, rnd*100, 100)+rect(1,1,1,1), 0.5)
  end if
  
  
  gEffectProps.listPos = gEffectProps.listPos + 1
  if gEffectProps.listPos > gEffectProps.list.count then
    l = [1,2,3,4,5,6,7,8]
    l2 = []
    repeat with a = 1 to 8 then
      val = l[random(l.count)]
      l2.add(val)
      l.deleteOne(val)
    end repeat
    gEffectProps = [#list:l2, #listPos:1]
  end if
end 


on apply3Dsprawler me, q, c, effc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  big = 0
  if (c > 1) and ((c2 - 1) > 0) then
    big = (gEEprops.effects[r].mtrx[q2][c2-1] > 0)
  end if
  
  lr = 1
  case lrSup of
    "All":
      layer = random(3)
      lrRange = [0, 29]
    "1":
      layer = 1
    "2":
      layer = 2
      lrRange = [6, 29]
    "3":
      layer = 3
      lrRange = [6, 29]
    "1:st and 2:nd":
      layer = random(2)
      lrRange = [0, 29]
    "2:nd and 3:rd":
      layer = random(2) + 1
      lrRange = [6, 29]
    otherwise:
      layer = random(3)
      lrRange = [0, 29]
  end case
  
  lr = ((layer-1)*10) + random(9) - 1
  
  if layer = 1 then
    if lr < 5 then
      lrRange = [0, 5] 
    else 
      lrRange = [6, 29] 
    end if
  end if
  
  case effc of
    "Sprawlbush":
      sts = [#branches:10+random(10)+15*big, #expectedBranchLife:[#small:20, #big:35, #smallRandom:30, #bigRandom:70], #startTired:0, #avoidWalls:1.0, #generalDir:0.6, #randomDir:1.2, #step:6.0]
    "featherFern":
      sts = [#branches:3+random(3)+3*big, #expectedBranchLife:[#small:130, #big:200, #smallRandom:50, #bigRandom:100], #startTired:-77 - (77*big), #avoidWalls:0.6, #generalDir:1.2, #randomDir:0.6, #step:2.0, #featherCounter:0, #airRoots:0]
    "Fungus Tree":
      sts = [#branches:10+random(10)+15*big, #expectedBranchLife:[#small:30, #big:60, #smallRandom:15, #bigRandom:30], #startTired:0, #avoidWalls:0.8, #generalDir:0.8, #randomDir:1.0, #step:3.0, thickness:(6+random(3))*(1+big*0.4), #branchPoints:[]]
      
  end case
  
  
  if (afaMvLvlEdit(point(q2,c2), layer)=0)and(afaMvLvlEdit(point(q2,c2+1), layer)=1) then
    
    pnt = giveMiddleOfTile(point(q,c))+point(-10+random(20), 10)
    
    case effc of
      "Fungus Tree":
        
        if big then
          expectedLife = sts.expectedBranchLife.big+random(sts.expectedBranchLife.bigRandom)
        else
          expectedLife = sts.expectedBranchLife.small+random(sts.expectedBranchLife.smallRandom)
        end if
        sts.branchPoints = [[#pos:pnt, #dir:point(0,-1), #thickness:sts.thickness, #layer:lr, #lifeLeft:expectedLife, #tired:sts.startTired]]
        
    end case
    
    repeat with branches = 1 to sts.branches then
      pos = point(pnt.loch, pnt.locv)
      lstPos = point(pnt.loch, pnt.locv)
      generalDir = degToVec(-60+random(120))
      lstAimPnt = generalDir
      brLr = lr
      
      brLrDir = 101 + random(201)
      avoidWalls = 2.0
      
      tiredNess = sts.startTired
      
      if big then
        expectedLife = sts.expectedBranchLife.big+random(sts.expectedBranchLife.bigRandom)
      else
        expectedLife = sts.expectedBranchLife.small+random(sts.expectedBranchLife.smallRandom)
      end if
      
      case effc of
        "featherFern":
          sts.airRoots = 25+15*big
        "Fungus Tree":
          branch = sts.branchPoints[random(sts.branchPoints.count)]
          sts.branchPoints.deleteOne(branch)
          
          baseThickness = branch.thickness
          pos = branch.pos
          lstPos = branch.pos
          brLr = branch.layer
          generalDir = branch.dir
          lstAimPnt = branch.dir
          tiredNess = branch.tired
          expectedLife = restrict(branch.lifeLeft - 11 + random(21), 5, 200)
          startLifeTime = expectedLife
      end case
      
      repeat with step = 1 to expectedLife then
        lstPos = pos
        
        case effc of
          "featherFern":
            tiredNess = tiredNess + 0.5 + abs(tiredNess*0.05) - 0.3*big
          "Fungus Tree":
            tiredNess = -90*(1.0-((startLifeTime-step)/startLifeTime.float))
        end case
        
        aimPnt = generalDir*sts.generalDir+degToVec(random(360))*sts.randomDir + point(0, tiredNess*0.01)
        
        repeat with dir in [point(-1,0), point(-1,-1), point(0,-1), point(1,-1), point(1,0), point(1,1), point(0,1), point(-1,1)] then
          if (afaMvLvlEdit(giveGridPos(lstPos)+dir+gRenderCameraTilePos, ((brLr/10.0)-0.4999).integer+1)=1) then
            aimPnt = aimPnt - dir*avoidWalls
            avoidWalls = restrict(avoidWalls - 0.06, 0.2, 2)
            step = step + (effc <> "Fungus Tree")
          else
            aimPnt = aimPnt + dir*0.1
          end if
        end repeat
        
        avoidWalls = restrict(avoidWalls + 0.03, 0.2, 2)
        
        lstLayer = brLr
        
        
        brLr = brLr + brLrDir*0.01
        
        smllst = lrRange[1]
        if ((lstLayer/10.0)-0.4999).integer+1 > 1 then
          if (afaMvLvlEdit(giveGridPos(pos)+gRenderCameraTilePos, ((lstLayer/10.0)-0.4999).integer+1-1)=1) then
            wall = ((lstLayer/10.0)-0.4999).integer*10
            if wall > 0 then
              wall = wall - 1 
            end if
            smllst = restrict(smllst, wall, 0)
          end if
        end if
        
        bggst = lrRange[2]
        if ((lstLayer/10.0)-0.4999).integer+1 < 3 then
          if (afaMvLvlEdit(giveGridPos(pos)+gRenderCameraTilePos, ((lstLayer/10.0)-0.4999).integer+1+1)=1) then
            wall = ((restrict(lstLayer, 1, 29)/10.0)+0.4999).integer*10 -1
            bggst = restrict(bggst, 0, wall)
          end if
        end if
        
        if brLr < smllst then
          brLr = smllst
          brLrDir = random(41)
        end if
        if brLr > bggst then
          brLr = bggst
          brLrDir = -random(41)
        end if
        
        
        -- aimPnt = aimPnt + point(0, tiredNess*0.01)
        
        aimPnt = (aimPnt + lstAimPnt + lstAimPnt)/3.0
        
        lstAimPnt = aimPnt
        
        pos = pos + moveToPoint(point(0,0), aimPnt, sts.step)
        
        pstColor = 0
        
        case effc of 
          "featherFern":
            if sts.airRoots > 0 then
              sts.featherCounter = 20
              sts.airRoots = sts.airRoots - 1
            end if
            
            
            sts.featherCounter = sts.featherCounter + diag(pos, lstPos)*0.5 + abs(pos.locH - lstPos.locH) + abs(lstLayer-brLr)
            if sts.featherCounter > 8 + ((expectedLife-step)/expectedLife.float)*12 then
              sts.featherCounter = sts.featherCounter - (8 + ((expectedLife-step)/expectedLife.float)*12)
              
              fc = ((expectedLife-step)/expectedLife.float)
              fc = 1.0-fc
              fc = fc*fc
              fc = 1.0-fc
              
              lngth = sin(fc*PI)*  (abs(pos.locV-pnt.locV) + 120)/3.0
              
              
              repeat with cntr = 1 to sts.airRoots then
                lngth = (lngth*6.0 + (abs(pos.locV-pnt.locV)+4))/7.0
              end repeat
              -- put (expectedLife-step)/expectedLife.float && lngth
              
              repeat with rct in [rect(pos, pos) + rect(0, 0, 1, lngth), rect(pos, pos) + rect(1, 0, 2, lngth-random(random(random(lngth.integer+1))))] then
                member("layer"&string(brLr.integer)).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {#ink:36, #color:colr})
              end repeat
              
              copyPixelsToEffectColor(gdLayer, brLr, rect(pos, pos) + rect(-6, 0, 6, lngth+2), "featherFernGradient", member("featherFernGradient").rect, 0.5)
              
              pstColor = 1
            end if
            
            fc = ((expectedLife-step)/expectedLife.float)
            fc = fc*fc
            
            ftness = sin(fc*PI)*(4+1*big)
            rct = rect(pos, pos) + rect(-1, -3, 1, 3)+rect(-ftness, -ftness, ftness, ftness)
            
            
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            
            brLrDir = brLrDir -4 + random(7)
          "Sprawlbush":
            rct = rect(pos, pos) + rect(-2, -5, 2, 5)
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            brLrDir = brLrDir -11 + random(21)
            
            pstColor = 1
            
          "Fungus Tree":
            
            thickness = ((startLifeTime-step)/startLifeTime.float)*baseThickness
            
            sts.branchPoints.add([#pos:pos, #dir:moveToPoint(point(0,0), aimPnt, 1.0), #thickness:thickness, #layer:brLr, #lifeLeft:startLifeTime-step, #tired:tiredNess])
            
            
            if step = expectedLife then
              rnd = random(5)
              rct = rect(pos, pos)+rect(-5, -19, 5, 1)
              if random(2)=1 then
                rct = vertFlipRect(rct)
              end if
              member("layer"&string(brLr.integer)).image.copyPixels(member("fungusTreeTops").image, rct, rect((rnd-1)*10, 1, rnd*10, 21), {#ink:36, #color:colr})
              copyPixelsToEffectColor(gdLayer, brLr, rect(pos, pos)+rect(-7, -11, 7, 3), "softBrush1", member("softBrush1").rect, 0.5)
            end if
            
            rct = rect(pos, pos) + rect(-1, -3, 1, 3)+rect(-thickness, -thickness, thickness, thickness)
            rct = rotateToQuad( rct ,lookAtPoint(pos, lstPos))
            
            brLrDir = brLrDir -11 + random(21)
            
            pstColor = 1
            
            
        end case
        
        
        
        
        
        member("layer"&string(brLr.integer)).image.copyPixels(member("blob").image, rct, member("blob").image.rect, {#ink:36, #color:colr})
        member("layer"&string(lstLayer.integer)).image.copyPixels(member("blob").image, rct, member("blob").image.rect, {#ink:36, #color:colr})
        
        if pstColor then
          blnd = (1.0-((expectedLife - step)/expectedLife.float))*25 + random((1.0-((expectedLife - step)/expectedLife.float))*75)
          if effc = "Fungus Tree" then
            blnd = (1.0-((expectedLife - step)/expectedLife.float))*100
          end if
          member("softbrush2").image.copypixels(member("pxl").image, member("softbrush2").image.rect, rect(0,0,1,1), {#color:color(255,255,255)})
          member("softbrush2").image.copypixels(member("softbrush1").image, member("softbrush2").image.rect, member("softbrush1").image.rect, {#blend:blnd})
          copyPixelsToEffectColor(gdLayer, brLr, rotateToQuad(rect(pos, pos) + rect(-17, -25, 17, 25),lookAtPoint(pos, lstPos)), "softBrush2", member("softBrush1").rect, 0.5)
        end if
        
      end repeat
    end repeat
    
    
  end if
end


on applyBlackGoo me, q, c, eftc
  sPnt = giveMiddleOfTile(point(q,c))+point(-10,-10)
  rct = member("blob").image.rect
  repeat with d = 1 to 10 then
    repeat with e = 1 to 10 then
      ps = point(sPnt.locH + d*2, sPnt.locV + e*2)
      if member("layer0").image.getPixel(ps) = color(255, 255, 255) then
        member("blackOutImg1").image.copyPixels(member("blob").image, rect(ps.locH-6-random(random(11)),ps.locV-6-random(random(11)),ps.locH+6+random(random(11)),ps.locV+6+random(random(11))), rct, {#color:0, #ink:36})
        member("blackOutImg2").image.copyPixels(member("blob").image, rect(ps.locH-7-random(random(14)),ps.locV-7-random(random(14)),ps.locH+7+random(random(14)),ps.locV+7+random(random(14))), rct, {#color:0, #ink:36})
      end if 
    end repeat
  end repeat
end

on applyRestoreEffect me, q, c, q2, c2, eftc
  
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      layers = [1,2,3]
    "1":
      layers = [1]
    "2":
      layers = [2]
    "3":
      layers = [3]
    "1:st and 2:nd":
      layers = [1,2]
    "2:nd and 3:rd":
      layers = [2,3]
    otherwise:
      layers = [1,2,3]
  end case
  
  repeat with layer in layers then
    if(afaMvLvlEdit(point(q2, c2), layer)=1)then
      mdPoint = giveMiddleOfTile(point(q,c))
      tlRct = rect(mdPoint+point(-10, -10), mdPoint+point(10,10))
      
      --        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint-point(10, 10), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      --    
      
      A = 2
      B = 1
      
      U = A
      if(me.isTileSolidAndAffected(point(q2-1, c2), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, -10), mdPoint+point(-10+U,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [1,4], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2+1, c2), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(10-U, -10), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [2,3], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2, c2-1), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, -10), mdPoint+point(10,-10+U)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [1,2], U)
      
      U = A
      if(me.isTileSolidAndAffected(point(q2, c2+1), layer) = 1)then
        U = B
      end if
      repeat with lr = ((layer-1)*10) + 4 to ((layer-1)*10) + 6 then
        member("layer" & lr).image.copyPixels(member("pxl").image, rect(mdPoint+point(-10, 10-U), mdPoint+point(10,10)), rect(0,0,1,1), {#color:color(255, 0, 0)})
      end repeat
      me.draw3DBeams(q2, c2, layer, tlRct, [3,4], U)
      
    end if
    reDrawPoles(point(q2,c2), layer, q, c, ((layer-1)*10) + 4)
  end repeat
end

on draw3DBeams me, q2, c2, layer, tlRct, crnrs, U
  if(layer > 1) then
    if(me.isTileSolidAndAffected(point(q2, c2), layer-1) = 1)then
      repeat with crnr in crnrs then
        rct = CornerRect(tlRct, crnr, U)
        repeat with lr = ((layer-1)*10) - 5 to ((layer-1)*10) + 5 then
          member("layer" & lr).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255, 0, 0)})
        end repeat
      end repeat
    end if
  end if
  if(layer < 3) then
    if(me.isTileSolidAndAffected(point(q2, c2), layer+1) = 1)then
      rct = CornerRect(tlRct, crnr, U)
      repeat with crnr in crnrs then
        repeat with lr = ((layer-1)*10) + 5 to ((layer-1)*10) + 15 then
          member("layer" & lr).image.copyPixels(member("pxl").image, rct, rect(0,0,1,1), {#color:color(255, 0, 0)})
        end repeat
      end repeat
    end if
  end if
end


on CornerRect(tlRct, crnr, U)
  -- tlRct = tlRct+rect(1,1,-1,-1)
  case crnr of
    1:
      return rect(tlRct.left, tlRct.top, tlRct.left+U, tlRct.top+U)
    2:
      return rect(tlRct.right-U, tlRct.top, tlRct.right, tlRct.top+U)
    3:
      return rect(tlRct.right-U, tlRct.bottom-U, tlRct.right, tlRct.bottom)
    4:
      return rect(tlRct.left, tlRct.bottom-U, tlRct.left+U, tlRct.bottom)
  end case
end

on isTileSolidAndAffected me, tl, layer
  if(afaMvLvlEdit(point(tl.locH, tl.locV), layer)<>1)or(tl.locH<1)or(tl.locV<1)or(tl.locH > gLOprops.size.locH)or(tl.locV > gLOprops.size.locV)then
    return 0
  else if (gEEprops.effects[r].mtrx[tl.locH][tl.locV] > 0)then
    return 1
  else
    return 0
  end if
end



on reDrawPoles(pos, layer, q, c, drawLayer)
  global gLEProps, gLOprops
  if pos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
    repeat with t in gLEProps.matrix[pos.locH][pos.locV][layer][2] then
      case t of
        1:
          rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(0, 8, 0, -8)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
          member("layer" & drawLayer).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 0, 0)})
        2:
          rct = rect((q-1)*20, (c-1)*20, q*20, c*20)+rect(8, 0, -8, 0)--rect(gRenderCameraTilePos,gRenderCameraTilePos)*20
          member("layer" & drawLayer).image.copyPixels(member("pxl").image, rct, member("pxl").image.rect, {color:color(255, 0, 0)})
      end case
    end repeat
  end if
end



on closestCamera me, pos
  global gCameraProps
  closest = 1000
  bestCam = 0
  repeat with camNum = 1 to gCameraProps.cameras.count then
    if(me.seenByCamera(camNum, pos) = 1)and(diag(pos, gCameraProps.cameras[camNum]+point(1400/2, 800/2)) < closest )then
      closest = diag(pos, gCameraProps.cameras[camNum]+point(1400/2, 800/2))
      bestCam = camNum
    end if
  end repeat
  
  return bestCam
end

on seenByCamera me, camNum, pos
  global gCameraProps
  
  cameraPos = gCameraProps.cameras[camNum]
  
  if pos.inside(rect(cameraPos.locH, cameraPos.locV, cameraPos.locH+1400, cameraPos.locV+800)+(rect(-15, -10, 15, 10)*20))then
    return 1
  else
    return 0
  end if
  
end

on ApplyMosaicPlant me, q, c
  global mosaicPlantStarts
  
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  -- Layers option is intentionally limited here
  lr = lrSup
  if (lrSup <> "1") and (lrSup <> "2") then
    if solidMtrx[q2][c2][2] then lr = "1"
    else lr = "2"
  end if
  
  if lr = "1" then
    dmin = 9
    dmax = 19
    lr = 1
    if solidMtrx[q2][c2][1] then
      return
    end if
  else
    dmin = 19
    dmax = 29
    lr = 2
    if solidMtrx[q2][c2][2] then
      return
    end if
  end if
  
  case colrIntensity of
    "H":
      maxblnd = 0.8
    "M":
      maxblnd = 0.5
    "L":
      maxblnd = 0.2
    "R":
      maxblnd = random(3) * 0.3 - 0.1
    "N":
      maxblnd = 0
    otherwise:
      maxblnd = 0.5
  end case
  
  -- Figure out if a plant spawns here
  ind = 0
  repeat with i = 1 to mosaicPlantStarts.count then
    if mosaicPlantStarts[i].locH.integer = q2 and mosaicPlantStarts[i].locV.integer = c2 then
      ind = i
      exit repeat
    end if
  end repeat
  
  -- Ok now draw it if it does
  if ind > 0 then
    startPt = mosaicPlantStarts[ind]
    
    if solidMtrx[startPt.locH.integer][startPt.locV.integer][lr+1] = 0 then exit
    
    -- What is the closest other?
    clsPt = point(-100000, -100000)
    repeat with i = 1 to mosaicPlantStarts.count then
      if (startPt <> mosaicPlantStarts[i]) then
        if diag(startPt, clsPt) > diag(startPt, mosaicPlantStarts[i]) then clsPt = mosaicPlantStarts[i]
      end if
    end repeat
    
    -- Figure out leaf locations
    leaves = []
    maxIter = random(1500) + 500
    ofst = random(360.0)
    repeat with i = 1 to maxIter then
      ds = sqrt(i) * 0.3
      ang = i * PI * (3.0 - sqrt(5.0)) -- golden angle
      pt = startPt + point(cos(ang + ofst) * ds, sin(ang + ofst) * ds)
      
      if (pt.locH < 1) or (pt.locH > gLOprops.size.locH) or (pt.locV < 1) or (pt.locV > gLOprops.size.locV) then next repeat
      
      str = gEEprops.effects[r].mtrx[pt.locH.integer][pt.locV.integer]
      if ((str < 1.0 and i > 10 + random(6)) or solidMtrx[pt.locH.integer][pt.locV.integer][lr]) then exit repeat
      if diag(startPt, pt) > diag(clsPt, pt) then
        if random(4) = 1 then exit repeat
        else next repeat
      end if
      
      leaves.append(pt)
    end repeat
    
    -- Filter out further out leaves
    oldL = leaves.count
    repeat with i = oldL down to 1 then
      if random(oldL) < i - 8 then
        leaves.deleteAt(i)
      end if
    end repeat
    
    -- FINALLY we get to draw the leaves :3
    lr = dmin
    grafSz = point(3, 6.5) -- mult by 2 to get actual size
    
    repeat with i = leaves.count down to 1 then -- reverse order for drawing reasons (outwards-in)
      leafPt = leaves[i]
      -- stem
      tl = (startPt + leafPt) / 2.0 - gRenderCameraTilePos
      tl = tl * 20.0 + point(10.0, 10.0)
      sz = point(1, (diag(startPt, leafPt) * 20.0).integer) / 2.0
      qd = rotateToQuadFix(rect(tl, tl) + rect(-sz, sz), lookAtPoint(leafPt, startPt))
      member("layer"&string(lr)).image.copypixels(member("pxl").image, qd, rect(0,0,1,1), {#color:color(255,0,0), #ink:36})
      -- leaf
      tl = (leafPt - gRenderCameraTilePos) * 20.0 + point(10.0, 10.0)
      qd = rotateToQuadFix(rect(tl, tl) + rect(-grafSz, grafSz), lookAtPoint(leafPt, startPt))
      member("layer"&string(lr-1)).image.copypixels(member("mosaicLeafGraf").image, qd, rect(0,0,6,11), {#color:colr, #ink:36})
      if colrIntensity <> "N" then
        copyPixelsToEffectColor(gdLayer, lr-1, qd, "mosaicLeafGraf", rect(6, 0, 12, 11), 0.5, maxblnd * (1 - (i.float / leaves.count.float) * 0.5))
      end if
    end repeat
    
    -- Guess what: flowers
    repeat with i = 1 to (leaves.count / 50.0).integer + 1 then
      if hasFlowers and random(3) = 1 then
        ds = random(diag(startPt, leaves[leaves.count])) * 0.45
        ang = random(360) / PI
        tl = startPt + point(cos(ang) * ds, sin(ang) * ds) - gRenderCameraTilePos
        tl = (tl * 20.0) + point(10.0, 10.0)
        
        ang = random(360/PI)
        amt = random(3) + 3
        repeat with j = 1 to amt then
          tl2 = tl + (point(cos(ang), sin(ang)) * 6.5)
          qd = rotateToQuadFix(rect(tl2, tl2) + rect(-grafSz, grafSz), lookAtPoint(tl2, tl))
          member("layer"&string(lr-2)).image.copypixels(member("mosaicLeafGraf").image, qd, rect(0,0,6,11), {#color:colrDetail, #ink:36})
          copyPixelsToEffectColor(gdDetailLayer, lr-2, qd, "mosaicLeafGraf", rect(6, 0, 12, 11), 0.5, (random(10) + 90.0) / 100.0)
          ang = ang + (2 * PI / amt)
        end repeat
      end if
    end repeat
  end if
end

on InitMosaicPlants me
  global mosaicPlantStarts
  mtrx = gEEprops.effects[r].mtrx
  
  savSeed = the randomSeed
  the randomSeed = effectSeed
  
  -- Figure out where the local maximum values are
  peakVals = []
  counters = []
  repeat with i = 1 to gLOprops.size.locH then
    repeat with j = 1 to gLOprops.size.locV then
      
      if mtrx[i][j] > 0 then
        test = 1
        if i > 1 then
          if mtrx[i - 1][j] > mtrx[i][j] then test = 0
        end if
        if i < gLOprops.size.locH then
          if mtrx[i + 1][j] > mtrx[i][j] then test = 0
        end if
        if j > 1 then
          if mtrx[i][j - 1] > mtrx[i][j] then test = 0
        end if
        if j < gLOprops.size.locV then
          if mtrx[i][j + 1] > mtrx[i][j] then test = 0
        end if
        
        if (test = 1) then
          peakVals.append(point(i.float, j.float))
          counters.append(1)
        end if
        
      end if
      
    end repeat
  end repeat
  
  -- Fiddle with the points (remove duplicates and randomize)
  repeat with k = 1 to 3 then
    
    -- Remove duplicates
    repeat with i = 1 to peakVals.count - 1 then
      actv = peakVals[i]
      repeat with j = i + 1 to peakVals.count then
        curr = peakVals[j]
        
        if diag(actv, curr) < 5 then
          actv = (actv * counters[i] + curr * counters[j]) / (counters[i] + counters[j])
          peakVals[i] = actv
          peakVals.deleteAt(j)
          counters[i] = counters[i] + 1
          counters.deleteAt(j)
          j = j - 1 -- the next one to look at will be in the same place
        end if
        
      end repeat
    end repeat
    
    -- Randomize slightly
    repeat with i = 1 to peakVals.count then
      peakVals[i] = peakVals[i] + point(random(3.0) - 2.0, random(3.0) - 2.0)
      peakVals[i] = point(max(1, min(gLOprops.size.locH, peakVals[i].locH)), max(1, min(gLOprops.size.locV, peakVals[i].locV)))
    end repeat
    
  end repeat
  
  -- One more passthrough to randomly remove a few low ones
  repeat with i = peakVals.count down to 1 then
    temp = mtrx[peakVals[i].locH.integer][peakVals[i].locV.integer]
    if power(random(100) / 100.0, 3) * 100.0 > temp then
      peakVals.deleteAt(i)
      counters.deleteAt(i) -- technically I don't need this but it's useful when debugging
    end if
  end repeat
  
  mosaicPlantStarts = peakVals
  
  -- Reset random
  the randomSeed = savSeed
end

on ApplyCobweb me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of
    "All":
      d = random(29)
    "1":
      d = random(9)
    "2":
      d = random(10) - 1 + 10
    "3":
      d = random(10) - 1 + 20
    "1:st and 2:nd":
      d = random(19)
    "2:nd and 3:rd":
      d = random(20) - 1 + 10
  end case
  lr = 1 + (d > 9) + (d > 19)
  
  if solidMtrx[q2][c2][lr] = 1 then exit
  
  startPt = giveMiddleOfTile(point(q, c))+point(-11+random(21), -11+random(21)) + gRenderCameraTilePos * 20.0
  
  -- Find branching points
  rot = random(360)
  angs = []
  repeat with i = 1 to 60 then
    pt = startPt
    repeat with j = 1 to 20 * 5 / 2 then -- 20 * max tile radius, moving two pixels at a time
      pt = pt + point(cos(rot * PI / 180) * 2, sin(rot * PI / 180) * 2)
      ipt = point(((pt.locH + 10) / 20).integer, ((pt.locV + 10) / 20).integer)
      if ipt.locH < 1 or ipt.locH > gLOprops.size.locH or ipt.locV < 1 or ipt.locV > gLOprops.size.locV then exit repeat
      if solidMtrx[ipt.locH][ipt.locV][lr] <> 0 then
        angs.append([rot, pt])
        exit repeat
      end if
    end repeat
    
    rot = (rot + 6) mod 360
  end repeat
  
  if angs.count < 3 then exit -- we preferably want at least 3 points
  
  -- Pick our angles
  picked = [angs[random(angs.count)]]
  maxpts = random(min(8, angs.count - 2)) + 2
  repeat with i = 2 to maxpts then
    -- Weed out close angles (they will look bad)
    repeat with j = angs.count down to 1 then
      dif = abs(picked[picked.count][1] - angs[j][1])
      if dif > 180 then dif = 360 - dif
      if dif < 15 then angs.deleteAt(j)
    end repeat
    
    -- Pick a random remaining angle
    if angs.count < 1 and i <= 3 then exit
    if angs.count < 1 then exit repeat
    picked.append(angs[random(angs.count)])
  end repeat
  
  picked.sort()
  
  -- Figure out colors
  case gdIndLayer of
    "A":
      webcl = color(150,0,150)
    "B":
      webcl = color(0,150,150)
    otherwise:
      webcl = color(255,0,0)
  end case
  case colrIntensity of
    "H":
      webin = 0.8
    "M":
      webin = 0.5
    "L":
      webin = 0.2
    "N":
      webin = 0
    otherwise:
      webin = 0.5
  end case
  
  -- Draw the base lines connecting to edges
  mn = 9999
  repeat with i = 1 to picked.count then
    len = diag(startPt, picked[i][2])
    mn = min(len, mn)
    qd = (startPt + picked[i][2]) / 2.0 - gRenderCameraTilePos * 20.0
    qd = rect(qd, qd) + rect(-0.5, -len/2.0, 0.5, len/2.0)
    qd = rotateToQuad(qd, lookAtpoint(startPt, picked[i][2]))
    member("layer"&string(d)).image.copypixels(member("pxl").image, qd, rect(0,0,1,1), {#color:webcl, #ink:36})
    
    if (gdIndLayer = "A" or gdIndLayer = "B") and (colrIntensity <> "N") then
      copyPixelsToEffectColor(gdIndLayer, d, qd, "pxl", rect(0, 0, 1, 1), 0.5, webin)
    end if
  end repeat
  
  -- Draw inner spiral lines
  pxlSpc = random(4) + 4.0 -- range: 5-8 (inclusive)
  repeat with i = 1 to mn / pxlSpc then
    repeat with j = 1 to picked.count then
      -- Random chance to skip
      if random(10) = 1 then next repeat
      
      -- Math to figure out what points we're at
      cur = picked[j]
      nxt = picked[1]
      if j <> picked.count then nxt = picked[j+1]
      
      dif = nxt[1] - cur[1]
      if nxt[1] < cur[1] then dif = 360 - cur[1] + nxt[1]
      if dif >= 150 then next repeat
      
      clrp = (i + (j.float / picked.count)) * pxlSpc / diag(startPt, cur[2])
      nlrp = (i + ((j.float + 1.0) / picked.count)) * pxlSpc / diag(startPt, nxt[2])
      
      cur = point(lerp(startPt.locH, cur[2].locH, clrp), lerp(startPt.locV, cur[2].locV, clrp)) - gRenderCameraTilePos * 20.0
      nxt = point(lerp(startPt.locH, nxt[2].locH, nlrp), lerp(startPt.locV, nxt[2].locV, nlrp)) - gRenderCameraTilePos * 20.0
      ang = lookAtpoint(cur, nxt)
      
      -- Draw the line
      len = diag(cur, nxt)
      qd = (cur + nxt) / 2.0
      qd = rect(qd, qd) + rect(-0.5, -len/2.0, 0.5, len/2.0)
      qd = rotateToQuad(qd, ang)
      member("layer"&string(d)).image.copypixels(member("pxl").image, qd, rect(0,0,1,1), {#color:webcl, #ink:36})
      
      if (gdIndLayer = "A" or gdIndLayer = "B") and (colrIntensity <> "N") then
        copyPixelsToEffectColor(gdIndLayer, d, qd, "pxl", rect(0, 0, 1, 1), 0.5, webin)
      end if
    end repeat
  end repeat
end

on ApplyFingers me, q, c
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  
  case lrSup of
    "All":
      lsL = [1,2,3]
    "1":
      lsL = [1]
    "2":
      lsL = [2]
    "3":
      lsL = [3]
    "1:st and 2:nd":
      lsL = [1,2]
    "2:nd and 3:rd":
      lsL = [2,3]
    otherwise:
      lsL = [1,2,3]
  end case
  
  case fingerSz of
    "S":
      amount = 12
    "M":
      amount = 10
    "L":
      amount = 7
    otherwise:
      amount = random(2) + 7
  end case
  
  repeat with layer in lsL then
    dDn = (solidMtrx[q2][c2][layer]<>1) and (solidAfaMv(point(q2,c2+1), layer)=1)
    dLf = (solidMtrx[q2][c2][layer]<>1) and (solidAfaMv(point(q2-1,c2), layer)=1)
    dRg = (solidMtrx[q2][c2][layer]<>1) and (solidAfaMv(point(q2+1,c2), layer)=1)
    
    if (dDn <> 1 and dLf <> 1 and dRg <> 1) then next repeat
    
    mdPnt = giveMiddleOfTile(point(q,c))
    repeat with cntr = 1 to gEEprops.effects[r].mtrx[q2][c2]*0.01*amount then
      -- Position and angle
      potential = []
      if dDn then
        ang = random(11) - 6
        if dLf and dRg then
          ang = random(81) - 41
        else if dLf then
          ang = random(40)
        else if dRg then
          ang = random(40) - 41
        end if
        potential.append([mdPnt + point(random(21) - 11, 10), ang])
      end if
      if dLf then
        potential.append([mdPnt + point(-10, random(21) - 11), random(30) + 20])
      end if
      if dRg then
        potential.append([mdPnt + point(10, random(21) - 11), random(30) - 51])
      end if
      picked = potential[random(potential.count)]
      pnt = picked[1]
      ang = picked[2]
      
      -- Sublayer, girth, and length
      lr = random(9) + (layer-1)*10
      case fingerSz of
        "S":
          sz = random(2) + 2
        "M":
          sz = random(3) + 3
        "L":
          sz = random(4) + 5
        "?":
          sz = random(7) + 2
      end case
      case fingerLen of
        "S":
          len = random(4) + 2
        "M":
          len = random(4) + 4
        "L":
          len = random(6) + 8
        "?":
          len = random(12) + 2
      end case
      if sz < 5 then
        len = ((len - 2) * 0.65).integer + 2
      end if
      len = ((len / 2) + (len/2 * gEEprops.effects[r].mtrx[q2][c2]*0.01)).integer
      
      -- Draw the finger
      wdth = sz
      hght = sz * 1.5
      tipGrad = (random(20) + 40) / 100.0
      lastRing = FALSE
      repeat with seg = 1 to len then
        qd = rotateToQuadFix(rect(point(-wdth/2, -hght/2), point(wdth/2, hght/2)) + rect(pnt, pnt), ang)
        
        thisCol = colr
        if (seg > 1) and (seg < len) and (not lastRing) and (random(3) = 1) then
          if (random(2) = 1) then
            thisCol = color(0,0,255)
          else
            thiscol = color(255,0,0)
          end if
          lastRing = TRUE
        else if lastRing then
          lastRing = FALSE
        end if
        
        member("layer"&string(lr)).image.copyPixels(member("blob").image, qd, member("blob").image.rect, {#ink:36, #color:thisCol})
        if colr <> color(0,255,0) then
          segGrad = tipGrad * (0.333 + seg * 0.667 / len)
          copyPixelsToEffectColor(gdLayer, lr, rotateToQuad(rect(pnt, pnt) + rect(-wdth,-hght/1.5,wdth,hght/1.5), ang), "softBrush1", member("softBrush1").rect, 0.5, segGrad)
        end if
        
        pnt = pnt + degToVec(ang) * 3
      end repeat
    end repeat
  end repeat
end


on applyGrapeRoots me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    lftBorder = mdPnt.locH-10
    rgthBorder =  mdPnt.locH+10
    grape=[]
    layerd = member("layer"&string(d)).image
    repeat while pnt.locV+gRenderCameraTilePos.locV*20 > -100
      lstPos = pnt
      pnt = pnt + degToVec(-45+random(90))*(2+random(6))
      pnt.locH = restrict(pnt.locH, lftBorder, rgthBorder)
      dir = moveToPoint(pnt, lstPos, 1.0)
      crossDir = giveDirFor90degrToLine(-dir, dir)
      qd = [pnt-crossDir, pnt+crossDir, lstPos+crossDir, lstPos-crossDir]
      layerd.copyPixels(DRPxl, qd, DRPxlRect, {#color:gLOProps.pals[gLOProps.pal].detCol})
      if solidAfaMv(giveGridPos(lstPos) + gRenderCameraTilePos, lr) = 1 then
        exit repeat
      end if
      if random (10 ) =1 then grape.append (pnt)
    end repeat
    grapegraf = member("grapegraf").image
    repeat with i=1 to grape.count then 
      pt=grape[i]
      rand = random (4) 
      if random (2) = 1 then 
        pt=pt-point(6-rand,0)
      else
        pt=pt-point(-6+rand,0)
      end if
      qd= rect(pt,pt) +rect(-6,-6,6,6)
      grapeSprite=rect(12*(rand-1),0,12*rand-1,11)
      layerd.copyPixels(grapegraf, qd, grapeSprite, {#color:colr,#ink:36})
      if i > grape.count-3 then
        copyPixelsToEffectColor (gdLayer, d, qd, "grapegrad", grapeSprite, 0.5, 0.1)
      else 
        copyPixelsToEffectColor (gdLayer, d, qd, "grapegrad", grapeSprite, 0.5, 1-i/grape.count.float)
      end if
    end  repeat
  end if
end

on applyHandGrowers me, q, c, eftc
  q2 = q + gRenderCameraTilePos.locH
  c2 = c + gRenderCameraTilePos.locV
  case lrSup of--["All", "1", "2", "3", "1:st and 2:nd", "2:nd and 3:rd"]
    "All":
      d = random(30)-1
    "1":
      d = random(10)-1
    "2":
      d = random(10)-1 + 10
    "3":
      d = random(10)-1 + 20
    "1:st and 2:nd":
      d = random(20)-1
    "2:nd and 3:rd":
      d = random(20)-1 + 10
    otherwise:
      d = random(30)-1
  end case
  lr = 1+(d>9)+(d>19)
  if (gLEprops.matrix[q2][c2][lr][1]=0)then
    layerd = member("layer"&string(d)).image
    mdPnt = giveMiddleOfTile(point(q,c))
    headPos = mdPnt+point(-11+random(21), -11+random(21))
    pnt = point(headPos.locH, headPos.locV)
    layerd.copyPixels(member("flowerhead").image, rect(pnt.locH-3, pnt.locV-3, pnt.locH+3, mdPnt.locV+3), member("flowerhead").image.rect, {#color:colr, #ink:36})
    t=0.0
    h = pnt.locV
    mog=0
    mog2=0
    hwide=10+(mog2/25)
    endH=0
    repeat while h<30000
      h=h+1
      mog2= mog2+1
      endH=h
      tlPos = giveGridPos(point(pnt.locH, h)) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        endH=h-300
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        endH=h-300
        stumpWidth=mog2/25
        exit repeat
      end if
    end repeat
    h = pnt.locV
    stumpPnt=0
    endOfNeck=0
    repeat while h < 30000
      h = h + 1
      mog= mog+1
      pnt.locH = pnt.locH -2 + random(3)
      --generate neck
      if mog<100 and (mog mod 2) =1 then
        layerd.copyPixels(DRPxl, rect(pnt.locH-hwide-(mog2/25), h-(mog2/25), pnt.locH+hwide+(mog2/25), h), DRPxlRect, {#color:colr})
        if random (3) =1 then
          hwide=hwide-1
        end if
        endOfNeck=h
      end if
      layerd.copyPixels(DRPxl, rect(pnt.locH-(mog2/25), h, pnt.locH+(mog2/25), h+3), DRPxlRect, {#color:colr})
      tlPos = giveGridPos(point(pnt.locH, h)) + gRenderCameraTilePos
      if tlPos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) = 0 then
        exit repeat
      else if solidAfaMv(tlPos, lr) = 1 then
        exit repeat
      end if
    end repeat
    copyPixelsToEffectColor(gdLayer, d, rect(pnt.locH-37-(mog2/25),headPos.locV-(mog2/25), headPos.locH+37+(mog2/25), h+60), "ogMask", member("ogMask").image.rect, 0.8)
    --generate lump
    i=1
    if i = random(2) then
      lumpPoint=random(h-pnt.locV)+pnt.locV
      rand= random(6)
      lumpSprite=rect(30*(rand-1),0,30*rand-1,29)
      layerd.copyPixels(member("oglumpgraf").image, rect(pnt.locH-(mog2/10), lumpPoint-(mog2/10), pnt.locH+(mog2/10), lumpPoint+(mog2/10)), lumpSprite, {#color:colr,#ink:36})
      copyPixelsToEffectColor(gdLayer, d, rect(pnt.locH-(mog2/10), lumpPoint-(mog2/10), pnt.locH+(mog2/10), lumpPoint+(mog2/10)), "oglumpgrad", lumpSprite, 0.8)
    end if
    --generate the crown
    i=1
    v=300
    --mog mog :))
    mog=mog/2
    startPnt = point(headPos.locH, headPos.locV)
    repeat with i = 1 to 5
      endPnt = point(mog, 0)
      ang=((i+1)*pi)/8.0
      ang=ang+pi
      tempEndX = endPnt.locH
      tempEndY = endPnt.locV
      endPnt.locH = (tempEndX)*cos(ang) - (tempEndY)*sin(ang)
      endPnt.locV = (tempEndY)*cos(ang) + (tempEndX)*sin(ang)
      endPnt=endPnt + startPnt
      midPnt=lerpVector(startPnt, endPnt, 0.5)
      widthPnt=gEEprops.effects[r].mtrx[q2][c2]/2.0 
      ctrl= point(midPnt.locH+(widthPnt*cos(ang)),midPnt.locV)
      prevPnt=point(0,0)
      endPnt.locV=endPnt.locV
      endPnt.locH=endPnt.locH+(((-mog/2.0)+random(mog))/2.0)
      t=0.0
      offsetArm=0
      repeat while t<v
        timePercent=t/v
        t=t+1
        currentPnt=me.Bezpoint(startPnt, endPnt, ctrl, timePercent)
        randCnt =4- random(8)
        currentPnt=currentPnt+point(-3+randCnt, -3+randCnt)
        if t <> 0  then
          ang2= lookAtpoint(prevPnt, currentPnt)
          pxlSize=((mog/25)+(timePercent))+2
          alongBez = rect(currentPnt.locH - pxlSize/2.0, currentPnt.locV - pxlSize/2.0, currentPnt.locH + pxlSize/2.0, prevPnt.locV + pxlSize/2.0)
          alongBez = rotateToQuad(alongBez, ang2)
          alongBez = (prevPnt+currentPnt)/2.0
          alongBez = rect(alongBez,alongBez) + rect(-pxlSize/2.0, -pxlSize/2.0, pxlSize/2.0, pxlSize/2.0)
          offsetArm=-1 + random(2)
          alongBez[1]=alongBez[1]+offsetArm
          if t<0 or t>1 then
            layerd.copyPixels(DRPxl, alongBez, DRPxlRect, {#color:colr})
            copyPixelsToEffectColor(gdLayer, d, alongbez, "pxl", DRPxlRect, 0.8)
          end if
        end if
        prevPnt=currentPnt
      end repeat
    end repeat
  end if
end

--determines current point along bezier at time T
--for hand grower, rendereffect grows longer by the day :JEEPERS:, also thank you cactus for helping me with this
on BezPoint me, startPT, endPT, ctrlPT, T
  xVal = (1-T) * ((1-T) * startPT.locH + t * ctrlPT.locH) + T * ((1-T) * ctrlPT.locH + T * endPT.locH)
  yVal = (1-T) * ((1-T) * startPT.locV + t * ctrlPT.locV) + T * ((1-T) * ctrlPT.locV + T * endPT.locV)
  output = point(xVal, yVal)
  return output
end





