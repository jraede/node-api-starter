boot = require './boot'
process.on 'uncaughtException', (error) ->
	console.log(error.stack)
boot.start().then ->
	console.log 'Finished boot'
, (err) ->
	console.log err.stack


