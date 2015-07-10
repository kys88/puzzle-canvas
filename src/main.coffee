#document.body.addEventListener 'touchmove', (event) ->
#	event.preventDefault()

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
	
	###
	Two pieces
	###

	pieces = []

	for i in [0..1]
		pieceEdge = new P.Shape.Rectangle rectangle
		pieceEdge.set
			strokeColor: 'black'
			strokeWidth: 0
			selected: true

		pieceBackground = new P.Raster
			source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
			position: new P.Point P.view.center.x, .7 * P.view.center.y

		pieceBackground.onLoad = () ->
			@size = new P.Size P.view.size.width, .7 * P.view.size.height

		pieceGroup = new P.Group pieceEdge, pieceBackground, pieceEdge.clone()
		pieceGroup.clipped = true
		pieceGroup.position.x = i * rectangle.width / 2 + rectangle.width / 2
		pieceGroup.strokeColor = 'black'

		pieces.push
			edge: pieceEdge
			group: pieceGroup

	tool = new P.Tool()
	tool.onMouseMove = (event) ->
		piece.group.strokeWidth = 0 for piece in pieces

		possiblePieces = []

		for piece in pieces
			if piece.edge.contains event.point
				possiblePieces.push piece

		return unless possiblePieces.length
		
		actualPiece = possiblePieces[0]

		for i in [1...possiblePieces.length]
			if possiblePieces[i].group.isAbove actualPiece.group
				actualPiece = possiblePieces[i]

		actualPiece.group.strokeWidth = 10

)(paper)