'use strict'

Moment = require('moment')()

TokenString =
    data:  require('crypto').randomBytes(48).toString('hex')
    create: Moment.format('x').valueOf()
    expires : Moment.add(1, 'days').format('x').valueOf()

module.exports = TokenString