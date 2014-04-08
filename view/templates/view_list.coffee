define (require, exports, module)->
  <%= coffee_base %> = require "../<%= coffee_base %>"
  <%= normalize_name %> = require "../<%= normalize_name %>/<%= normalize_name %>"
  <%= collection_name %> = require "collection/<%= collection_name %>"

  <%= normalize_name_list %> = <%= coffee_base %>.extend
    template:"#<%= normalize_name_list %>"
    className:"<%= css_classname_list %>"
    bindings:
      ":el":"collection:$collection"
    initialize:->
      @collection = new <%= collection_name %>
      @collection.view = <%= normalize_name %>
