global c, gBlurOptions, gLOprops, gLightEProps, gCurrentRenderCamera

on exitFrame me
  
  
  -- member("finalbg").image = image(52*20, 40*20, 32)
  -- member("finalfg").image = image(52*20, 40*20, 32)
  
  --  member("glassImage").image = image(gLOprops.size.loch*20, gLOprops.size.locv*20, 32)
  
  lightangle = degToVec(gLightEProps.lightAngle) * gLightEProps.flatness
  
  repeat with q = 0 to 29 then
    member("layer"&q).image = image(100*20,60*20,32)
    member("gradientA"&string(q)).image = image(100*20, 60*20, 16)
    member("gradientB"&string(q)).image = image(100*20, 60*20, 16)
    member("layer"&q&"dc").image = image(100*20,60*20,32)
  end repeat
  
  member("rainBowMask").image = image(100*20,60*20,32)
  
  -- gBlurOptions = [#blurLight:gLOprops.pals[gLOprops.pal].blurLight, #blurSky:gLOprops.pals[gLOprops.pal].blurSky]
  
  --  gGradientMaps = []
  --  repeat with q = 0 to 19 then
  --    gGradientMaps.add( image(1040, 800, 16) )
  --  end repeat
  
  
  
  
  renderLevel()
  
  c=1
end







