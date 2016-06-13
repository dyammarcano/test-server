socket = Primus.connect('http://' + location.hostname + ':8000')

status = false

socket.on 'open', ->
  socket.send 'verify'
  socket.on 'verify', (data) ->
    console.log data
    return
  
socket.on 'online', (data) ->
  console.info 'connect ok'
  $('body').addClass 'loaded'
  status = data
  return

  if data.data != undefined
    location.pathname = '/message-list'
    return

$('#form').on 'submit', (event) ->
  event.preventDefault()

  console.info 'username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val()
  
  socket.send 'verify',
    username: $('#user_name').val()
    password: $('#user_pass').val()
    remember: $('#remember').val()
