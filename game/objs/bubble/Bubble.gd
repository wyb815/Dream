extends KinematicBody2D

var dir := Vector2.UP
var speed := 100.0

onready var timer := $Timer as Timer

func _ready():
	pass # Replace with function body.


func _physics_process(delta: float):
	if !timer.is_stopped():
		return
	
	var vel := dir * speed
	var col := move_and_collide(vel * delta)
	
	if col:
		timer.start()
		
	
func _on_Timer_timeout():
	queue_free()
