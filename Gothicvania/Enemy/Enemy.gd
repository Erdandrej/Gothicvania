extends Node2D

var Fireball = preload("res://Effects/Fireball.tscn")
 
export var health = 3

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var ray = $RayCast2D
onready var projectileSpawn = $ProjectileSpawn
onready var timer = $Timer
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animationPlayer.play("Idle")
	
func _physics_process(_delta):
	if health <= 0:
		death()
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

func death():
	animationPlayer.play("Death")
	yield(animationPlayer, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	health -= area.damage
	hurtbox.start_invincibility(0.25)

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
