var getIPs;

getIPs = function(callback) {
  var RTCPeerConnection, handleCandidate, ip_dups, mediaConstraints, pc, servers, useWebKit, win;
  ip_dups = {};
  RTCPeerConnection = window.RTCPeerConnection || window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
  useWebKit = !!window.webkitRTCPeerConnection;
  handleCandidate = function(candidate) {
    var ip_addr, ip_regex;
    ip_regex = /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/;
    ip_addr = ip_regex.exec(candidate)[1];
    if (ip_dups[ip_addr] == undefined) {
      callback(ip_addr);
    }
    ip_dups[ip_addr] = true;
  };
  if (!RTCPeerConnection) {
    win = iframe.contentWindow;
    RTCPeerConnection = win.RTCPeerConnection || win.mozRTCPeerConnection || win.webkitRTCPeerConnection;
    useWebKit = !!win.webkitRTCPeerConnection;
  }
  mediaConstraints = {
    optional: [
      {
        RtpDataChannels: true
      }
    ]
  };
  servers = {
    iceServers: [
      {
        urls: 'stun:stun.services.mozilla.com'
      }
    ]
  };
  pc = new RTCPeerConnection(servers, mediaConstraints);
  pc.onicecandidate = function(ice) {
    if (ice.candidate) {
      handleCandidate(ice.candidate.candidate);
    }
  };
  pc.createDataChannel('');
  pc.createOffer((function(result) {
    pc.setLocalDescription(result, (function() {}), function() {});
  }), function() {});
  setTimeout((function() {
    var lines;
    lines = pc.localDescription.sdp.split('\n');
    lines.forEach(function(line) {
      if (line.indexOf('a=candidate:') == 0) {
        handleCandidate(line);
      }
    });
  }), 1000);
};

getIPs(function(ip) {
  console.log(ip[0]);
});
