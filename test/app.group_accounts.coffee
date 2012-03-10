redis = require('redis')
rclient = redis.createClient()
require 'should'
groupAccounts = require('../group_accounts').GroupAccounts
ga = new groupAccounts()


describe 'group accounts:', ->
  describe 'create', ->
    it 'should save a new account', (done) ->
      ga.create 'testing-testing-testing', ->
        ga.exists 'testing-testing-testing', (res) ->
          res.should.be.ok
          done()
  describe 'save', ->
    it 'should save account details', (done) ->
      ga.save 'testing-testing-testing', { kyle: 'was-here' }, (err, obj) ->
        if err then throw err
        ga.read 'testing-testing-testing', (obj) ->
          obj.kyle.should.eql('was-here')
          done()
  describe 'delete', ->
    it 'should delete an account', (done) ->
      ga.delete 'testing-testing-testing', (err, obj) ->
        if err then throw err
        ga.exists 'testing-testing-testing', (res) ->
          res.should.not.be.ok
          done()

