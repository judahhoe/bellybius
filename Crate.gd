extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isLocked = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = base_gravity
var set_pos

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if !isLocked:
		move_and_slide()
	elif isLocked:
		position = set_pos

func get_charged(direction):
	velocity.x = direction * 20
	velocity.y = -100
	await get_tree().create_timer(1).timeout
	velocity.x = 0

func lock_movement():
	set_pos = global_position
	isLocked = true
	velocity.x = 0
	velocity.y = 0

func unlock_movement():
	isLocked = false


func _on_area_2d_body_entered(body):
	gravity = 0


func _on_area_2d_body_exited(body):
	gravity = base_gravity
