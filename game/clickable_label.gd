class_name ClickableLabel
extends Label

signal was_clicked

@export var default_color: Color = Color.WHITE_SMOKE
@export var hover_color: Color = Color.AQUA
@export var disabled_color: Color = Color.DARK_GRAY

var is_disabled: bool = false

func set_colors(default: Color, hover: Color) -> void:
	self.default_color = default
	self.hover_color = hover

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_theme_color_override("font_color", self.default_color)


func disable():
	self.is_disabled = true
	self.modulate.a = 0.25

func _on_mouse_entered():
	if !self.is_disabled:
		self.add_theme_color_override("font_color", self.hover_color)



func _on_mouse_exited():
	self.add_theme_color_override("font_color", self.default_color)



func _on_gui_input(event):
	if !self.is_disabled:
		if event is InputEventMouseButton and event.pressed and event.button_index==1:
			emit_signal("was_clicked")
			_on_mouse_exited()
