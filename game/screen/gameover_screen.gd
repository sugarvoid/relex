extends Node2D


func set_up() -> void:
	
	var len = len(PlayerData.reaction_times)
	var sum: float
	for r in PlayerData.reaction_times:
		sum += r
	var average = snappedf(sum/len, 0.001)
	
	$LblGameOver2.set_text(str("Hits: ", len, "\nAverage Time: " , average))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
