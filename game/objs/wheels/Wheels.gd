extends Node2D

tool

var wheels_node = preload('./WheelsNode.tscn')
var cur_rotation := 0.0
var is_ready := false

export var anti_clock := false
export var radius := 150 setget set_radius
export var count := 8 setget set_count,get_count

func set_count(val: int):
	count = val
	while get_child_count() > 0:
		var child = get_child(0)
		
		remove_child(child)
		child.queue_free()
		
	for i in range(0, val):
		var sub_node = wheels_node.instance()
		
		add_child(sub_node)
	_update_child_pos()
	
		
func get_count():
	return count
	
func set_radius(val):
	radius = val
	_update_child_pos()
	
func get_radius():
	return radius

# Called when the node enters the scene tree for the first time.
func _ready():
	set_count(get_count())
	set_process_priority(ProcessPriority.WHEELS)


func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	# 转速，多少秒一圈
	var dir := -1.0 if anti_clock else 1.0
	var speed := 360.0 / 10.0 * dir
	var pass_degree = delta * speed
	var next_rotation = cur_rotation + pass_degree
	var count = get_count()
	
	# 每个车厢尝试进行转动
	for i in range(0, get_child_count()):
		var child = get_child(i) as KinematicBody2D
		# 算出车厢的下一个位置
		var rotation = next_rotation + i * (360.0 / count)
		var pos = Vector2(radius * cos(deg2rad(rotation)), radius * sin(deg2rad(rotation)))
		
		var offset = pos - child.position
		child.position += offset
						
	cur_rotation = next_rotation
			
		
func _update_child_pos():
	var child_count = get_child_count()
	
	for i in range(0, child_count):
		var child = get_child(i) as KinematicBody2D
		var degree = i * (360.0 / child_count)
	
		var pos = Vector2(radius * cos(deg2rad(degree)), radius * sin(deg2rad(degree)))
		child.position = pos
