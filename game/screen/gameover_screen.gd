extends Node2D


func set_up() -> void:
	var len = len(PlayerData.reaction_times)
	var sum: float
	for r in PlayerData.reaction_times:
		sum += r
	var average = snappedf(sum/len, 0.001)
	
	$LblGameOver2.set_text(str("Clicks: ",PlayerData.clicks, "\nHits: ", len, "\nMissed: ", PlayerData.misses, "\nAverage Time: " , average))


func _ready():
	set_up()


func _on_lbl_back_to_start_was_clicked():
	get_tree().change_scene_to_file("res://game/screen/start_menu.tscn")
