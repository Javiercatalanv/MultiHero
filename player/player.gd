extends CharacterBody2D

var spead:= 120
var direccion := 0.0

func _physics_process(delta):
	direccion = Input.get_axis("ui_left", "ui_right")
	velocity.x =  direccion*spead
	move_and_slide()
