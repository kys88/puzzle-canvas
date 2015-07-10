# Prevent iOS Safari from doing the scroll thing
document.body.addEventListener 'touchmove', (event) ->
	event.preventDefault()

# Anonymous function to map paper to P
((P) ->
	canvas = document.getElementById 'canvas'
	P.setup canvas

	# Set the background image
	background = new P.Raster
		source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
		position: new P.Point P.view.center.x, .7 * P.view.center.y

	background.onLoad = () ->
		@size = new P.Size P.view.size.width, .7 * P.view.size.height

	# The rectangle used for the cutout of the pieces
	rectangle = new P.Rectangle 0, 0, P.view.size.width / 4, .7 * P.view.size.height / 4
	
	###
	Two pieces
	###

	dropZoneLayer = new P.Layer()
	piecesLayer = new P.Layer()
	pieces = []

	for i in [0..1]
		
		# The dropzone for the piece
		dropZone = new P.Shape.Rectangle rectangle
		dropZone.fillColor = 'white'
		dropZone.opacity = 0.5
		dropZone.position.x = i * rectangle.width + rectangle.width / 2
		dropZoneLayer.addChild dropZone

		# The edge will serve as the mask for the piece
		pieceEdge = new P.Shape.Rectangle rectangle
		pieceEdge.set
			selected: true

		pieceBackground = new P.Raster
			source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
			position: new P.Point P.view.center.x - i * rectangle.width, .7 * P.view.center.y

		pieceBackground.onLoad = () ->
			@size = new P.Size P.view.size.width, .7 * P.view.size.height

		# Create a Group using the mask and the background
		pieceGroup = new P.Group pieceEdge, pieceBackground, pieceEdge.clone()
		pieceGroup.clipped = true
		pieceGroup.position.x = i * rectangle.width / 2 + rectangle.width / 2
		pieceGroup.strokeColor = 'black'
		piecesLayer.addChild pieceGroup

		pieces.push
			zone: dropZone
			edge: pieceEdge
			group: pieceGroup

	###
	Mouse events
	###

	actualPiece = null
	dragging = false

	tool = new P.Tool()
	tool.onMouseDown = (event) ->
		return if dragging

		# Reset
		possiblePieces = []
		actualPiece = null

		for piece in pieces
			if piece.edge.contains event.point
				possiblePieces.push piece

		return unless possiblePieces.length
		
		actualPiece = possiblePieces[0]

		for i in [1...possiblePieces.length]
			if possiblePieces[i].group.isAbove actualPiece.group
				actualPiece = possiblePieces[i]

		for piece in pieces
			if piece.zone.contains event.point
				piece.zone.fillColor = 'gray'

		actualPiece.group.strokeWidth = 10
		actualPiece.group.bringToFront()

	tool.onMouseUp = (event) ->
		return unless actualPiece
		
		# Possibly snap to grid
		if actualPiece.zone.contains event.point
			actualPiece.group.position = background.position

			# Send behind all the other pieces
			actualPiece.group.sendToBack()

		# Reset
		for piece in pieces
			piece.group.strokeWidth = 0 
			piece.zone.fillColor = 'white'
		actualPiece = null
		dragging = false

	tool.onMouseMove = (event) ->

		# Reset
		piece.zone.fillColor = 'white' for piece in pieces

		return unless actualPiece
		dragging = true
		actualPiece.group.position.x += event.delta.x
		actualPiece.group.position.y += event.delta.y

		for piece in pieces
			if piece.zone.contains event.point
				piece.zone.fillColor = 'gray'

)(paper)