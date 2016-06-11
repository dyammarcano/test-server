var socket, status;

socket = io.connect('http://' + location.hostname + ':8000');

status = false;

socket.emit('online', false);

socket.on('online', function(data) {
  console.info('connect ok');
  return status = data;
});

socket.on('verify', function(data) {
  console.log(data);
  if (data.data !== void 0) {
    return location.pathname = '/message-list';
  }
});

$('#form').on('submit', function(event) {
  event.preventDefault();
  console.info('username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val());
  return socket.emit('verify', {
    username: $('#user_name').val(),
    password: $('#user_pass').val(),
    remember: $('#remember').val()
  });
});
