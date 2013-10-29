module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files:
          'lib/express-client.js': ['src/express-client.coffee']
    mochaTest:
      options:
        reporter: 'nyan'
      src: ['test/test.coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.registerTask 'default', ['coffee', 'mochaTest']
