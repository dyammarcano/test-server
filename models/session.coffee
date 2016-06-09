'use strict'

Mongoose       = require('mongoose')
Schema         = Mongoose.Schema
Config         = require('../config')

##############################################################################################
# Declare Schema.
##############################################################################################

#Mongoose.connect Config.db_name

Session = new Schema(
    token : type: String
    expireAt :
        type : Date
        expires : 60 * 60 * 24
        default : Date.now)

module.exports = Mongoose.model 'Session', Session