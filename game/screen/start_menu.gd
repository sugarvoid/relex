extends Node2D

@onready var lbl_play = $Main/Play
@onready var lbl_info = $Main/Info
@onready var lbl_easy = $Modes/Easy
@onready var lbl_normal = $Modes/Normal
@onready var lbl_hard = $Modes/Hard
@onready var lbl_endless = $Modes/Endless
@onready var lbl_back = $Back



# Called when the node enters the scene tree for the first time.
func _ready():
	self.lbl_back.hide()
	self._connect_labels()
	for l in $Main.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))
	for l in $Modes.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))

func _connect_labels() -> void:
	self.lbl_play.connect("was_clicked", _start_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_game() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_back_was_clicked():
	get_tree().change_scene_to_file("res://game/screen/start_menu.tscn")
	$lbl_back.hide()
