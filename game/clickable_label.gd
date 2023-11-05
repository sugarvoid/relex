class_name ClickableLabel
extends Label

signal was_clicked

var default_color: Color = Color.WHITE_SMOKE
var hover_color: Color = Color.AQUA

func set_colors(default: Color, hover: Color) -> void:
	self.default_color = default
	self.hover_color = hover

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_theme_color_override("font_color", self.default_color)



func _on_mouse_entered():
	self.add_theme_color_override("font_color", self.hover_color)



func _on_mouse_exited():
	self.add_theme_color_override("font_color", self.default_color)



func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		emit_signal("was_clicked")
		print("label clicked")
