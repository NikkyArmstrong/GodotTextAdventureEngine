extends TextEdit


# Declare member variables here. Examples:
var prompt = ">";
var promptLine = 0;
var updatePrompt = false;
var currentLine = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor_set_line(currentLine)
	insertPrompt()
	grab_focus()

func _process(delta):
	if updatePrompt:
		cursor_set_line(promptLine)
		cursor_set_column(1)
		updatePrompt = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var userInput = get_line(cursor_get_line());
		var toParse = userInput.split(prompt)[1]
		newLine()
		insert_text_at_cursor(toParse)
		newLine()
		newLine()
		insertPrompt()

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
