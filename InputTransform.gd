extends HBoxContainer

signal transformChanged(_transform)
@export var transformName:String = "undefined"

var transform = Vector3.ZERO : set = _set_transform, get = _get_transform
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

func _set_transform(value):
	transform = value
	transformX.text = str(value.x)
	transformY.text = str(value.y)
	transformZ.text = str(value.z)

func _get_transform():
	return transform
