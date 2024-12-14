extends Node2D


var velocidad = Vector2(250,0)
var salida = false

signal destruirLaser

func _ready() -> void:
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	body = body
	destruirProyectil()

func _on_timer_timeout():
	destruirProyectil()
	
func destruirProyectil():
	emit_signal("destruirLaser")
	queue_free()
