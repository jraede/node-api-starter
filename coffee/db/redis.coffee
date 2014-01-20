express = require 'express'
RedisStore = require('connect-redis')(express)
url = require('url')
module.exports = 
	config: false
	getConfig: ->
		if !@config
			@config = {}
			if process.env.REDISTOGO_URL?

				redisUrl = process.env.REDISTOGO_URL

			else
				redisUrl = 'redis://:@127.0.0.1:6379/0'

			parsedUrl = url.parse(redisUrl)
			@config.protocol = parsedUrl.protocol.substr(0, parsedUrl.protocol.length - 1)
			@config.username = parsedUrl.auth.split(':')[0]
			@config.password = parsedUrl.auth.split(':')[1]
			@config.host = parsedUrl.hostname
			@config.port = parsedUrl.port
			@config.database = parsedUrl.path.substring(1)
			@config.secret = 'REPLACE ME'
			@config.url = redisUrl

		return @config
	connect: ->
		@redis = require('redis-url').connect(@getConfig().url)
		@redis.on 'connect', ->
			console.log 'redis connected'

		@redis.on 'error', (error) ->
			console.error 'redis error', error

	flush: ->
		@redis.flushdb()
	setupSession: (app) ->
		# Parse the 
		console.log 'Setting up redis session'
		app.use express.session
			secret: @getConfig().secret
			store: new RedisStore
				port: @getConfig().port
				host: @getConfig().host
				db: @getConfig().database
				pass: @getConfig().password

