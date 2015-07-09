((P) ->

	canvas = document.getElementById 'canvas'
	P.setup canvas

	background = new P.Raster
		source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
		position: new P.Point P.view.center.x, .7 * P.view.center.y
		opacity: .7

	background.onLoad = () ->
		@size = new P.Size P.view.size.width, .7 * P.view.size.height

	rectangle = new P.Rectangle 0, 0, P.view.size.width / 4, .7 * P.view.size.height / 4
	pieceEdge = new P.Shape.Rectangle rectangle

	pieceBackground = new P.Raster
		source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
		position: new P.Point P.view.center.x, .7 * P.view.center.y

	pieceBackground.onLoad = () ->
		@size = new P.Size P.view.size.width, .7 * P.view.size.height

	pieceGroup = new P.Group pieceEdge, pieceBackground
	pieceGroup.clipped = true

	P.view.draw()

)(paper)