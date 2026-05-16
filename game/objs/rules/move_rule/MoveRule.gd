extends Node2D

class_name MoveRule

var velocity: Vector2
var gravity := 980
var up_dir := Vector2.UP
var init_dir: float
var born_pos: Vector2

export var direction := 0.0
export var move_speed := 200.0
export var jump_speed := 580.0

onready var body := get_parent() as KinematicBody2D

func _ready():
	init_dir = direction
	born_pos = body.global_position
	
func reset_to_ready():
	direction = init_dir
	velocity = Vector2.ZERO
	body.global_position = born_pos

func handle_gravity(delta: float):
	if velocity.y > 0 && body.is_on_floor():
		velocity.y = 0
	else:
		# 重力
		velocity.y += gravity * delta
		
func handle_move_speed():
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

func move():
	velocity = body.move_and_slide_with_snap(velocity, Vector2(0, -up_dir.y * 2.0), up_dir)
