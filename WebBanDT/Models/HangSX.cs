using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: HANG_SX — Master data for phone brands/manufacturers (Apple, Samsung, etc.)
    /// </summary>
    public class HangSX
    {
        public int MaHang { get; set; }

        [Required(ErrorMessage = "Ten hang san xuat khong duoc de trong")]
        [StringLength(100, ErrorMessage = "Ten hang khong vuot qua 100 ky tu")]
        [Display(Name = "Ten hang san xuat")]
        public string TenHang { get; set; }

        [StringLength(100)]
        [Display(Name = "Nuoc goc")]
        public string NuocGC { get; set; }

        [StringLength(500)]
        [Display(Name = "Logo URL")]
        public string LogoUrl { get; set; }

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
