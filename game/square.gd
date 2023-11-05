class_name Square
extends Node2D

signal was_clicked


var is_moving: bool = false
var height = 64
var width = 64

#var x_pos = 50.0
#var y_pos = 100.0
var color: Color = Color.AZURE
var body: Rect2 = Rect2(self.position.x, self.position.y, self.width, self.height)


func _ready():
	pass


func _process(delta):
	pass
#	if self.is_moving:
#		self.visible = false
#	else:
#		self.visible = true

func check_mouse_click(mx,my) -> bool:
	return self.body.has_point(Vector2(mx,my))



func _on_hitbox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		emit_signal("was_clicked")
		print("click")
