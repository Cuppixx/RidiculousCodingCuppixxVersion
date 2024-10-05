@tool
class_name RcSkillWindow extends Window

const MAX_LEVEL : int = 100

var skill_01_level : int = 0
var skill_02_level : int = 0
var level : int = 0


func _notification(what:int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			queue_free()
		_: pass


func _ready() -> void:
	if (level - (skill_01_level + skill_02_level)) < 0:
		skill_01_level = 0
		skill_02_level = 0
	_update_labels()

	$Control/GridContainer/Skill01TextureButton.pressed.connect(func() -> void:
		if level - (skill_01_level + skill_02_level) > 0 and skill_01_level < MAX_LEVEL:
			skill_01_level += 1
			_update_labels()
	)
	$Control/GridContainer/Skill02TextureButton.pressed.connect(func() -> void:
		if level - (skill_01_level + skill_02_level) > 0 and skill_02_level < MAX_LEVEL:
			skill_02_level += 1
			_update_labels()
	)

	$Control/MarginContainerReset/ResetTextureButton.pressed.connect(func() -> void:
		skill_01_level = 0
		skill_02_level = 0
		_update_labels()
	)


func _update_labels() -> void:
	$Control/MarginContainerSkillPoints/SkillPointsLabel.text = str(level - (skill_01_level + skill_02_level))

	if skill_01_level == MAX_LEVEL:
		$Control/GridContainer/Skill01TextureButton/SkillPointsLabel.text = "MAX"
	else: $Control/GridContainer/Skill01TextureButton/SkillPointsLabel.text = str(skill_01_level)

	if skill_02_level == MAX_LEVEL:
		$Control/GridContainer/Skill02TextureButton/SkillPointsLabel.text = "MAX"
	else: $Control/GridContainer/Skill02TextureButton/SkillPointsLabel.text = str(skill_02_level)
