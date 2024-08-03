@tool
class_name RcBoom extends RcBaseEffect

func _ready() -> void:
	super.do_animation($AnimationPlayer); super.do_sprite($BoomSprite)
	super.start_effect_timer()
