extends Node2D

var dir := Vector2.UP
var gen_interval := 3
var bubble_scene := preload('./Bubble.tscn')

onready var timer := $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var bubble = bubble_scene.instance()
	
	timer.start(gen_interval);
	get_parent().add_child(bubble)
	bubble.global_position = global_position
