extends Node2D

var speed = 50
var direction = Vector2.LEFT

func _process(delta):
	move_local_x(delta * -50)
	
func _on_Area2D_body_entered(body):
	queue_free()
