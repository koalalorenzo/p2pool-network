exports.config =
  jsWrapper: 'raw'
  modules:
    wrapper: false
    definition: false
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
      
    copycat:
      ".": "nodes.json"
      "fonts": "bower_components/font-awesome/fonts/"