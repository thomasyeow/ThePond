extends Camera2D

var cameraSpeed:int = 10

var moveRight:bool = false
var moveLeft:bool = false
var moveUp:bool = false
var moveDown:bool = false

var viewportSize:Vector2
#scroll boundaries in pixels, updated when window size changes
var scrollBoundaries:Array= [0, 0, 0, 0]
#percent of viewport size distance to trigger scrolling
var scrollBoundaryPercent = 0.02
func _ready():	
	get_tree().get_root().connect("size_changed", windowSizeChanged)
	windowSizeChanged()
	

func _input(event):
	if event is InputEventMouseMotion:
		moveCamera(event)
		
func _physics_process(delta):
	force_update_transform()
	if moveRight:
		if(position.x > limit_right * 3/5):
			position.x = limit_right*3/5
		position.x += cameraSpeed
	elif moveLeft:
		if(position.x < limit_left * 3/5):
			position.x = limit_left*3/5
		position.x -= cameraSpeed
	if moveUp:
		if(position.y < limit_top * 3/5):
			position.y = limit_top * 3/5
		position.y -= cameraSpeed
	elif moveDown:
		if(position.y > limit_bottom * 3/5):
			position.y = limit_bottom * 3/5
		position.y += cameraSpeed
	
func moveCamera(event: InputEventMouseMotion):
	if event.position.x > scrollBoundaries[3]:
		moveLeft = false
		moveRight = true
	else:
		moveRight = false
	if event.position.x < scrollBoundaries[2]:
		moveRight = false
		moveLeft = true
	else:
		moveLeft = false
	if event.position.y < scrollBoundaries[0]:
		moveDown = false
		moveUp = true
	else:
		moveUp = false
	if event.position.y > scrollBoundaries[1]:
		moveUp = false
		moveDown = true
	else:
		moveDown = false

func windowSizeChanged():
	viewportSize = get_viewport_rect().size
	
	scrollBoundaries = [viewportSize.y * (scrollBoundaryPercent), viewportSize.y * (1 - scrollBoundaryPercent),
	viewportSize.x * (scrollBoundaryPercent), viewportSize.x * (1 - scrollBoundaryPercent)]
