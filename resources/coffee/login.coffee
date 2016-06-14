'use strict'

#window.indexedDB = window.indexedDB or window.mozIndexedDB or window.webkitIndexedDB or window.msIndexedDB

saveDB = (data) ->
  if !window.indexedDB
    alert "Su navegador no soporta una versión estable de indexedDB. Tal y como las características no serán validas"
  else
    request = indexedDB.open("webApp", 3)

    request.onerror = (event) ->
      # Handle errors.
      console.log event
      return

    request.onupgradeneeded = (event) ->
      db = event.target.result
      objectStore = db.createObjectStore('token', keyPath: 'data')

      objectStore.transaction.oncomplete = (event) ->
        customerObjectStore = db.transaction('token', 'readwrite').objectStore('token')
        customerObjectStore.add data
        return
      return

socket = Primus.connect('http://' + location.hostname + ':8000')

status = false

socket.on 'open', ->
  socket.send 'verify'
  socket.on 'verify', (data) ->
    console.log data
    saveDB data
    return
  
socket.on 'online', (data) ->
  console.info 'connect ok'
  #$('body').addClass 'loaded'
  status = data
  return

  if data.data != undefined
    location.pathname = '/message-list'
    return

webApp = angular.module('webApp', [])
webApp.controller 'myForm', ($scope, $http) ->
  $scope.user = {}

  $scope.submitFrom = ->
    $http(
      method: 'POST'
      url: '/auth'
      data: $scpe.user
      headers: 'Content-type': 'application/x-www-form-urlencoded').success (dara) ->
      if data.errors
        $scope.errorUsername = data.errors.username
        $scope.errorPassword = data.errors.password
      else
        $scope.messege = data.messege
    return
  return

  $scope.registerUser = (user) ->
    console.log user
    return

###$('#form').on 'submit', (event) ->
  event.preventDefault()

  console.info 'username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val()
  
  socket.send 'verify',
    username: $('#user_name').val()
    password: $('#user_pass').val()
    remember: $('#remember').val()
###