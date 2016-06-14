'use strict'

if typeof Storage != undefined
  if localStorage['debug'] == undefined
    localStorage['debug'] = ' : ' + Date.now() + '\n'
  else
    localStorage['debug'] = localStorage['debug'] + ' : ' + Date.now() + '\n'
else
  console.log 'Sorry! No Web Storage support...'
