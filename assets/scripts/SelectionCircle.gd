extends Node2D

func setFor(physObj):
	scale = Vector2(physObj.size, physObj.size)
	position = physObj.position
