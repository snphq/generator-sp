module.exports =
   coffeelint:
      options:
        force: true
        'max_line_length':
          'level': 'ignore'
        'indentation':
          'level':'warn'
        'no_trailing_semicolons':
          'level':'warn'
        'duplicate_key':
          'level':'warn'
      app:
        files: [
            expand: true
            cwd: "<%= yeoman.app %>/scripts"
            src: "**/*.coffee"
          ]
