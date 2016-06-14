'use strict';
var createCookie, eraseCookie, readCookie;

createCookie = function(name, value, days) {
  var expires;
  var date, expires;
  if (days) {
    date = new Date;
    date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
    expires = '; expires=' + date.toGMTString();
  } else {
    expires = '';
  }
  document.cookie = name + '=' + value + expires + '; path=/';
};

readCookie = function(name) {
  var c, ca, i, nameEQ;
  nameEQ = name + '=';
  ca = document.cookie.split(';');
  i = 0;
  while (i < ca.length) {
    c = ca[i];
    while (c.charAt(0) === ' ') {
      c = c.substring(1, c.length);
    }
    if (c.indexOf(nameEQ) === 0) {
      return c.substring(nameEQ.length, c.length);
    }
    i++;
  }
  return null;
};

eraseCookie = function(name) {
  createCookie(name, '', -1);
};
