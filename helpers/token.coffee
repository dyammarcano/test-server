get = ->
  #Crypto.randomBytes(48).toString('hex')
  hash = Crypto.createHash 'sha256'
  hash.update Moment.format('x').valueOf().toString()
  hash.digest('hex').toString()

'use strict'

Crypto = require('crypto')
Moment = require('moment')()

token = 
  data: get()
  create: Moment.format('x').valueOf()
  expires: Moment.add(1, 'days').format('x').valueOf()

module.exports = token
