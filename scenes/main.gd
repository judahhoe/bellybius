extends Node2D

var isBloated = false
@onready var unbloated = preload("res://scenes/pythoniusz.tscn")
@onready var bloated = preload("res://scenes/bellybius_bloated.tscn")
var current_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("bloat"):
		if !isBloated:
			get_bloated()
		elif isBloated:
			unbloat()

func get_bloated():
	print(owner)
	var unbloated_player = get_node("pythoniusz")
	current_position = unbloated_player.position
	remove_child(unbloated_player)
	var bloated_instance = bloated.instantiate()
	add_child(bloated_instance)
	bloated_instance.position = current_position
	isBloated = true

func unbloat():
	var bloated_player = get_node("bellybius_bloated")
	current_position = bloated_player.position
	remove_child(bloated_player)
	var unbloated_instance = unbloated.instantiate()
	add_child(unbloated_instance)
	unbloated_instance.position = current_position
	isBloated = false
