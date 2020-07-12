extends KinematicBody2D

const SPEED = 80
const ACCELERATION = 10

var velocity = Vector2()
var direction = Vector2()

func _ready():
	direction.x = randf()
	direction.y = randf()
	direction = direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	velocity = velocity.clamped(SPEED)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(velocity.normalized())
		direction = direction.bounce(collision.normal)
		if randf() < 0.3:
			direction.x += 0.2 * randf() - 0.1
			direction.y += 0.2 * randf() - 0.1
		direction = direction.normalized()
		
	z_index = global_position.y
	
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.position.x = abs($AnimatedSprite.position.x)
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.position.x = -abs($AnimatedSprite.position.x)
