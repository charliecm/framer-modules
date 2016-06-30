# Layer Helper Functions
# by @charliecm

# Gets all sublayers by name recursively
Layer.prototype.select = (string, isCaseInsensitive, layers) ->
	if !layers
		layers = []
	for layer in this.subLayers
		name = layer.name
		if isCaseInsensitive
			name = name.toLowerCase()
			string = string.toLowerCase()
		if (name.indexOf(string) > -1)
			layers.push(layer)
		this.select(string, isCaseInsensitive, layers)
	return layers

# Get sublayer by path
Layer.prototype.selectByPath = (path = '', delimeter = '/') ->
  names = path.split(delimeter)
  layers = this.subLayersByName(names.shift() || '')
  if (layers.length && names.length)
    path = names.join(delimeter)
    return layers[0].selectByPath(path, delimeter)
  else
    return layers[0] || false

Layer.prototype.superimpose = (layer) ->
	this.x = layer.x
	this.y = layer.y
	this.width = layer.width
	this.height = layer.height
	if layer.superLayer
		this.superLayer = layer.superLayer

# Resets the default state of a layer
exports.resetDefaultState = (layer) ->
	props = _.extend {}, layer._properties,
		image: ''
	layer.states.add
		default: props

# Add button click states to layer
exports.makeButton = (layer, isInstant, inactiveState, activeState) ->
	inactive = inactiveState || 'default'
	active = activeState || 'active'
	layer.on Events.MouseDown, ->
		if isInstant
			layer.states.switchInstant active
		else
			layer.states.switch active
	layer.on Events.MouseUp, ->
		if isInstant
			layer.states.switchInstant inactive
		else
			layer.states.switch inactive

# Returns an object of layers from an object of paths using selectByPath()
exports.getLayersFromPaths = (targetLayer, paths) ->
	layers =
		target: targetLayer
	for name, path of paths
		layers[name] = targetLayer.selectByPath(path) || ''
	return layers