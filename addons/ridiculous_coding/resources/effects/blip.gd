@tool
class_name RcBlip extends RcBaseEffect

func _ready() -> void:
	super.do_animation($AnimationPlayer); super.do_sprite($BlipSprite)
	super.start_effect_timer()
