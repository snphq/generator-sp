define ["utils/ServerClient"],(ServerClient)->
  class ServerAPI extends ServerClient
    initialize:->

    get_data:->
      @get {
        url:"/api"
        stub:(async)->
          async.resolve "stub data"
      }
