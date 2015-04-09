define (require, exports, module)->
  <%= coffee_base %> = require '../<%= coffee_base %>'
  <%= normalize_name %> = <%= coffee_base %>.extend
    template: '#<%= normalize_name %>'
    className: '<%= css_classname %>'

    #initialize: ->
    #  <%= coffee_base %>::initialize.apply this, arguments
    #  #You code here

    #showModal: ->
    #  #You code here
    #  <%= coffee_base %>::showModal.apply this, arguments
