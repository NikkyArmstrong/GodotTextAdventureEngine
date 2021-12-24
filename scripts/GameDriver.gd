extends Node

enum GameState {
	WELCOME,
	COPY_PROTECTION,
	RUNNING,
	WON
}

var gameState = GameState.WELCOME;

# Declare member variables here. Examples:
onready var textEditNode = get_node("InputTextBox/TextEdit")
onready var titleBarNode = get_node("TitleBar")
onready var textStoreNode = get_node("TextVariables")

signal score_increase(amount)
signal game_win

var yesWillKillDragon = false;
var yesResponse = null;
var noResponse = null;
var winOnce = false

onready var roomDriver = RoomDriver.new();
onready var inventory = Inventory.new();
onready var parser = Parser.new();

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Print the welcome message to the user
	titleBarNode.currentRoom = "Welcome!"
	textEditNode.outputText(textStoreNode.introText)
	textEditNode.outputText("Press Enter to Start")
	
	roomDriver.connect("score_increase", self, "increaseScore")
	roomDriver.connect("game_win", self, "gameWin")
	inventory.connect("score_increase", self, "increaseScore")
	inventory.connect("wearing_clothes", self, "wearingClothes")
	inventory.connect("wearing_fish", self, "wearingFish")

func _input(event):
	if !event.is_action_pressed("ui_accept"):
		return
	
	var userInput = textEditNode.getCurrentLine()
	textEditNode.newLine()
	
	if gameState == GameState.WELCOME:
		textEditNode.outputText(textStoreNode.welcomeText)
		textEditNode.newLine()
		textEditNode.outputText(textStoreNode.copyProtectionText)
		titleBarNode.currentRoom = "Copy Protection"
		gameState = GameState.COPY_PROTECTION;
	elif gameState == GameState.COPY_PROTECTION:
		var passed = checkCopyProtection(userInput)
		if passed:
			gameState = GameState.RUNNING;
			textEditNode.outputText("You're in!")
			textEditNode.outputText(roomDriver.startRooms());
		else:
			textEditNode.outputText("How can I be sure you're you?")
	elif gameState == GameState.RUNNING:
		parseInput(userInput)
		titleBarNode.moves += 1
	
	textEditNode.insertPrompt()

func _process(_delta):
	if gameState == GameState.WON and winOnce:
		textEditNode.outputText("You won the game!")
		var winText = "You finished the game with a score of %d" % titleBarNode.score
		winText += " in %d moves" % titleBarNode.moves
		textEditNode.outputText(winText)
		winOnce = false
		
	if gameState == GameState.RUNNING:
		titleBarNode.currentRoom = roomDriver.currentRoom.roomName

func checkCopyProtection(copyInput):
	return copyInput == textStoreNode.copyProtectionAnswer;

func parseInput(input):
	input = input.to_lower();
	
	if parser.isDirection(input):
		var output = roomDriver.move(input)
		textEditNode.outputText(output)
	elif parser.isYesNo(input):
		parseYesNo(input)
	elif parser.isCommand(input):
		parser.parseCommand(input, textEditNode)
	else:
		parseComplexInput(input)

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
		if words[0] in parser.verbs:
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
	var merry = """███╗   ███╗███████╗██████╗ ██████╗ ██╗   ██╗
	 ████╗ ████║██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
	 ██╔████╔██║█████╗  ██████╔╝██████╔╝ ╚████╔╝ 
	 ██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝  
	 ██║ ╚═╝ ██║███████╗██║  ██║██║  ██║   ██║   
	 ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   \n\n""";
	
	var christmas = """      ██████╗██╗  ██╗██████╗ ██╗███████╗████████╗███╗   ███╗ █████╗ ███████╗██╗
	 ██╔════╝██║  ██║██╔══██╗██║██╔════╝╚══██╔══╝████╗ ████║██╔══██╗██╔════╝██║
	 ██║     ███████║██████╔╝██║███████╗   ██║   ██╔████╔██║███████║███████╗██║
	 ██║     ██╔══██║██╔══██╗██║╚════██║   ██║   ██║╚██╔╝██║██╔══██║╚════██║╚═╝
	 ╚██████╗██║  ██║██║  ██║██║███████║   ██║   ██║ ╚═╝ ██║██║  ██║███████║██╗
	  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝""";
	
	return merry + christmas;

func printHelpText():
	textEditNode.outputText(textStoreNode.helpResponse)

func increaseScore(score):
	titleBarNode.score += score

func wearingClothes():
	roomDriver.currentRoom.wearingClothes(true)
	
func wearingFish():
	roomDriver.wearingFish(true)

func gameWin():
	gameState == GameState.WON
	winOnce = true
