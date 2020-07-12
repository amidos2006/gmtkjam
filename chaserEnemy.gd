extends KinematicBody2D

const SPEED = 120
const ACCELERATION = 10
const FRICTION = 1.5

var velocity = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var player = $"/root/Global".player
	if player == null:
		velocity = Vector2()
		return
	var direction = (player.global_position - global_position).normalized()
	velocity.x += direction.x * ACCELERATION
	velocity.y += direction.y * ACCELERATION
	velocity = velocity.clamped(SPEED)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(velocity.normalized())
		velocity *= -1
	z_index = global_position.y
	
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.position.x = abs($AnimatedSprite.position.x)
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.position.x = -abs($AnimatedSprite.position.x)
