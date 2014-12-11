module.exports =
  app: "app"
  extras:[]
  scripts:[]

  server:
    host: "0.0.0.0"
    port: 9000
    fallback: "index.html"

  open:
    host: "localhost"
    port: 9001
    path: "/"

  # Use spritesmith options to configure for each sprite   https://github.com/twolfson/gulp.spritesmith#documentation
  sprites: {
    # icons:
    #   cssFormat: 'css'
  }
