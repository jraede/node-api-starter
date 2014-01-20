###
This handles the loading and retrieval of models and schemas per company. These collections
are divided up per company in one database, using company.clean_name + '_' as prefix
###
mongoose = require 'mongoose'
_ = require 'underscore'
Q = require 'q'

module.exports =
	register: ->

		fs = require 'fs'

		dir = fs.readdirSync __dirname + '/models'
		deferred = Q.defer()

		try
			for m in globalModels
				console.log 'loading ', m
				require './models/' + m.replace('.js', '')
		catch e
			console.log e.stack
			console.log 'Models already registered, probably in test'
		
		deferred.resolve()

		return deferred.promise




