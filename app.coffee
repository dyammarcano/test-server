'use strict'

require('dotenv').config()

Config         = require('./config')
Debug          = require('debug') Config.app + ':server'
Http           = require('http')
Express        = require('express')
Path           = require('path')
Favicon        = require('serve-favicon')
Compress       = require('compression')
Cors           = require('cors')
BodyParser     = require('body-parser')
Mongoose       = require('mongoose')
Cookie         = require('cookie-parser')
Session        = require('express-session')
Errorhandler   = require('errorhandler')
MongoDBStore   = require('connect-mongodb-session')(Session)
Morgan         = require('morgan')
ResponseTime   = require('response-time')
#middleware     = require('./middleware')
#services       = require('./services')
Routes         = require('./routes')


##############################################################################################
# Event listener for HTTP server "error" event.
##############################################################################################

onError = (error) ->
    if error.syscall isnt 'listen'
        throw error

    bind = if typeof port is 'string' then "Pipe #{port}" else "Port #{port}"

    # handle specific listen errors with friendly messages
    switch error.code
        when 'EACCES'
            console.error "#{bind} require elevated privileges"
            process.exit 1
        when 'EADDRINUSE'
            console.error "#{bind} is already in use"
            process.exit 1
        else
            throw error

##############################################################################################
# Event listener for HTTP server "listening" event.
##############################################################################################

onListening = ->
    addr = server.address()
    bind = if typeof addr is 'string' then "pipe #{addr}" else "port #{addr.port}"
    Debug "Listening on #{bind}"

##############################################################################################
# Get port from .env and store in Express.
##############################################################################################

app = Express()

app.use Morgan 'combined'
app.use ResponseTime()
app.set 'trust proxy', 1

app.use Session (
    secret: Config.session_secret
    cookie: maxAge: 1000 * 60 * 60 * 24 * 7
    store: new MongoDBStore 
        uri: Config.db_name
        collection: 'sessions'
    resave: true
    saveUninitialized: true)

app.set 'views', Path.join __dirname, 'views'
app.set 'view engine', 'pug'

app.use Favicon "#{__dirname}/public_html/favicon.png"
app.use Compress()
app.use Cookie()
app.use BodyParser.json()
app.use BodyParser.urlencoded extended: true
app.use Express.static Path.join __dirname, 'public_html'
app.disable 'x-powered-by'

###Mongoose.connect Config.db_name, (error) ->
    if error
        console.log error###
    

app.use '/', Routes

port = process.env.PORT

app.set 'port', port

##############################################################################################
# Create HTTP server.
##############################################################################################

server = Http.createServer(app).listen app.get 'port'

##############################################################################################
# Listen on provided port, on all network interfaces.
##############################################################################################

server.on 'error', onError
server.on 'listening', onListening

##############################################################################################
# Print console information.
##############################################################################################

console.log 'Express server ready in (' + process.env.MODE + ') mode http://localhost:' + app.get 'port'