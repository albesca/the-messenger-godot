extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal back_to_start


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func back_to_start():
	print("going back to start menu")
	emit_signal("back_to_start")
