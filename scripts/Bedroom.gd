extends Room

class_name Bedroom

var lightOn = false

var graham = Item.new(true, true, "cap and tunic", "A kingly tunic and cap with a feather in it", "You look great, Ty of Daventry");
var roger = Item.new(true, true, "janitor's outfit", "An outfit fit for a King...of cleaning space toilets", "You look great, Ty Wilco");
var arthur = Item.new(true, true, "dressing gown", "A comfy dressing gown", "You look great, Ty Dent");
var pirate = Item.new(true, true, "pirate costume", "A not very convincing pirate outfit", "Do you wannabe a pirate, Tybrush Threepwood?");

# Called when the node enters the scene tree for the first time.
func _init():
	objects.push_back(Item.new(false, false, "calendar", "The calendar shows it is the most Christmassy of days,\nthe 17th of December", ""))
	objects.push_back(Item.new(true, false, "lamp", "A standard adventurer's lamp", ""))
	objects.push_back(Item.new(false, false, "wardrobe", "Your wardrobe. All your clothes are in here.", ""))
	lookAtText = "You awake in your bedroom from a deep sleep.\nIt's pitch black and you find it hard to see"
	roomName = "Bedroom"

func lookAt():
	if lightOn:
		return .lookAt()
	else:
		return lookAtText

func parseRoomSpecificText(input):
	if input.nocasecmp_to("turn on light") == 0:
		lookAtText = "You are in your bedroom.\nIn the light you can see that you are wearing your pyjamas\nand the floor is a mess"
		emit_signal("score_increase", 10)
		lightOn = true
		return lookAt()
	if input.nocasecmp_to("open wardrobe") == 0:
		emit_signal("score_increase", 10)
		objects.push_back(graham)
		objects.push_back(roger)
		objects.push_back(arthur)
		objects.push_back(pirate)
		return "You open your wardrobe and \n" + listObjects()
		
	return "I don't know what you mean"

func canParse():
	return lightOn

func blockedMessage():
	return "You can't see anything in the dark!"

func canMove(direction):
	return wearingClothes;
	
func stuckInRoomMessage():
	return "You can't leave while you're wearing pyjamas!\nWhat will people think!"
