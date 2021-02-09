extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var constants
var player_state
var states
var accept_input
var game_over
export var speed = 120
export var testing = false
var speed_factor

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over = false
	speed_factor = 1.0
	accept_input = false
	constants = get_node("/root/Constants")
	init_states()
	player_state = constants.STATE_RUNNING
	perform_action()


func init_states():
	states = {
		constants.STATE_RUNNING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_RUN,
			constants.STATE_PARAM_COLLISION: $StandingCollision,
			constants.STATE_PARAM_ALLOW_ACTION: true,
			constants.STATE_PARAM_SPEED_FACTOR: [1.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: false
		},
		constants.STATE_FALLING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_FALL,
			constants.STATE_PARAM_NEXT: constants.STATE_CATCHING_BREATH,
			constants.STATE_PARAM_COLLISION: $FallenCollision,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [3.5, 0.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: true
		},
		constants.STATE_LIFTING_OFF: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_LIFT_OFF,
			constants.STATE_PARAM_NEXT: constants.STATE_JUMPING,
			constants.STATE_PARAM_COLLISION: $StandingCollision,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [1.0, 1.25],
			constants.STATE_PARAM_FRAMERATE_FIXED: false
		},
		constants.STATE_JUMPING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_JUMP,
			constants.STATE_PARAM_NEXT: constants.STATE_LANDING,
			constants.STATE_PARAM_COLLISION: $JumpingCollision,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [1.25],
			constants.STATE_PARAM_FRAMERATE_FIXED: true
		},
		constants.STATE_LANDING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_LAND,
			constants.STATE_PARAM_NEXT: constants.STATE_RUNNING,
			constants.STATE_PARAM_COLLISION: $StandingCollision,
			constants.STATE_PARAM_TRANSITION: true,
			constants.STATE_PARAM_ALLOW_ACTION: true,
			constants.STATE_PARAM_SPEED_FACTOR: [1.25, 1.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: false
		},
		constants.STATE_RAISING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_RAISE,
			constants.STATE_PARAM_NEXT: constants.STATE_RUNNING,
			constants.STATE_PARAM_COLLISION: $CrouchingCollision,
			constants.STATE_PARAM_TRANSITION: true,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [0.0, 1.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: true
		},
		constants.STATE_CATCHING_BREATH: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_CATCH_BREATH,
			constants.STATE_PARAM_NEXT: constants.STATE_RECOVERING,
			constants.STATE_PARAM_COLLISION: $FallenCollision,
			constants.STATE_PARAM_TRANSITION: true,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [0.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: true,
			constants.STATE_PARAM_FINAL_ON_GAME_OVER: true
		},
		constants.STATE_RECOVERING: {
			constants.STATE_PARAM_ANIMATION: constants.ANIMATION_RECOVER,
			constants.STATE_PARAM_NEXT: constants.STATE_RAISING,
			constants.STATE_PARAM_COLLISION: $FallenCollision,
			constants.STATE_PARAM_TRANSITION: true,
			constants.STATE_PARAM_ALLOW_ACTION: false,
			constants.STATE_PARAM_SPEED_FACTOR: [0.0],
			constants.STATE_PARAM_FRAMERATE_FIXED: true
		}
	}


func start_action(new_state, forced):
	if accept_input and (is_state_action_allowed(player_state) or forced):
		player_state = new_state
		perform_action()
	else:
		print("the messenger is busy!")


func update_state(action):
	var state = get_state(null)
	var player_action = get_state_animation(state)
	if action == player_action and get_next_state(state):
		player_state = get_next_state(state)
		perform_action()
	#code for testing only
	elif testing:
		player_state = choose_random_state()
		perform_action()


func perform_action():
	enable_collision()
	if is_state_framerate_fixed(null):
		$Messenger.speed_scale = 1.0
	else:
		$Messenger.speed_scale = speed_factor
	$Messenger.play(get_state_animation(null))


func get_state(state):
	if state:
		return states[state]
	else:
		return states[player_state]


func get_next_state(state):
	if !state:
		state = get_state(null)
		
	if constants.STATE_PARAM_NEXT in state:
		if game_over and constants.STATE_PARAM_FINAL_ON_GAME_OVER in state and \
				state[constants.STATE_PARAM_FINAL_ON_GAME_OVER]:
			return null
		else:
			return state[constants.STATE_PARAM_NEXT]
	else:
		return null


func get_state_animation(state):
	if !state:
		state = get_state(null)
	return state[constants.STATE_PARAM_ANIMATION]


func get_state_collision(state):
	if !state:
		state = get_state(null)
	return state[constants.STATE_PARAM_COLLISION]


func is_state_transition(state):
	var transition = false
	var new_state = get_state(state)
		
	if constants.STATE_PARAM_TRANSITION in new_state:
		transition = new_state[constants.STATE_PARAM_TRANSITION]
		
	return transition


func is_state_action_allowed(state):
	var action_allowed = false
	var new_state = get_state(state)
		
	if constants.STATE_PARAM_ALLOW_ACTION in new_state:
		action_allowed = new_state[constants.STATE_PARAM_ALLOW_ACTION]
		
	return action_allowed


func is_state_framerate_fixed(state):
	var framerate_fixed = false
	var new_state = get_state(state)
		
	if constants.STATE_PARAM_FRAMERATE_FIXED in new_state:
		framerate_fixed = new_state[constants.STATE_PARAM_FRAMERATE_FIXED]
		
	return framerate_fixed


func get_speed_factor(state):
	var result = 1
	if !state:
		state = get_state(null)
	var animation_speed_factor = state[constants.STATE_PARAM_SPEED_FACTOR]
	if len(animation_speed_factor) == 1:
		result = animation_speed_factor[0]
	else:
		result = animation_speed_factor[0] + (animation_speed_factor[1] - \
				animation_speed_factor[0]) * $Messenger.get_animation_progress()
		
	return result


#code for testing only
func choose_random_state():
	var available_states = states.keys()
	var random_state = null
	while !random_state:
		randomize()
		var state_index = randi()%len(available_states)
		var state = available_states[state_index]
		if !is_state_transition(state):
			random_state = state
	
	return random_state


func enable_collision():
	#disable all collisions
	$CrouchingCollision.set_deferred("disabled", true)
	$FallenCollision.set_deferred("disabled", true)
	$JumpingCollision.set_deferred("disabled", true)
	$StandingCollision.set_deferred("disabled", true)
	get_state_collision(null).set_deferred("disabled", false)


func get_speed():
	return speed * get_speed_real()


func get_speed_real():
	return get_speed_factor(get_state(player_state))
