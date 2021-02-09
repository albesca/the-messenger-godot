extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var constants
var distance

# Called when the node enters the scene tree for the first time.
func _ready():
	constants = get_node("/root/Constants")
	update_label(0.0)


func update_label(new_distance):
	distance = new_distance
	text = constants.DISPLAY_DISTANCE_FORMAT % [distance, \
			constants.DISPLAY_DISTANCE_UNIT]
