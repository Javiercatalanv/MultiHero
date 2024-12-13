extends CanvasLayer

func _process(_delta):
	$cantidadLlaves.text = str(get_parent().llaves)
