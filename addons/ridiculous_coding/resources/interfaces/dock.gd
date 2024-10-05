@tool
class_name RidiculousCodingDock extends Control

signal rc_window_debug_pitch

const BASE_XP:int = 50
const ROOT_PATH:String = "user://"
const FILE_NAME_STATS:String = "ridiculous_xp.tres"
const FILE_NAME_THEME:String = "ridiculous_themes.tres"
const WARN:String = "RidiculousCoding plugin couldn't load any savedata, proceed to load and save default config!\nShould the addon not work proceed to RELOAD!"

const RANKS := {
	10:  "initiate",
	20:  "novice",
	30:  "neophyte",
	40:  "apprentice",
	50:  "journeyman",
	60:  "adept",
	66:  "devilish",
	70:  "wayfarer",
	85:  "master",
	100: "devotee",
	115: "seasoned",
	135: "veteran",
	155: "elite",
	175: "legendary",
	200: "demigod",
	333: "G.O.A.T",
	999: "addicted",
}

var xp_calculator:RcXpCalculator = RcXpCalculator.new()
var xp_next:int = 2 * BASE_XP
var stats:StatsDataRC
var theme_custom:ThemeDataRc
var backup_xp:Array[int] = []; var backup_level:Array[int] = []; var backup_rank:Array[String] = []

#regions @onready variables
@onready var xp_label:Label = $VBoxContainer/XP/XpLabel
@onready var level_label:Label = $VBoxContainer/XP/LevelLabel
@onready var progress:TextureProgressBar = $VBoxContainer/XP/ProgressBar

@onready var firework_particles_one:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Firework0/FireworkParticles2d
@onready var firework_particles_two:GPUParticles2D = $VBoxContainer/XP/ProgressBar/Firework1/FireworkParticles2d
@onready var firework_timer:Timer = $VBoxContainer/XP/ProgressBar/FireworkTimer

@onready var restore_button:TextureButton = $VBoxContainer/GridContainer/ResetUndoButton
@onready var reset_button:TextureButton = $VBoxContainer/GridContainer/ResetButton
@onready var settings_button:TextureButton = $VBoxContainer/GridContainer/SettingsButton
@onready var level_button:TextureButton = $VBoxContainer/GridContainer/LevelUpButton
#endregion

