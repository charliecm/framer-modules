# Framer Modules

A personal collection of utility modules for [Framer](http://framerjs.com/).

## Hint

Provides a way to manage sets of hints to show what's interactable on screen. This module allows finer control of when hints should be displayed instead of relying on Framer's automated implementation.

    Hint = require 'Hint'
    Hint.addSet('home', [layerA, layerB])
    Hint.switchSet('home')

## LayerUtils

Provides useful utility functions for working with layers.

    LayerUtils = require 'LayerUtils'
    LayerUtils.restoreImportedNames(sketch)
    LayerUtils.selectByPath(screenLayer, 'header/btnBack/icon')
    LayerUtils.selectAll(screenLayer, 'icon')
    LayerUtils.createWrapper(layer)
    LayerUtils.superimpose(layerA, layerB)
