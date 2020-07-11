extends Node2D

var speed = 50
var direction = Vector2.RIGHT

func _process(delta):
	move_local_x(delta * -50)

func _on_Hitbox_area_entered(_area):
	queue_free()
