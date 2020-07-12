extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"/root/Global".player != null:
		$health1/front.visible = $"/root/Global".player.health >= 1
		$health2/front.visible = $"/root/Global".player.health >= 2
		$health3/front.visible = $"/root/Global".player.health >= 3
	else:
		$health1/front.visible = false
		$health2/front.visible = false
		$health3/front.visible = false
	$sword1/front.visible = $"/root/Global".room.collected >= 1
	$sword2/front.visible = $"/root/Global".room.collected >= 2
	$sword3/front.visible = $"/root/Global".room.collected >= 3
	$sword4/front.visible = $"/root/Global".room.collected >= 4
	$sword5/front.visible = $"/root/Global".room.collected >= 5
	$sword6/front.visible = $"/root/Global".room.collected >= 6
	$sword7/front.visible = $"/root/Global".room.collected >= 7
	$sword8/front.visible = $"/root/Global".room.collected >= 8
	$sword9/front.visible = $"/root/Global".room.collected >= 9
