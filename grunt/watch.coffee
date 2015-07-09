module.exports =
	options:
		livereload: true
	jade:
		options:
			livereload: false
		files: ['src/*.jade']
		tasks: ['jade']
	html:
		files: ['dest/*.html']
	coffee:
		files: ['src/*.coffee']
		tasks: ['coffee']
	sass:
		files: ['src/*.styl']
		tasks: ['stylus']