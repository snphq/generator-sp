define [
  "../<%= coffee_base %>"
],(<%= coffee_base %>)->
  <%= normalize_name %> = <%= coffee_base %>.extend
    template:"#<%= normalize_name %>"
    className:"<%= css_classname %>"
