using System;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: GIO_HANG — Transaction data for the shopping cart.
    /// UNIQUE constraint on (MA_ND, MA_BIEN_THE) ensures one row per user/variant combo.
    /// 3NF: SO_LUONG depends only on (MA_ND, MA_BIEN_THE) — no transitive dependency.
    /// </summary>
    public class GioHang
    {
        public int MaGH { get; set; }

        [Required]
        [Display(Name = "Nguoi dung")]
        public int MaND { get; set; }

        [Required]
        [Display(Name = "Bien the san pham")]
        public int MaBienThe { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "So luong phai >= 1")]
        [Display(Name = "So luong")]
        public int SoLuong { get; set; } = 1;

        [Display(Name = "Ngay them vao gio")]
        public DateTime NgayThem { get; set; } = DateTime.Now;

        [Display(Name = "Ngay cap nhat")]
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;

        // Navigation properties
        public virtual NguoiDung NguoiDung { get; set; }
        public virtual BienTheSP BienTheSP { get; set; }
    }
}
