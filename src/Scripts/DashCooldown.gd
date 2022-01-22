extends Polygon2D

onready var length = 14
onready var DashTimer = get_parent().get_node("DashRecoveryTimer")

func _process(delta):
	if DashTimer.is_stopped():
		self.visible = false
	else:
		self.visible = true
		var x = (1 - DashTimer.time_left / DashTimer.wait_time) * length
		print(DashTimer.time_left / DashTimer.wait_time)
		self.polygon = PoolVector2Array( [Vector2(-8, -10), Vector2(7-x, -10), Vector2(7-x, -8), Vector2(-8, -8)] )

