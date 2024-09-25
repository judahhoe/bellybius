extends Node2D

@onready var particles = $CPUParticles2D
@onready var animation = $AnimationPlayer
var main_node

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("float")
	main_node = get_node("/root/main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("drink"):
		body.drink()
		#await get_tree().create_timer(0.5).timeout
		particles.emitting = true
		main_node.get_bloated()
		queue_free()
