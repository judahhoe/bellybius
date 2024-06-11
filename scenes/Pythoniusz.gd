extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -100.0

@onready var landing_particles = preload("res://scenes/landing_particles.tscn")
@onready var running_particles = $RunningParticles
@onready var sprite = $Sprite2D
@onready var feet_marker = $FeetMarker
@onready var animation_player = $AnimationPlayer
@onready var charge_area = $ChargeArea
@onready var charge_timer = $ChargeTimer

var isFallTimerCounting = false

var hasJumped = false
var step_counter = 0
var isInteracting = false
var isMoving = false
var isCharging = false
var last_direction
var canCharge = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		print(velocity.y)
		if velocity.y > 10:
			sprite.play("fall")
			if velocity.y > 200:
				sprite.speed_scale *= 1.05
			if velocity.y > 400:
				sprite.speed_scale *= 1.05
			if velocity.y > 1000:
				sprite.speed_scale *= 1.05
	
	if is_on_floor():
		sprite.speed_scale = 1
	
	if hasJumped and is_on_floor():
		emit_landing_particles()
		animation_player.play("land")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		hasJumped = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	last_direction = direction
	if direction:
		isMoving = true
		velocity.x = handle_movement(direction)
	else:
		isMoving = false
		if is_on_floor() && !isInteracting:
			sprite.play("idle")
		running_particles.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("interact") and !isInteracting:
		print("interact")
		if is_on_floor():
			interact()
	if event.is_action_pressed("charge") and !isCharging and canCharge:
		charge()
		
func charge():
	charge_timer.start()
	canCharge = false
	isCharging = true
	charge_area.monitoring = true
	sprite.play("charge")
	await get_tree().create_timer(0.3).timeout
	charge_area.monitoring = false
	isCharging = false

func handle_movement(direction):
	if is_on_floor():
		#if(step_counter == 0):
			#animation_player.play("walk_0")
		#if(step_counter == 1):
			#animation_player.play("walk_1")
		if !isCharging:
			sprite.play("walk")
		emit_walk_particles()
	if !is_on_floor():
		running_particles.emitting = false
	scale.x = scale.y * direction #flippin sprite to direction
	velocity.x = direction * SPEED
	if isCharging:
		velocity.x = direction * SPEED * 3
	return velocity.x

func emit_walk_particles():
	get_floor_color(running_particles)
	running_particles.emitting = true

func emit_landing_particles():
	var landing_particles_instance = landing_particles.instantiate()
	get_floor_color(landing_particles_instance)
	landing_particles_instance.emitting = true
	landing_particles_instance.position = feet_marker.global_position
	owner.add_child(landing_particles_instance)
	hasJumped = false

func get_floor_color(particle):
	if is_on_floor():
		var floor = get_last_slide_collision()
		if floor != null:
			floor = floor.get_collider()
		if (floor != null and floor.has_method("pass_particle_color")):
			particle.color = floor.pass_particle_color()

func interact():
	isInteracting = true
	sprite.play("pickup")
	await get_tree().create_timer(0.3).timeout
	if sprite.animation_finished:
		print("finito")
		isInteracting = false

func _on_step_timer_timeout():
	if step_counter == 0:
		step_counter = 1
	if step_counter == 1:
		step_counter = 0


func _on_charge_area_body_entered(body):
	if body.has_method("get_charged"):
		body.get_charged(last_direction)


func _on_charge_timer_timeout():
	canCharge = true
