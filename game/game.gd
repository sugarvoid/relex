extends Node2D


@onready var real_marker: Marker2D = get_node("RealMarker")
@onready var react_timer: Timer = get_node("Timer")
@onready var fish_sound: AudioStreamPlayer = get_node("AudioStreamPlayer")

@onready var lbl_title: Label = $HUD/LblTitle
@onready var lbl_title2: Label = $HUD/LblTitle2

@onready var real_square: Square = get_node("RealSquare")
@onready var fake_square: Square = get_node("FakeSquare")

const CENTER_POS = Vector2(300.0,300.0)
const SPAWN_AREA = Vector2(450,450)

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

var square: Rect2


func _ready():
	self.lbl_title.visible = true
	self.lbl_title2.visible = true
	
	self.real_square.connect("was_clicked", real_clicked)
	
	
	self.square = Rect2(real_marker.position.x, real_marker.position.y, 64.0, 64.0)
	self.rng = RandomNumberGenerator.new()
	self.real_marker.position = Vector2(50.0, 100.0)

func _draw():
	draw_rect(Rect2(0, 0, 600, 40), Color.BLACK)
	match self.game_state:
		0:
			draw_rect(Rect2(0, 30, 600.0, 570.0), Color.DARK_SLATE_GRAY)
		1:
			draw_rect(Rect2(0, 30, 600.0, 570.0), Color.DARK_SLATE_BLUE)
		2:
			draw_rect(Rect2(0, 30, 600.0, 570.0), Color.DARK_OLIVE_GREEN)

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
		1:
			pass
#			if event is InputEventMouseButton:
#				if event.is_action_pressed('left_mouse'):
#					if self.real_square.check_mouse_click(event.position.x, event.position.y):
#						print('real square clicked')
#						self.stopwatch_reset()
#						self.fish_sound.play()
#						self.move_square(self.real_square, 0.2)
#						self.update_score(20)
		2:
			pass
   
#func check_mouse_click(mx,my) -> bool:
#	return square.has_point(Vector2(mx,my))


func move_square(sq: Square, time: float) -> void:
	var starting_pos = sq.position
	var end_pos = self.get_position_in_area()
	
	print("Traveled: ", roundf(starting_pos.distance_to(end_pos)), " units")
	
	var tween = get_tree().create_tween()
	tween.tween_property(sq, "position", end_pos, time)
	sq.is_moving = true
	tween.tween_callback(func(): sq.is_moving=false)
	


#func _on_Tween_tween_all_completed():
#	self.is_square_moving = false
#	pass # Replace with function body.

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
	print("time elapsed:", time_elapsed)
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
	self.update_score(20)
