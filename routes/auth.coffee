'use strict'

Express        = require('express')
Router         = Express.Router()
Config         = require('../config')
Account        = require('../models/account')
Session        = require('../models/session')
TokenString    = require('../helpers/token')
Mongoose       = require('mongoose')
Bcrypt         = require('bcrypt')

##############################################################################################
# Route POST 
##############################################################################################

Router.post '/api/auth', (request, response) ->

    db = Mongoose.connect Config.db_name

    sess = new Session token: TokenString.data
    sess.save (error) ->
        if !error
            #response.json token: 'TokenString'
            #db.disconnect()
        else
            console.log error
            #db.disconnect()

    Account.findOne 'username': request.query.username, (error, user) ->
        if !error
            console.log 'no error 1'
        else
            console.log error

        if user
            console.log user

            Bcrypt.compare request.query.password, user.password, (error, ok) ->
                if !error
                    console.log 'no error 2'
                else
                    console.log error

                if ok
                    sess = new Session token: TokenString.data
                    sess.save (error) ->
                        if !error
                            response.json token: 'TokenString'
                            db.disconnect()
                else
                    response.json error: 'authentication error'
        else
            response.json error: 'no user exist'

module.exports = Router
