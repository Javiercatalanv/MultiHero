extends Node2D

@onready var rect_verde: ColorRect = $rect_verde
@onready var rect_rojo: ColorRect = $rect_rojo
@onready var rect_azul: ColorRect = $rect_azul
@onready var rect_amarillo: ColorRect = $rect_amarillo

@onready var nfc_reader: Node = $NFCReader

var colores_originales: Dictionary = {}
var colores_claros: Dictionary = {}
var secuencia: Array = []
var indice: int = 0
var jugando: bool = false

var tarjetas_colores: Dictionary = {
	"C3CDCFF8": "verde",
	"F3F12B11": "rojo",
	"D2A93E52": "azul",
	"915E6AD": "amarillo"
}

func _ready() -> void:
	# Guardar los colores originales de cada ColorRect
	colores_originales = {
		"verde": rect_verde.color,
		"rojo": rect_rojo.color,
		"azul": rect_azul.color,
		"amarillo": rect_amarillo.color
	}

	# Crear colores aclarados
	for color_nombre in colores_originales.keys():
		var color: Color = colores_originales[color_nombre]
		colores_claros[color_nombre] = color.lightened(0.5)

	# Conectar señal de NFCReader
	nfc_reader.connect("UIDReceived", Callable(self, "_on_uid_received"))

	# Iniciar el juego
	iniciar_juego()

func iniciar_juego() -> void:
	secuencia.clear()
	indice = 0
	jugando = true
	agregar_color_a_secuencia()

func agregar_color_a_secuencia() -> void:
	var colores = ["verde", "rojo", "azul", "amarillo"]
	secuencia.append(colores[randi() % colores.size()])
	mostrar_secuencia()

func mostrar_secuencia() -> void:
	jugando = false
	for i in range(secuencia.size()):
		await mostrar_color(secuencia[i])
	jugando = true
	indice = 0

func mostrar_color(color_nombre: String) -> void:
	var rect = get_rect_por_nombre(color_nombre)
	if rect != null:
		rect.color = colores_claros[color_nombre]
		await get_tree().create_timer(0.5).timeout
		rect.color = colores_originales[color_nombre]
		await get_tree().create_timer(0.5).timeout

func get_rect_por_nombre(nombre: String) -> ColorRect:
	match nombre:
		"verde": return rect_verde
		"rojo": return rect_rojo
		"azul": return rect_azul
		"amarillo": return rect_amarillo
	return null

func _on_uid_received(uid: String) -> void:
	print("UID recibido: ", uid)
	if not jugando:
		return

	var color_nombre: String = ""
	if uid in tarjetas_colores:
		color_nombre = tarjetas_colores[uid]
	else:
		color_nombre = "desconocido"

	# Iluminar el color correspondiente o un color de error
	await iluminar_color(color_nombre)

	if color_nombre != "desconocido":
		validar_entrada(color_nombre)
	else:
		print("UID desconocido: ", uid)

func iluminar_color(color_nombre: String) -> void:
	var rect = get_rect_por_nombre(color_nombre)
	if rect != null:
		rect.color = colores_claros[color_nombre]
		await get_tree().create_timer(0.5).timeout
		rect.color = colores_originales[color_nombre]
		await get_tree().create_timer(0.5).timeout
	else:
		print("Color no reconocido, no se puede iluminar.")

func validar_entrada(color_presionado: String) -> void:
	if secuencia[indice] == color_presionado:
		indice += 1
		if indice >= secuencia.size():
			agregar_color_a_secuencia()
	else:
		jugando = false
		print("\u00a1Te equivocaste! Reiniciando juego...")
		await get_tree().create_timer(2.0).timeout
		iniciar_juego()
