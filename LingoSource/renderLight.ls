global q, c, tm, pos, gLightEProps, gLevel, keepLooping, gViewRender, gLOprops, DRActiveLight, DRWhite

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
  cols: number = 2000
  rows: number = 1200
  marginPixels: number = 150
  marginRect: rect = rect(0, 0, cols + marginPixels * 2, rows + marginPixels * 2)
  fullRect: rect = rect(0, 0, cols, rows)
  inv: image = image(marginRect.right, marginRect.bottom, 1)
  svPos: point = pos
  silhou: image = makeSilhoutteFromImg(DRActiveLight, 1)
  repeat with q = 1 to gLightEProps.flatness
    inv.copypixels(silhou, marginRect + rect(pos, pos), marginRect, {#ink:36, #color:color(255, 0, 0)})
    pos = pos + degToVec(gLightEProps.lightAngle)
  end repeat
  inv = makeSilhoutteFromImg(inv, 1)
  strc = string(c)
  layercsh = member("layer" & strc & "sh").image
  layerc = member("layer" & strc).image
  repeat with dir in [point(0, 0), point(-1, 0), point(0, -1), point(1, 0), point(0, 1)]
    type dir: point
    layercsh.copypixels(inv, marginRect + rect(dir, dir), marginRect, {#ink:36, #color:color(255, 0, 0)})
  end repeat
  rctshad = fullRect + rect(marginPixels, marginPixels, marginPixels, marginPixels)
  layercsh.copypixels(makeSilhoutteFromImg(layerc, 1), rctshad, fullRect, {#ink:36, #color:DRWhite})
  silhou: image = makeSilhoutteFromImg(layerc, 0)
  repeat with q = 1 to gLightEProps.flatness then
    DRActiveLight.copypixels(silhou, rctshad - rect(svPos, svPos), fullRect, {#ink:36, #color:DRWhite})
    svPos = svPos + degToVec(gLightEProps.lightAngle)
  end repeat
  c = c + 1
  if (c > 29) then
    keepLooping = 0
  end if
end