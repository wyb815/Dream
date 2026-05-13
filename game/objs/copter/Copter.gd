extends Area2D

var x_speed := 200.0
var y_speed := 200.0
var ctrl_body: KinematicBody2D
var pos_offset := Vector2(0, -20)
var vel := Vector2.ZERO
var born_pos: Vector2

onready var lab_left_time := $labLeftTime as Label
onready var life_timer := $life_timer as Timer
onready var reset_timer := $reset_timer as Timer

func _ready():
	set_process_priority(ProcessPriority.COPER)
	born_pos = global_position
	reset()
	
func reset():
	global_position = born_pos
	life_timer.stop()
	lab_left_time.text = str(life_timer.wait_time)
	if ctrl_body:
		ctrl_body.is_follow = false;
		ctrl_body = null

func _refresh_lab():
	lab_left_time.text = "%.1f" % life_timer.time_left
	
func _physics_process(delta: float):
	if !life_timer.is_stopped():
		_refresh_lab()
		
	if not ctrl_body:
		for body in get_overlapping_bodies():
			if is_instance_valid(body):
				_on_Copter_body_entered(body)
				if ctrl_body:
					break
			
	
	if ctrl_body:
		if ctrl_body.is_follow || life_timer.is_stopped():
			var dir = ctrl_body.get_ctrl_dir() as Vector2
			
			vel.x = dir.x * x_speed
			vel.y += ctrl_body.gravity * delta
			
			global_position = ctrl_body.global_position + pos_offset
			
			if dir.y != 0:
				vel.y = dir.y * y_speed
			
			ctrl_body.follow_v = vel
		else:
			_on_die()

func _on_Copter_body_entered(body: KinematicBody2D):
	if ctrl_body:
		return
	if is_instance_valid(body) && 'is_follow' in body:
		body.is_follow = true
		ctrl_body = body
		ctrl_body.global_position = global_position - pos_offset
		life_timer.start()


func _on_life_timer_timeout():
	_on_die()

func _on_die():
	visible = false
	set_physics_process(false)
	reset()
	reset_timer.start()


func _on_reset_timer_timeout():
	visible = true
	set_physics_process(true)
