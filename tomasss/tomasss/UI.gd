extends CanvasLayer

var heart1
var heart2
var heart3

func _ready():
	
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart3 = get_node("Heart3")
		
	

func handleHearts(vidas):
	
	if	vidas==0:	
		heart1.visible =false
		
	if	vidas==1:	
		heart2.visible =false
		
	if	vidas==2:	
		heart3.visible =false
