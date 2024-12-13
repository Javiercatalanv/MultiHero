extends Control

var full_text: String = "En un universo distante, donde las nubes se movían al ritmo de las emociones..."
var text_speed: float = 0.05
var current_text: String = ""
var timer: Timer

func _ready():
	# Crear y configurar el Timer
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = text_speed
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	
	# Configurar Label
	var _label = $ScrollContainer/VBoxContainer/MarginContainer/Label
	_label.autowrap = true
	$ScrollContainer/VBoxContainer.size_flags_vertical = Control.SIZE_EXPAND

func _on_timer_timeout():
	var _label = $ScrollContainer/VBoxContainer/MarginContainer/Label
	if current_text.length() < full_text.length():
		# Añadir un carácter más al texto actual
		current_text = full_text.substr(0, current_text.length() + 1)
		_label.text = current_text
		
		# Desplazar automáticamente el ScrollContainer
		$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll().max_value
	else:
		# Detener el Timer y cambiar la escena
		timer.stop()
		get_tree().change_scene_to_file("res://Jugador/mundo.tscn")
