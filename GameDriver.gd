extends Node


# Declare member variables here. Examples:
onready var textEditNode = get_node("InputTextBox/TextEdit")
onready var titleBarNode = get_node("TitleBar")

signal score_increase(amount)
signal game_win

var gameStarted = false;
var playIntro = false;
var copyProtection = false;
var copyProtectionPassed = false;
var runOnce = true;
var yesWillKillDragon = false;
var yesResponse = null;
var noResponse = null;
var gameWinCondition = false
var winOnce = false

var verbs = ["take", "get", "kill", "hit", "wear", "look", "jump", "steal", "drop"]

var welcomeText = "Welcome to Ty's Colossal Secret Santa Cave Adventure Quest!\nYou will embark on an epic quest to retrieve your Secret Santa\npresent from the depths of a dark and mysterious cave.\nIt's said the present is guarded by a dragon.\nGood luck!";

var copyProtectionText = "Please enter the first and fifth words of your\nSecret Santa's gift message to you"

onready var roomDriver = RoomDriver.new();
onready var inventory = Inventory.new();

# Called when the node enters the scene tree for the first time.
func _ready():	
	var titleText = createTitle();
	# Print the welcome message to the user
	titleBarNode.currentRoom = "Welcome!"
	textEditNode.outputText(titleText)
	textEditNode.outputText("Press Enter to Start")
	
	roomDriver.connect("score_increase", self, "increaseScore")
	roomDriver.connect("game_win", self, "gameWin")
	inventory.connect("score_increase", self, "increaseScore")
	inventory.connect("wearing_clothes", self, "wearingClothes")
	inventory.connect("wearing_fish", self, "wearingFish")
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !gameStarted:
			gameStarted = true
			playIntro = true
		else:
			var userInput = textEditNode.getCurrentLine()
			textEditNode.newLine()
			parseInput(userInput)
			textEditNode.insertPrompt()
			titleBarNode.moves += 1

func _process(_delta):
	if playIntro:
		textEditNode.outputText(welcomeText)
		textEditNode.newLine()
		playIntro = false
		copyProtection = true
	elif copyProtection:
		textEditNode.outputText(copyProtectionText)
		textEditNode.insertPrompt()
		titleBarNode.currentRoom = "Copy Protection"
		copyProtection = false
	elif copyProtectionPassed and runOnce:
		textEditNode.setGameRunning(true)
		textEditNode.outputText(roomDriver.startRooms());
		textEditNode.insertPrompt()
		runOnce = false
	elif gameWinCondition and winOnce:
		textEditNode.outputText("You won the game!")
		var winText = "You finished the game with a score of %d" % titleBarNode.score
		winText += " in %d moves" % titleBarNode.moves
		textEditNode.outputText(winText)
		winOnce = false
		
	if gameStarted and copyProtectionPassed:
		titleBarNode.currentRoom = roomDriver.currentRoom.roomName

func parseInput(input):
	if !copyProtectionPassed:
		if input.nocasecmp_to("hey your") == 0:
			textEditNode.outputText("You're in!")
			copyProtectionPassed = true
			return
		else:
			textEditNode.outputText("How can I be sure you're Ty?")
			return
	
	if isDirection(input):
		var output = roomDriver.move(input)
		textEditNode.outputText(output)
	elif isYesNo(input):
		parseYesNo(input)
	elif input.nocasecmp_to("inventory") == 0 or input.nocasecmp_to("i") == 0:
		textEditNode.outputText(inventory.listInventory());
	elif input.nocasecmp_to("help") == 0:
		printHelpText()
	elif input.nocasecmp_to("hello") == 0:
		textEditNode.outputText("Hello Ty!")
	elif input.nocasecmp_to("who is my santa?") == 0:
		textEditNode.outputText("Do you really want to know?")
		yesResponse = "Your Secret Santa is Nikky!"
		noResponse = "Good choice! Keep it a secret."
	elif input.nocasecmp_to("quit") == 0 or input.nocasecmp_to("exit") == 0:
		get_tree().quit()
	else:
		parseComplexInput(input)

func isDirection(testInput):
	if testInput.nocasecmp_to("north") == 0 or testInput.nocasecmp_to("south") == 0 or \
		testInput.nocasecmp_to("east") == 0 or testInput.nocasecmp_to("west") == 0 or \
		testInput.nocasecmp_to("n") == 0 or testInput.nocasecmp_to("s") == 0 or \
		testInput.nocasecmp_to("e") == 0 or testInput.nocasecmp_to("w") == 0:
		return true;
	
	return false;

func isYesNo(yesNoInput):
	if yesNoInput.nocasecmp_to("yes") == 0 or yesNoInput.nocasecmp_to("y") == 0 or \
		yesNoInput.nocasecmp_to("no") == 0 or yesNoInput.nocasecmp_to("n") == 0:
		return true
	
	return false

func parseYesNo(yesNoToParse):
	if yesNoToParse.nocasecmp_to("yes") == 0 or yesNoToParse.nocasecmp_to("y") == 0:
		if yesResponse == null:
			textEditNode.outputText("Yes what?")
		else:
			textEditNode.outputText(yesResponse)
			yesResponse = null
			if yesWillKillDragon:
				roomDriver.currentRoom.killDragon()
	elif yesNoToParse.nocasecmp_to("no") == 0 or yesNoToParse.nocasecmp_to("n") == 0:
		if noResponse == null:
			textEditNode.outputText("No u")
		else:
			textEditNode.outputText(noResponse)
			noResponse = null

