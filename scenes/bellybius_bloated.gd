extends RigidBody2D

# Speed and jump parameters
@export var move_speed: float = 200.0
@export var jump_force: float = 150.0
@export var max_speed: float = 500.0

@onready var sprite = $Sprite2D

# Variable to check if on the ground
var is_on_ground: bool = false
var sprite_side = 1

# Called every frame
func _physics_process(delta):
	# Check if on ground by using a raycast or area
	# Assuming you have a RayCast2D node as a child named "GroundCheck"
	if ($GroundCheck.is_colliding() or $GroundCheck2.is_colliding() or $GroundCheck3.is_colliding() or $GroundCheck4.is_colliding()):
		is_on_ground = true
	else:
		is_on_ground = false
	
	# Get input directions
	var direction = 0
	if Input.is_action_pressed("right"):
		direction += 1
		sprite.flip_h = false
		#sprite_side = 1
	elif Input.is_action_pressed("left"):
		direction -= 1
		sprite.flip_h = true
		#sprite_side = -1
	
	# Apply force for movement
	if direction != 0:
		apply_central_force(Vector2(move_speed * direction, 0))
	#scale.x = scale.y * sprite_side #flippin sprite to direction
		
	# Limit the speed
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	# Jump
	if is_on_ground and Input.is_action_just_pressed("jump"):
		apply_central_impulse(Vector2(0, -jump_force))
	
func interact():
	pass
