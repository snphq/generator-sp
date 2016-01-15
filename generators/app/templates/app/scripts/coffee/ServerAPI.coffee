define ['sp-utils-serverclient'], (ServerClient)->
  class ServerAPI extends ServerClient
    initialize: ->

    _isServer: -> false #can using stubs

    get_data: ->
      @get {
        url: '/api'
        stub: (async)->
          async.resolve 'stub data'
      }
