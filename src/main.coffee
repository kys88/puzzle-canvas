((P) ->

	canvas = document.getElementById 'canvas'
	P.setup canvas

	background = new P.Raster
		source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
		position: new P.Point P.view.center.x, .7 * P.view.center.y
		opacity: .7

	console.log P.view.bounds

	background.onLoad = () ->
		@size = new P.Size P.view.size.width, .7 * P.view.size.height

	P.view.draw()

)(paper)