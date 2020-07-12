extends Node2D

const SHIFT = 20
const COIN = preload("res://coin.tscn")
const CHASER_ENEMY = preload("res://chaserEnemy.tscn")
const STATIC_ENEMY = preload("res://staticEnemy.tscn")
const LINE_ENEMY = preload("res://lineEnemy.tscn")
const RAND_ENEMY = preload("res://randomEnemy.tscn")

const ENEMY_TYPES = [
	[0, 0, 0, 0],
	[4, 0, 0, 0],
	[0, 4, 0, 0],
	[4, 3, 0, 0],
	[0, 0, 4, 0],
	[0, 3, 2, 0],
	[2, 3, 2, 0],
	[0, 0, 0, 1],
	[6, 0, 0, 1],
	[0, 3, 0, 1],
	[0, 2, 2, 1],
	[4, 2, 2, 1]
]

const RANDOM_TYPES = [
	[0, 0, 0, 0],
	[2, 0, 0, 0],
	[0, 1, 0, 0],
	[2, 1, 0, 0],
	[0, 0, 2, 0],
	[0, 1, 1, 0],
	[2, 1, 1, 0],
	[0, 0, 0, 0],
	[2, 0, 0, 0],
	[0, 2, 0, 0],
	[0, 1, 1, 1],
	[2, 1, 1, 1]
]

var firstTime = true

func _get_far_loc(center, size, relative, index):
	var trials = 0
	var location = Vector2(relative.x, relative.y)
	var regions = [
		{"x1":SHIFT, "x2":size.x/2, "y1":SHIFT, "y2": size.y/2},
		{"x1":-size.x/2, "x2":-SHIFT, "y1":-size.x/2, "y2": -SHIFT},
		{"x1":-size.x/2, "x2":-SHIFT, "y1":SHIFT, "y2": size.y/2},
		{"x1":SHIFT, "x2":size.x/2, "y1":-size.x/2, "y2": -SHIFT},
		{"x1":-size.x/2, "x2":size.x/2, "y1":-size.x/2, "y2": size.y/2},
		{"x1":-size.x/2, "x2":size.x/2, "y1":SHIFT, "y2": size.y/2},
		{"x1":-size.x/2, "x2":size.x/2, "y1":-size.x/2, "y2": -SHIFT},
		{"x1":-size.x/2, "x2":-SHIFT, "y1":-size.x/2, "y2": size.y/2},
		{"x1":SHIFT, "x2":size.x/2, "y1":-size.x/2, "y2": size.y/2}
	]
	var r = regions[index % regions.size()]
	while (location - relative).length() < 80 && trials < 100:
		trials += 1
		location.x = rand_range(r['x1'], r['x2']) + center.x
		location.y = rand_range(r['y1'], r['y2'])  + center.y
	return location	

func get_new_position(index):
	var center = $"/root/Global".room.global_position
	var size = $"/root/Global".room.get_node("coinarea").shape.extents
	return _get_far_loc(center, size, $"/root/Global".player.global_position, index)

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".enemies = self
		
func _process(delta):
	if firstTime:
		var coin = COIN.instance()
		get_parent().add_child(coin)
		
		firstTime = false
		var level = min($"/root/Global".level, ENEMY_TYPES.size())
		var enemies = [0, 0, 0, 0]
		enemies[0] += ENEMY_TYPES[level][0] + randi() % (RANDOM_TYPES[level][0] + 1)
		enemies[1] += ENEMY_TYPES[level][1] + randi() % (RANDOM_TYPES[level][1] + 1)
		enemies[2] += ENEMY_TYPES[level][2] + randi() % (RANDOM_TYPES[level][2] + 1)
		enemies[3] += ENEMY_TYPES[level][3] + randi() % (RANDOM_TYPES[level][3] + 1)
		for i in range(0, enemies[0]):
			var enemy = STATIC_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i)
		for i in range(0, enemies[1]):
			var enemy = LINE_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i)
		for i in range(0, enemies[2]):
			var enemy = RAND_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i)
		for i in range(0, enemies[3]):
			var enemy = CHASER_ENEMY.instance()
			self.add_child(enemy)
			enemy.global_position = get_new_position(i)
			
	if $"/root/Global".room.collected >= $"/root/Global".room.MAX_COINS:
		if $"/root/Global".level < ENEMY_TYPES.size() - 1:
			if Input.is_key_pressed(KEY_SPACE):
				$"/root/Global".level += 1
				#$"/root/Global".player.global_position = Vector2(320, 180)
				firstTime = true
				$"/root/Global".room.collected = 0
				$"/root/Global".flash.flash()
		else:
			pass
		