func parseComplexInput(complexInput):
	var words = complexInput.split(" ");
	if words.size() > 0:
		# see if the first word is a verb
		if words[0] in verbs:
			var verb = words[0]
			if verb.nocasecmp_to("jump") == 0:
				textEditNode.outputText("You jump until you are tired,\nbut it doesn't help you figure out what to do")
				return
				
			elif isInventoryWord(verb):
				textEditNode.outputText(parseInventoryWord(words))
				return
				
			elif isRoomWord(verb):
				textEditNode.outputText(parseRoomWord(words))
				return

		# special cases	
		elif complexInput.nocasecmp_to("put junk mail on ground") == 0:
			if !inventory.hasObject("junk mail"):
				textEditNode.outputText("You aren't holding the junk mail")
				return
			else:
				textEditNode.outputText(roomDriver.currentRoom.parseRoomSpecificText(complexInput))
				return
		else:
			#try to parse using the room logic
			textEditNode.outputText(roomDriver.currentRoom.parseRoomSpecificText(complexInput))
			return
	
	textEditNode.outputText("I don't know what you mean")

func isInventoryWord(inventoryWord):
	return inventoryWord.nocasecmp_to("wear") == 0 or inventoryWord.nocasecmp_to("drop") == 0;
	
func isRoomWord(roomWord):
	return roomWord.nocasecmp_to("take") == 0 or \
		roomWord.nocasecmp_to("get") == 0 or \
		roomWord.nocasecmp_to("steal") == 0 or \
		roomWord.nocasecmp_to("hit") == 0 or \
		roomWord.nocasecmp_to("kill") == 0 or \
		roomWord.nocasecmp_to("look") == 0;

func parseInventoryWord(words):
	var verb = words[0]
	words.remove(0)
	var object = PoolStringArray(words).join(" ");
	
	if object == "":
		return "%s what?" % verb
	
	if verb.nocasecmp_to("wear") == 0:
		if inventory.hasObject(object):
			return inventory.wearObject(object)
		else:
			return "You aren't holding that!"
	elif verb.nocasecmp_to("drop") == 0:
		if inventory.hasObject(object):
			var actualObject = inventory.removeObject(object)
			roomDriver.currentRoom.addObject(actualObject)
			return "You drop the %s" % object
		else:
			return "You aren't holding that!"

func parseRoomWord(words):
	var verb = words[0];
	words.remove(0)
	var object = PoolStringArray(words).join(" ");
	
	if !roomDriver.currentRoom.canParse():
		return roomDriver.currentRoom.blockedMessage()
	
	if verb.nocasecmp_to("take") == 0 or \
		verb.nocasecmp_to("get") == 0 or \
		verb.nocasecmp_to("steal") == 0:
			if object == "":
				return "%s what?" % verb
			elif roomDriver.currentRoom.hasObject(object):
				if roomDriver.currentRoom.canTakeObject(object):
					var actualObject = roomDriver.currentRoom.removeObject(object)
					
					increaseScore(actualObject.score)
					actualObject.score = 0
					inventory.addObject(actualObject)

					if object == "note":
						roomDriver.currentRoom.holdingNote()
						increaseScore(50)
					return "You take the %s" % object
				else:
					return "You cannot take the %s" % object
			else:
				return "You can't see a %s" % object
	elif verb.nocasecmp_to("look") == 0:
		if object == "":
			return roomDriver.currentRoom.lookAt()
		else:
			return roomDriver.currentRoom.lookAtObject(object)
	elif verb.nocasecmp_to("kill") == 0:
		if object == "":
			return "Maybe you should take a break?"
		elif object == "dragon":
			if roomDriver.currentRoom.hasObject("dragon"):
				yesResponse = "You killed the dragon! Weird that worked a second time."
				noResponse = "Listen, that's probably the smarter option."
				yesWillKillDragon = true
				return "With your bare hands?"
			else:
				return "That's a good idea, but the dragon isn't here"
		else:
			return roomDriver.currentRoom.killObject(object)
			

func createTitle():
	var tyName = "             _____     _     \n";
	tyName += "            |_   _|   ( )    \n";
	tyName += "              | |_   _|/ ___ \n";
	tyName += "              | | | | | / __|\n";
	tyName += "              | | |_| | \\__ \\ \n";
	tyName += "              \\_/\\__, | |___/\n";
	tyName += "                  __/ |      \n";
	tyName += "                 |___/       \n\n";
	
	var introText = "  _____                    _      _____             _        \n";
	introText += " / ____|                  | |    / ____|           | |       \n";
	introText += "| (___   ___  ___ _ __ ___| |_  | (___   __ _ _ __ | |_ __ _ \n";
	introText += " \\___ \\ / _ \\/ __| '__/ _ \\ __|  \\___ \\ / _` | '_ \\| __/ _` |\n";
	introText += " ____) |  __/ (__| | |  __/ |_   ____) | (_| | | | | || (_| |\n";
	introText += "|_____/ \\___|\\___|_|  \\___|\\__| |_____/ \\__,_|_| |_|\\__\\__,_|\n";
	
	return tyName + introText;

func printHelpText():
	var helpText = "Hello! If you are stuck, we're sorry.\nPlease ask your Secret Santa for help.\n";
	helpText += "If you have found a bug, congratulations!\nTry to find them all!\n"
	textEditNode.outputText(helpText)

func increaseScore(score):
	titleBarNode.score += score

func wearingClothes():
	roomDriver.currentRoom.wearingClothes(true)
	
func wearingFish():
	roomDriver.wearingFish(true)

func gameWin():
	gameWinCondition = true
	winOnce = true
