extends Particles2D

onready var collectibleType = get_parent().thisCollectibleType

func _ready():
	match collectibleType:
		"Health":
			self.process_material.color = Color("#19b0de")
		"DashSpeed":
			self.process_material.color = Color("#decd19")
		"BulletSize":
			self.process_material.color = Color("#ffffff")
		"BulletSpeed":
			self.process_material.color = Color("#d91a66")
		"MoveSpeed":
			self.process_material.color = Color("#5ddc06")
		"CadenceUp":
			self.process_material.color = Color("#e81a1a")
