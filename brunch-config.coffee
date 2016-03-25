exports.config =
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
      joinTo: 'js/templates.js'

  plugins:
    coffeescript:
      bare: true