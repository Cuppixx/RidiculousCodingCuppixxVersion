@tool
class_name RcNewline extends RcBaseEffect

func _ready() -> void:
	super.do_animation($AnimationPlayer); super.do_sprite($NewlineSprite)
	super.start_effect_timer()
