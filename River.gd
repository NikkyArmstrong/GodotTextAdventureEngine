extends Room

class_name River

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var blockedGround = false
var gotFish = false

# Called when the node enters the scene tree for the first time.
func _init():
	objects.push_back(Item.new(false, false, "vending machine", "You can't tell what it vends. It has a large button.", ""))
	objects.push_back(Item.new(false, false, "glowing button", "There is a big glowing button on the vending machine.\nPress it press it! You know you want to!", ""))
	lookAtText = "You are standing by a majestic flowing river. Its a dead end.\nFor some reason the council though this was the perfect\nplace to leave a vending machine."
	roomName = "River"

func parseRoomSpecificText(input):
	if input.nocasecmp_to("press button") == 0 or input.nocasecmp_to("press glowing button") == 0:
		if gotFish:
			return "The vending machine looks broken. You broke it."
		elif !blockedGround:
			return "You press the button.\nYou watch as a fish flies out of the vending machine,\nbounces once on the ground, and flies into the river\nto live out the rest of its happy life."
		else:
			objects.push_back(Item.new(true, true, "babel fish", "The fish is lying comfortably on top of the junk mail", "You place the babel fish in your ear. Squelch."))
			gotFish = true
			return "You press the button.\nYou watch as the fish flies out of the vending machine\nand lands on the junk mail, perfectly arresting its movement"
	if input.nocasecmp_to("put junk mail on ground") == 0:
		blockedGround = true
		emit_signal("score_increase", 15)
		return "You place the junk mail on the ground\nin front of the vending machine"
		
	return "I don't know what you mean"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
