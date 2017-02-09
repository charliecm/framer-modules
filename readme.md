# Framer Modules

A personal collection of utility modules for [Framer](http://framerjs.com/).

## Hint

Provides a way to manage sets of hints to show what is interactable on screen. This module allows finer control of when hints should be displayed instead of relying on Framer's automatic implementation.

    Hint = require 'Hint'
    Hint.addSet('home', [layerA, layerB])
    Hint.switchSet('home')

## LayerUtil

Provides useful utility functions for dealing with layers.

    LayerUtil = require 'LayerUtil'
    LayerUtil.selectByPath(screenLayer, 'header/btnBack/icon')
    LayerUtil.selectAll(screenLayer, 'icon')
    LayerUtil.superimpose(layerA, layerB)
