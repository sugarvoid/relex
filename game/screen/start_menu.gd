extends Node2D

@onready var lbl_play = $Main/Play
@onready var lbl_info = $Main/Info

@onready var lbl_easy = $Modes/Easy
@onready var lbl_normal = $Modes/Normal
@onready var lbl_hard = $Modes/Hard
@onready var lbl_endless = $Modes/Endless


@onready var lbl_back = $Back



func _ready():
	self.lbl_back.hide()
	$Info.hide()
	self._connect_labels()
	for l in $Main.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))
	for l in $Modes.get_children():
		l.set_colors(Color("fafdff"), Color("68aed4"))

func _connect_labels() -> void:
	self.lbl_play.connect("was_clicked", _show_modes)
	self.lbl_info.connect("was_clicked", _show_info)
	self.lbl_back.connect("was_clicked", _go_back)
	
	self.lbl_easy.connect("was_clicked", _set_easy)
	self.lbl_normal.connect("was_clicked", _set_normal)
	self.lbl_hard.connect("was_clicked", _set_hard)
	
	


func _process(delta):
	pass

func _start_game() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")

func _set_easy() -> void:
	PlayerData.game_mode = PlayerData.GAME_MODES.EASY
	_start_game()
	
func _set_normal() -> void:
	PlayerData.game_mode = PlayerData.GAME_MODES.NORMAL
	_start_game()
	
func _set_hard() -> void:
	PlayerData.game_mode = PlayerData.GAME_MODES.HARD
	_start_game()

func _go_back():
	$Main.show()
	#get_tree().change_scene_to_file("res://game/screen/start_menu.tscn")
	self.lbl_back.hide()
	$Info.hide()
	$Modes.hide()

func _show_info():
	$Main.hide()
	lbl_back.show()
	$Info.show()

func _show_modes():
	$Main.hide()
	lbl_back.show()
	$Modes.show()