func _notification(what:int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			xp_calculator.queue_free()
		_: pass


func _ready() -> void:
	if _verify_file(FILE_NAME_STATS) == false:
		push_warning(WARN)
		stats = StatsDataRC.new()
		write_savefile(stats,FILE_NAME_STATS)
	else:
		stats = _load_savefile(FILE_NAME_STATS)

	if _verify_file(FILE_NAME_THEME) == false:
		push_warning(WARN)
		theme_custom = ThemeDataRc.new()
		write_savefile(theme_custom,FILE_NAME_THEME)
	else:
		theme_custom = _load_savefile(FILE_NAME_THEME)

	firework_timer.timeout.connect(_stop_firework); _stop_firework()
	_connect_signals()

	_load_experience_progress()
	_update_progress()


func _load_experience_progress() -> void:
	xp_next = 2 * BASE_XP
	progress.max_value = xp_next
	for i in range(1,stats.level+1):
		xp_next += round(BASE_XP * i / 10.0) * 10
		progress.max_value = round(BASE_XP * stats.level / 10.0) * 10
	progress.value = stats.xp - (xp_next - progress.max_value)


func _start_firework() -> void:
	if stats.sound == true and stats.firework_sound == true:
		var sound_resource:Resource = load("res://addons/ridiculous_coding/resources/effects/sound.tscn")
		var sound:RcSound = sound_resource.instantiate()
		sound.destroy = true
		var stream:AudioStreamWAV = load("res://addons/ridiculous_coding/sounds/others/fireworks.wav")
		var volume:float = -8.0 + stats.sound_addend + stats.firework_sound_addend
		add_child(sound)
		sound.create_sound(stream,volume)
		sound.play_sound_effect()

	if stats.firework == true:
		firework_timer.start()
		firework_particles_one.emitting = true
		firework_particles_two.emitting = true


func _stop_firework() -> void:
	firework_particles_one.emitting = false
	firework_particles_two.emitting = false


func _on_typing(last_key:String) -> void:
	xp_calculator.skill_01_level = stats.skill_01_level
	xp_calculator.skill_02_level = stats.skill_02_level
	var xp : int = xp_calculator.calculate_xp(last_key)
	stats.xp += xp
	progress.value += xp
	if progress.value >= progress.max_value:
		stats.level += 1
		xp_next = stats.xp + round(BASE_XP * stats.level / 10.0) * 10
		progress.value = 0
		progress.max_value = xp_next - stats.xp
		for level in RANKS.keys(): if stats.level >= level: stats.rank = RANKS[level]
		_start_firework()
	_update_progress()


func _update_progress() -> void:
	xp_label.text = "XP: %d / %d" % [stats.xp,xp_next]
	level_label.text = "%s dev - Lvl %d" % [stats.rank,stats.level]


func _connect_signals() -> void:
	settings_button.pressed.connect(func() -> void:
		settings_button.disabled = true
		level_button.disabled = true

		var window:Resource = load("res://addons/ridiculous_coding/resources/interfaces/settings_window.tscn")
		var window_instance:RcWindow = window.instantiate()

		window_instance.stats = stats
		window_instance.theme_custom = theme_custom
		window_instance.position = DisplayServer.screen_get_size() / 2 - window_instance.size / 2
		DisplayServer.set_native_icon("res://addons/ridiculous_coding/icon_small.ico")
		add_child(window_instance,false,Node.INTERNAL_MODE_FRONT)

		window_instance.tree_exiting.connect(func() -> void:
			var window_instance_old:Window = get_child(0,true)
			stats = window_instance_old.stats
			theme_custom = window_instance_old.theme_custom
			settings_button.disabled = false
			level_button.disabled = false
		)
		window_instance.rc_window_debug_pitch.connect(func() -> void: emit_signal("rc_window_debug_pitch"))
	)

	restore_button.pressed.connect(func() -> void:
		if backup_level.is_empty(): return
		stats.xp = backup_xp.pop_back(); stats.level = backup_level.pop_back(); stats.rank = backup_rank.pop_back()
		_load_experience_progress()
		_update_progress()
	)

	reset_button.pressed.connect(func() -> void:
		backup_xp.append(stats.xp); backup_level.append(stats.level); backup_rank.append(stats.rank)
		if backup_level.size() > 10: backup_xp.pop_front(); backup_level.pop_front(); backup_rank.pop_front()

		xp_next = 2 * BASE_XP
		progress.value = 0
		progress.max_value = xp_next
		var default_stats = StatsDataRC.new()
		stats.xp = default_stats.xp
		stats.level = default_stats.level
		stats.rank = default_stats.rank
		_update_progress()
	)

	level_button.pressed.connect(func() -> void:
		settings_button.disabled = true
		level_button.disabled = true

		var window:Resource = load("res://addons/ridiculous_coding/resources/interfaces/skill_window.tscn")
		var window_instance:RcSkillWindow = window.instantiate()

		window_instance.skill_01_level = stats.skill_01_level
		window_instance.skill_02_level = stats.skill_02_level
		window_instance.level = stats.level
		window_instance.position = DisplayServer.screen_get_size() / 2 - window_instance.size / 2
		DisplayServer.set_native_icon("res://addons/ridiculous_coding/icon_small.ico")
		add_child(window_instance,false,Node.INTERNAL_MODE_FRONT)

		window_instance.tree_exiting.connect(func() -> void:
			var window_instance_old:Window = get_child(0,true)
			stats.skill_01_level = window_instance_old.skill_01_level
			stats.skill_02_level = window_instance_old.skill_02_level
			settings_button.disabled = false
			level_button.disabled = false
		)
	)


func write_savefile(file,file_name:String) -> void:
	ResourceSaver.save(file,ROOT_PATH+file_name,0)


func _load_savefile(file_name:String) -> Resource:
	return ResourceLoader.load(ROOT_PATH+file_name,"",0)


func _verify_file(file_name:String) -> bool:
	if DirAccess.open(ROOT_PATH).file_exists(file_name) == true: return true
	else: return false
