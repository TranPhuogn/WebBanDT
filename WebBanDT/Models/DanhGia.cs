using System;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: DANH_GIA — Transaction data for product reviews and ratings (1–5 stars).
    /// MA_DH links to a verified purchase; it is nullable to allow non-purchase reviews.
    /// UNIQUE constraint on (MA_ND, MA_SP, MA_DH) prevents duplicate reviews per order.
    /// 3NF: all attributes depend only on MA_DG.
    /// </summary>
    public class DanhGia
    {
        public int MaDG { get; set; }

        [Required]
        [Display(Name = "Nguoi danh gia")]
        public int MaND { get; set; }

        [Required]
        [Display(Name = "San pham")]
        public int MaSP { get; set; }

        [Display(Name = "Don hang (mua hang da xac minh)")]
        public int? MaDH { get; set; }

        [Required(ErrorMessage = "Vui long chon so sao")]
        [Range(1, 5, ErrorMessage = "So sao tu 1 den 5")]
        [Display(Name = "So sao")]
        public int SoSao { get; set; }

        [StringLength(2000, ErrorMessage = "Binh luan khong vuot qua 2000 ky tu")]
        [Display(Name = "Binh luan")]
        public string BinhLuan { get; set; }

        [Display(Name = "Ngay danh gia")]
        public DateTime NgayDanhGia { get; set; } = DateTime.Now;

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation properties
        public virtual NguoiDung NguoiDung { get; set; }
        public virtual SanPham SanPham { get; set; }
        public virtual DonHang DonHang { get; set; }
    }
}
