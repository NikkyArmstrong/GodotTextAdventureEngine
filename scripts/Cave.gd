extends Room

class_name Cave

var numberOfTries = 0;

func _init():
	lookAtText = "You are in a maze of twisty little passages, all alike"
	roomName = "Cave"

func lookAt():
	if numberOfTries < 4:
		return lookAtText;
	else:
		return "You made it through the super difficult maze!"

func canMove(direction):
	numberOfTries += 1;
	if direction.nocasecmp_to("south") == 0 or direction.nocasecmp_to("s") == 0:
		return true;
	elif numberOfTries == 4:
		emit_signal("score_increase", 20)
		return true
	else:
		return false

func stuckInRoomMessage():
	return lookAt()
