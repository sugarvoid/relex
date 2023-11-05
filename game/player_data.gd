
extends Node

var reaction_times: Array
var game_mode: int 


func _ready():
	self.reset_data()

func reset_data():
	self.reaction_times = []


