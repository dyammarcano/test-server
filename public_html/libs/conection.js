'use strict';
var socket, status;

socket = Primus.connect('http://' + location.hostname + ':8000');

status = false;

socket.on('open', function() {
  socket.send('verify');
  return socket.on('verify', function(data) {
    console.log(data);
  });
});

socket.on('online', function(data) {
  console.info('connect ok');
  $('body').addClass('loaded');
  status = data;
  return;
  if (data.data !== void 0) {
    location.pathname = '/message-list';
  }
});

$('#form').on('submit', function(event) {
  event.preventDefault();
  console.info('username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val());
  return socket.send('verify', {
    username: $('#user_name').val(),
    password: $('#user_pass').val(),
    remember: $('#remember').val()
  });
});
