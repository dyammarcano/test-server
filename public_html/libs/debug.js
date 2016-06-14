'use strict';
if (typeof Storage !== void 0) {
  if (localStorage['debug'] === void 0) {
    localStorage['debug'] = ' : ' + Date.now() + '\n';
  } else {
    localStorage['debug'] = localStorage['debug'] + ' : ' + Date.now() + '\n';
  }
} else {
  console.log('Sorry! No Web Storage support...');
}
