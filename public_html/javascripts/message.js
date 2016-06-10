var socket;

socket = io.connect('http://localhost:9000');


/*socket.on 'messages', (data) ->
    alert data
    console.log data
    socket.emit 'join', 'Hello World from client'
 */

socket.emit('messages', 'Hello World from client');
