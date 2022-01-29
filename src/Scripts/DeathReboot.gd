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
		n._setDropRate(0.0)
		n._setCount(false)
		n.health = 0
	for n in get_tree().get_nodes_in_group("Collectible"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("Bullet"):
		n.queue_free()	
	var Player = get_parent()
	Player.health = 5
	Player.position = Vector2.ZERO
	Player.inputON = true
	Player.get_node("Glitch").visible = false
	Player.get_node("AnimationTree").get("parameters/playback").travel("Idle")
	Player.get_node("PlayerHealth").updateHealthUI()
	var Wave = Player.get_parent().get_node("WaveManager")
	if Wave.currentWave >= 6 : Wave.currentWave = 6
	Wave.setFTW0(true)
	Wave.setFTW6(true)
	var totalTimer = Wave.get_node("TotalTimer").time_left
	var timer = Wave.get_node("Timer").time_left
	var timer_waitTime = Wave.get_node("Timer").wait_time
	Wave.get_node("Timer").stop()
	Wave.get_node("TotalTimer").stop()
	Wave.get_node("TotalTimer").start(totalTimer+timer_waitTime-timer)
	Wave.get_node("SoundManager")._play_song_from_name("honk",1.2)
