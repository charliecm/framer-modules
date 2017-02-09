# Layer Utilities v0.0.1
# By @charliecm

# Selects all sublayers by name recursively.
# @param {Layer} layer Target layer.
# @param {String} string Search string.
# @param {boolean} [ignoreCase] Ignore case in search.
# @param {Array} [layers] Layers to append to.
# @return {Array} Layers with string in their name.
exports.selectAll = (layer, string, ignoreCase, layers) ->
	if !layers
		layers = []
	for layer in this.subLayers
		name = layer.name
		if ignoreCase
			name = name.toLowerCase()
			string = string.toLowerCase()
		if (name.indexOf(string) > -1)
			layers.push(layer)
		this.select(string, ignoreCase, layers)
	return layers

# Selects a sublayer by path.
# @param {String} path Layer path.
# @param {String} delimeter Path delimeter.
# @return {Layer} Sublayer.
exports.selectByPath = (path = '', delimeter = '/') ->
  names = path.split(delimeter)
  layers = this.subLayersByName(names.shift() || '')
  if (layers.length && names.length)
    path = names.join(delimeter)
    return layers[0].selectByPath(path, delimeter)
  else
    return layers[0] || false

# Superimposes a layer onto another layer.
# @param {Layer} src Source layer.
# @param {Layer} dest Destination layer.
exports.superimpose = (src, dest) ->
	src.x = dest.x
	src.y = dest.y
	src.width = dest.width
	src.height = dest.height
	if dest.superLayer
		src.superLayer = dest.superLayer

# Shortcut for setting layer states with animation options.
# @param {Layer} layer Target layer.
# @param {Object} animationOptions State animation options.
# @param {Object} defaultState Overrides layer.state.default.
# @param {Array} states Additional states.
exports.setStates = (layer, animationOptions, defaultState, states) ->
	layer.states.animationOptions = animationOptions
		if defaultState
			layer.states.default = defaultState
			layer.states.switchInstant 'default'
		if states
			layer.states.add states
