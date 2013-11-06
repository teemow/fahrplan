module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          'lib/fahrplan.js': ['src/fahrplan.coffee']
    mochaTest:
      options:
        reporter: 'nyan'
      src: ['test/test.coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', ['coffee', 'mochaTest']
