extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var health_threshold = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_health(current_health):
	if current_health >= health_threshold:
		visible = true
	else:
		visible = false
