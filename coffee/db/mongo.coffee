mongoose = require('mongoose')
Q = require('q')
module.exports =
	connection:null
	connect: ->
		mongooseTypes.loadTypes(mongoose)
		if process.env.NODE_ENV is 'test'
			mongoose.connect('mongodb://localhost/api_test')
			#mongoose.connect('mongodb://cornerstone:AmYisraelChai1948@linus.mongohq.com:10002/Cornerstone-Test')
		else
			mongoose.connect(process.env.MONGOHQ_URL)
		mongoose.set('debug', true)
		@connection = mongoose.connection
		mongoose.connection.on 'error', (error) ->
			console.error error
		mongoose.connection.on 'connected', ->
			console.log 'connected'

		#if process.env.NODE_ENV != 'development'
	
	clear: (callback) ->
		for collection,config of @connection.collections
			@connection.collections[collection].drop()
		

		callback()

