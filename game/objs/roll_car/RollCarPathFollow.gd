extends PathFollow2D

var is_start = false
var layer: int

export var speed := 200.0

onready var timer := $Timer as Timer
onready var car := $car as KinematicBody2D
onready var line := $Line2D as Line2D

func _ready():
	var player = BehaviorUtils.find_player()
	
	if player:
		player.connect('on_die', self, '_on_player_die')
	
	layer = car.collision_layer
	
	var path = get_parent() as Path2D
	
	if path && path.curve:
		var global_pos = line.global_position
		line.get_parent().remove_child(line)
		path.call_deferred('add_child', line)
		_draw_curve(path.curve)
		
func _on_player_die():
	if is_start:
		timer.stop()
		_on_Timer_timeout()
		
func _draw_curve(curve: Curve2D):
	var points = curve.tessellate()
	
	line.points = points

func _physics_process(delta: float):
	if is_start:
		if unit_offset < 1.0:
			offset += speed * delta
		else:
			if timer.is_stopped():
				# 重置位置计时器
				timer.start()
				
	_update_car_pos()
	
func _update_car_pos():
	if car:
		car.global_position = global_position

func _on_Area2D_body_entered(body: Node2D):
	if BehaviorUtils.is_player(body):
		is_start = true
		
func _on_Timer_timeout():
	if !car.collision_layer:
		car.visible = true
		car.collision_layer = layer
		return
	
	offset = 0
	car.visible = false
	car.collision_layer = 0
	timer.start()
	_update_car_pos()
	is_start = false
