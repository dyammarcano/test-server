'use strict'

Mongoose       = require('mongoose')
Schema         = Mongoose.Schema
Config         = require('../config')

##############################################################################################
# Declare Schema.
##############################################################################################

#Mongoose.connect Config.db_name

Account = new Schema(
    username : type: String
    password : type: String
    created  :
        type    : Date
        default : Date.now)

#Account.plugin require('mongoose-bcrypt')

module.exports = Mongoose.model 'Account', Account