extends Node


signal monk_grabbed(registered_vnit: CharacterBody2D)
signal monk_drop_pos(drop_position: Vector2)
signal add_gongde(gongde: int)
signal luohantang_panel(is_on: bool)
signal update_resource
signal send_a_monk(pos: Vector2)
signal is_converting_resource(converting: bool)

var registered_monk

var xianghuo_sum: int = 0:
	set(value):
		xianghuo_sum = value
		emit_signal("update_resource")
var gongde_sum: int = 0:
	set(value):
		gongde_sum = value
		emit_signal("update_resource")
var MuyuLevel: int = 0
var ini_monk_amount: int = 3

func _ready():
	gongde_sum = DataLoader.main_csv.get("gongde_sum")
	xianghuo_sum = DataLoader.main_csv.get("xianghuo_sum", 0)
	daxiongbaodian_build_gongde_price = DataLoader.main_csv.get("daxiongbaodian_build_gongde_price", 0)
	sengshe_build_gongde_price = DataLoader.main_csv.get("sengshe_build_gongde_price", 0)
	luohantang_build_gongde_price = DataLoader.main_csv.get("luohantang_build_gongde_price", 0)
	MuyuLevel = DataLoader.main_csv.get("muyu_level", 0)
	monk_produce_price = DataLoader.main_csv.get("monk_produce_price", 0)
	monk_produce_change_price = DataLoader.main_csv.get("monk_produce_change_price", 0)
	ini_monk_amount = DataLoader.main_csv.get("ini_monk_amount", 0)
	building_level_up = DataLoader.main_csv.get("building_level_up_index", 0)
	sengshe_level_up_basic_cost = DataLoader.main_csv.get("sengshe_level_up_basic_cost", 0)
#------------price
var daxiongbaodian_build_gongde_price: int = 10
var sengshe_build_gongde_price: int = 20
var luohantang_build_gongde_price: int = 30
var monk_produce_price: int = 5
var monk_produce_change_price: int = 5
var building_level_up: int = 1
var sengshe_level_up_basic_cost: int = 10
#-----------------
