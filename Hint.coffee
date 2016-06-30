# Hint Module
# Shows hint overlays on tap to direct user on where to hit.
# by @charliecm

currentSet = ''
sets = {}
isDragging = false
layerOptions = {}

# Adds hint set
exports.addSet = (name, set) ->
	sets[name] = set || []

# Removes hint set
exports.removeSet = (name) ->
	delete sets[name]

# Switches hint set
exports.switchSet = (name) ->
	currentSet = name

# Sets default hint layer options
exports.setLayerOptions = (options) ->
	layerOptions = options || {}

# Detect dragging
document.addEventListener Events.TouchStart, ->
	isDragging = false
document.addEventListener Events.TouchMove, ->
	isDragging = true

# Bind show hint on tap event
document.addEventListener Events.TouchEnd, (event) ->
	return if isDragging
	return if not sets.hasOwnProperty currentSet
	# From https://github.com/tisho/framer-hints/blob/master/src/framer-hints.coffee#L82
	event = Events.touchEvent(event)
	scale = Framer.Device?.phone.scale || 1
	xOffset = (Canvas.size.width - Screen.size.width * scale) / 2
	yOffset = (Canvas.size.height - Screen.size.height * scale) / 2
	point =
		x: (event.clientX + window.pageXOffset - xOffset) / scale
		y: (event.clientY + window.pageYOffset - yOffset) / scale
	for layer in sets[currentSet]
		return if Utils.pointInFrame point, layer.screenFrame
	for layer in sets[currentSet]
		do ->
			frame = layer.screenFrame
			options = _.assign
					x: frame.x
					y: frame.y
					width: frame.width
					height: frame.height
					backgroundColor: 'rgba(52,152,219,0.75)'
					opacity: 0
					ignoreEvents: true
				, layerOptions
			hint = new Layer options
			hint.animate
				properties:
					opacity: 1
				time: 0.2
			hint.once 'end', ->
				hint.animate
					properties:
						opacity: 0
					curve: 'linear'
					time: 0.8
				hint.once 'end', ->
					hint.destroy()