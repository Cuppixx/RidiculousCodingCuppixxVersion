@tool
class_name RcSound extends Node

@export var destroy:bool = false
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer

func create_sound(streamWAV:AudioStreamWAV,volume:float,pitch_increment:float = 0.0) -> void:
	audio_stream_player.stream = streamWAV
	audio_stream_player.volume_db = volume
	audio_stream_player.pitch_scale = 1.0 + pitch_increment * 0.01

func play_sound_effect() -> void:
	audio_stream_player.play()
	#print("Volume: ",audio_stream_player.volume_db)
	await audio_stream_player.finished
	if destroy == true: queue_free()
