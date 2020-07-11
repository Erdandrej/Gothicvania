extends KinematicBody2D

const TARGET_FPS = 60
export var ACCELERATION = 8
export var MAX_SPEED = 64
export var FRICTION = 10
export var AIR_RESISTANCE = 1
export var GRAVITY = 4
export var JUMP_FORCE = 140

enum {
	MOVE,
	ATTACK,
	CROUCH,
	DODGE
}

var state = MOVE
var animation = "Idle"
var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var shape = $Shape
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		CROUCH:
			crouch_state(delta)
		DODGE:
			dodge_state(delta)
	
func move_state(delta):
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animation = "Run"
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animation = "Idle"
		
		
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_FORCE

	else:
		if Input.is_action_pressed("attack"):
			animation = "JumpKick"
		else:
			if motion.y < 0 :
				animation = "Jump"
			else:
				animation = "Fall"
			
		if Input.is_action_just_released("jump") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	animationPlayer.play(animation)
	motion = move_and_slide(motion, Vector2.UP)

func attack_state(delta):
	if is_on_floor():
		if Input.get_action_strength("ui_down") == 1:
			animationPlayer.play("CrouchKick")
		elif Input.get_action_strength("ui_up") == 1:
			animationPlayer.play("Kick")
		else:
			animationPlayer.play("Punch")
	
		yield(animationPlayer, "animation_finished")
		
	state = MOVE

func crouch_state(delta):
	pass
	
func dodge_state(delta):
	pass
