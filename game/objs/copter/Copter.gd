extends Area2D

var speed := 200.0
var ctrl_body: KinematicBody2D
var pos_offset := Vector2(0, -20)

func _ready():
	pass
	
func _physics_process(_delta: float):
	if ctrl_body:
		if ctrl_body.is_follow:
			var dir = ctrl_body.get_ctrl_dir()
			global_position = ctrl_body.global_position + pos_offset
			ctrl_body.follow_v = dir * speed
		else:
			ctrl_body = null

func _on_Copter_body_entered(body: KinematicBody2D):
	if ctrl_body:
		return
	if 'is_follow' in body:
		body.is_follow = true
		ctrl_body = body
		ctrl_body.global_position = global_position - pos_offset
