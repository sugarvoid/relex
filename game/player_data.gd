
extends Node

var reaction_times: Array
var game_mode: int 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.reset_data()

func reset_data():
	self.reaction_times = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
