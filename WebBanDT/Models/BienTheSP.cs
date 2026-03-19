using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: BIEN_THE_SP — Master data for product variants (color + storage combos).
    /// A UNIQUE constraint on (MA_SP, MAU_SAC, DUNG_LUONG) prevents duplicate variants.
    /// 3NF: GIA_THEM and SO_LUONG_TON depend only on MA_BIEN_THE.
    /// </summary>
    public class BienTheSP
    {
        public int MaBienThe { get; set; }

        [Required(ErrorMessage = "Vui long chon san pham")]
        [Display(Name = "San pham")]
        public int MaSP { get; set; }

        [Required(ErrorMessage = "Mau sac khong duoc de trong")]
        [StringLength(50, ErrorMessage = "Mau sac khong vuot qua 50 ky tu")]
        [Display(Name = "Mau sac")]
        public string MauSac { get; set; }

        [Required(ErrorMessage = "Dung luong khong duoc de trong")]
        [StringLength(20, ErrorMessage = "Dung luong khong vuot qua 20 ky tu")]
        [Display(Name = "Dung luong luu tru")]
        public string DungLuong { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = "Gia them phai >= 0")]
        [Display(Name = "Gia them (VND)")]
        public decimal GiaThem { get; set; } = 0;

        [Range(0, int.MaxValue, ErrorMessage = "So luong ton phai >= 0")]
        [Display(Name = "So luong ton kho")]
        public int SoLuongTon { get; set; } = 0;

        [Display(Name = "Ngay cap nhat")]
        public DateTime NgayCapNhat { get; set; } = DateTime.Now;

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation properties
        public virtual SanPham SanPham { get; set; }
        public virtual ICollection<ChiTietDH> ChiTietDHs { get; set; }
    }
}
