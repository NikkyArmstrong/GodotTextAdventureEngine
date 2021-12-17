extends Room

class_name Outside
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	objects.push_back(Item.new(true, false, "junk mail", "A bunch of junk leaflets", ""))
	lookAtText = "You are standing on your front porch. A path runs to the North."
	roomName = "Porch"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
