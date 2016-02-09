module.exports = (libName)->
  try
    require libName
  catch
    require "snp-gulp-tasks/node_modules/#{libName}"
