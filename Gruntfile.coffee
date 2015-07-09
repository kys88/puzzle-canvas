module.exports = (grunt) ->
	
	require('load-grunt-config') grunt

	grunt.registerTask 'build', ['clean', 'copy', 'jade', 'coffeelint', 'coffee', 'stylus']
	grunt.registerTask 'serve', ['build', 'express', 'open', 'watch']
	grunt.registerTask 'default', ['serve']