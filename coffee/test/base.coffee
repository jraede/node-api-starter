request = require('supertest')
should = require('should')

boot = require('../server/boot')


mongoose = require('mongoose')

testSetup = require '../server/util/testSetup'
describe 'Tenant', ->
	@timeout(15000)
	before (done) ->
		boot.start().then (app) =>
			Session = require('supertest-session')({
				app:app

			})
			@sess = new Session()
				
			done()
	after (done) ->
		testSetup.clear().then ->
			done()
	
