get = (data) ->
  #Crypto.randomBytes(48).toString('hex')
  hash = Crypto.createHash 'sha256'
  hash.update data
  return hash.digest('hex')

'use strict'

Crypto = require('crypto')
Moment = require('moment')()

tData = Moment.format('x').valueOf()

token = 
  data: get(tData)
  create: tData
  expires: Moment.add(1, 'days').format('x').valueOf()

module.exports = token
