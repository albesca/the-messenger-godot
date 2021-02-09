extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal quit
signal cancel_quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func quit():
	emit_signal("quit")


func cancel_quit():
	emit_signal("cancel_quit")
