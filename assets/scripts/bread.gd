extends PhysicalObject


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	super(Global.Size.LARGE)
	print("init bread with size: ", size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
