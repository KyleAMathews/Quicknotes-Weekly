redis = require('redis')
rclient = redis.createClient()

# For managing group accounts.
class exports.GroupAccounts

  # Create a group account
  create: (id, clb) ->
    rclient.sadd 'quicknotes_groups', id, (err, obj) ->
      if clb? then clb err, obj

  exists: (id, clb) ->
    rclient.sismember 'quicknotes_groups', id, (err, obj) ->
      clb obj

  delete: (id, clb) ->
    rclient.srem 'quicknotes_groups', id, (err, obj) ->
      if clb? then clb err, obj

  save: (id, obj, clb) ->
    @exists id, (res) ->
      if res
        rclient.hmset 'quicknotes_group_' + id, obj, (err, obj) ->
          if clb then clb err, obj

  read: (id, clb) ->
    @exists id, (res) ->
      if res
        rclient.hgetall 'quicknotes_group_' + id, (err, obj) ->
          if err then throw err
          clb obj
