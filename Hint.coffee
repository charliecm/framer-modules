# Hint Module v0.0.1
# By @charliecm
# Shows hint overlays on tap to direct user on where to hit.

# Example:
# Hint = require 'Hint'
# Hint.addSet 'home', [layerA, layerB]
# Hint.switchSet 'home'

sets = {}
currentSet = ''
isDragging = false
isEnabled = true
defaultTint = 'rgba(52,152,219,0.75)'
fadeIn = 0.2
fadeOut = 0.8
layerOptions = {}

# Adds a hint set.
# @param {String} name Set name.
# @param {Array} set Layers for show hints for.
exports.addSet = (name, set) ->
	sets[name] = set || []

# Removes a hint set.
# @param {String} name Set name.
exports.removeSet = (name) ->
	delete sets[name]

# Switches hint set to display on tap.
# @param {String} name Set name.
exports.switchSet = (name) ->
	currentSet = name

# Sets default hint layer options.
# @param {Object} options Layer options.
exports.setLayerOptions = (options) ->
	layerOptions = options || {}

# Sets display transition timing.
# @param {number} inDuration Fade in duration.
# @param {number} outDuration Fade out duration.
exports.setTiming = (inDuration, outDuration) ->
	fadeIn = inDuration
	fadeOut = outDuration

# Enables hints.
exports.enable = ->
	isEnabled = true

# Disables hints.
exports.disable = ->
	isEnabled = false

# Initialize global interactions
do ->

	# Detect dragging
	document.addEventListener Events.TouchStart, ->
		isDragging = false
	document.addEventListener Events.TouchMove, ->
		isDragging = true

	# Bind show hint on tap event
	document.addEventListener Events.TouchEnd, (event) ->
		return if !isEnabled or isDragging # or isRushing
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
						backgroundColor: defaultTint
						opacity: 0
						ignoreEvents: true
						name: 'hint'
					, layerOptions
				hint = new Layer options
				hint.animate
					properties:
						opacity: 1
					time: fadeIn
				hint.once 'end', ->
					hint.animate
						properties:
							opacity: 0
						curve: 'linear'
						time: fadeOut
					hint.once 'end', ->
						hint.destroy()
