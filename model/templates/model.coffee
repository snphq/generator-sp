Backbone = require 'backbone'
require 'epoxy'

<%= normalize_name %> = Backbone.Epoxy.Model.extend

  defaults:
    field: 'value'



module.exports = <%= normalize_name %>
