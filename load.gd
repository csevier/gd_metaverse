extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var success = ProjectSettings.load_resource_pack("res://test3.pck")
	if success:
		var imported_scene = load("res://World.tscn")
		get_tree().change_scene_to(imported_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
