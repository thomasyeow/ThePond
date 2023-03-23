extends Node2D

const TILE_SIZE:int = 32

#status bools
var isNodeSelected:bool = false

#scene references
var selectionCircleScene  = preload("res://assets/scenes/ui/SelectionCircle.tscn")

#node references
var selectedNode
var selectionCircle
var breadNode
var cameraNode
var yellowBase
var redBase
var blueBase
var greenBase

#tile status dictionary
var tileDict = {}

func _ready():
	print(range(1,2))
	#setup board dictionary
	for x in range(-23, 25):
		for y in range (-19, 19):
			tileDict[Vector2(x, y)] = null
	#get references to starting nodes
	breadNode = get_node("bread")
	cameraNode = get_node("Camera2D")
	yellowBase = get_node("YellowBase")
	redBase = get_node("RedBase")
	blueBase = get_node("BlueBase")
	greenBase = get_node("GreenBase")
	moveNode(breadNode, 0,1)
	moveNode(yellowBase, -18, 16)
	moveNode(redBase, -18, -14)
	moveNode(blueBase, 18, -14)
	moveNode(greenBase, 18, 16)
	print("Bread is of size: ", breadNode.size)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			#only releasing the mouse button does stuff
			if !(event.is_pressed()):
				var clickedTile:Vector2 = getTileCords(get_global_mouse_position())
				print("Clicked on tile: ", clickedTile)
				if (isNodeSelected):
					selectedNode = null
					selectionCircle.queue_free()
					isNodeSelected = false
				if (tileDict[clickedTile] is PhysicalObject):
					isNodeSelected = true
					selectedNode = tileDict[clickedTile]
					selectionCircle = selectionCircleScene.instantiate()
					add_child(selectionCircle)
					selectionCircle.setFor(selectedNode)

func printTilePos(pos:Vector2):
	print("Mouse position: ", pos, ", Tile coordinate: ", getTileCords(pos))

func getTileCords(pos:Vector2):
	return Vector2(floori(pos.x/TILE_SIZE), ceili(-pos.y/TILE_SIZE))

#visually places PhysicalObject in tile (xCoor, yCoor)
#This function is supposed to simplify moving PhysicalObject instances around
#Passed coordinates start from (0,0) from the centermost square, like a cartesian plane
func moveNode(physObj:PhysicalObject, xCoor:int, yCoor:int):
	var oldPosition:Vector2 = getTileCords(physObj.position)
	unregisterObj(oldPosition.x, oldPosition.y)
	physObj.position = Vector2(xCoor*TILE_SIZE, -yCoor*TILE_SIZE)
	registerObj(physObj, xCoor, yCoor)
	
	
#register PhysicalObject at this position
func registerObj(physObj:PhysicalObject, xCoor:int, yCoor:int):
	var size = physObj.size
	match size:
		Global.Size.SMALL:
			tileDict[Vector2(xCoor, yCoor)] = physObj
		Global.Size.MEDIUM:
			for x in range(xCoor, xCoor + 2):
				for y in range(yCoor - 1, yCoor + 1):
					tileDict[Vector2(x, y)] = physObj
		Global.Size.LARGE:
			for x in range(xCoor, xCoor + 3):
				for y in range(yCoor - 2, yCoor + 1):
					tileDict[Vector2(x, y)] = physObj

#unregister PhysicalObject at this position
func unregisterObj(xCoor:int, yCoor:int):
	if(tileDict[Vector2(xCoor, yCoor)] == null):
		return
	var objToUnregister = tileDict[Vector2(xCoor, yCoor)].position
	#get this PhysicalObject's first(topleftmost) tile
	var objStartPos:Vector2 = getTileCords(objToUnregister.position)
	#loop to unregister this node from every tile it occupies
	for x in range(objStartPos.x, objStartPos.x + objToUnregister.size):
		for y in range(objStartPos.y, objStartPos.y + objToUnregister.size):
			tileDict[Vector2(x, y)] = null

