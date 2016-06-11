requirejs.config
    shim:
        jquery: 
            exports: 'jQuery'
        materialize:
            deps: [
                'jquery'
                'hammer'
            ]
            exports: 'Materialize'
    paths:
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
            'https://cdnjs.cloudflare.com/ajax/libs/hammer.js/2.0.8/hammer'
            '/module/hammerjs/hammer'
        ]

define [ 
    'jquery'
    'materialize'
    'socketio'
], ($, Materialize, io) ->
    console.log 'all deps loads...'

    socket = io.connect('http://' + location.hostname + ':8000')

    status = false

    socket.emit 'online', false
        
    socket.on 'online', (data) ->
        console.info 'connect ok'
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