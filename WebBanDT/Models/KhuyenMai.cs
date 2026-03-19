using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: KHUYEN_MAI — Time-bound promotions (percentage discount, fixed amount, free shipping).
    /// NGAY_KET_THUC must be after NGAY_BAT_DAU (enforced by DB CHECK constraint).
    /// MA_SP is nullable: NULL means the promotion applies to all products.
    /// 3NF: all attributes depend only on MA_KM.
    /// </summary>
    public class KhuyenMai
    {
        public int MaKM { get; set; }

        [Required(ErrorMessage = "Ten khuyen mai khong duoc de trong")]
        [StringLength(200, ErrorMessage = "Ten khuyen mai khong vuot qua 200 ky tu")]
        [Display(Name = "Ten chuong trinh")]
        public string TenKM { get; set; }

        [StringLength(1000)]
        [Display(Name = "Mo ta / Dieu kien ap dung")]
        public string MoTa { get; set; }

        [Required(ErrorMessage = "Vui long chon loai khuyen mai")]
        [StringLength(20)]
        [Display(Name = "Loai khuyen mai")]
        public string LoaiKM { get; set; }

        [Required(ErrorMessage = "Gia tri khuyen mai khong duoc de trong")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Gia tri phai lon hon 0")]
        [Display(Name = "Gia tri (% hoac VND)")]
        public decimal GiaTri { get; set; }

        [Display(Name = "San pham ap dung (NULL = tat ca)")]
        public int? MaSP { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = "Gia tri toi thieu phai >= 0")]
        [Display(Name = "Gia tri don hang toi thieu (VND)")]
        public decimal GiaToiThieu { get; set; } = 0;

        [Required(ErrorMessage = "Ngay bat dau khong duoc de trong")]
        [Display(Name = "Ngay bat dau")]
        [DataType(DataType.Date)]
        public DateTime NgayBatDau { get; set; }

        [Required(ErrorMessage = "Ngay ket thuc khong duoc de trong")]
        [Display(Name = "Ngay ket thuc")]
        [DataType(DataType.Date)]
        public DateTime NgayKetThuc { get; set; }

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation properties
        public virtual SanPham SanPham { get; set; }
        public virtual ICollection<DonHang> DonHangs { get; set; }
    }
}
