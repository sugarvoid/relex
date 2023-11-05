
extends Node

var reaction_times: Array
var game_mode: int 
var clicks: int
var hits: int
var misses: int


func _ready():
	self.reset_data()

func reset_data():
	self.reaction_times = []
	clicks = 0
	hits = 0
	misses = 0

func player_clicked() -> void:
	self.clicks += 1
