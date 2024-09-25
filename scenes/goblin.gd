extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var belly_plop_sound = $PlopAudio

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	sprite.play("default")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func get_charged(direction):
	belly_plop_sound.play()
	animation.play("get_charged")
	collider.call_deferred("set_disabled", true)
	sprite.play("fall")
	velocity.x = direction * 20
	velocity.y = -100
	await get_tree().create_timer(3).timeout
	queue_free()
