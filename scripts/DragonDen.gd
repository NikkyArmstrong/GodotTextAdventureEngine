extends Room

class_name DragonDen
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _init():
	lookAtText = "You made it through the maze!\nYou have made it to the Dragon's Den. Your treasure awaits."
	roomName = "Dragon's Den"
	objects.push_back(Item.new(false, false, "treasure chest", "A chest that is surely full of all the dragon's treasure", ""))
	objects.push_back(Item.new(false, false, "dragon", "A huge, terrifying, fire-breathing dragon", ""))

func parseRoomSpecificText(input):
	if input.nocasecmp_to("open treasure chest") == 0:
		if !killedDragon:
			return "You should kill the dragon before it kills you"
		else:
			var winText = "You open the treasure chest. Your mind fills with anticipation.\nWill there be gold? Jewels? Shadowless Pokemon cards?\n"
			winText += "You look in the chest. Its...empty. Apart from a note."
			objects.push_back(Item.new(true, false, "note", "The note from inside the chest", ""))
			return winText
	if input.nocasecmp_to("read note") == 0:
		if !holdingNote:
			return "Take the note out first"
		else:
			emit_signal("game_win")
			return "The note reads: \nDear Dragon, Due to the ongoing Covid-19 situation, your\nshipment of unfathomable treasure has been delayed.\nWe apologise for any inconvenience caused.\nYou can track your parcel with the\ntracking number LH196792363AU.\nMerry Christmas from everyone here at Australia Post."
	else:
		return "I don't know what you mean"

func lookAt():
	if killedDragon:
		lookAtText = "You killed the dragon! There is a lifeless strangled dragon\ncorpse here. Nice work."
	else:
		lookAtText = "You made it through the maze!\nYou have made it to the Dragon's Den.\nYour treasure awaits, if only you could get past the dragon."

	return .lookAt()
	
func canMove(direction):
	return false

func stuckInRoomMessage():
	return "You can't leave without your present!"
