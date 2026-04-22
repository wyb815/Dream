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

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var move_body = $move
onready var con = $con

func _physics_process(delta: float) -> void:
	if is_follow:
		_handle_follow()
		return
		
	velocity.y += gravity * delta
	
	var isJumpPressed = Input.is_action_pressed("ui_accept");
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_apply_left_time = 0.5
		velocity.y = JUMP_VELOCITY * up_dir.y
	else:
		if Input.is_action_pressed("ui_accept"):
			jump_apply_left_time -= delta
		else:
			if jump_apply_left_time > 0:
				#松开跳跃键，跳的近一些
				velocity.y *= 0.3
				jump_apply_left_time = 0
			
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	velocity = move_and_slide(velocity, up_dir)
	
func _handle_follow():
	if Input.is_action_just_pressed("ui_accept"):
		# 解除跟随
		velocity.y = JUMP_VELOCITY * up_dir.y
		is_follow = false
		return
	
	velocity = follow_v
	move_and_slide(velocity, up_dir)

