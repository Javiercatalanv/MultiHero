extends Node2D

signal ataque_desaparecido

var velocidad = Vector2(250,0)
var salida = false
var cont = 0
var textura: Texture = preload("res://Assets_PixelAdventure/Other/Dust Particle.png")
@export var tiempo_para_desaparecer = 4.5  # Tiempo en segundos antes de desaparecer
var temporizador_actual = 0.0
func _ready():
	if salida:
		velocidad.x *= -1
		$Sprite2D.flip_h = true  
	else:
		$Sprite2D.flip_h = false 

func _process(delta):
	
	position += velocidad * delta
	
	if temporizador_actual > 0:
		temporizador_actual -= delta
		if temporizador_actual <= 0:
			emit_signal("ataque_desaparecido")
			queue_free()

func replace_node_with_area2d(node_to_replace: Node2D):
		
	var parent = node_to_replace.get_parent()
	var posicion = node_to_replace.position
	
	node_to_replace.queue_free()

	var new_node = StaticBody2D.new()
	
	new_node.position = posicion
	
	var sprite = Sprite2D.new()
	sprite.texture = textura
	
	new_node.add_child(sprite)
	
	parent.add_child(new_node)
	
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(20,8)
	collision_shape.shape = shape
	new_node.add_child(collision_shape)

func _on_hit_box_body_entered(body):
	
	body = body
	cont += 1
	if cont == 2:
		velocidad = Vector2(0,0)
		replace_node_with_area2d($Sprite2D)
		temporizador_actual = tiempo_para_desaparecer
