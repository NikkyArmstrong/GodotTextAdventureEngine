extends TextEdit


# Declare member variables here. Examples:
var prompt = ">";
var promptLine = 0;
var updatePrompt = false;
var currentLine = 0;

var gameRunning = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if updatePrompt:
		cursor_set_line(promptLine)
		cursor_set_column(1)
		updatePrompt = false

func setGameRunning(running):
	gameRunning = running

func outputText(textToOutput):
	insert_text_at_cursor(textToOutput)
	newLine()
	newLine()

func getCurrentLine():
	var input = get_line(cursor_get_line());
	return input.split(prompt)[1]

func _input(event):
# Consume all navigation attempts
	if event.is_action_pressed("ui_up") or \
	   event.is_action_pressed("ui_down") or \
	   event.is_action_pressed("ui_left") or \
	   event.is_action_pressed("ui_right") or \
	   event.is_action_pressed("ui_page_up") or \
	   event.is_action_pressed("ui_page_down") or \
	   event.is_action_pressed("ui_select"):
		accept_event()
		pass

func insertPrompt():
	insert_text_at_cursor(prompt)
	promptLine = cursor_get_line()
	updatePrompt = true

func newLine():
	insert_text_at_cursor("\n")
