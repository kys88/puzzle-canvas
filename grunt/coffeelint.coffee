module.exports =
	app:
		files:
			src: ['src/*.coffee']
		options:
			no_tabs:
				level: 'ignore'
			indentation:
				level: 'error'
				value: 1
			max_line_length:
				value: 132
				level: 'warn'
