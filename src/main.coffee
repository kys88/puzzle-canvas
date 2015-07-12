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
	rectangle = new P.Rectangle 0, 0, P.view.size.width / 3, .7 * P.view.size.height / 3

	###
	Top row
	###

	pieceEdges = [{
		left: 0
		right: 1,
		top: 0,
		bottom: 1
	}, {
		left: -1,
		right: -1,
		top: 0,
		bottom: 1
	}, {
		left: 1,
		right: 0,
		top: 0,
		bottom: 1
	}, {
		left: 0,
		right: 1,
		top: -1,
		bottom: 1
	}, {
		left: -1,
		right: -1,
		top: -1,
		bottom: 1
	}, {
		left: 1,
		right: 0,
		top: -1,
		bottom: -1
	}, {
		left: 0,
		right: -1,
		top: -1,
		bottom: 0
	}, {
		left: 1,
		right: -1,
		top: -1,
		bottom: 0
	}, {
		left: 1,
		right: 0,
		top: 1,
		bottom: 0
	}]

	dropZoneLayer = new P.Layer()
	piecesLayer = new P.Layer()
	pieces = []

	for i in [0..8]

		# An actual puzzle piece shape
		W = rectangle.width
		H = rectangle.height

		E = H / 8

		puzzle = new P.Path()
		puzzle.strokeWidth = 0

		# Top left
		puzzle.moveTo 0, 0

		# Top edge
		zero = (rectangle.width - rectangle.height) / 2
		one = zero + rectangle.height
		half = rectangle.height / 2

		if pieceEdges[i].top is 1

			# Outwards
			puzzle.lineTo new P.Point zero + 3 * E, 0
			puzzle.quadraticCurveTo new P.Point(zero + half, 0), new P.Point(zero + 3 * E, -E)
			puzzle.cubicCurveTo new P.Point(zero + 2 * E, -2 * E), new P.Point(one - 2 * E, -2 * E), new P.Point(one - 3 * E, -E)
			puzzle.quadraticCurveTo new P.Point(one - half, 0), new P.Point(one - 3 * E, 0)

		else if pieceEdges[i].top is -1

			# Inwards
			puzzle.lineTo new P.Point zero + 3 * E, 0
			puzzle.quadraticCurveTo new P.Point(zero + half, 0), new P.Point(zero + 3 * E, E)
			puzzle.cubicCurveTo new P.Point(zero + 2 * E, 2 * E), new P.Point(one - 2 * E, 2 * E), new P.Point(one - 3 * E, E)
			puzzle.quadraticCurveTo new P.Point(one - half, 0), new P.Point(one - 3 * E, 0)

		puzzle.lineTo new P.Point W, 0
		
		# Right edge
		if pieceEdges[i].right is 1

			# Outwards
			puzzle.lineTo new P.Point W, 3 * E
			puzzle.quadraticCurveTo new P.Point(W, H / 2), new P.Point(W + E, 3 * E)
			puzzle.cubicCurveTo new P.Point(W + 2 * E, 2 * E), new P.Point(W + 2 * E, 6 * E), new P.Point(W + E, 5 * E)
			puzzle.quadraticCurveTo new P.Point(W, H / 2), new P.Point(W, 5 * E)
		
		else if pieceEdges[i].right is -1

			# Inwards
			puzzle.lineTo new P.Point W, 3 * E
			puzzle.quadraticCurveTo new P.Point(W, H / 2), new P.Point(W - E, 3 * E)
			puzzle.cubicCurveTo new P.Point(W - 2 * E, 2 * E), new P.Point(W - 2 * E, 6 * E), new P.Point(W - E, 5 * E)
			puzzle.quadraticCurveTo new P.Point(W, H / 2), new P.Point(W, 5 * E)

		# Straight
		puzzle.lineTo new P.Point W, H
		
		# Bottom edge
		if pieceEdges[i].bottom is 1

			# Outwards
			puzzle.lineTo new P.Point one - 3 * E, H
			puzzle.quadraticCurveTo new P.Point(one - half, H), new P.Point(one - 3 * E, H + E)
			puzzle.cubicCurveTo new P.Point(one - 2 * E, H + 2 * E), new P.Point(zero + 2 * E, H + 2 * E), new P.Point(zero + 3 * E, H + E)
			puzzle.quadraticCurveTo new P.Point(one - half, H), new P.Point(zero + 3 * E, H)

		else if pieceEdges[i].bottom is -1

			# Inwards
			puzzle.lineTo new P.Point one - 3 * E, H
			puzzle.quadraticCurveTo new P.Point(one - half, H), new P.Point(one - 3 * E, H - E)
			puzzle.cubicCurveTo new P.Point(one - 2 * E, H - 2 * E), new P.Point(zero + 2 * E, H - 2 * E), new P.Point(zero + 3 * E, H - E)
			puzzle.quadraticCurveTo new P.Point(one - half, H), new P.Point(zero + 3 * E, H)

		# Straight
		puzzle.lineTo new P.Point 0, H
		
		# Left edge
		if pieceEdges[i].left is 1

			# Outwards
			puzzle.lineTo new P.Point 0, 5 * E
			puzzle.quadraticCurveTo new P.Point(0, H / 2), new P.Point(-E, 5 * E)
			puzzle.cubicCurveTo new P.Point(-2 * E, 6 * E), new P.Point(-2 * E, 2 * E), new P.Point(-E, 3 * E)
			puzzle.quadraticCurveTo new P.Point(0, H / 2), new P.Point(0, 3 * E)
		
		else if pieceEdges[i].left is -1

			# Inwards
			puzzle.lineTo new P.Point 0, 5 * E
			puzzle.quadraticCurveTo new P.Point(0, H / 2), new P.Point(E, 5 * E)
			puzzle.cubicCurveTo new P.Point(2 * E, 6 * E), new P.Point(2 * E, 2 * E), new P.Point(E, 3 * E)
			puzzle.quadraticCurveTo new P.Point(0, H / 2), new P.Point(0, 3 * E)

		# Close
		puzzle.closePath()
		
		# The dropzone for the piece
		dropZone = puzzle.clone()
		dropZone.fillColor = 'white'
		dropZone.opacity = 0.5
		dropZoneLayer.addChild dropZone

		differenceHorizontally = puzzle.bounds.width - rectangle.width
		differenceHorizontally /= 2 if pieceEdges[i].left is 1 and pieceEdges[i].right is 1

		differenceVertically = puzzle.bounds.height - rectangle.height
		differenceVertically /= 2 if pieceEdges[i].left is 1 and pieceEdges[i].right is 1

		# Set correct top left
		dropZone.bounds.x = (i % 3) * rectangle.width
		dropZone.bounds.x -= differenceHorizontally if pieceEdges[i].left > 0
		dropZone.bounds.y = Math.floor(i / 3) * rectangle.height
		dropZone.bounds.y -= differenceVertically if pieceEdges[i].top > 0

		# The edge will serve as the mask for the piece
		pieceEdge = puzzle.clone()

		pieceBackground = new P.Raster
			source: '//hufkens.net/wp-content/uploads/2012/10/bumba-win8.png'
			position: new P.Point P.view.center.x - (i % 3) * rectangle.width, .7 * P.view.center.y - Math.floor(i / 3) * rectangle.height

		pieceBackground.onLoad = () ->
			@size = new P.Size P.view.size.width, .7 * P.view.size.height

		# Create a Group using the mask and the background
		pieceGroup = new P.Group pieceEdge, pieceBackground, pieceEdge.clone()
		pieceGroup.clipped = true
		pieceGroup.bounds.x = (i % 3) * rectangle.width
		pieceGroup.bounds.x -= differenceHorizontally if pieceEdges[i].left > 0
		pieceGroup.bounds.y = Math.floor(i / 3) * rectangle.height
		pieceGroup.bounds.y -= differenceVertically if pieceEdges[i].top > 0
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

		actualPiece.group.strokeWidth = 3
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