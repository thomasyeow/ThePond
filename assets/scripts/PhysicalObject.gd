extends Node2D
class_name PhysicalObject

var size:Global.Size

func _init(sizeArg:Global.Size):
	size = sizeArg
	
func _ready():
	#default size is small
	print(name, " ready")
	size = Global.Size.SMALL
