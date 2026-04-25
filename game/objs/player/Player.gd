extends KinematicBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 580.0
var velocity = Vector2()
var up_dir := Vector2(0, -1)
var height := 150

var is_follow := false
var follow_v := Vector2(0, 0)
var is_on_platform := false
var jump_apply_left_time := 0.0
var born_pos := Vector2()

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var move_body = $move
onready var con = $con

func _ready():
	born_pos = global_position

func _physics_process(delta: float) -> void:
	if is_follow:
		_handle_follow()
		return
	
	if is_on_floor():
		# 要把设成 0，才能站在蜗牛的头上
		velocity.y = 0
	else:
		velocity.y += gravity * delta		
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			jump_apply_left_time = 0.5
			velocity.y = JUMP_VELOCITY * up_dir.y
	else:
		if jump_apply_left_time > 0:
			if Input.is_action_pressed("ui_accept"):
				jump_apply_left_time -= delta
			else:
				#松开跳跃键，跳的近一些
				velocity.y *= 0.3
				jump_apply_left_time = 0

	velocity = move_and_slide_with_snap(velocity, Vector2(0, -up_dir.y * 2.0), up_dir)
	
func _handle_follow():
	if Input.is_action_just_pressed("ui_accept"):
		# 解除跟随
		velocity.y = JUMP_VELOCITY * up_dir.y
		is_follow = false
		return
	
	velocity = follow_v
	move_and_slide(velocity, up_dir)

