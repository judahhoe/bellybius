extends StaticBody2D

@onready var particles = $CPUParticles2D
@onready var collider = $CollisionShape2D
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func destroy():
	sprite.visible = false
	collider.call_deferred("set_disabled", true)
	particles.emitting = true
	await get_tree().create_timer(1.5).timeout
	queue_free()
