on giveGridPos(pos: point)
  type return: point
  return point(((pos.locH.float / 20.0) + 0.4999).integer, ((pos.locV.float / 20.0) + 0.4999).integer)
end

on giveMiddleOfTile(pos: point)
  type return: point
  return point(pos.locH * 20 - 10, pos.locV * 20 - 10)
end

on restrict(val, low, high)
  if (val < low) then
    return low
  else if (val > high) then
    return high
  else
    return val
  end if
end

on restrictWithFlip(val: number, low: number, high: number)
  type return: number
  if (val < low) then
    return val + (high - low) + 1
  else if (val > high) then
    return val - (high - low) - 1
  else
    return val
  end if
end

on afaMvLvlEdit(pos: point, layer: number)
  type return: number
  global gLEProps, gLOprops
  if pos.inside(rect(1, 1, gLOprops.size.locH + 1, gLOprops.size.locV + 1)) then
    return gLEProps.matrix[pos.locH][pos.locV][layer][1]
  else
    return 1
  end if
end

on solidAfaMv(pos: point, layer: number)
  type return: number
  global solidMtrx, gLOprops
  if pos.inside(rect(1, 1, gLOprops.size.locH + 1, gLOprops.size.locV + 1)) then
    return solidMtrx[pos.locH][pos.locV][layer]
  else
    return 1
  end if
end

on depthPnt(pnt, dpt)
  return (pnt - point(700, 800 / 3)) / ((10 + dpt * 0.025) * 0.1) + point(700, 800 / 3)
end

on seedForTile(tile: point, effectSeed: number)
  type return: number
  global gLEprops
  return effectSeed + tile.locH + tile.locV * gLEprops.matrix.count
end

on rotateToQuadFix(rct, deg)
  mdpt = point((rct.left + rct.right) * 0.5, (rct.top + rct.bottom) * 0.5)
  halfWidth = (rct.right - rct.left) / 2.0
  halfHeight = (rct.bottom - rct.top) / 2.0
  if deg.float mod 360.0 = 0.0 then return [point(rct.left, rct.top), point(rct.right, rct.top), point(rct.right, rct.bottom), point(rct.left, rct.bottom)]
  else if deg.float mod 360.0 = 180.0 then return [point(rct.right, rct.bottom), point(rct.left, rct.bottom), point(rct.left, rct.top), point(rct.right, rct.top)]
  else if deg.float mod 360.0 = 90.0  then return [mdpt + point(-halfHeight, halfWidth), mdpt + point(-halfHeight, -halfWidth), mdpt + point(halfHeight, -halfWidth), mdpt + point(halfHeight, halfWidth)]
  else if deg.float mod 360.0 = 270.0 then return [mdpt + point(halfHeight, -halfWidth), mdpt + point(halfHeight, halfWidth),   mdpt + point(-halfHeight, halfWidth), mdpt + point(-halfHeight, -halfWidth)]
  else return rotateToQuad(rct, deg)
end

