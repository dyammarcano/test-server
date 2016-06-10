socket = io.connect('http://localhost:9000')

$('#form').on 'submit', (event) ->
    event.preventDefault()
    console.log 'user_name: ' + $('#user_name').val() + ' user_pass: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val()
    socket.emit 'verify',
        username: $('#user_name').val()
        password: $('#user_pass').val()
        remember: $('#remember').val()
    return