define (require, exports, module)->
  <%= coffee_base %> = require '../<%= coffee_base %>'
  <% if(is_webpack) { %>require './<%= normalize_name %>.<%= cssPreprocessor%>'<% } %>
  <%= normalize_name %> = <%= coffee_base %>.extend
    <% if(!is_webpack) { %>template: '#<%= normalize_name %>'<% } %>
    <% if(is_webpack) { %>templateFunc: require './<%= normalize_name %>.jade'<% } %>
    className: '<%= css_classname %>'
