extends Area2D

onready var waveManager = get_parent().get_parent().get_node("WaveManager")

func _on_KillZone_area_entered(area):
	if area.name == "RobotArea":
		area.get_parent().queue_free()
		if waveManager.currentWave >= 5:
			waveManager.populate_DMC()
		else:
			waveManager.populate_one()
