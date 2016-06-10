Express        = require('express')
Router         = Express.Router()

Router.use require './auth'
Router.use require './login'

##############################################################################################
# Route GET 
##############################################################################################

Router.get '/', (request, response) ->
    #console.log 'Cookies: ', request.cookies
    params = 
        title: 'render title'

    response.render 'index', params, (error, html) ->
        response.send html

module.exports = Router