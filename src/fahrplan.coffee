http = require "http"

class Fahrplan
  constructor: (@options, cb) ->
    @options.port = @options.port || 80
    @options.host = @options.host || 'localhost'

    @_meta cb

  request: (method, path, data, cb) ->
    console.log arguments
    options = 
      hostname: @options.host
      port: @options.port
      path: path
      method: method.toUpperCase()

    req = http.request options, (res) =>
      body = ""
      res.setEncoding 'utf8'
      res.on 'data', (chunk) ->
        body += chunk
      res.on 'end', () ->
        cb null, JSON.parse body

    req.on 'error', (e) ->
      cb e

    req.write JSON.stringify(data) if data
    req.end()

  _meta: (cb) ->
    @request 'GET', '/_meta', null, (err, api) =>
      Object.keys(api).forEach (method) =>
        routes = api[method]
        routes.forEach (route) =>
          return if route.path is "/_meta"

          path = route.path.replace(/^\//, '').split /\//
          without_keys = path.filter (x) -> not x.match /^\:/
          without_keys = without_keys.map (x, index) ->
            if index is 0
              x
            else
              x.charAt(0).toUpperCase() + x.slice(1)

          name = without_keys.join ''
          name = "list" if name is "" and method is "get"
          name = "create" if name is "" and method is "post"

          @["#{name}"] = () =>
            args = Array.prototype.slice.call arguments

            # check correct number of arguments
            expected_arguments_length = route.keys.length + 1
            if method in ["post", "put"]
              expected_arguments_length++

            if args.length isnt expected_arguments_length
              key_names = route.keys.map((x) -> x.name).join()
              return args.pop() error: "wrong number of arguments. expected #{key_names} and callback"

            path = route.path
            for key in route.keys
              path = path.replace ":#{key.name}", args.shift()

            data = null
            if method in ["post", "put"]
              data = args.shift()

            callback = args.shift()

            @request method, route.path, data, (err, result) =>
              callback err, result

      cb err
module.exports = Fahrplan
