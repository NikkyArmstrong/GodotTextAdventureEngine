extends Room

class_name GravelPath
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var foughtPirate = false

# Called when the node enters the scene tree for the first time.
func _init():
	lookAtText = "You are walking along a gravel path.\nThere is a pirate here, babbling something.\nThe path continues to the north, but the pirate doesn't look\nlike she'll let you past. You can get around her to the east."
	roomName = "Gravel Path"
	objects.push_back(Item.new(false, false, "pirate", "She looks like she wants to fight,\nbut you can't understand what she is saying", ""))

func lookAt():
	if !wearingFish:
		lookAtText = "You are walking along a gravel path.\nThere is a pirate here, babbling something.\nThe path continues to the north, but the pirate doesn't look\nlike she'll let you past. You can get around her to the east."
	else:
		lookAtText = "You are walking along a gravel path.\nThere is a pirate here, and unfortunately you can now understand her.\nThe path continues to the north, but the pirate doesn't look\nlike she'll let you past. You can get around her to the east."
	return .lookAt()

func parseRoomSpecificText(input):
	if input.nocasecmp_to("talk pirate") == 0 or input.nocasecmp_to("talk to pirate") == 0:
		if wearingFish:
			return "She's yelling 'You fight like a dairy farmer!'"
		else:
			return "You have no idea what she's saying. Sounds mean though."
	if input.nocasecmp_to("how appropriate, you fight like a cow") == 0 or \
		input.nocasecmp_to("how appropriate. you fight like a cow") == 0 or \
		input.nocasecmp_to("how appropriate you fight like a cow") == 0:
			if wearingFish:
				foughtPirate = true
				return "Your cutting insult kills her where she stands"
			else:
				return "If only there was a way to be SURE that was the answer"
	return "I don't know what you mean"

func canMove(direction):
	if direction.nocasecmp_to("north") == 0 or direction.nocasecmp_to("n") == 0:
		return foughtPirate;
	else:
		return true
	
func stuckInRoomMessage():
	return "The pirate won't let you past"
