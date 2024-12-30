global gLoadedName, INT_EXIT, INT_EXRD, DRInternalList, DRFirstTileCat, DRLastMatCat, RandomMetals_allowed, RandomMetals_grabTiles, ChaoticStone2_needed, DRRandomMetal_needed, SmallMachines_grabTiles, SmallMachines_forbidden, RandomMachines_forbidden, RandomMachines_grabTiles, RandomMachines2_forbidden, RandomMachines2_grabTiles, DRBevelColors, CommsDrizzle

on clearLogs()
  --type fl: dynamic
  --type return: void
  member("logText").text = "Rain World Community Editor; V.0.4.53; Editor exception log"
  member("DEBUGTR").text = "Rain World Community Editor; V.0.4.53; Large trash log"
  fl = new xtra("fileio")
  fl.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fl.delete()
  fl.createFile(the moviePath & "editorExceptionLog.txt")
  fl.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fl.writeString(member("logText").text)
  fl.closeFile()
  fl.openFile(the moviePath & "largeTrashLog.txt", 0)
  fl.delete()
  fl.createFile(the moviePath & "largeTrashLog.txt")
  fl.openFile(the moviePath & "largeTrashLog.txt", 0)
  fl.writeString(member("DEBUGTR").text)
  fl.closeFile()
end

