module.exports =
	puzzle:
		files:
			'dest/main.css': 'src/main.styl'
		options:
			'include css': true
			use: [
				() -> require('autoprefixer-stylus')()
			]
