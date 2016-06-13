'use strict'

var socket = Primus.connect('ws://localhost:8000');
 
socket.on('open', function () {
 
  // Send request to join the news room 
  socket.send('verify');
 
  // listen to hello events 
  socket.on('verify', function (msg) {
 
    console.log(msg); //-> hello from the server 
 
  });
});