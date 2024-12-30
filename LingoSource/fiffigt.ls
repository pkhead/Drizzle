--detta skript räknar ut distansen mellan två punkter
on diag(point1: point, point2: point)
  type return: number
  rectHeight: number = abs(point1.locV - point2.locV)
  rectWidth: number = abs(point1.locH - point2.locH)
  return sqrt((rectHeight * rectHeight) + (rectWidth * rectWidth))
end

on diagWI(point1: point, point2: point, dig: number)
  type return: number
  RectHeight: number = ABS(point1.locV - point2.locV)
  RectWidth: number = ABS(point1.locH - point2.locH)
  return ((RectHeight * RectHeight) + (RectWidth * RectWidth) < dig*dig )
end 

on diagNoSqrt(point1: point, point2: point)
  type return: number
  RectHeight: number = ABS(point1.locV - point2.locV)
  RectWidth: number = ABS(point1.locH - point2.locH)
  
  diagonal: number = (RectHeight * RectHeight) + (RectWidth * RectWidth)
  
  return diagonal
end

on vertFlipRect(rct: rect)
  type return: list
  return [point(rct.right, rct.top),point(rct.left, rct.top),point(rct.left, rct.bottom),point(rct.right, rct.bottom)]
end

--tar fram en förflyttning mellan två punkter, bergänsad till theMovement
on moveToPoint(pointA: point, pointB: point, theMovement: number)
  type return: point
  
  pointB = pointB-pointA
  diagonal = diag(point(0,0), pointB)
  if diagonal>0 then
    dirVec = pointB/diagonal
  else
    dirVec = point(0, 1)
  end if
  return dirVec*theMovement
end

on returnRelativePoint p1, p2
  -- p1 är den relativa nollpunktens absoluta position
  -- p2 är den absoluta positionen hos punkten vars relativa position ska beräknas
  newX = -1 * (p1.locH - p2.locH)
  newY = p1.locV - p2.locV
  return point(newX, newY)
end

on returnAbsolutePoint p1, p2
  -- p1 är den relativa nollpunktens absoluta position
  -- p2 är den relativa positionen hos den punkt vars absoluta position ska beräknas
  realX = p1.locH + p2.locH
  realY = p1.locV - p2.locV
  return point(realX, realY)
end

on lerp(A: number, B: number, val: number)
  type return: number
  val = restrict(val, 0, 1)
  if(B < A)then
    sv = A
    A = B
    B = sv
    val = 1.0-val
  end if
  return restrict(A + (B-A)*val, A, B)
  
end


--lämnar tillbaks punkten där två linjer korsar varandra
--(lämna in linjerna som rektanglar)
on giveCrossPoint(line1PntA, line1PntB, line2PntA, line2PntB)
  
  X1 =line1PntA.locH.float
  Y1 =line1PntA.locV.float
  X2 =line1PntB.locH.float
  Y2 =line1PntB.locV.float
  
  X3 =line2PntA.locH.float
  Y3 =line2PntA.locV.float
  X4 =line2PntB.locH.float
  Y4 =line2PntB.locV.float
  
  if (X2<>X1) and (X4<>X3) then
    if (((Y4-Y3)/(X4-X3))-((Y2-Y1)/(X2-X1))) <> 0 then
      crossPointX = (Y1-((Y2-Y1)/(X2-X1))*X1+((Y4-Y3)/(X4-X3))*X3-Y3)/(((Y4-Y3)/(X4-X3))-((Y2-Y1)/(X2-X1)))
      crossPointY = ((Y2-Y1)/(X2-X1))*crossPointX+(Y1-((Y2-Y1)/(X2-X1))*X1)
    end if
  else if X4<>X3 then
    crossPointX = X1
    crossPointY = ((Y4-Y3)/(X4-X3))*crossPointX+Y3-((Y4-Y3)/(X4-X3))*X3
  else
    crossPointX = X3
    crossPointY = Y1 
  end if 
  
  return point(crossPointX, crossPointY)
end




