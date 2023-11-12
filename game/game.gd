extends Node2D


@onready var react_timer: Timer = get_node("Timer")
@onready var game_time_left: Timer = get_node("GameTime")

@onready var fish_sound: AudioStreamPlayer = get_node("AudioStreamPlayer")

@onready var lbl_score: Label = get_node("HUD/LblScore")


var p_fake_square = preload("res://game/object/square/square.tscn")

var real_square : Square
var fake_square : Square

const CENTER_POS = Vector2(300.0,300.0)
const SPAWN_AREA = Vector2(450,450)
const GAME_TIME: int = 20

var game_state: int = 0
var is_square_moving: bool = false
var square_height = 64
var square_width = 64
var square_x = 50.0
var square_y = 100.0

var rng = RandomNumberGenerator.new()
var player_score = 0
var time_elapsed: float = 0.0
var is_stopped := false

var move_speed: float


func _ready():
	for l in $HUD.get_children():
		l.add_theme_color_override("font_color", Color("fafdff"))
		
	PlayerData.reset_data()

	self.game_time_left.connect("timeout", gameover)
	self.rng = RandomNumberGenerator.new()
	self._set_mode_label()
	self._start_game()


func get_fake_square() -> Square:
	var new_square = p_fake_square.instantiate()
	self.add_child(new_square)
	new_square.name = "FakeSquare"
	new_square.connect("was_clicked", fake_clicked)
	new_square.set_color(Color("10d275"))
	new_square.move_off_screen()
	return new_square

func _start_game():
	self.real_square = preload("res://game/object/square/square.tscn").instantiate()
	self.add_child(self.real_square)
	self.real_square.name = "RealSquare"
	self.real_square.connect("was_clicked", real_clicked)
	self.real_square.set_color(Color("10d275"))

	self.fake_square = get_fake_square()
#	self.fake_square = p_fake_square.instantiate()
#	self.add_child(self.fake_square)
#	self.fake_square.name = "FakeSquare"
#	self.fake_square.connect("was_clicked", fake_clicked)
#	self.fake_square.set_color(Color("10d275"))
#	self.fake_square.move_off_screen()

	match PlayerData.game_mode:
		PlayerData.GAME_MODES.EASY, PlayerData.GAME_MODES.NORMAL:
			move_speed = 0.2
		PlayerData.GAME_MODES.HARD:
			move_speed = 0.5

	self.move_square(self.real_square, 0.0)
	self.game_time_left.start(GAME_TIME)

	self.real_square.show()
	self.fake_square.show()


func _process(delta):
	if !is_stopped:
		time_elapsed += delta

func _set_mode_label() -> void:
	var _mode = PlayerData.game_mode
	var _mode_txt: String
	
	match _mode:
		PlayerData.GAME_MODES.EASY:
			_mode_txt = "Easy Mode"
		PlayerData.GAME_MODES.NORMAL:
			_mode_txt = "Normal Mode"
		PlayerData.GAME_MODES.HARD:
			_mode_txt = "Hard Mode"
	
	$HUD/LblMode.text = _mode_txt

func move_square(sq: Square, time: float) -> void:

	var starting_pos = sq.position
	var end_pos = self.get_position_in_area()
	var tween = create_tween()
	
	
	tween.tween_property(sq, "position", end_pos, time)
	sq.is_moving = true
	
	if PlayerData.game_mode == PlayerData.GAME_MODES.NORMAL:
		sq.hide()
	
	if sq != null:
		tween.tween_callback(sq.reset).set_delay(0.2)
		#tween.call_deferred("tween_callback", sq.reset)
		
	##print("Traveled: ", roundf(starting_pos.distance_to(end_pos)), " units")


func update_score(num: int) -> void:
	self.player_score += num
	self.lbl_score.set_text(str("Score:", player_score))


func get_position_in_area() -> Vector2:
	var position_in_area: Vector2
	position_in_area.x = (randi() % int(SPAWN_AREA.x)) - (SPAWN_AREA.x/2) + CENTER_POS.x
	position_in_area.y = (randi() % int(SPAWN_AREA.y)) - (SPAWN_AREA.y/2) + CENTER_POS.y

	return position_in_area


func stopwatch_reset() -> void:
	print("time elapsed:", snappedf(time_elapsed,0.01))
	PlayerData.reaction_times.append(snappedf(time_elapsed,0.01))
	time_elapsed = 0.0
	is_stopped = false

func stopwatch_stop() -> void:
	is_stopped = true

func stopwatch_start() -> void:
	is_stopped = false

func real_clicked() -> void:
	
	print('real square clicked')
	self.update_score(1)
	self.stopwatch_reset()
	self.fish_sound.play()
	self.move_square(self.real_square, move_speed)
	
	
	if PlayerData.game_mode == PlayerData.GAME_MODES.HARD:
		self.fake_square = get_fake_square()
		#self.fake_square.reset_alpha()
		self.fake_square.position = self.real_square.position
		self.move_square(self.fake_square, move_speed)
		
		await get_tree().create_timer(0.5).timeout
		self.fake_square.lower_alpha(move_speed+0.2)
	
	

	
	
	
	
	
	

func fake_clicked() -> void:
	print('fake square clicked')
	PlayerData.misses += 1

func gameover() -> void:
	get_tree().change_scene_to_file("res://game/screen/gameover_screen.tscn")



func _on_background_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		PlayerData.player_clicked()
		print("missed click")
		PlayerData.misses += 1
