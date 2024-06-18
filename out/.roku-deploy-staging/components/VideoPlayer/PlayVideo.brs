sub init()
  m.state = "buffering"
  m.PlayVideo = m.top.findNode("PlayVideo")
  m.videoitem = m.top.findNode("videoitem")

  m.progressBar = m.top.findNode("progressBar")
  m.progressBar.width = 0

  m.controlView = m.top.findNode("controlView")
  m.controlView.visible = false


  m.seekbarPoster = m.top.findNode("seekbarPoster")
  m.seekbarWidth = 1280 ' Width of the seekbar

  m.fadAnimView = m.top.findNode("fadAnimView")

  m.currentTime = m.top.findNode("currentTime")
  m.durationTime = m.top.findNode("durationTime")
  m.currentTime.text = "00:00"
  m.durationTime.text = "00:00"
  m.currentTime.font.size = "25"
  m.durationTime.font.size = "25"

  m.playPause = m.top.findNode("playPause")
  m.playPause.uri = "pkg:/images/pause.png"
  m.playPause.setFocus(true)

  m.positionTimer = m.top.findNode("getPosition")
  m.videoitem.observeField("position", "onPlayerPosition")
  m.videoitem.observeField("state", "onVideoState")

  m.controlTimer = m.top.findNode("controlTimer")
  m.controlTimer.ObserveField("fire", "onControlTimer")

  m.fadeout = m.top.findNode("fadeout")
  m.fadein = m.top.findNode("fadein")

  setPlayerData()


end sub

function setPlayerData()
  ContentNode = CreateObject("roSGNode", "ContentNode")
  ContentNode.streamFormat = "mp4"
  ContentNode.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
  m.videoitem.content = ContentNode
  m.videoitem.control = "play"
end function

sub onPlayerPosition()
  passedVideoProgress = (m.videoitem.position / m.videoitem.duration) * 100
  passedProgreesBar = (1620 / 100) * passedVideoProgress
  m.progressBar.width = passedProgreesBar
  m.currentTime.text = convertDate(m.videoitem.position)
end sub


sub forward(seconds as integer)
  if m.videoitem.position < m.videoitem.duration
    m.videoitem.position = m.videoitem.position + seconds
    m.positionTimer = m.videoitem.position
    m.videoitem.seek = m.videoitem.position
    m.currentTime.text = convertDate(m.videoitem.position)
  else
    m.videoitem.control = "stop"
  end if

end sub


sub backward(seconds as integer)
  m.videoitem.position = m.videoitem.position - seconds
  m.positionTimer = m.videoitem.position
  m.videoitem.seek = m.videoitem.position
  m.currentTime.text = convertDate(m.videoitem.position)
end sub




sub onClickVideoBack()
  if m.controlView.visible = true
    m.videoitem.control = "pause"
  else
    m.controlView.visible = true
    m.controlTimer.control = "start"
  end if
end sub


sub onVideoState()
  if m.videoitem.state = "buffering"
    m.state = "buffering"
  else if m.videoitem.state = "playing"
    m.state = "playing"
    m.durationTime.text = convertDate(m.videoitem.duration)
  else if m.videoitem.state = "paused"
    m.state = "paused"
  end if
end sub


sub onControlTimer()
  m.controlView.visible = false
end sub


function convertDate(scound)
  h = scound / 3600
  m = scound mod 3600 / 60
  s = scound mod 60

  hStr = Int(h).toStr()
  mStr = Int(m).toStr()
  sStr = Int(s).toStr()

  if Int(h) < 10
    hStr = "0" + Int(h).toStr()
  end if

  if Int(m) < 10
    mStr = "0" + Int(m).toStr()
  end if

  if Int(s) < 10
    sStr = "0" + Int(s).toStr()
  end if
  return hStr + ":" + mStr + ":" + sStr

end function




function onKeyEvent(key as string, press as boolean) as boolean
  if press then
    m.controlTimer.control = "stop"
    if key = "OK" then
      if m.controlView.visible and m.state = "playing"
        m.playPause.uri = "pkg:/images/play.png"
        m.videoitem.control = "pause"
      else if m.controlView.visible and m.state = "paused"
        m.playPause.uri = "pkg:/images/pause.png"
        m.videoitem.control = "resume"
      end if
      m.controlTimer.control = "start"
    end if

    if key = "Back" then
      m.videoitem.control = "pause"
    end if

    if key = "right" then
      forward(10)
    end if

    if key = "left" then
      backward(10)
    end if

    if key = "down" then
      m.controlView.visible = false
    end if

    if key = "up" then
      onClickVideoBack()
    end if

  end if
end function
