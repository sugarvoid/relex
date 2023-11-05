extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for l in $Main.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))
	for l in $Modes.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
