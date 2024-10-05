class_name ThemeDataRc extends Resource

const DEFAULT_THEME := [[Vector4(0.0,0.0,0.0,1.0),Vector4(2.0,2.0,2.0,1.0)],[Vector4(1.0,0.0,0.0,0.85),Vector4(2.0,1.5,0.4,1.0)]]
@export var saved_themes_dictionary:Dictionary = {
	0 : DEFAULT_THEME,
	1 : [[Vector4(0.2,0.5,0.7,1.0),Vector4(1.0,0.5,2.0,1.0)],[Vector4(1.0,0.0,0.0,0.85),Vector4(2.0,1.5,0.4,1.0)]],
	2 : [[Vector4(0.0,0.0,0.0,1.0),Vector4(2.0,2.0,2.0,1.0)],[Vector4(0.0,0.0,0.0,1.00),Vector4(2.0,2.0,2.0,1.0)]],
	3 : [[Vector4(0.0,0.0,0.0,1.0),Vector4(2.0,2.0,2.0,1.0)],[Vector4(0.0,0.0,0.0,1.00),Vector4(2.0,2.0,2.0,1.0)]],
}
@export var saved_themes_dictionary_selected:int = 0
@export var current_theme := DEFAULT_THEME
