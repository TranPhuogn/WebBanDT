using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: SAN_PHAM — Master data for products (phones, tablets).
    /// Belongs to one LOAI_HANG and one HANG_SX.
    /// 3NF: all attributes depend only on MA_SP; category/brand stored via FKs only.
    /// </summary>
    public class SanPham
    {
        public int MaSP { get; set; }

        [Required(ErrorMessage = "Ten san pham khong duoc de trong")]
        [StringLength(200, ErrorMessage = "Ten san pham khong vuot qua 200 ky tu")]
        [Display(Name = "Ten san pham")]
        public string TenSP { get; set; }

        [Required(ErrorMessage = "Vui long chon loai hang")]
        [Display(Name = "Loai hang")]
        public int MaLoai { get; set; }

        [Required(ErrorMessage = "Vui long chon hang san xuat")]
        [Display(Name = "Hang san xuat")]
        public int MaHang { get; set; }

        [Required(ErrorMessage = "Gia goc khong duoc de trong")]
        [Range(1, double.MaxValue, ErrorMessage = "Gia goc phai lon hon 0")]
        [Display(Name = "Gia goc (VND)")]
        public decimal GiaGoc { get; set; }

        [Display(Name = "Mo ta san pham")]
        public string MoTa { get; set; }

        [StringLength(2000)]
        [Display(Name = "Thong so ky thuat")]
        public string ThongSoKT { get; set; }

        [StringLength(500)]
        [Display(Name = "Anh dai dien")]
        public string AnhDaiDien { get; set; }

        [Display(Name = "Luot xem")]
        public int LuotXem { get; set; } = 0;

        [Display(Name = "Ngay nhap")]
        public DateTime NgayNhap { get; set; } = DateTime.Now;

        [Display(Name = "Ngay sua")]
        public DateTime? NgaySua { get; set; }

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation properties
        public virtual LoaiHang LoaiHang { get; set; }
        public virtual HangSX HangSX { get; set; }
        public virtual ICollection<BienTheSP> BienTheSPs { get; set; }
        public virtual ICollection<KhuyenMai> KhuyenMais { get; set; }
        public virtual ICollection<DanhGia> DanhGias { get; set; }
    }
}
