using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: LOAI_HANG — Master data for product categories (Smartphone, Tablet, etc.)
    /// </summary>
    public class LoaiHang
    {
        public int MaLoai { get; set; }

        [Required(ErrorMessage = "Ten loai hang khong duoc de trong")]
        [StringLength(100, ErrorMessage = "Ten loai hang khong vuot qua 100 ky tu")]
        [Display(Name = "Ten loai hang")]
        public string TenLoai { get; set; }

        [StringLength(500)]
        [Display(Name = "Mo ta")]
        public string MoTa { get; set; }

        [Display(Name = "Ngay tao")]
        public DateTime NgayTao { get; set; } = DateTime.Now;

        [Display(Name = "Ngay sua")]
        public DateTime? NgaySua { get; set; }

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation property
        public virtual ICollection<SanPham> SanPhams { get; set; }
    }
}
