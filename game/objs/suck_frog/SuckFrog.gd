extends Area2D

enum State {
	Idle,
	Attack,
	ToneBack,
	Rest, # 休息
}

var target_enter_time := -1.0
var state = State.Idle
var SUCK_SPEED := 400.0
var TONE_BACK_SPEED := 200.0
var catch_body: Node2D

onready var tone := $tone as Area2D
onready var tween := $tween as Tween
onready var sensor := $sensor as CollisionShape2D

func _physics_process(_delta: float):
	if catch_body:
		catch_body.global_position = tone.global_position
		return
		
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		_check_body(body)
	

func _check_body(body: Node2D):	
	if state != State.Idle:
		# 攻击中
		return
		
	if !BehaviorUtils.can_die(body):
		# 不是玩家
		return
		
	if (body.global_position - global_position).length() > (sensor.shape as CircleShape2D).radius * 2:
		# 范围外
		return
		
	_attack(body)
	
func _attack(target: Node2D):
	# 开始伸向玩家
	state = State.Attack
	
	_tone_move_to(target.global_position, SUCK_SPEED, 0)

func _on_tone_body_entered(body: Node2D):
	if catch_body:
		return
		
	# 找到玩家
	if BehaviorUtils.can_die(body):
		catch_body = body
		_tone_back()
	
func _tone_move_to(target_position: Vector2, speed: float, end_wait: float):		
	var duration = (tone.global_position - target_position).length() / speed
	
	tween.interpolate_property(
		tone, 
		'global_position', 
		tone.global_position, 
		target_position,
		duration
	)
	if end_wait > 0:
		tween.interpolate_callback(self, duration + end_wait, '_foo')
	
	# 启动动画
	tween.start()
	
func _foo():
	pass

# 舌头收回来
func _tone_back():
	if state == State.ToneBack:
		return
	state = State.ToneBack
	_tone_move_to(global_position, TONE_BACK_SPEED, 0.5)

func _on_tween_tween_all_completed():
	if state == State.Attack:
		_tone_back()
	elif state == State.Rest:
		#休息结束
		state = State.Idle
	else:
		state = State.Rest
		tween.interpolate_callback(self, 0.2, '_foo')
		tween.start()
		if catch_body:
			catch_body.die()
			catch_body = null
