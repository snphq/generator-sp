define (require, exports, module)->
  <%= coffee_base %> = require '../_Item'
  <%= normalize_name %> = _Item.extend
    template: '#<%= normalize_name %>'
    className: '<%= css_classname %>'
