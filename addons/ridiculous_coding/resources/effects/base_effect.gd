@tool
class_name RcBaseEffect extends Node2D

@export var destroy:bool = false

func do_animation(animation_player:AnimationPlayer, animation_name:String = "default") -> void:
	animation_player.play(animation_name)

func do_sprite(sprite:AnimatedSprite2D) -> void:
	sprite.frame = 0
	sprite.play("default")

func start_effect_timer(time_sec:float = 1.0) -> void:
	var timer:Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout,4)
	timer.start()

func _on_timer_timeout() -> void: if destroy == true: queue_free()
