exports.config =
  jsWrapper: 'raw'

  files:
    javascripts:
      joinTo:
        'js/app.js': /^(app)/
        'js/components.js': /^(bower_components)/

    stylesheets:
      joinTo:
        'css/app.css': /^(app)/
        'css/components.css': /^(bower_components)/

    templates:
      joinTo: 'templates.html'

  plugins:
    coffeescript:
      bare: true

    coffeelint:
      pattern: /^app\/.*\.coffee$/
      options:
        indentation:
          value: 2
          level: "error"

        max_line_length:
          value: 80
          level: "error"

    copycat:
      ".": "nodes.json"
      "fonts": "bower_components/font-awesome/fonts/"