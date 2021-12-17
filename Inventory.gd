extends Node

class_name Inventory

signal score_increase(amount)
signal wearing_clothes
signal wearing_fish

var inventory = []

# Called when the node enters the scene tree for the first time.
func _init():
	pass # Replace with function body.

func listInventory():
	var inventoryList = "You are holding: \n"
	
	if inventory.size() == 0:
		inventoryList += "nothing"
	
	for i in inventory:
		inventoryList += i.itemName + "\n"
		
	return inventoryList

func hasObject(objectName):
	for o in inventory:
		if o.itemName.nocasecmp_to(objectName) == 0:
			return true
	return false

func removeObject(objectName):
	var foundObject;
	for i in inventory:
		if i.itemName.nocasecmp_to(objectName) == 0:
			foundObject = i
			break
	
	inventory.erase(foundObject)
	return foundObject
	
func addObject(object):
	inventory.push_back(object)
	
func wearObject(object):
	for o in inventory:
		if o.itemName.nocasecmp_to(object) == 0:
			if o.canWear:
				if o.itemName == "babel fish":
					emit_signal("score_increase", 20)
					emit_signal("wearing_fish")
				else:
					emit_signal("score_increase", 10)
					emit_signal("wearing_clothes")
				return o.wearText
			else:
				return "You'd look silly wearing that"
