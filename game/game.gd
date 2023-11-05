extends Node2D


@onready var react_timer: Timer = get_node("Timer")
@onready var game_time_left: Timer = get_node("GameTime")

@onready var fish_sound: AudioStreamPlayer = get_node("AudioStreamPlayer")

@onready var lbl_title: Label = $HUD/LblTitle
@onready var lbl_title2: Label = $HUD/LblTitle2

var real_square: Square
var fake_square: Square

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

var reaction_times: Array



func _ready():
	
	self.lbl_title.visible = true
	self.lbl_title2.visible = true
	$HUD/LblGameOver.hide()
	self.reaction_times = []
	
	self.game_time_left.connect("timeout", gameover)
	self.rng = RandomNumberGenerator.new()
	

func _start_game():
	self.real_square = preload("res://game/square.tscn").instantiate()
	self.add_child(self.real_square)
	self.real_square.name = "RealSquare"
	self.real_square.connect("was_clicked", real_clicked)
	self.real_square.modulate = Color("10d275")
	
	self.fake_square = preload("res://game/square.tscn").instantiate()
	self.add_child(self.fake_square)
	self.fake_square.name = "FakeSquare"
	self.fake_square.connect("was_clicked", fake_clicked)
	self.fake_square.modulate = Color("7f0622")
	self.fake_square.position = Vector2(-100,-100)
	
	
	
	self.move_square(self.real_square, 0.0)
	self.game_time_left.start(GAME_TIME)
	
	self.real_square.show()
	self.fake_square.show()

func _draw():
	draw_rect(Rect2(0, 0, 600, 40), Color("2b2821"))
	
	draw_rect(Rect2(0, 30, 600.0, 570.0), Color("16171a"))
	
	

func _process(delta):
	match self.game_state:
		0:
			pass
		1:
			
			queue_redraw()
			if !is_stopped:
				time_elapsed += delta
				$HUD/Label.text = str(time_elapsed).pad_decimals(1)
		2:
			pass


func _input(event):
	match self.game_state:
		0:
			if event is InputEventMouseButton:
				if event.is_action_pressed('left_mouse'):
					self.lbl_title.visible = false
					self.lbl_title2.visible = false
					
					self.game_state = 1
					self._start_game()
					
		1:
			pass
		2:
			pass
   

func move_square(sq: Square, time: float) -> void:
	var starting_pos = sq.position
	var end_pos = self.get_position_in_area()
	
	print("Traveled: ", roundf(starting_pos.distance_to(end_pos)), " units")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sq, "position", end_pos, time)
	sq.is_moving = true
	sq.hide()
	tween.tween_callback(
		func(): 
			sq.is_moving=false 
			sq.show()
			)


func update_score(num: int) -> void:
	self.player_score += num
	$HUD/LblScore.set_text(str("Score:", player_score)) 
	

func get_position_in_area() -> Vector2:
	var position_in_area: Vector2
	position_in_area.x = (randi() % int(SPAWN_AREA.x)) - (SPAWN_AREA.x/2) + CENTER_POS.x
	position_in_area.y = (randi() % int(SPAWN_AREA.y)) - (SPAWN_AREA.y/2) + CENTER_POS.y
	
	return position_in_area
	

func stopwatch_reset() -> void:
	# possibly save time_elapsed somewhere else before overriding it
	print("time elapsed:", snappedf(time_elapsed,0.01))
	self.reaction_times.append(snappedf(time_elapsed,0.01))
	time_elapsed = 0.0
	is_stopped = false

func stopwatch_stop() -> void:
	is_stopped = true
	
func stopwatch_start() -> void:
	is_stopped = false

func real_clicked() -> void:
	print('real square clicked')
	self.stopwatch_reset()
	self.fish_sound.play()
	self.move_square(self.real_square, 0.2)
	self.update_score(1)

func fake_clicked() -> void:
	print('fake square clicked')

func gameover() -> void:
	var len = len(self.reaction_times)
	var sum: float
	for r in self.reaction_times:
		sum += r
	var average = snappedf(sum/len, 0.001)
	print("average time: ", average)
	print(self.reaction_times)
	self.real_square.position = Vector2(-100, -100)
	self.fake_square.position = Vector2(-100, -100)
	self.game_state = 2 
	
	$HUD/LblGameOver.show()
	$HUD/LblGameOver.set_text(str("Game Over \n\nHits: ", len, "\nAverage Time: " , average))

