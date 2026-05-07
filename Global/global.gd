extends Node


signal monk_grabbed(registered_vnit: CharacterBody2D)
signal monk_drop_pos(drop_position: Vector2)
signal add_gongde(gongde: int)
signal luohantang_panel(is_on: bool)
signal update_resource

var xianghuo_sum: int = 0:
	set(value):
		xianghuo_sum = value
		emit_signal("update_resource")
var gongde_sum: int = 0:
	set(value):
		gongde_sum = value
		emit_signal("update_resource")
var MuyuLevel: int = 0

func _ready():
	gongde_sum = DataLoader.main_csv.get("gongde_sum")
	xianghuo_sum = DataLoader.main_csv.get("xianghuo_sum")
	daxiongbaodian_build_gongde_price = DataLoader.main_csv.get("daxiongbaodian_build_gongde_price")
	sengshe_build_gongde_price = DataLoader.main_csv.get("sengshe_build_gongde_price")
	luohantang_build_gongde_price = DataLoader.main_csv.get("luohantang_build_gongde_price")
	MuyuLevel = DataLoader.main_csv.get("muyu_level")
#------------price
var daxiongbaodian_build_gongde_price: int = 10
var sengshe_build_gongde_price: int = 20
var luohantang_build_gongde_price: int = 30

#-----------------
