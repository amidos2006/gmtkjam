extends Control

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if $"/root/Global".player == null && Input.is_key_pressed(KEY_SPACE):
		get_tree().reload_current_scene()
