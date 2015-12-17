Backbone = require 'backbone'
<%= model_name %> = require 'model/<%= model_name %>'

<%= normalize_name %> = Backbone.Collection.extend
  model: <%= model_name %>



module.exports = <%= normalize_name %>
