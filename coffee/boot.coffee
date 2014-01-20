mongo = require './db/mongo'
redis = require './db/redis'
modelIndex = require './services/modelIndex'
mongoose = require 'mongoose'
Q = require('q')

class Boot
	@app:null
	@start: ->

		deferred = Q.defer()
		if @app
			try
				@app.server.close()
			catch err
				console.log 'Server not running'

		mongo.connect(process.env.MONGOHQ_URL)
		redis.connect(process.env.REDISTOGO_URL)
		modelIndex.register().then =>
			try
				@app = require './init'
			catch e
				console.log e.stack
				return deferred.reject(e)
			deferred.resolve(@app)

		return deferred.promise

module.exports = Boot



