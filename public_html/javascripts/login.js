'use strict';
var saveDB, socket, status, webApp;

saveDB = function(data) {
  var request;
  if (!window.indexedDB) {
    return alert("Su navegador no soporta una versión estable de indexedDB. Tal y como las características no serán validas");
  } else {
    request = indexedDB.open("webApp", 3);
    request.onerror = function(event) {
      console.log(event);
    };
    return request.onupgradeneeded = function(event) {
      var db, objectStore;
      db = event.target.result;
      objectStore = db.createObjectStore('token', {
        keyPath: 'data'
      });
      objectStore.transaction.oncomplete = function(event) {
        var customerObjectStore;
        customerObjectStore = db.transaction('token', 'readwrite').objectStore('token');
        customerObjectStore.add(data);
      };
    };
  }
};

socket = Primus.connect('http://' + location.hostname + ':8000');

status = false;

socket.on('open', function() {
  socket.send('verify');
  return socket.on('verify', function(data) {
    console.log(data);
    saveDB(data);
  });
});

socket.on('online', function(data) {
  console.info('connect ok');
  status = data;
  return;
  if (data.data !== void 0) {
    location.pathname = '/message-list';
  }
});

webApp = angular.module('webApp', []);

webApp.controller('myForm', function($scope, $http) {
  $scope.user = {};
  $scope.submitFrom = function() {
    $http({
      method: 'POST',
      url: '/auth',
      data: $scpe.user,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded'
      }
    }).success(function(dara) {
      if (data.errors) {
        $scope.errorUsername = data.errors.username;
        return $scope.errorPassword = data.errors.password;
      } else {
        return $scope.messege = data.messege;
      }
    });
  };
  return;
  return $scope.registerUser = function(user) {
    console.log(user);
  };
});


/*$('#form').on 'submit', (event) ->
  event.preventDefault()

  console.info 'username: ' + $('#user_name').val() + ' password: ' + $('#user_pass').val() + ' remember: ' + $('#remember').val()
  
  socket.send 'verify',
    username: $('#user_name').val()
    password: $('#user_pass').val()
    remember: $('#remember').val()
 */
