extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const SPEED = 300.0
const JUMP_VELOCITY = 580.0
var velocity = Vector2()
var up_dir := Vector2(0, -1)
var height := 150

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var move_body = $move
onready var con = $con

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * up_dir.y

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide(velocity, up_dir)
