extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal action_complete(action)
var constants
var animations


# Called when the node enters the scene tree for the first time.
func _ready():
	constants = get_node("/root/Constants")
	init_animations()
	#play_random()


func init_animations():
	animations = [constants.ANIMATION_FALL, constants.ANIMATION_JUMP, 
			constants.ANIMATION_JUMP, constants.ANIMATION_RUN, 
			constants.ANIMATION_RUN, constants.ANIMATION_RUN]


func play_random():
	randomize()
	var animation_index = randi()%len(animations)
	play(animations[animation_index])
	
	
func play_animation():
	print("current_animation finished, starting new one...")
	play_random()
	print("started new animation: " + animation)


func action_completed():
	emit_signal("action_complete", animation)


func get_animation_progress():
	var animation_lenght = frames.get_frame_count(animation)
	return (frame + 1.0) / animation_lenght
