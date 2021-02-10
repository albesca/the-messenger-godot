extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const PLAYER_POSITION = Vector2(180, 300)
const OBSTACLE_STARTING_POSITION = Vector2(0, 254)
const TERRAIN_STARTING_POSITION = Vector2(0, 254)
signal game_over(distance)
export (PackedScene) var ObstacleScene
export (PackedScene) var PlayerScene
export (PackedScene) var TerrainScene
export (PackedScene) var GameOverScene
export var obstacle_frequency = 0.5
export var obstacle_distance = 120
export var speed_factor = 100.0
export var lives = 3
var constants
var player
var terrains
var obstacles
var screen_width
var obstacle_countdown = 0
var distance
var last_obstacle_hit
var landscape_fixed
var game_over
var high_score


# Called when the node enters the scene tree for the first time.
func _ready():
	landscape_fixed = true
	distance = 0.0
	last_obstacle_hit = distance
	screen_width = ProjectSettings.get_setting("display/window/size/width")
	constants = get_node("/root/Constants")
	init_player()
	init_terrain(TERRAIN_STARTING_POSITION)
	init_obstacles(OBSTACLE_STARTING_POSITION)
	update_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_player(delta)
	update_terrain(delta)
	update_obstacles(delta)
	update_distance(delta)
	if Input.is_action_just_pressed("action_jump"):
		print("the messenger is trying to jump")
		if player.accept_input:
			player.start_action(constants.STATE_LIFTING_OFF, false)
		else:
			print("the messenger is not ready yet!")


func init_player():
	player = PlayerScene.instance()
	player.position = PLAYER_POSITION - Vector2(300, 0)
	player.accept_input = false
	add_child(player)


func update_player(delta):
	if player.position.x < PLAYER_POSITION.x:
		var movement = Vector2(1, 0) * delta * get_speed(false)
		player.position += movement
	else:
		landscape_fixed = false
		player.accept_input = true
		
	player.speed_factor = get_speed_factor()


func update_terrain(delta):
	if !landscape_fixed:
		var max_terrain_position = 0
		var terrain_width = 0
		for terrain in terrains:
			terrain_width = terrain.get_size().x
			terrain.position -= Vector2(1, 0) * delta * get_speed(false)
			if terrain.position.x > max_terrain_position:
				max_terrain_position = terrain.position.x
				
			if terrain.position.x < 0 - terrain.get_size().x:
				terrain.queue_free()
				terrains.pop_front()
			
		if max_terrain_position < screen_width - terrain_width:
			init_terrain(Vector2(max_terrain_position + terrain_width, 
					TERRAIN_STARTING_POSITION.y))


func init_terrain(starting_position):
	if !terrains:
		terrains = []

	var position = starting_position
	while position.x < screen_width:
		var terrain = TerrainScene.instance()
		terrain.position = position
		position += Vector2(terrain.get_size().x, 0)
		add_child(terrain)
		terrains.append(terrain)


func update_obstacles(delta):
	if !landscape_fixed:
		var max_obstacle_position = 0
		var obstacle_width = 0
		for obstacle in obstacles:
			obstacle_width = obstacle.get_size().x
			obstacle.position -= Vector2(1, 0) * delta * get_speed(false)
			if obstacle.position.x > max_obstacle_position:
				max_obstacle_position = obstacle.position.x
				
			if obstacle.position.x < 0 - obstacle.get_size().x:
				obstacle.queue_free()
				obstacles.pop_front()
			
		if max_obstacle_position < screen_width - obstacle_width - \
				obstacle_distance or len(obstacles) == 0:
			init_obstacles(OBSTACLE_STARTING_POSITION)


func init_obstacles(starting_position):
	if !obstacles:
		obstacles = []
	
	randomize()
	var random_float = randf()
	if obstacle_countdown > 0:
		obstacle_countdown -= 1
	elif random_float < obstacle_frequency:
		var obstacle = ObstacleScene.instance()
		obstacle.position = starting_position + Vector2(screen_width, 0)
		add_child(obstacle)
		obstacle.connect("player_hit", self, "player_hit_obstacle")
		obstacles.append(obstacle)
		obstacle_countdown = obstacle_distance
	else:
		obstacle_countdown = obstacle_distance
	

func player_hit_obstacle():
	lives -= 1
	update_health()
	if lives == 0:
		process_game_over()
	else:
		last_obstacle_hit = distance
		player.start_action(constants.STATE_FALLING, true)


func update_distance(delta):
	if !player.game_over:
		distance += get_speed(true) * delta
		$Distance.update_label(distance)


func get_speed_factor():
	return 1.0 + (distance - last_obstacle_hit) / speed_factor


func get_speed(real):
	var player_speed
	if real:
		player_speed = player.get_speed_real()
	else:
		player_speed = player.get_speed()

	return get_speed_factor() * player_speed


func process_game_over():
	player.start_action(constants.STATE_FALLING, true)
	player.accept_input = false
	player.game_over = true
	game_over = GameOverScene.instance()
	var game_over_text
	var rounded_distance = stepify(distance, 0.1)
	if (rounded_distance > high_score) :
		game_over_text = constants.GAME_OVER_MESSAGE_NEW_RECORD
	else:
		game_over_text = constants.GAME_OVER_MESSAGE
		
	game_over.text = game_over_text % [rounded_distance, \
			constants.DISPLAY_DISTANCE_UNIT_FULL]
	add_child(game_over)
	yield(get_tree().create_timer(4.0), "timeout")
	emit_signal("game_over", rounded_distance)


func update_health():
	$Health.update_health(lives)
