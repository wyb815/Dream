extends Area2D

var x_speed := 200.0
var y_speed := 100.0
var ctrl_body: KinematicBody2D
var pos_offset := Vector2(0, -20)
var vel := Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta: float):
	if ctrl_body:
		if ctrl_body.is_follow:
			var dir = ctrl_body.get_ctrl_dir() as Vector2
			
			vel.x = dir.x * x_speed
			vel.y += ctrl_body.gravity * delta
			
			global_position = ctrl_body.global_position + pos_offset
			
			if dir.y != 0:
				vel.y = dir.y * y_speed
			
			ctrl_body.follow_v = vel
		else:
			ctrl_body = null
			queue_free()

func _on_Copter_body_entered(body: KinematicBody2D):
	if ctrl_body:
		return
	if 'is_follow' in body:
		body.is_follow = true
		ctrl_body = body
		ctrl_body.global_position = global_position - pos_offset
