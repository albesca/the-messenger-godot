extends "res://Assets/Scripts/WorldObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func player_hit(_area):
	print("obstacle: player entered area")
	$ObjectCollision.set_deferred("disabled", true)
	emit_signal("player_hit")
