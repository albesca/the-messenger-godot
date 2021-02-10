extends Node2D


func update_health(current_health):
	$FirstHeart.update_health(current_health)
	$SecondHeart.update_health(current_health)
	$ThirdHeart.update_health(current_health)
