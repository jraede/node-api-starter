Q = require('q')
mongo = require '../db/mongo'
module.exports = 
	dropCollection: (collection) ->
		deferred = Q.defer()
		mongo.connection.db.dropCollection collection, (err, result) ->
			deferred.resolve()
		return deferred.promise
	clear: ->
		console.log 'Clearing app!'
		deferred = Q.defer()

		# Clear out the databases
		
		drops = []
		for collection,config of mongo.connection.collections
			drops.push(@dropCollection(collection))
		
		Q.all(drops).then ->

		
		

			# Flush the redis cache
			redis = require '../db/redis'
			redis.redis.flushdb()
			console.log 'Flushed redis'

			# Disconnect from redis
			redis.redis.quit()
			console.log 'Quit redis'

			# Disconnect
			mongoose = require('mongoose')
			mongoose.disconnect()
			console.log 'Disconnected from mongodb'

			# Now clear out mongoose models, etc
			mongoose.models = []
			#mongoose.mtModel.goingToCompile = []

			deferred.resolve()
		return deferred.promise

		
	