extends KinematicBody2D

const TARGET_FPS = 60
export var ACCELERATION = 8
export var MAX_SPEED = 64
export var FRICTION = 10
export var AIR_RESISTANCE = 1
export var GRAVITY = 4
export var JUMP_FORCE = 140

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var collisionShape = $CollisionShape2D
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animationPlayer.play("Idle")
		
		
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE

	else:
		animationPlayer.play("Jump")
			
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
			
	motion = move_and_slide(motion, Vector2.UP)
