extends KinematicBody2D

var dir := Vector2.UP
var speed := 100.0

onready var timer := $Timer as Timer
onready var sensor := $Area2D as Area2D

func _ready():
	pass # Replace with function body.


func _physics_process(delta: float):
	if !timer.is_stopped():
		return
	
	var vel := dir * speed
	
	position += vel * delta;
	
	if sensor.get_overlapping_bodies().size() > 0:
		timer.start()
		
	
func _on_Timer_timeout():
	queue_free()


func _on_life_timeout():
	if !timer.is_stopped():
		return
	timer.start()
