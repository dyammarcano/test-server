"use strict"

require("dotenv").config()

Config         = require("./config")
Debug          = require("debug") Config.app + ":server"
Http           = require("http")
Express        = require("express")
Path           = require("path")
Favicon        = require("serve-favicon")
Compress       = require("compression")
Cors           = require("cors")
BodyParser     = require("body-parser")
Mongoose       = require("mongoose")
CookieParser   = require("cookie-parser")
ExpressSession = require("express-session")
Errorhandler   = require("errorhandler")
MongoDBStore   = require("connect-mongodb-session")(ExpressSession)
MorganLogger   = require("morgan")
ResponseTime   = require("response-time")()
Primus         = require("primus.io")
Routes         = require("./routes")
Moment         = require("moment")()
PrimusSession  = require("primus-express-session")

##############################################################################################
# Event listener for HTTP server "error" event.
##############################################################################################

onError = (error) ->
  if error.syscall isnt "listen"
    throw error

  bind = if typeof port is "string" then "Pipe #{port}" else "Port #{port}"

  # handle specific listen errors with friendly messages
  switch error.code
    when "EACCES"
      console.error "#{bind} require elevated privileges"
      process.exit 1
    when "EADDRINUSE"
      console.error "#{bind} is already in use"
      process.exit 1
    else
      throw error

##############################################################################################
# Event listener for HTTP server "listening" event.
##############################################################################################

onListening = ->
  addr = server.address()
  bind = if typeof addr is "string" then "pipe #{addr}" else "port #{addr.port}"
  Debug "Listening on #{bind}"

##############################################################################################
# Get port from .env and store in Express.
##############################################################################################

app = Express()

#app.use Morgan "combined"

app.use ResponseTime

app.enable 'trust proxy'

cookies = CookieParser(Config.session_secret)

session =  ExpressSession(
  secret: Config.session_secret
  cookie: maxAge: 1000 * 60 * 60 * 24 * 7
  store: new ExpressSession.MemoryStore()
  resave: true
  saveUninitialized: true)

app.set "views", Path.join __dirname, "views"
app.set "view engine", "pug"
app.use MorganLogger "dev"
app.use Favicon "#{__dirname}/public_html/favicon.png"
app.use Compress()
app.use cookies
app.use session
app.use BodyParser.json()
app.use BodyParser.urlencoded extended: true
app.use Express.static Path.join __dirname, "public_html"
#app.disable "x-powered-by"

app.use "/", Routes

port = process.env.PORT

app.set "port", port

##############################################################################################
# Create HTTP server.
##############################################################################################

server = Http.createServer(app)

primus = new Primus(server,
  transformer: "websockets"
  parser: "JSON")

##############################################################################################
# Use cookie and cookie-session middleware
##############################################################################################

primus.before "cookies", cookies
primus.before "session", session

###
primus.before 'session', (req, res, next) ->
  try
    sid = req.signedCookies['connect.sid']
    if !sid
      return next()
    req.pause()
    store.get sid, (err, session) ->
      if err
        primus.emit 'log', 'error', err
        return next()
      if session
        req.sessionID = sid
        req.sessionStore = store
        req.thesession = store.createSession(req, session)
      req.resume()
      next()
      return
  catch error
    console.log error
  return
primus.on 'connection', (spark) ->
  spark.on 'data', (data) ->
    spark.request.thesession.addthis = 'save this to session'
    spark.request.thesession.save()
    return
  return
### 

primus.on "connection", (spark) ->
  address = spark.request.client._peername.address
  port    = spark.request.client._peername.port
  user    = spark.id

  console.log "on::socket connection %s from %s:%s date: %s", user, address, port, Moment.format("LLLL")
  #console.log spark.request

  Moment = require('moment')()

  spark.on "message", (data) ->  
    spark.write "message", data
    return

  spark.on "verify", (data) ->
  
    token = 
      data: require('crypto').createHash('sha256').update(spark.id).digest('hex')
      create: Moment.format('x').valueOf()
      expires: Moment.add(1, 'days').format('x').valueOf()

    setTimeout (->
      #console.log token
      spark.send "verify", token
      return
    ), 2000

server.listen app.get "port"

##############################################################################################
# Listen on provided port, on all network interfaces.
##############################################################################################

server.on "error", onError
server.on "listening", onListening

##############################################################################################
# Print console information.
##############################################################################################

console.log "Express server ready in (" + process.env.MODE + ") mode http://localhost:" + app.get "port"
