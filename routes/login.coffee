'use strict'

Express    = require('express')
Router     = Express.Router()
Account    = require('../models/account')

##############################################################################################
# Route GET 
##############################################################################################

Router.get '/login', (request, response) ->
  params = 
    title: 'render title'

  response.render 'register/login', params, (error, html) ->
    response.send html

module.exports = Router