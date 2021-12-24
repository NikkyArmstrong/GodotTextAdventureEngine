extends Node

class_name RoomDriver

signal score_increase(amount)
signal game_win

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentRoom = null;
var rooms = []

var Bedroom = load("res://scripts/Bedroom.gd")

# Called when the node enters the scene tree for the first time.
func _init():
	# create rooms
	var bedroom = Bedroom.new();
	rooms.push_back(bedroom)
	bedroom.connect("score_increase", self, "increaseScore")
	
	var outside = Outside.new()
	rooms.push_back(outside)
	var gravelPath = GravelPath.new()
	rooms.push_back(gravelPath)
	
	var river = River.new()
	rooms.push_back(river)
	river.connect("score_increase", self, "increaseScore")
	
	bedroom.west = outside
	outside.east = bedroom
	
	outside.north = gravelPath
	gravelPath.south = outside
	
	gravelPath.east = river
	river.west = gravelPath
	
	var cave = Cave.new()
	rooms.push_back(cave)
	cave.connect("score_increase", self, "increaseScore")
	
	gravelPath.north = cave
	cave.south = gravelPath
	
	var dragonDen = DragonDen.new();
	dragonDen.connect("score_increase", self, "increaseScore")
	dragonDen.connect("game_win", self, "gameWin")
	rooms.push_back(dragonDen)
	
	cave.north = dragonDen
	cave.east = dragonDen
	cave.south = dragonDen
	
	dragonDen.south = cave
	
	currentRoom = bedroom;

func startRooms():
	return currentRoom.lookAt();

func move(direction):
	if !currentRoom.canMove(direction):
		return currentRoom.stuckInRoomMessage();
	
	var nextRoom = currentRoom.move(direction)
		
	if nextRoom == null:
		return "You can't go that way";
	else:
		currentRoom = nextRoom;
		return nextRoom.lookAt();

func increaseScore(amount):
	emit_signal("score_increase", amount)

func wearingFish(fish):
	for r in rooms:
		r.wearingFish = fish

func gameWin():
	emit_signal("game_win")
