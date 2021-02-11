extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var StartScene
export (PackedScene) var GameScene
export (PackedScene) var HowToScene
export var background_music = false
var start
var game
var how_to
var high_score
var constants


# Called when the node enters the scene tree for the first time.
func _ready():
	constants = get_node("/root/Constants")
	init_high_score()
	init_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func init_start():
	start = StartScene.instance()
	start.connect("start_game", self, "start_game")
	start.connect("how_to", self, "how_to_play")
	start.connect("quit_game", self, "quit")
	add_child(start)
	start.update_high_score(high_score)
	if !$Theme.playing and background_music:
		$Theme.play()


func remove_start():
	if start:
		start.queue_free()


func init_game():
	if $Theme.playing:
		$Theme.stop()

	game = GameScene.instance()
	game.connect("game_over", self, "back_to_start")
	game.high_score = high_score
	add_child(game)


func remove_game():
	if game:
		game.queue_free()


func init_how_to():
	how_to = HowToScene.instance()
	how_to.connect("back_to_start", self, "back_to_start")
	add_child(how_to)


func remove_how_to():
	if how_to:
		how_to.queue_free()


func how_to_play():
	remove_start()
	init_how_to()


func start_game():
	remove_start()
	init_game()


func back_to_start(distance = 0):
	if distance > high_score:
		update_high_score(distance)
		
	remove_game()
	remove_how_to()
	init_start()


func quit():
	get_tree().quit()


func init_high_score():
	var data_file = File.new()
	if data_file.file_exists(constants.DATA_FILE):
		data_file.open(constants.DATA_FILE, File.READ)
		var data = parse_json(data_file.get_line())
		high_score = data[constants.DATA_HIGH_SCORE]
		data_file.close()
	else:
		high_score = 0


func update_high_score(distance):
	high_score = distance
	var data_file = File.new()
	data_file.open(constants.DATA_FILE, File.WRITE)
	var data = {constants.DATA_HIGH_SCORE: high_score}
	data_file.store_line(to_json(data))
	data_file.close()
