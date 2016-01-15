module.exports =
  app: "app"
  extras:[]
  scripts:[]

  # browserSync settings (http://www.browsersync.io/docs/options/)
  browserSync:
    port: 9000
    open: false

  cdn:
    host: ""

  # Use spritesmith options to configure for each sprite   https://github.com/twolfson/gulp.spritesmith#documentation
  sprites: {
    # icons:
    #   cssFormat: 'css'
  }

  proxy:
    port: 9001
    remotes:
      dist:
        host: "project.snpdev.ru"
        port: 80
        https: false
      prod:
        host: "project.ru"
        port: 80
        https: false
    activeRemote: 'dist'
    pushState: true
    remoteRoutes: [
      /^\/(api|auth|admin|assets|system|rich).*$/
    ]
    localRoutes: [
      /^\/(bower_components|resources|browser\-sync|images|files|scripts|styles|favicon\.ico|robots\.txt|livereload\.js).*$/
    ]

