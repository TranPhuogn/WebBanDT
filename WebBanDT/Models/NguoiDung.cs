using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: NGUOI_DUNG — Master data for customer accounts.
    /// EMAIL is UNIQUE. MAT_KHAU stores a bcrypt hash (never plaintext).
    /// 3NF: all attributes depend only on MA_ND.
    /// </summary>
    public class NguoiDung
    {
        public int MaND { get; set; }

        [Required(ErrorMessage = "Ho ten khong duoc de trong")]
        [StringLength(200, ErrorMessage = "Ho ten khong vuot qua 200 ky tu")]
        [Display(Name = "Ho ten")]
        public string HoTen { get; set; }

        [Required(ErrorMessage = "Email khong duoc de trong")]
        [EmailAddress(ErrorMessage = "Email khong hop le")]
        [StringLength(150, ErrorMessage = "Email khong vuot qua 150 ky tu")]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Mat khau khong duoc de trong")]
        [StringLength(256)]
        [Display(Name = "Mat khau (bcrypt hash)")]
        public string MatKhau { get; set; }

        [StringLength(15)]
        [Display(Name = "So dien thoai")]
        public string SoDT { get; set; }

        [StringLength(10)]
        [Display(Name = "Gioi tinh")]
        public string GioiTinh { get; set; }

        [Display(Name = "Ngay sinh")]
        [DataType(DataType.Date)]
        public DateTime? NgaySinh { get; set; }

        [Display(Name = "Ngay dang ky")]
        public DateTime NgayDangKy { get; set; } = DateTime.Now;

        [Display(Name = "Ngay dang nhap gan nhat")]
        public DateTime? NgayDangNhap { get; set; }

        [Display(Name = "Trang thai")]
        public int TrangThai { get; set; } = 1;

        // Navigation properties
        public virtual ICollection<GioHang> GioHangs { get; set; }
        public virtual ICollection<DonHang> DonHangs { get; set; }
        public virtual ICollection<DanhGia> DanhGias { get; set; }
    }
}
