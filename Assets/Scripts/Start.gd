extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_game
signal how_to
signal quit_game
export (PackedScene) var QuitScene
var quit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func start_game():
	print("start game!")
	emit_signal("start_game")


func how_to():
	print("how do I play?")
	emit_signal("how_to")


func cancel_quit():
	remove_quit()
	enable_menu()


func confirm_quit():
	print("I call it quits!")
	emit_signal("quit_game")


func init_quit():
	disable_menu()
	quit = QuitScene.instance()
	quit.connect("quit", self, "confirm_quit")
	quit.connect("cancel_quit", self, "cancel_quit")
	quit.position = Vector2(224, 168)
	add_child(quit)


func remove_quit():
	if quit:
		quit.queue_free()


func quit_attempt():
	init_quit()


func disable_menu():
	$StartButton.disabled = true
	$HowToButton.disabled = true
	$QuitButton.disabled = true
	

func enable_menu():
	$StartButton.disabled = false
	$HowToButton.disabled = false
	$QuitButton.disabled = false
