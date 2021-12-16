extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0;
var moves = 0;
var currentRoom = "West of House";

# Called when the node enters the scene tree for the first time.
func _ready():
	var scoreText = "Score: %d" % score
	get_node("Score").set_text(scoreText)
	
	var moveText = "Moves: %d" % moves
	get_node("Moves").set_text(moveText)

	get_node("Room").set_text(currentRoom)
