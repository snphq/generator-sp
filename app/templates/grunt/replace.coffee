module.exports = 
	replace:
    requirejs:
      src: "<%= yeoman.tmpPath %>/scripts/main.js"
      overwrite: true
      replacements:[
        from: /VENDOR_PATH[ ]*=[ ]*["']{1}.+["']{1};/
        to: ''
      ,
        from: /var[ ]*VENDOR_PATH[ ]*;/
        to: ''
      ,
        from: "VENDOR_PATH"
        to: '"../../app/bower_components/"'
      ]
