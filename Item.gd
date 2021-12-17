extends Node

class_name Item
# Declare member variables here. Examples:
var canTake = false
var canWear = false
var itemName = ""
var lookAtText = ""
var wearText = ""
var score = 5

# Called when the node enters the scene tree for the first time.
func _init(take, wear, iName, lookAt, wearT):
	canTake = take
	canWear = wear
	itemName = iName
	lookAtText = lookAt
	wearText = wearT
