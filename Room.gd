extends Node

class_name Room

signal score_increase(amount)
signal game_win

var objects;
var lookAtText;
var north = null;
var south = null;
var east = null;
var west = null;
var roomName;
var wearingClothes = false;
var wearingFish = false;
var killedDragon = false
var holdingNote = false

func _init():
	objects = []
	lookAtText = "An empty room"
	roomName = "Room"

func lookAt():
	return lookAtText + "\n" + listObjects() + "\n" + listDirections()

func listObjects():
	var objectList = ""
	for i in objects:
		objectList += "You see a %s \n" % i.itemName
	return objectList
	
func listDirections():
	var directionList = ""
	if north != null:
		directionList += "To the north there is a %s \n" % north.roomName
	
	if south != null:
		directionList += "To the south there is a %s \n" % south.roomName
		
	if east != null:
		directionList += "To the east there is a %s \n" % east.roomName
		
	if west != null:
		directionList += "To the west there is a %s \n" % west.roomName
		
	return directionList

func move(direction):
	if direction.nocasecmp_to("north") == 0 or direction.nocasecmp_to("n") == 0:
		return north;
	elif direction.nocasecmp_to("east") == 0 or direction.nocasecmp_to("e") == 0:
		return east;
	elif direction.nocasecmp_to("south") == 0 or direction.nocasecmp_to("s") == 0:
		return south;
	elif direction.nocasecmp_to("west") == 0 or direction.nocasecmp_to("w") == 0:
		return west;
	else:
		return null;
		
func removeObject(objectName):
	var foundObject;
	for o in objects:
		if o.itemName.nocasecmp_to(objectName) == 0:
			foundObject = o
			break
	
	objects.erase(foundObject)
	return foundObject
	
func addObject(object):
	objects.push_back(object)
	
func parseRoomSpecificText(input):
	return "I don't know what you mean"

func canParse():
	return true

func blockedMessage():
	return ""

func hasObject(objectName):
	for o in objects:
		if o.itemName.nocasecmp_to(objectName) == 0:
			return true
	return false

func canTakeObject(objectName):
	for o in objects:
		if o.itemName.nocasecmp_to(objectName) == 0 and o.canTake:
			return true
	return false

func lookAtObject(objectName):
	for o in objects:
		if o.itemName.nocasecmp_to(objectName) == 0:
			return o.lookAtText
	return "You can't see a %s" % objectName

func canMove(direction):
	return true;
	
func stuckInRoomMessage():
	return ""

func wearingClothes(wearing):
	wearingClothes = wearing

func killObject(objectName):
	for o in objects:
		if o.itemName.nocasecmp_to(objectName) == 0:
			return "You can't kill the %s" % objectName
	
	return "You can't see that to kill it"

func killDragon():
	killedDragon = true

func holdingNote():
	holdingNote = true
