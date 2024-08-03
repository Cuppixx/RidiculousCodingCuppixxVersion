@tool
class_name RcKey extends RcBaseEffect

@export var animation_name:String = "default"

func _ready() -> void:
	super.do_animation($AnimationPlayer, animation_name)
	super.start_effect_timer()

func create_key(r:Vector2,g:Vector2,b:Vector2,a:Vector2,last_key:String = "") -> void:
	var key_label:Label = $Label
	rotation_degrees = randf_range(-7.0,7.0)
	key_label.text = last_key
	key_label.modulate = Color(randf_range(r.x,r.y),randf_range(g.x,g.y),randf_range(b.x,b.y),randf_range(a.x,a.y))
