extends Node2D

@onready var poop = preload("res://scenes/poop.tscn")
@onready var poop_marker = $Marker2D
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	sprite.play("pooping")
	var poop_instance = poop.instantiate()
	add_child(poop_instance)
	poop_instance.global_position = poop_marker.global_position
	await get_tree().create_timer(0.3).timeout
	sprite.play("default")
