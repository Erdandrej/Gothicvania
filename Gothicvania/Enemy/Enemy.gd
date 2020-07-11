extends Node2D

var Fireball = preload("res://Effects/Fireball.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var ray = $RayCast2D
onready var projectileSpawn = $ProjectileSpawn
onready var timer = $Timer

func _ready():
	animationPlayer.play("Idle")
	
func _physics_process(delta):
	if ray.is_colliding():
		attack()
		
func attack():
	ray.enabled = false
	animationPlayer.play("Attack")
	yield(animationPlayer, "animation_finished")
	animationPlayer.play("Idle")	
	timer.start(2)
	yield(timer, "timeout")
	ray.enabled = true
	
func create_projectile():
	var main = get_tree().current_scene
	var fireball = Fireball.instance()
	if sprite.flip_h:
		fireball.direction = Vector2.RIGHT
	main.add_child(fireball)
	fireball.global_position = projectileSpawn.global_position
	
