class_name Square
extends Node2D

signal was_clicked

var is_moving: bool = false
var height = 64
var width = 64
var is_real: bool = false

var color: Color = Color.AZURE

func reset() -> void:
	self.is_moving=false
	self.show()

func set_color(c: Color):
	$ColorRect.color = c

func check_mouse_click(mx,my) -> bool:
	return self.body.has_point(Vector2(mx,my))

func lower_alpha(duration: float) -> void:
	var tween_a = create_tween()
	
	tween_a.tween_property(self, "modulate", Color(1, 1, 1, 0), duration)
	
	if !self == null:
		tween_a.tween_callback(queue_free).set_delay(0.3)
	
	#tween_a.call_deferred("tween_callback", self.die)
	

func die():
	self.queue_free()

func reset_alpha() -> void:
	self.modulate.a = 1.0
#
#func _on_hitbox_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed and event.button_index==1:
		#
		#PlayerData.player_clicked()
		#
		#emit_signal("was_clicked")

func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		if self.is_real:
			$AnimationPlayer.play("pulse")
		else:
			PlayerData.player_clicked()
			emit_signal("was_clicked")
		

func move_off_screen() -> void:
	self.position = Vector2(-100,-100)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pulse":
		PlayerData.player_clicked()
		emit_signal("was_clicked")
