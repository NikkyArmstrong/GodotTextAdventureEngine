extends Node

class_name Parser

var verbs = ["take", "get", "kill", "hit", "wear", "look", "jump", "steal", "drop", "put"]

var commands = ["help", "quit", "exit", "hello", "inventory", "i"]

var directions = ["north", "n", "south", "s", "east", "e", "west", "w"]

var yesno = ["yes", "no", "y", "n"]

func isDirection(testInput):
	return testInput in directions
	
func isCommand(testInput):
	return testInput in commands

func isVerb(testInput):
	return testInput in verbs

func isYesNo(testInput):
	return testInput in yesno

func parseCommand(input, textEditNode):
	if input.nocasecmp_to("inventory") == 0 or input.nocasecmp_to("i") == 0:
		textEditNode.outputText(inventory.listInventory());
	elif input.nocasecmp_to("help") == 0:
		printHelpText()
	elif input.nocasecmp_to("hello") == 0:
		textEditNode.outputText("Hello Everyone!")
	elif input.nocasecmp_to("quit") == 0 or input.nocasecmp_to("exit") == 0:
		get_tree().quit()
