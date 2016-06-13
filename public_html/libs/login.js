
/*requirejs.config
    shim:
        jquery: 
            exports: 'jQuery'
        materialize:
            deps: [
                'jquery'
                'hammer'
            ]
            exports: 'Materialize'
        angular_material:
            deps: [
                'hammer'
                'angular'
                'angular_animate'
                'angular_aria'
            ]
            exports: 'AngularMaterial'
    paths:
        angular: [
            'http://ajax.googleapis.com/ajax/libs/angularjs/1.5.6/angular.min'
            '/module/angular/angular.min'
        ]
        angular_material:[
            'http://ajax.googleapis.com/ajax/libs/angular_material/1.1.0-rc2/angular-material.min'
            '/module/angular-material/angular-material.min'
        ]
        angular_animate:[
            'http://ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-animate.min'
            '/module/angular-animate/angular-animate.min'
        ]
        angular_aria:[
            'http://ajax.googleapis.com/ajax/libs/angularjs/1.5.6/angular-aria.min'
            '/module/angular-aria/angular-aria.min'
        ]
        materialize: [
            'https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.6/js/materialize.min'
            '/module/Materialize/dist/js/materialize.min'
        ]
        jquery: [
            'https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min'
            '/module/jquery/dist/jquery.min'
        ]
        socketio: [
            'https://cdn.socket.io/socket.io-1.4.5'
            '/socket.io/socket.io'
        ]
        hammer: [
            'https://cdnjs.cloudflare.com/ajax/libs/hammer.js/2.0.8/hammer.min'
            '/module/hammerjs/hammer.min'
        ]

define [ 
    'jquery'
    'materialize'
    'socketio'
    'angular'
    'angular_material'
], ($, Materialize, io, Angular) ->
    console.log 'all deps loads...'

    socket = io.connect('http://' + location.hostname + ':8000')

    status = false

    socket.emit 'online', false
        
    socket.on 'online', (data) ->
        console.info 'connect ok'
        $('body').addClass 'loaded'
        status = data

    socket.on 'verify', (data) ->
        console.log data

        if data.data != undefined
            location.pathname = '/message-list'

    $('#form').on 'submit', (event) ->
        event.preventDefault()

        console.info 'username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val()
        
        socket.emit 'verify',
            username: $('#user_name').val()
            password: $('#user_pass').val()
            remember: $('#remember').val()
 */
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
