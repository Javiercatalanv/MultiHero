extends Node

@export var vidaMaxima: int = 3
var vidaActual: int = vidaMaxima

func reducirVida(cantidad: int):
	vidaActual -= cantidad
	vidaActual = max(vidaActual, 0)
	print(vidaActual)

func restaurarVida(cantidad: int):
	vidaActual += cantidad
	vidaActual = min(vidaActual, vidaMaxima)

func vidas(cantidad: int):
	if vidaActual == 3:
		$CorazonIzquierda.visible = true
		$CorazonMedio.visible = true
		$CorazonDerecha.visible = true
	if vidaActual == 2:
		$CorazonIzquierda.visible = true
		$CorazonMedio.visible = true
		$CorazonDerecha.visible = false
	if vidaActual == 1:
		$CorazonIzquierda.visible = true
		$CorazonMedio.visible = false
		$CorazonDerecha.visible = false
	if vidaActual == 0:
		$CorazonIzquierda.visible = false
		$CorazonMedio.visible = false
		$CorazonDerecha.visible = false
