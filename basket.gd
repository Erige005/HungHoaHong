extends Area2D

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	position.x = mouse_pos.x

func _on_area_entered(area):
	var main_node = get_parent()
	
	if area.loai_vat_pham == "hoa" or area.loai_vat_pham == "hoa_khong_lo":
		main_node.cong_diem(area.diem_thuong)
		
	elif area.loai_vat_pham == "bom":
		main_node.tru_mang(1)
		
	elif area.loai_vat_pham == "bom_khong_lo":
		# Gọi tru_mang với toàn bộ số mạng hiện có để chết luôn + hiện hiệu ứng
		main_node.tru_mang(5)
			
	elif area.loai_vat_pham == "tim":
		# Để Main xử lý việc check max 15 mạng và hiện số nhảy
		main_node.cong_mang()
			
	area.queue_free()