--lämnar tillbaks yta och punkt för var en linje träffar en rect
--(lämna in linjen som en rektangel, punkten innuti recten som andrapunkt)
on giveHitSurf(obstRect, movLine)
  lastPoint = point(movLine.left, movLine.top)
  insidePoint = point(movLine.right, movLine.bottom)
  
  leftHitPoint = giveCrossPoint(rect(obstRect.left, 0, obstRect.left, 1), movLine)
  rightHitPoint = giveCrossPoint(rect(obstRect.right, 0, obstRect.right, 1), movLine)
  topHitPoint = giveCrossPoint(rect(0, obstRect.top, 1, obstRect.top), movLine)
  bottomHitPoint = giveCrossPoint(rect(0, obstRect.bottom, 1, obstRect.bottom), movLine)
  
  insidePointsL = []
  
  obstRect = obstRect + rect(-1, -1, 1, 1)
  
  if leftHitPoint.inside(obstRect) then
    pointData = [#dist:the_Diagonal(leftHitPoint, point(movLine.left, movLine.top)), #pos:leftHitPoint, #LTRB:"left"]
    insidePointsL.add(pointData)
  end if
  
  if rightHitPoint.inside(obstRect) then
    pointData = [#dist:the_Diagonal(rightHitPoint, point(movLine.left, movLine.top)), #pos:rightHitPoint, #LTRB:"right"]
    insidePointsL.add(pointData)
  end if
  
  if topHitPoint.inside(obstRect) then
    pointData = [#dist:the_Diagonal(topHitPoint, point(movLine.left, movLine.top)), #pos:topHitPoint, #LTRB:"top"]
    insidePointsL.add(pointData)
  end if
  
  if bottomHitPoint.inside(obstRect) then
    pointData = [#dist:the_Diagonal(bottomHitPoint, point(movLine.left, movLine.top)), #pos:bottomHitPoint, #LTRB:"bottom"]
    insidePointsL.add(pointData)
  end if
  
  insidePointsL.sort()
  
  hitsurf = insidePointsL.getAt(1).LTRB
  hitPoint = insidePointsL.getAt(1).pos
  
  
  return [hitSurf, hitPoint]
end



on lookAtPoint(pos: point, lookAtpoint: point)
  type return: number
  
  
  y_diff: number = lookAtpoint.locV.float - pos.locV.float
  x_diff: number = pos.locH.float - lookAtpoint.locH.float
  
  type rotationAngleRad: number

  if x_diff <> 0 then
    rotationAngleRad = atan(y_diff / x_diff)
  else
    rotationAngleRad = 1.5 * PI
  end if
  
  type fuckedupanglefix_parameter: number

  if lookAtpoint.locH > pos.locH then
    fuckedupanglefix_parameter = 0  -- 2 * PI
  else 
    fuckedupanglefix_parameter = PI
  end if
  rotationAngleRad = fuckedupanglefix_parameter - rotationAngleRad
  
  return ((rotationAngleRad * 180 / PI) + 90)
end

on degToVec(deg: number)
  type return: point
  rad = -2 * PI * ((deg + 90) / 360.0).float
  return point(-cos(rad), sin(rad))
end

on degToVecFac2(deg: number, facH: number, facV: number)
  deg = deg + 90
  deg = -deg 
  rad: number = ((deg/360.0).float)*PI*2
  
  return point(-cos(rad)*facH, sin(rad)*facV)
end


on closestPointOnLine(pnt: point, A: point, B: point)
  return giveCrossPoint(pnt, pnt + giveDirFor90degrToLine(A, B), A, B)
end






on giveDirFor90degrToLine(pnt1: point, pnt2: point)
  type return: point
  
  X1: number = pnt1.locH
  Y1: number = pnt1.locV
  
  X2: number = pnt2.locH
  Y2: number = pnt2.locV
  
  
  Ydiff: number = Y1-Y2
  Xdiff: number = X1-X2
  
  type dir: number

  if Xdiff<>0 then
    dir = Ydiff/Xdiff
  else
    dir = 1
  end if
  
  type newDir: number
  
  if dir<>0 then
    newDir = -1.0/dir
  else
    newDir = 1
  end if
  
  newPnt: point = point(1, newDir)
  
  
  fac: number = 1
  
  if X2 < X1 then 
    if Y2 < Y1 then
      fac = 1
    else
      fac = -1
    end if
  else
    if Y2 < Y1 then
      fac = 1
    else
      fac = -1
    end if
  end if
  
  
  
  newPnt = newPnt * fac
  
  newPnt = newPnt/diag(point(0,0), newPnt)--(ABS(newPnt.locH)-ABS(newPnt.locV))
  
  return newPnt
  
  
end 


on lnPntDist(pnt, lineA, lineB)
  --  dir = giveDirFor90degrToLine(lineA, lineB)
  --  newLinePnt = pnt + dir
  --  crossPnt = giveCrossPoint(pnt, newLinePnt, lineA, lineB)
  --  return diag(pnt, crossPnt)
  
  return diag(pnt, giveCrossPoint(pnt, pnt + giveDirFor90degrToLine(lineA, lineB), lineA, lineB))
end



on giveCircleCollTime(pos1, r1, vel1, pos2, r2, vel2)
  -- h = _system.milliseconds
  x1 = pos1.locH
  y1 = pos1.locV
  
  x2 = pos2.locH
  y2 = pos2.locV
  
  vx1 = vel1.locH
  vy1 = vel1.locV
  
  vx2 = vel2.locH
  vy2 = vel2.locV
  
  
  A = -x1*vx1-y1*vy1+vx1*x2+vy1*y2+x1*vx2-x2*vx2+y1*vy2-y2*vy2
  B = -x1*vx1-y1*vy1+vx1*x2+vy1*y2+x1*vx2-x2*vx2+y1*vy2-y2*vy2
  C = power(vx1, 2)+power(vy1, 2)-2*vx1*vx2+power(vx2, 2)-2*vy1*vy2+power(vy2, 2)
  D = power(x1, 2)+power(y1, 2)-power(r1, 2)-2*x1*x2+power(x2, 2)-2*y1*y2+power(y2, 2)-2*r1*r2-power(r2, 2)
  E = power(vx1, 2)+power(vy1, 2)-2*vx1*vx2+power(vx2, 2)-2*vy1*vy2+power(vy2, 2)
  
  T = (2.0*A-sqrt(power(-2.0*B, 2)-4.0*C*D))/(2.0*E)
  
  return T
end


on lnPntDistNonAbs(pnt, lnPnt1, lnPnt2)
  if (lnPnt1.locH-lnPnt2.locH) <> 0 then
    k = (lnPnt1.locV-lnPnt2.locV)/(lnPnt1.locH-lnPnt2.locH)
  else
    k = 0
  end if
  m = lnPnt1.locV-(k*lnPnt1.locH)
  
  Y1 = pnt.locV
  X1 = pnt.locH --+ 0.0001
  
  
  if X1 <> 0 then
    k2 = (Y1-m)/X1
    D = sqrt(power(ABS(Y1-m), 2)+ power(X1, 2))
    E = sin(atan(   (k2-k)/(1+k2*k)  ))
    
    F = 1
    if k<0 then
      F = -1
    end if
    
    
    return (D*E*F)
  else 
    --  put "lnPntDistNonAbs ALERT"
    return point(0, 0)
  end if
end 






on closestPntInRect(rct, pnt)
  resPnt = point(0,0)
  if pnt.locH < rct.left then
    
    
    if pnt.locV < rct.top then
      resPnt = point(rct.left, rct.top)
    else if pnt.locV > rct.bottom then
      resPnt = point(rct.left, rct.bottom)
    else
      resPnt = point(rct.left, pnt.locV)
    end if
    
    
    
  else if pnt.locH > rct.right then
    
    
    if pnt.locV < rct.top then
      resPnt = point(rct.right, rct.top)
    else if pnt.locV > rct.bottom then
      resPnt = point(rct.right, rct.bottom)
    else
      resPnt = point(rct.right, pnt.locV)
    end if
    
    
    
  else
    
    if pnt.locV < rct.top then
      resPnt = point(pnt.locH, rct.top)
    else if pnt.locV > rct.bottom then
      resPnt = point(pnt.locH, rct.bottom)
    else
      resPnt = pnt
    end if
    
  end if
  
  return resPnt
end


on angleBetweenLines(pnt1, pnt2, pnt3, pnt4)
  --  k = (pnt2.locV-pnt1.locV)/(pnt2.locH-pnt1.locH)
  --  k2 = (pnt4.locV-pnt3.locV)/(pnt4.locH-pnt3.locH)
  --  k = k.float
  --  k2 = k2.float
  --  if (1+k2*k)<>0 then
  --    return (atan((k2-k)/(1+k2*k))/(PI*2))*360.0
  --  else
  --    return 0
  --  end if
  -- return ((atan(k)-atan(k2))/PI)*180.0
  return lookAtPoint(pnt1, pnt2)-lookAtPoint(pnt3, pnt4)
end



on compareAngles(origo, pnt1, pnt2)
  --tm = _system.milliseconds
  
  -- repeat with q = 1 to 10000 then
  
  pnt1 = pnt1 - origo
  pnt2 = pnt2 - origo
  
  pnt2 = rotatePntFromOrigo(pnt2, point(0,0), lookAtPoint(point(0,0), pnt1))
  ang = lookAtPoint(point(0,0), pnt2)
  if ang > 180 then
    ang = abs(ang-360)
  end if
  
  
  
  --end repeat
  --put  _system.milliseconds - tm
  return ang
end


on rotatePntFromOrigo(pnt, org, rotat)
  realDir = lookAtPoint(org, pnt)
  diagonal = diag(org, pnt)
  newDir = realDir-rotat
  vec = degToVec(newDir)
  rotatedPnt = org+(vec*diagonal)
  return rotatedPnt
end






on customAdd(L, val)
  L.add(val)
  return L
end

on customSort(L)
  L.sort()
  return L
end




on insideLine(pnt, A, B, rad)
  retrn = FALSE
  if diag(pnt, A)<rad then 
    retrn = TRUE
  else if diag(pnt, B)<rad then 
    retrn = TRUE
  end if
  
  if retrn = FALSE then
    dist = ABS(lnPntDistNonAbs(pnt, A, B))
    if dist < rad then
      hyp1 = diag(A, B)
      hyp2 = diag(A, A+(giveDirFor90degrToLine(A, B)*rad))
      
      maxDiag = sqrt(power(hyp1, 2)+power(hyp2, 2))
      
      if (diag(pnt, A)<maxDiag)and(diag(pnt, B)<maxDiag) then
        retrn = TRUE
      end if
      
    end if
  end if
  
  return retrn
  
end


on newMakeLevel(lvlName)
  put "saving:" && lvlName && "..."
  
  global gLOprops, gCameraProps
  
  sz  = gLOprops.size*20
  pos = point(0,0)
  
  global gLOprops, gLightEProps, gLEProps, gEnvEditorProps, gLevel
  
  lightangle = degToVec(gLightEProps.lightAngle) * gLightEProps.flatness
  
  txt = ""
  txt = txt & lvlName
  put RETURN after txt
  txt = txt & (gLOprops.size.locH - gLOprops.extratiles[1] - gLOprops.extratiles[3]) & "*" & (gLOprops.size.locV - gLOprops.extratiles[2] - gLOprops.extratiles[4])
  if gEnvEditorProps.waterLevel > -1 then
    txt = txt & "|" & gEnvEditorProps.waterLevel & "|" & gEnvEditorProps.waterInFront
  end if
  put RETURN after txt
  txt = txt & lightangle.loch & "*" & lightangle.locV & "|0|0"
  put RETURN after txt
  
  repeat with q = 1 to gCameraProps.cameras.count then
    put (gCameraProps.cameras[q].loch.integer - gLOprops.extratiles[1]*20) & "," & (gCameraProps.cameras[q].locv.integer - gLOprops.extratiles[2]*20) after txt
    if (q < gCameraProps.cameras.count)then
      put "|" after txt
    end if
  end repeat
  
  
  mtrx = script("saveFile").changeToPlayMatrix()
  
  put RETURN after txt
  if (gLevel.defaultTerrain = 1) then
    txt = txt & "Border: Solid"
  else
    txt = txt & "Border: Passable"
  end if
  put RETURN after txt
  --ITEMS
  repeat with q = 1 + gLOprops.extratiles[1] to gLOprops.size.loch - gLOprops.extratiles[3] then
    repeat with c = 1 + gLOprops.extratiles[2] to gLOprops.size.locv - gLOprops.extratiles[4] then
      if(mtrx[q][c][1][2].getPos(9) > 0) then
        txt = txt & "0," & (q-gLOprops.extratiles[1]) & "," & (c-gLOprops.extratiles[2]) & "|"
      end if
      if(mtrx[q][c][1][2].getPos(10) > 0) then
        txt = txt & "1," & (q-gLOprops.extratiles[1]) & "," & (c-gLOprops.extratiles[2]) & "|"
      end if
    end repeat
  end repeat
  
  put RETURN after txt
  put RETURN after txt
  put RETURN after txt
  put RETURN after txt
  put "0" after txt--connmap
  put RETURN after txt--connmap
  put RETURN after txt--line for baked AI info
  repeat with q = 1 + gLOprops.extratiles[1] to gLOprops.size.loch - gLOprops.extratiles[3] then
    repeat with c = 1 + gLOprops.extratiles[2] to gLOprops.size.locv - gLOprops.extratiles[4] then
      
      case mtrx[q][c][1][1] of
        1: --wall
          txt = txt & "1"
        2, 3, 4, 5:--slopes
          txt = txt & "2"
        6: --floor
          txt = txt & "3"
        7: --shortcut entrance
          txt = txt & "4,3"
        otherwise: --air
          txt = txt & "0"
      end case
      
      repeat with e = 1 to mtrx[q][c][1][2].count then
        case mtrx[q][c][1][2][e] of
          2: --vertical beam
            if(mtrx[q][c][1][1] <> 1)then
              txt = txt & ",1"
            end if
          1: -- horizontal beam
            if(mtrx[q][c][1][1] <> 1)then
              txt = txt & ",2"
            end if
          5: --shortcut
            txt = txt & ",3"
          6: --room exit
            txt = txt & ",4"
          7: --hiding hole
            txt = txt & ",5"
          19: -- WHAM
            txt = txt & ",9"
          21: -- scavenger hole
            txt = txt & ",12"
          3: -- hive!
            if(afaMvLvlEdit(point(q,c), 1) = 0)and(afaMvLvlEdit(point(q,c+1), 1) = 1)then
              txt = txt & ",7"
            end if
          18: -- waterfall!
            txt = txt & ",8"
          13: --garbage hole
            txt = txt & ",10"
          20: --worm grass
            txt = txt & ",11"
            
        end case
      end repeat
      
      if(mtrx[q][c][1][1] <> 1) and (mtrx[q][c][2][1] = 1)then -- wall behind
        txt = txt & ",6"
      end if
      
      txt = txt & "|"
    end repeat
  end repeat
  
  put RETURN after txt
  -- Put the cangles into the txt
  put "camera angles:" after txt
  repeat with q = 1 to gCameraProps.cameras.count then
    repeat with i = 1 to 4 then
      put gCameraProps.quads[q][i][1] & "," & gCameraProps.quads[q][i][2] after txt
      if i < 4 then put ";" after txt
    end repeat
    if (q < gCameraProps.cameras.count)then
      put "|" after txt
    end if
  end repeat
  
  foundFile = 0
  
  repeat with i = 1 to 1000 then
    n = getNthFileNameInFolder(the moviePath & "Levels", i)
    if n = EMPTY then exit repeat
    if n = lvlName & ".txt" then
      foundFile = 1
      exit repeat
    end if
  end repeat
  
  put "Found file: " + foundFile
  if foundFile = 1 then
    fileDeleter = new xtra("fileio")
    fileDeleter.openFile(the moviePath & "Levels/" & lvlName & ".txt", 0)
    fileDeleter.delete()
    put "FILE DELETED!"
  end if
  
  
  objFileio = new xtra("fileio")
  objFileio.createFile(the moviePath & "Levels/" & lvlName & ".txt")
  objFileio.closeFile()
  
  
  
  fileOpener = new xtra("fileio")
  fileOpener.openFile(the moviePath & "Levels/" & lvlName & ".txt", 0)
  repeat with q = 1 to the number of lines in txt then
    fileOpener.writeString(line q of txt)
    fileOpener.writeReturn(#windows)
  end repeat
  -- txt2 = ""
  --- --repeat with q = 1 to 1040*800 then
  --  txt2 = txt2 & string(random(10)-1)
  -- end repeat
  --  fileOpener.writeString(txt2)
  -- fileOpener.writeReturn(#windows)
  fileOpener.closeFile()
  fileOpener = void
  
  
  
  
  
  -- repeat with q = 0 to 29 then
  --     props = ["image": member("layer"&q).image, "filename":_movie.path&"Levels/"&lvlName & "_" & q & ".png"]
  -- ok = gImgXtra.ix_saveImage(props)
  -- end repeat
  
  
  
  
  put "saved22:" && lvlName --&& ok
end 

on LerpVector(A, B, l)
  return point(lerp(A.locH, B.locH, l), lerp(A.locV, B.locV, l))
end


on SeedOfTile(tile)
  global gLOprops
  return gLOprops.tileSeed + (tile.locV * gLOprops.size.locH) + tile.locH
end



on Bezier(A, cA, B, cB, f)
  
  middleControl = LerpVector(cA, cB, f)
  cA = LerpVector(A, cA, f)
  cB = LerpVector(cB, B, f)
  cA = LerpVector(cA, middleControl, f)
  cB = LerpVector(middleControl, cB, f)
  
  return LerpVector(cA, cB, f)
end

on CacheLoadImage(fileName: string)
  -- implemented in C#
end





























