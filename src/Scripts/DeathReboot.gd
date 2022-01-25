extends Node2D

onready var Player = get_parent()

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _process(delta):
	if Player.health <= 0:
		self.visible = true
		if $RebootTimer.is_stopped():
			$RebootTimer.start()
		$RebootLabel.text = str(round_to_dec($RebootTimer.time_left,2))


func _on_RebootTimer_timeout():
	$RebootTimer.stop()
	self.visible = false
	for n in get_tree().get_nodes_in_group("Enemy"):
		n.health = 0
	for n in get_tree().get_nodes_in_group("Collectible"):
		n.queue_free()
	var Player = get_parent()
	Player.health = 5
	Player.position = Vector2.ZERO
	Player.inputON = true
	Player.get_node("Glitch").visible = false
	Player.get_node("AnimationTree").get("parameters/playback").travel("Idle")
	var Wave = Player.get_parent().get_node("WaveManager")
	Wave.currentWave = 0
	Wave.get_node("Timer").stop()
