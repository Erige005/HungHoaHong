extends Area2D

@export var loai_vat_pham = "hoa" 
@export var diem_thuong = 1 
@export var speed = 300 

func _process(delta):
	position.y += speed * delta
	
	# Xử lý khi vật phẩm rớt qua đáy màn hình (bỏ lỡ)
	if position.y > 700:
		if loai_vat_pham == "hoa":
			# Gọi hàm tru_mang và truyền thêm vị trí hiện tại của hoa để hiện số nhảy tại đó
			get_parent().hien_so_nhay(global_position, "-1 Mạng", Color.BLACK)
			get_parent().tru_mang_khong_hieu_ung(1) 
			
		elif loai_vat_pham == "hoa_khong_lo":
			get_parent().hien_so_nhay(global_position, "-2 Mạng", Color.BLACK)
			get_parent().tru_mang_khong_hieu_ung(2) 
			
		queue_free() # Xóa vật thể
