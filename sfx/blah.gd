extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand = randf_range(1.4,2)
	pitch_scale = rand
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
