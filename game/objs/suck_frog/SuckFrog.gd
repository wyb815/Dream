extends Area2D

enum State {
	Idle,
	Attack,
	ToneBack,
}

var target_enter_time := -1.0
var state = State.Idle
var SUCK_SPEED := 400.0
var TONE_BACK_SPEED := 200.0

onready var tone := $tone as Area2D
onready var tween := $tween as Tween

func _ready():
	pass # Replace with function body.
	

func _on_SuckFrog_body_entered(body: Node2D):
	if state != State.Idle:
		# 攻击中
		return
		
	if !BehaviorUtils.is_player(body):
		# 不是玩家
		return
	_attack(body)
	
func _attack(target: Node2D):
	# 开始伸向玩家
	state = State.Attack
	
	_tone_move_to(target.global_position, SUCK_SPEED)
	

func _on_tone_body_entered(body):
	# 找到玩家
	print('find player')
	
func _on_tween_tween_completed(object, key):
	if state == State.Attack:
		# 舌头收回来
		state = State.ToneBack
		_tone_move_to(global_position, TONE_BACK_SPEED)
	else:
		state = State.Idle
	
func _tone_move_to(target_position: Vector2, speed: float):		
	var duration = (tone.global_position - target_position).length() / speed
	
	# 设置插值动画：对 "position" 属性进行插值
	# 参数：对象，属性，起始值，终点值，持续时间，过渡类型，缓动类型
	tween.interpolate_property(
		tone, 
		"global_position", 
		tone.global_position,    # 起始位置：当前位置
		target_position, # 目标位置
		duration # 移动所需的时长（秒）)
	)    
	# 启动动画
	tween.start()