on copyPixelsToEffectColor(gdLayer: string, lr: number, rct, getMember, gtRect: rect, zbleed: number, blnd)
  global DRPxl
  if (blnd = VOID) then
    blnd = 1.0
  end if
  if (gdLayer <> "C") and (blnd > 0) then
    lr = lr.integer
    if (lr < 0) then lr = 0
    else if (lr > 29) then lr = 29
    gtImg: image = member(getMember).image
    if (blnd <> 0) and (blnd <> VOID) then
      dmpImg: image = gtImg.duplicate()
      dmpImg.copyPixels(DRPxl, dmpImg.rect, rect(0, 0, 1, 1), {#blend:100.0 * (1.0 - blnd), #color:color(255, 255, 255)})
      gtImg = dmpImg
    end if   
    member("gradient" & gdLayer & string(lr)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
    if (zbleed > 0) then
      if (zbleed < 1) then
        dmpImg = gtImg.duplicate()
        dmpImg.copyPixels(DRPxl, dmpImg.rect, rect(0, 0, 1, 1), {#blend:100.0 * (1.0 - zbleed), #color:color(255, 255, 255)})
        gtImg = dmpImg
      end if
      nxt: number = lr + 1
      if (nxt > 29) then nxt = 29
      member("gradient" & gdLayer & string(nxt)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
      nxt = lr - 1
      if (nxt < 0) then nxt = 0
      member("gradient" & gdLayer & string(nxt)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
    end if
  end if
end

on copyPixelsToRootEffectColor(gdLayer, lr, rct, getMember, gtRect, zbleed, blnd)
  global DRPxl
  --use: copyPixelsToRootEffectColor(effect color letter from "Color" option (A, B, C=none), depth layer (from 0 to 29), final rectangle, gradient image name, source rectangle, blend modifier(from 0 to 1))
  if (blnd = VOID) then
    blnd = 1.0
  end if
  if (gdLayer <> "C") and (blnd > 0) then
    lr = lr.integer
    if (lr < 0) then lr = 0
    else if (lr > 29) then lr = 29
    gtImg = member(getMember).image
    if (blnd <> 0) and (blnd <> VOID) then
      dmpImg = gtImg.duplicate()
      dmpImg.copyPixels(DRPxl, dmpImg.rect, rect(0, 0, 1, 1), {#blend:100.0 * (1.0 - blnd), #color:color(255, 255, 255)})
      gtImg = dmpImg
    end if
    member("gradient" & gdLayer & string(lr)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
    if (zbleed > 0) then
      if (zbleed < 1) then
        dmpImg = gtImg.duplicate()
        dmpImg.copyPixels(DRPxl, dmpImg.rect, rect(0, 0, 1, 1), {#blend:100.0 * (1.0 - zbleed), #color:color(255, 255, 255)})
        gtImg = dmpImg
      end if
      repeat with nxtAdd = 1 to 3
        nxt = lr + nxtAdd
        if (nxt > 29) then nxt = 29
        member("gradient" & gdLayer & string(nxt)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
        nxt = lr - nxtAdd
        if (nxt < 0) then nxt = 0
        member("gradient" & gdLayer & string(nxt)).image.copyPixels(gtImg, rct, gtRect, {#ink:39})
      end repeat
    end if
  end if
end

on makeSilhoutteFromImg(img: image, inverted: number)
  type return: image
  global DRPxl
  inv = image(img.width, img.height, 1)
  inv.copyPixels(DRPxl, img.rect, rect(0, 0, 1, 1), {#color:255})
  inv.copyPixels(img, img.rect, img.rect, {#ink:36, #color:color(255, 255, 255)})
  if (inverted = 0) then
    inv = makeSilhoutteFromImg(inv, 1)
  end if
  return inv
end

on rotateToQuad(rct: rect, deg: number)
  type return: list
  dir: point = degToVec(deg.float)
  midPnt: point = point((rct.left + rct.right) * 0.5, (rct.top + rct.bottom) * 0.5)
  tlr: point = dir * rct.height * 0.5
  topPnt: point = midPnt + tlr
  bottomPnt: point = midPnt - tlr
  tlr: point = giveDirFor90degrToLine(-dir, dir) * rct.width * 0.5
  return [topPnt + tlr, topPnt - tlr, bottomPnt - tlr, bottomPnt + tlr]
end

on giveDirFor90degrToLineLB(pnt1, pnt2)
  X1: number = pnt1.locH
  Y1: number = pnt1.locV
  X2: number = pnt2.locH
  Y2: number = pnt2.locV
  Ydiff: number = Y1 - Y2
  Xdiff: number = X1 - X2
  if (Ydiff = 0) then
    return point(0, 1)
  else if (Xdiff = 0) then
    return point(1, 0)
  else
    newPnt = point(1, -1.0 / (Ydiff / Xdiff))
    return newPnt / sqrt(newPnt.locH * newPnt.locH + newPnt.locV * newPnt.locV)
  end if
end 

on dirVecLB(pointA: point, pointB: point)
  type return: point
  pointB = pointB - pointA
  if (pointB = point(0, 0)) then
    return point(0, 1)
  else
    return pointB / sqrt(pointB.locH * pointB.locH + pointB.locV * pointB.locV)
  end if
end

on rotateToQuadLB(rct: rect, dir: point)
  type return: list
  midPnt: point = point((rct.left + rct.right) * 0.5, (rct.top + rct.bottom) * 0.5)
  tlr: point = dir * rct.height * 0.5
  topPnt: point = midPnt + tlr
  bottomPnt: point = midPnt - tlr
  tlr: point = giveDirFor90degrToLineLB(-dir, dir) * rct.width * 0.5
  return [topPnt + tlr, topPnt - tlr, bottomPnt - tlr, bottomPnt + tlr]
end

on flipQuadH(qd: list)
  type return: list
  return [qd[2], qd[1], qd[4], qd[3]]
end

on pasteShortCutHole(mem: string, pnt: point, dp: number, cl)
  global gLEProps, gLOprops, gCameraProps, gCurrentRenderCamera, gRenderCameraTilePos, gRenderCameraPixelPos
  rct = giveMiddleOfTile(pnt) - (gRenderCameraTilePos * 20) - gRenderCameraPixelPos
  rct = depthPnt(rct, dp)
  rct = rect(rct, rct) + rect(-10, -10, 10, 10)
  idString: string = ""
  repeat with dr in [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)]
    type dr: point
    if (pnt + dr).inside(rect(1, 1, gLOprops.size.loch, gLOprops.size.locv)) then
      matProp = gLEProps.matrix[pnt.locH + dr.locH][pnt.locV + dr.locV][1][2]
      if (matProp.getPos(5) > 0) or (matProp.getPos(4) > 0) then
        idString = idString & "1"
      else
        idString = idString & "0"
      end if
    else
      idString = idString & "0"
    end if
  end repeat
  ps: number = ["0101", "1010", "1111", "1100", "0110", "0011", "1001", "1110", "0111", "1011", "1101", "0000"].getPos(idString)
  type clL: list
  if (cl = "BORDER") then
    clL = [[color(255, 0, 0), point(-1, 0)], [color(255, 0, 0), point(0, -1)], [color(255, 0, 0), point(-1, -1)], [color(255, 0, 0), point(-2, 0)], [color(255, 0, 0), point(0, -2)], [color(255, 0, 0), point(-2, -2)], [color(0, 0, 255), point(1, 0)], [color(0, 0, 255), point(0, 1)], [color(0, 0, 255), point(1, 1)], [color(0, 0, 255), point(2, 0)], [color(0, 0, 255), point(0, 2)], [color(0, 0, 255), point(2, 2)]]
  else
    clL = [[cl, point(0, 0)]]
  end if
  shortCutsGraf = member("shortCutsGraf").image
  memImage: image = member(mem).image
  getShCtRect: rect = rect(20 * (ps - 1), 1, 20 * ps, 21)
  repeat with c in clL
    type c: list
    memImage.copyPixels(shortCutsGraf, rct + rect(c[2], c[2]), getShCtRect, {#ink:36, #color:c[1]})
  end repeat
end

on resizeLevel(sze: point, addTilesLeft: number, addTilesTop: number)--nt
  global gLEprops, gLOProps, gTEprops, gEEprops
  newMatrix: list = []
  newTEmatrix: list = []
  
  repeat with q = 1 to sze.locH + addTilesLeft then
    ql: list = []
    repeat with c = 1 to sze.locV + addTilesTop then
      if (q-addTilesLeft<=gLEprops.matrix.count)and(c-addTilesTop<=gLEprops.matrix[1].count)and(q-addTilesLeft>0)and(c-addTilesTop>0)then
        adder = gLEprops.matrix[q-addTilesLeft][c-addTilesTop]
      else
        adder: list = [[1, []], [1, []], [1, []]]
      end if
      ql.add(adder)
    end repeat
    newMatrix.add(ql)
  end repeat
  
  repeat with q = 1 to sze.locH + addTilesLeft then
    ql = []
    repeat with c = 1 to sze.locV + addTilesTop then
      if (q+addTilesLeft<=gTEprops.tlMatrix.count)and(c+addTilesTop<=gTEprops.tlMatrix[1].count)and(q-addTilesLeft>0)and(c-addTilesTop>0)then
        adder = gTEprops.tlMatrix[q-addTilesLeft][c-addTilesTop]
      else
        adder: list = [[#tp:"default", #data:0], [#tp:"default", #data:0], [#tp:"default", #data:0]]
      end if
      ql.add(adder)
    end repeat
    newTEmatrix.add(ql)
  end repeat
  
  
  repeat with effect in gEEprops.effects then
    newEffMtrx = []
    
    repeat with q = 1 to sze.locH + addTilesLeft then
      ql = []
      repeat with c = 1 to sze.locV + addTilesTop then
        if (q+addTilesLeft<=effect.mtrx.count)and(c+addTilesTop<=effect.mtrx[1].count)and(q-addTilesLeft>0)and(c-addTilesTop>0)then
          ql.add(effect.mtrx[q-addTilesLeft][c-addTilesTop])
        else
          ql.add(0)
        end if
      end repeat
      newEffMtrx.add(ql)
    end repeat
    
    effect.mtrx = newEffMtrx
  end repeat
  
  
  gLEprops.matrix = newMatrix
  gTEprops.tlMatrix = newTEmatrix
  gLOprops.size = sze + point(addTilesLeft, addTilesTop) --- (rmvTilesLeft, rmvTilesTop)
  
  global gLASTDRAWWASFULLANDMINI
  gLASTDRAWWASFULLANDMINI = 0
  
  oldimg: image = member("lightImage").image.duplicate()
  member("lightImage").image = image((gLOprops.size.locH*20)+300,(gLOprops.size.locV*20)+300, 1)
  member("lightImage").image.copypixels(oldimg, oldimg.rect, oldimg.rect)
end

on ResetgEnvEditorProps()
  global gEnvEditorProps
  gEnvEditorProps = [#waterLevel:-1, #waterInFront:1, #waveLength:60, #waveAmplitude:5, #waveSpeed:10]
end

on resetPropEditorProps()
  global gPEprops
  gPEprops = [#props:[], #lastKeys:[], #keys:[], #workLayer:1, #lstMsPs:point(0, 0), pmPos:point(1, 1), #pmSavPosL:[], #propRotation:0, #propStretchX:1, #propStretchY:1, #propFlipX:1, #propFlipY:1, #depth:0, #color:0]
end

on vecToRadLB(vec)
  if (vec.locH = 0) then
    if (vec.locV < 0) then
      return -PI / 2.0
    else
      return PI / 2.0
    end if
  else if (vec.locH < 0) then
    return atan(vec.locV / vec.locH) - PI
  else
    return atan(vec.locV / vec.locH)
  end if
end