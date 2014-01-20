## Boot the express app

mongoose = require 'mongoose'
PORT = process.env.PORT or 5000
express = require('express')

app = express()
if 'development' is app.get('env') or 'test' is app.get('env')
	app.use(express.errorHandler())
	app.use(express.logger('dev'))

app.set('port', PORT)
app.use(express.favicon())
app.use(express.bodyParser())

app.use(express.methodOverride())
app.use(express.cookieParser())

redis = require './db/redis'

redis.setupSession(app)

env = app.get('env')



passport = require('passport')

app.use(passport.initialize())
app.use(passport.session())

#BasicAuth = require('./auth')
#BasicAuth.init(app)









app.server = app.listen PORT, ->
	console.log 'Express server listening on port ' + app.get('port')

app.clear = (callback) ->
	try
		require('./db/redis').flush()
		
	catch e
		console.log e.stack
	callback()

module.exports = app
