class_name SquareObj
extends Node2D

signal was_clicked


var is_moving: bool = false
var height = 64
var width = 64

var color: Color = Color.AZURE

func reset() -> void:
	self.is_moving=false
	self.show()

func set_color(c: Color):
	$ColorRect.color = c

func check_mouse_click(mx,my) -> bool:
	return self.body.has_point(Vector2(mx,my))


func _on_hitbox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		PlayerData.player_clicked()
		emit_signal("was_clicked")
		print("click")


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		PlayerData.player_clicked()
		emit_signal("was_clicked")
		print("click")