on writeException(tp, msg)--(tp: string, msg: dynamic)
  --type fileOpener: dynamic
  --type return: void
  member("logText").text = member("logText").text&RETURN&string(gLoadedName)&" ! "&string(tp)&" Exception : "&string(msg)
  fileOpener = new xtra("fileio")
  fileOpener.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fileOpener.writeString(member("logText").text)
  fileOpener.writeReturn(#windows)
end

on writeMessage(msg)--(msg: dynamic)
  --type fileOpener: dynamic
  --type return: void
  member("logText").text = member("logText").text&RETURN&string(gLoadedName)&" : "&string(msg)
  fileOpener = new xtra("fileio")
  fileOpener.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fileOpener.writeString(member("logText").text)
  fileOpener.writeReturn(#windows)
end

on writeInfoMessage(msg)--(msg: dynamic)
  --type fileOpener: dynamic
  --type return: void
  member("logText").text = member("logText").text&RETURN&"Info : "&string(msg)
  fileOpener = new xtra("fileio")
  fileOpener.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fileOpener.writeString(member("logText").text)
  fileOpener.writeReturn(#windows)
end

on writeInternalMessage(msg)--(msg: dynamic)
  --type return: void
  member("logText").text = member("logText").text&RETURN&string(gLoadedName)&" : "&string(msg)
end

on outputInternalLog()
  --type fileOpener: dynamic
  --type return: void
  fileOpener = new xtra("fileio")
  fileOpener.openFile(the moviePath & "editorExceptionLog.txt", 0)
  fileOpener.writeString(member("logText").text)
  fileOpener.writeReturn(#windows)
end

on popupWarning(ttl, msg)
  --alertObj = new(xtra "MUI")
  --alertArgs = [#buttons:#Ok, #icon:#caution, #title:ttl, #message:msg&RETURN&RETURN&"Press 'Ok' to dismiss.", #movable:TRUE]
  --if objectp(alertObj) then
  --  Alert(alertObj, alertArgs)
  --end if
end

--on exportAll()
--  pth = the moviePath & "Export\"
--  objFileio = new xtra("fileio")
--  objImg = new xtra("ImgXtra")
--  repeat with c in [_movie.castLib["Internal"], _movie.castLib["customMems"], _movie.castLib["soundCast"], _movie.castLib["levelEditor"], _movie.castLib["Drought"], _movie.castLib["Dry Editor"]] then
--    cname = c.name
--    repeat with m in c.member then
--      mname = string(m.number)
--      repeat while mname.length < 3 then
--        put "0" before mname
--      end repeat
--      mname = mname&"_"&m.name
--      
--      if m.type = #bitmap then
--        objImg.ix_saveImage(["image":  m.image, "filename": pth&cname&"\"&mname&".bmp", "format": "BMP"])
--      end if
--      if m.type = #script then
--        createFile (objFileio, pth&cname&"\"&mname&".lingo")
--        objFileio.openFile(pth&cname&"\"&mname&".lingo", 0)
--        objFileio.writeString(m.scriptText)
--        objFileio.closeFile()
--      end if
--    end repeat
--  end repeat
--  _movie.halt()
--end

on exportAll()
  --type pth: string
  --type objFileio: dynamic
  --type objImg: dynamic
  --type return: void
  pth = the moviePath & "Export\"
  objFileio = new xtra("fileio")
  objImg = new xtra("ImgXtra")
  repeat with c in [_movie.castLib["Internal"], _movie.castLib["customMems"], _movie.castLib["soundCast"], _movie.castLib["levelEditor"], _movie.castLib["Drought"], _movie.castLib["Dry Editor"], _movie.castLib["MSC"]]
    --type c: dynamic
    --type cname: string
    cname = c.name & "\"
    repeat with m in c.member
      --type m: dynamic
      --type mname: string
      mname = m.name
      if (mname = VOID) or (mname = "") then
        mname = string(m.number)
      end if
      if (m.type = #bitmap) then
        objImg.ix_saveImage(["image": m.image, "filename": pth & cname & mname & ".bmp", "format": "BMP"])
      else if (m.type = #script) then
        createFile(objFileio, pth & cname & mname & ".lingo")
        objFileio.openFile(pth & cname & mname & ".lingo", 0)
        objFileio.writeString(m.scriptText)
        objFileio.closeFile()
      end if
    end repeat
  end repeat
  _movie.halt()
end

on getBoolConfig(str)--(str: string)
  --type txt: string
  --type return: number
  txt = member("editorConfig").text
  repeat with q = 1 to the number of lines in txt
    if (txt.line[q] = str & " : TRUE") then
      return true
    end if
  end repeat
  return false
end

on getStringConfig(str)--(str: string)
  --type txt: string
  --type return: string
  txt = member("editorConfig").text
  repeat with q = 1 to the number of lines in txt
    if (txt.line[q] = str & " : DROUGHT") then
      return "DROUGHT"
    else if (txt.line[q] = str & " : DRY") then
      return "DRY"
    end if
  end repeat
  return "VANILLA"
end

on checkMinimize()
  --type return: number
  if (_movie.window.sizeState <> #minimized) then
    if (_key.keyPressed(56)) then
      return (_key.keyPressed(48))
    end if
  end if
  return FALSE
end

on checkExitRender()
  --type return: number
  if (_movie.window.sizeState <> #minimized) then
    if (_key.keyPressed(48)) then
      if (INT_EXRD = "DROUGHT") then
        if (_key.keyPressed("Z")) then
          return (_key.keyPressed("R"))
        end if
      else if (INT_EXRD = "DRY") then
        if (_key.keyPressed("X")) then
          return (_key.keyPressed("C"))
        end if
      else
        return TRUE
      end if
    end if
  end if
  return FALSE
end

on checkExit()
  --type return: number
  if (_movie.window.sizeState <> #minimized) then
    if (INT_EXIT = "DROUGHT") then
      if (_key.keyPressed(56)) then
        return (_key.keyPressed(53))
      end if
    else if (INT_EXIT = "DRY") then
      if (_key.keyPressed(48)) then
        if (_key.keypressed(36)) then
          return (_key.keyPressed("X"))
        end if
      end if
    else
      return (_key.keyPressed(53))
    end if
  end if
  return FALSE
end

on checkDRInternal(nm)--(nm: string)
  --type return: number
  return DRInternalList.getPos(nm) > 0
end

on setFirstTileCat(num)--(num: number)
  --type return: void
  DRFirstTileCat = num
end

on getFirstTileCat()
  --type return: number
  return DRFirstTileCat
end

on setLastMatCat(num)--(num: number)
  --type return: void
  DRLastMatCat = num
end

on getLastMatCat()
  --type return: list
  return DRLastMatCat
end

on initDRInternal()
  --type return: void
  DRInternalList = ["SGFL", "tileSetAsphaltFloor", "tileSetStandardFloor", "tileSetBigMetalFloor", "tileSetBricksFloor", "tileSetCliffFloor", "tileSetConcreteFloor", "tileSetNon-Slip MetalFloor", "tileSetRainstoneFloor", "tileSetRough RockFloor", "tileSetScaffoldingDRFloor", "tileSetSteelFloor", "tileSetSuperStructure2Floor", "tileSetSuperStructureFloor", "tileSetTiny SignsFloor", "tileSetElectricMetalFloor", "tileSetCageGrateFloor", "tileSetGrateFloor", "tileSetBulkMetalFloor", "tileSetMassiveBulkMetalFloor", "4Mosaic Square", "4Mosaic Slope NE", "4Mosaic Slope SE", "4Mosaic Slope NW", "4Mosaic Slope SW", "4Mosaic Floor", "3DBrick Square", "3DBrick Slope NE", "3DBrick Slope SE", "3DBrick Slope NW", "3DBrick Slope SW", "3DBrick Floor", "Small Stone Slope NE", "Small Stone Slope SE", "Small Stone Slope NW", "Small Stone Slope SW", "Small Stone Floor", "Small Machine Slope NE", "Small Machine Slope SE", "Small Machine Slope NW", "Small Machine Slope SW", "Small Machine Floor", "Missing Metal Slope NE", "Missing Metal Slope SE", "Missing Metal Slope NW", "Missing Metal Slope SW", "Missing Metal Floor", "Small Stone Marked", "Square Stone Marked", "Small Metal Alt", "Small Metal Marked", "Small Metal X", "Metal Floor Alt", "Metal Wall", "Metal Wall Alt", "Square Metal Marked", "Square Metal X", "Wide Metal", "Tall Metal", "Big Metal X", "Large Big Metal", "Large Big Metal Marked", "Large Big Metal X", "AltGrateA", "AltGrateB1", "AltGrateB2", "AltGrateB3", "AltGrateB4", "AltGrateC1", "AltGrateC2", "AltGrateE1", "AltGrateE2", "AltGrateF1", "AltGrateF2", "AltGrateF3", "AltGrateF4", "AltGrateG1", "AltGrateG2", "AltGrateH", "AltGrateI", "AltGrateF2", "AltGrateJ1", "AltGrateJ2", "AltGrateJ3", "AltGrateJ4", "AltGrateK1", "AltGrateK2", "AltGrateK3", "AltGrateK4", "AltGrateL", "AltGrateM", "AltGrateN", "AltGrateO", "Big Big Pipe", "Ring Chain", "Stretched Pipe", "Stretched Wire", "Twisted Thread", "Christmas Wire", "Ornate Wire", "Dune Sand", "Big Chain", "Chunky Chain", "Big Bike Chain", "Huge Bike Chain", "Long Barbed Wire", "Small Chain", "Fat Chain"]
  RandomMetals_grabTiles = ["Metal", "Metal construction", "Plate"]
  RandomMetals_allowed = ["Small Metal", "Metal Floor", "Square Metal", "Big Metal", "Big Metal Marked", "C Beam Horizontal AA", "C Beam Horizontal AB", "C Beam Vertical AA", "C Beam Vertical BA", "Plate 2"]
  ChaoticStone2_needed = ["Small Stone", "Square Stone", "Tall Stone", "Wide Stone", "Big Stone", "Big Stone Marked"]
  DRRandomMetal_needed = ["Small Metal", "Metal Floor", "Square Metal", "Big Metal", "Big Metal Marked", "Four Holes", "Cross Beam Intersection"]
  SmallMachines_grabTiles = ["Machinery", "Machinery2", "Small machine"]
  SmallMachines_forbidden = ["Feather Box - W", "Feather Box - E", "Piston Arm", "Vertical Conveyor Belt A", "Ventilation Box Empty", "Ventilation Box", "Big Fan", "Giant Screw", "Compressor Segment", "Compressor R", "Compressor L", "Hub Machine", "Pole Holder", "Sky Box", "Conveyor Belt Wheel", "Piston Top", "Piston Segment Empty", "Piston Head", "Piston Segment Filled", "Piston Bottom", "Piston Segment Horizontal A", "Piston Segment Horizontal B", "machine box C_E", "machine box C_W", "machine box C_Sym", "Machine Box D", "machine box B", "Big Drill", "Elevator Track", "Conveyor Belt Covered", "Conveyor Belt L", "Conveyor Belt R", "Conveyor Belt Segment", "Dyson Fan", "Metal Holes", "valve", "Tank Holder", "Drill Rim", "Door Holder R", "Door Holder L", "Drill B", "machine box A", "Machine Box E L", "Machine Box E R", "Drill Shell A", "Drill Shell B", "Drill Shell Top", "Drill Shell Bottom", "Pipe Box R", "Pipe Box L"]
  RandomMachines_grabTiles = ["Machinery", "Machinery2", "Small machine", "LB Machinery", "Custom Random Machines"]
  RandomMachines_forbidden = ["Feather Box - W", "Feather Box - E", "Piston Arm", "Vertical Conveyor Belt A", "Piston Head No Cage", "Conveyor Belt Holder Only", "Conveyor Belt Wheel Only", "Drill Valve"]
  RandomMachines2_grabTiles = ["Machinery", "Machinery2", "Small machine"]
  RandomMachines2_forbidden = ["Feather Box - W", "Feather Box - E", "Piston Arm", "Vertical Conveyor Belt A", "Ventilation Box Empty", "Ventilation Box", "Big Fan", "Giant Screw", "Compressor Segment", "Compressor R", "Compressor L", "Hub Machine", "Pole Holder", "Sky Box", "Conveyor Belt Wheel", "Piston Top", "Piston Segment Empty", "Piston Head", "Piston Segment Filled", "Piston Bottom", "Piston Segment Horizontal A", "Piston Segment Horizontal B", "machine box C_E", "machine box C_W", "machine box C_Sym", "Machine Box D", "machine box B", "Big Drill", "Elevator Track", "Conveyor Belt Covered", "Conveyor Belt L", "Conveyor Belt R", "Conveyor Belt Segment", "Dyson Fan"]
  DRBevelColors = [[color(255, 0, 0), point(-1, -1)], [color(255, 0, 0), point(0, -1)], [color(255, 0, 0), point(-1, 0)], [color(0, 0, 255), point(1, 1)], [color(0, 0, 255), point(0, 1)], [color(0, 0, 255), point(1, 0)]]
end

on checkIsDrizzleRendering()
  -- For Drizzle to override to skip some initialization code that it shouldn't need to care about
  return FALSE
end

--on freeImageNotFoundEx me
--  if (the moviePath & "FreeImage.dll" = void) then
--    member("logText").text = member("logText").text&RETURN&"File Not Found Exception : FreeImage.dll is missing. You must place it in the same folder as your editor executable."
--    fileOpener = new xtra("fileio")
--    fileOpener.openFile(the moviePath & "editorExceptionLog.txt", 0)
--    fileOpener.writeString(member("logText").text)
--    fileOpener.writeReturn(#windows)
--  end if
--end