class_name Square
extends Node2D

signal was_clicked


var is_moving: bool = false
var height = 64
var width = 64
var x_pos = 50.0
var y_pos = 100.0
var color: Color = Color.AZURE
var body: Rect2 = Rect2(self.x_pos, self.y_pos, self.width, self.height)

func _draw():
	draw_rect(self.body, self.color)
	

func check_mouse_click(mx,my) -> bool:
	return self.body.has_point(Vector2(mx,my))
