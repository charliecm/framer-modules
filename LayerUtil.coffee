# Layer Utilities v0.0.2
# By @charliecm

# Selects all sublayers by name recursively.
# @param {Layer} layer Target layer.
# @param {String} string Search string.
# @param {boolean} [ignoreCase] Ignore case in search.
# @param {Array} [layers] Layers array to append to.
# @return {Array} Layers with string in their name.
exports.selectAll = (layer, string, ignoreCase, layers) ->
	if !layers
		layers = []
	for layer in layers.descendants
		name = layer.name
		if ignoreCase
			name = name.toLowerCase()
			string = string.toLowerCase()
		if (name.indexOf(string) > -1)
			layers.push(layer)
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

# Set ignore events to a layer and its descendants.
# @param {Layer} layer Layer to apply to.
# @param {boolean} ignore Ignore events value.
# @param {Array} [exclude] Layers to exclude.
exports.setIgnoreEvents = (layer, ignore = true, exclude = []) ->
	layer.ignoreEvents = ignore
	for layer in layer.descendants
		isExcluded = false
		for excluded in exclude
			if layer == excluded
				isExcluded = true
		if !isExcluded
			layer.ignoreEvents = ignore