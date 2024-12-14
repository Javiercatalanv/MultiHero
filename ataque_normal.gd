extends Node2D

var velocidad = Vector2(250,0)
var salida = false
var cont = 0

signal destruirNieve 

func _ready():
	$Timer.start()
	if salida:
		velocidad.x *= -1
		$Sprite2D.flip_h = true  
	else:
		$Sprite2D.flip_h = false  

func SetDireccion(direccion: bool) -> void:
	salida = direccion
	if salida:
		velocidad.x *= 1
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func _process(delta):
	
	position += velocidad * delta


func _on_hit_box_body_entered(body):
	body = body
	cont += 1
	if cont == 2:
		destruirProyectil()
func _on_timer_timeout():
	destruirProyectil()
func destruirProyectil():
	emit_signal("destruirNieve")
	queue_free()
