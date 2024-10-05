@tool
class_name RcXpCalculator extends Node

#const KEYWORD_STRING_LEN: int = 7
#
#var keyword_string: String = ""
#var keyword_dict: Dictionary = {
	#"VAR"     : 2,
	#"FUNC"    : 5,
	#"RETURN"  : 5,
	#"CONST"   : 3,
	#"EXPORT"  : 4,
	#"SIGNAL"  : 7,
	#"CLASS"   : 8,
	#"EXTENDS" : 9,
	#"LOAD"    : 7,
	#"MATCH"   : 4,
	#"SET"     : 6,
	#"GET"     : 6,
	#"ASSERT"  : 5,
	#"TOOL"    : 10,
#}

var skill_01_level: int
var skill_02_level: int
#var skill_03_level: int


#func _init(skill_01_level: int, skill_02_level: int, skill_03_level: int) -> void:
	#self.skill_01_level = skill_01_level
	#self.skill_02_level = skill_02_level
	#self.skill_03_level = skill_03_level


func calculate_xp(last_key: String) -> int:
	var xp : int = randi_range(1, 1 + (skill_02_level * 2)) + skill_01_level
	#keyword_string += last_key

	#if keyword_string.length() > KEYWORD_STRING_LEN:
		#keyword_string = keyword_string.right(KEYWORD_STRING_LEN)

	#for keyword in keyword_dict.keys():
			#if keyword in keyword_string:
				#keyword_string = ""
				#xp += (keyword_dict[keyword] + skill_03_level)

	return xp
