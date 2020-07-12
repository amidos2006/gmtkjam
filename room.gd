extends Node2D

const MAX_COINS = 9

var collected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".room = self

func activate():
	for i in range($colliders.get_child_count()):
		$colliders.get_child(i).disabled = false
	visible = true
	
func deactivate():
	for i in range($colliders.get_child_count()):
		$colliders.get_child(i).disabled = true
	visible = false

func coin_collected():
	collected += 1
	if collected >= MAX_COINS:
		var enemies = $"/root/Global".enemies
		for i in range(0, enemies.get_child_count()):
			enemies.get_child(i).queue_free()
		$"/root/Global".coin.queue_free()
		$"/root/Global".flash.flash()
		$scream.play()
		$"/root/Global".player.heal()
		return false
	return true
