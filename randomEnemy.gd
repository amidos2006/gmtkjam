extends KinematicBody2D

const SPEED = 100

var timer = 100
export(Vector2) var dir = Vector2(1, 0)

func _change_direction():
	if abs(dir.x) > 0:
		if (dir.x < 0 and $left.is_colliding() and "colliders" in $left.get_collider().name) or\
			(dir.x > 0 and $right.is_colliding() and "colliders" in $right.get_collider().name):
			if !$up.is_colliding():
				dir.x = 0
				dir.y = -1
			if !$down.is_colliding():
				dir.x = 0
				dir.y = 1
	elif abs(dir.y) > 0:
		if (dir.y < 0 and $up.is_colliding() and "colliders" in $up.get_collider().name) or\
			(dir.y > 0 and $down.is_colliding() and "colliders" in $down.get_collider().name):
			if !$left.is_colliding():
				dir.x = -1
				dir.y = 0
			if !$right.is_colliding():
				dir.x = 1
				dir.y = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_change_direction()
	var collision = move_and_collide(dir * SPEED * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(dir.normalized())
	z_index = global_position.y
	
	$AnimatedSprite.flip_h = false
	if dir.x < 0:
		$AnimatedSprite.flip_h = true
		
