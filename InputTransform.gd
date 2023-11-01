extends HBoxContainer

signal transformChanged(_transform)
@export var transformName:String = "undefined"

var transform = Vector3()
@onready var transformX = $LabelScale/ScaleX
@onready var transformY = $LabelScale/ScaleY
@onready var transformZ = $LabelScale/ScaleZ
@onready var labelName = $LabelScale

func _ready():
	labelName.text = transformName

func _on_scale_x_text_changed():
	transform.x = float(transformX.text)
	emit_signal("transformChanged",transform)

func _on_scale_y_text_changed():
	transform.y = float(transformY.text)
	emit_signal("transformChanged",transform)

func _on_scale_z_text_changed():
	transform.z = float(transformZ.text)
	emit_signal("transformChanged",transform)
