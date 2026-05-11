extends Node2D
class_name Sengshe

var is_occupied: bool = false
var can_contain_num: int
var is_contain_num: int = 0
var occupied_monk: CharacterBody2D
var gongde_progress: int = 0:
	set(value):
		gongde_progress = value
		$GongdeProgress.value = gongde_progress

enum MonkType {
	LITTLE,
	ZHIKE,
	YUNYOU,
	JING
}

@onready var monk_to_building_sound = $MonkToBuildingSound
@onready var click_sound = $ClickSound

var is_converting_resource: bool = false
func _ready():
	$MenuPanel.hide()
	can_contain_num = $PanelContainer/VBoxContainer.get_child_count()
	
	pass # Replace with function body.




#func monk_dragged_in(registered_monk: CharacterBody2D, specific_drop_pos: Vector2):
	#if is_occupied == true:
		#return
	#
	#if is_contain_num > can_contain_num:
		#is_occupied = true
		#return
		#
	#is_contain_num += 1
	#
	#occupied_monk = registered_monk
	#if occupied_monk.get_parent():
		#occupied_monk.get_parent().remove_child(registered_monk)
		#$MonkResidence.add_child(registered_monk)
		#registered_monk.visible = false
		#registered_monk.position = Vector2.ZERO
		#
		#if "is_grabbed" in registered_monk:
			#registered_monk.is_grabbed = false
	#
	#refill_based_on_is_contain_num(is_contain_num)
	
func monk_dragged_in(registered_monk: CharacterBody2D, specific_drop_pos: Vector2):
	# 检查是否已满 (应该判断当前数量是否已经达到上限)
	if is_contain_num >= can_contain_num:
		is_occupied = true
		print("僧舍已满")
		return
		
	is_contain_num += 1
	
	if is_contain_num == can_contain_num:
		is_occupied = true
	
	occupied_monk = registered_monk
	monk_to_building_sound.play()
	if occupied_monk.get_parent():
		occupied_monk.get_parent().remove_child(registered_monk)
		$MonkResidence.add_child(registered_monk)
		registered_monk.visible = false
		registered_monk.position = Vector2.ZERO
		
		if "is_grabbed" in registered_monk:
			registered_monk.is_grabbed = false
	
	refill_based_on_is_contain_num(is_contain_num)
	
	
func refill_based_on_is_contain_num(contain_num: int):
	var i = 0
	for c in $PanelContainer/VBoxContainer.get_children():
		i += 1
		
		if i <= contain_num:
			
			var char = $MonkResidence.get_child(i - 1)
			#var monk_code
			var monk_code =  char.monk_code
			#match char.monk_code:
				#0:
					#monk_code = MonkType.LITTLE
				#1:
					#monk_code = MonkType.ZHIKE
				#2:
					#monk_code = MonkType.YUNYOU
				#3:
					#monk_code = MonkType.JING
				#"_":
					#pass
			c.monk_code = monk_code
			c.is_occupied = true
		else:
			c.is_occupied = false
			
		

#func _on_click_area_input_event(viewport, event, shape_idx):
	#get_viewport().set_input_as_handled()
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.is_released():
				#show_menu()
@onready var long_press_timer = $LongPressTimer
var is_long_press_triggered = false # 防止一次按压触发多次
var is_press_started_here := false
func _on_click_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# 记录：按下是从这里开始的
			is_press_started_here = true
			is_long_press_triggered = false
			long_press_timer.start()
			Global.emit_signal("is_converting_resource", true)
			is_converting_resource = true
		elif event.is_released():
			# 如果不是从这里按下的
			# 就不是 short click
			if not is_press_started_here:
				return
			# 用完后重置
			is_press_started_here = false
			if not is_long_press_triggered:
				long_press_timer.stop()
				
				_on_short_click()
			else:
				Global.emit_signal("is_converting_resource", false)
				is_converting_resource = false
				
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			Global.emit_signal("is_converting_resource", false)
			is_converting_resource = false

func _on_long_press_timer_timeout():
	is_long_press_triggered = true
	_on_long_press_action()

func _on_short_click():
	show_menu()

func _on_long_press_action():
	is_converting_resource = true
	# 这里执行长按逻辑，比如弹出二级菜单、蓄力攻击等
	
	
var menu_tween: Tween

func show_menu():
	if menu_tween:
		menu_tween.kill()
	$MenuPanel.show()
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2.ONE, 0.5).from(Vector2(0, 1))
	
func hide_menu():
	if menu_tween:
		menu_tween.kill()
		
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2(0, 1), 0.5).from(Vector2.ONE)
	await menu_tween.finished
	if not menu_tween.is_valid(): 
		$MenuPanel.hide()
	$MenuPanel.hide()

var mouse_position
var distance_to_sengshe
func _physics_process(delta):
	distance_to_sengshe = get_local_mouse_position().length()
	if distance_to_sengshe < 120:
		$PanelContainer.show()
	else:
		$PanelContainer.hide()
	if is_converting_resource == true and gongde_progress >= 1:
		gongde_progress -= 1
		Global.gongde_sum += 1
	
	
func registered_monk_release(index: int):
	var removed_monk = $MonkResidence.get_child(index)
	var world = get_node("../..")
	var monksystem = world.get_node("MonkSystem")
	if removed_monk.get_parent():
		removed_monk.get_parent().remove_child(removed_monk)
	monksystem.add_child(removed_monk)
	
	is_contain_num = $MonkResidence.get_child_count()
	refill_based_on_is_contain_num(is_contain_num)
	
	removed_monk.show()
	#world.get_node("MonkSystem").add_child(removing_monk)
	removed_monk.position = global_position + Vector2(0, -40)
	pass

func calculate_resource_based_on_monk():
	var gongde_every_turn: int
	for m in $PanelContainer/VBoxContainer.get_children():
		if m.is_occupied != true:
			continue
		match m.monk_code:
			MonkType.LITTLE:
				gongde_every_turn += 1
			MonkType.ZHIKE:
				gongde_every_turn += 2
			MonkType.YUNYOU:
				gongde_every_turn += 3
			MonkType.JING:
				gongde_every_turn += 4
			_:
				gongde_every_turn += 0
	return gongde_every_turn
	
func _on_produce_gongde_timeout():
	gongde_progress += calculate_resource_based_on_monk()

