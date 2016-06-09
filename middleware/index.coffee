'use strict'

handler        = require('express-error-handler')
logger         = require('./logger')

module.exports = ->
    app = this
    app.use notFound()
    app.use logger(app)
    app.use handler()
    return