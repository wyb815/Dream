extends PathFollow2D

var car: KinematicBody2D

export var speed := 50.0

func _ready():
	car = $car

func _physics_process(delta: float):
	if unit_offset < 1.0:
		offset += speed * delta
	if car:
		car.global_position = global_position
