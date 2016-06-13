getIPs = (callback) ->
  ip_dups = {}
  #compatibility for firefox and chrome
  RTCPeerConnection = window.RTCPeerConnection or window.mozRTCPeerConnection or window.webkitRTCPeerConnection
  useWebKit = ! !window.webkitRTCPeerConnection
  #bypass naive webrtc blocking using an iframe

  handleCandidate = (candidate) ->
    #match just the IP address
    ip_regex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/
    ip_addr = ip_regex.exec(candidate)[1]
    #remove duplicates
    if `ip_dups[ip_addr] == undefined`
      callback ip_addr
    ip_dups[ip_addr] = true
    return

  if !RTCPeerConnection
    #NOTE: you need to have an iframe in the page right above the script tag
    #
    #<iframe id="iframe" sandbox="allow-same-origin" style="display: none"></iframe>
    #<script>...getIPs called in here...
    #
    win = iframe.contentWindow
    RTCPeerConnection = win.RTCPeerConnection or win.mozRTCPeerConnection or win.webkitRTCPeerConnection
    useWebKit = ! !win.webkitRTCPeerConnection
  #minimal requirements for data connection
  mediaConstraints = optional: [ { RtpDataChannels: true } ]
  servers = iceServers: [ { urls: 'stun:stun.services.mozilla.com' } ]
  #construct a new RTCPeerConnection
  pc = new RTCPeerConnection(servers, mediaConstraints)
  #listen for candidate events

  pc.onicecandidate = (ice) ->
    #skip non-candidate events
    if ice.candidate
      handleCandidate ice.candidate.candidate
    return

  #create a bogus data channel
  pc.createDataChannel ''
  #create an offer sdp
  pc.createOffer ((result) ->
    #trigger the stun server request
    pc.setLocalDescription result, (->
    ), ->
    return
  ), ->
  #wait for a while to let everything done
  setTimeout (->
    #read candidate info from local description
    lines = pc.localDescription.sdp.split('\n')
    lines.forEach (line) ->
      if `line.indexOf('a=candidate:') == 0`
        handleCandidate line
      return
    return
  ), 1000
  return

getIPs (ip) ->
  console.log ip[0]
  return
