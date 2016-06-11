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
    