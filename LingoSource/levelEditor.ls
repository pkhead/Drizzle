

global gLEProps, gDirectionKeys, gLOprops, gEnvEditorProps


on exitFrame me
  
  repeat with q = 1 to 4 then
    if (_key.keyPressed([86, 91, 88, 84][q]))and(gDirectionKeys[q] = 0) then
      gLEProps.camPos = gLEProps.camPos + [point(-1, 0), point(0,-1), point(1,0), point(0,1)][q] * (1 + 9 * _key.keyPressed(83))
      lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 1)
      lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 2)
      lvlEditDraw(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 3)
      drawShortCutsImg(rect(1,1,gLOprops.size.loch,gLOprops.size.locv), 16)
    end if
    gDirectionKeys[q] = _key.keyPressed([86, 91, 88, 84][q])
  end repeat
  
  call(#newUpdate, gLEProps.levelEditors)
  
  rct = rect(0,0,gLOprops.size.loch, gLOprops.size.locv) + rect(gLOProps.extraTiles[1], gLOProps.extraTiles[2], -gLOProps.extraTiles[3], -gLOProps.extraTiles[4]) - rect(gLEProps.camPos, gLEProps.camPos)
  sprite(71).rect = (rct.intersect(rect(0,0,52,40))+rect(11, 1, 11, 1))*rect(16,16,16,16)
  
  if gEnvEditorProps.waterLevel = -1 then
    sprite(9).rect = rect(0,0,0,0)
  else
    rct = rect(0, gLOprops.size.locv-gEnvEditorProps.waterLevel-gLOProps.extraTiles[4], gLOprops.size.loch, gLOprops.size.locv) - rect(gLEProps.camPos, gLEProps.camPos)
    sprite(9).rect = ((rct.intersect(rect(0,0,52,40))+rect(11, 1, 11, 1))*rect(16,16,16,16))+rect(0, -8, 0, 0)
  end if
  
  script("levelOverview").goToEditor()
  go the frame
end













