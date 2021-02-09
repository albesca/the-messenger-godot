extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var StartScene
export (PackedScene) var GameScene
export (PackedScene) var HowToScene
var start
var game
var how_to


# Called when the node enters the scene tree for the first time.
func _ready():
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


func remove_start():
	if start:
		start.queue_free()


func init_game():
	game = GameScene.instance()
	game.connect("game_over", self, "back_to_start")
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


func back_to_start():
	remove_game()
	remove_how_to()
	init_start()


func quit():
	get_tree().quit()
