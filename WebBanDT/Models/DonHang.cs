using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: DON_HANG — Transaction data for order headers.
    /// DIA_CHI_GIAO is a snapshot of the address at order time (not a FK) to preserve
    /// historical accuracy when a customer later changes their address.
    /// 3NF: all attributes depend only on MA_DH.
    /// </summary>
    public class DonHang
    {
        public int MaDH { get; set; }

        [Required]
        [Display(Name = "Nguoi dat hang")]
        public int MaND { get; set; }

        [Display(Name = "Khuyen mai ap dung")]
        public int? MaKM { get; set; }

        [Display(Name = "Ngay dat hang")]
        public DateTime NgayDat { get; set; } = DateTime.Now;

        [Display(Name = "Ngay giao hang du kien")]
        [DataType(DataType.Date)]
        public DateTime? NgayGiaoDuKien { get; set; }

        [Display(Name = "Ngay giao hang thuc te")]
        [DataType(DataType.Date)]
        public DateTime? NgayGiaoThucTe { get; set; }

        [Required]
        [Range(0, double.MaxValue, ErrorMessage = "Tong tien hang phai >= 0")]
        [Display(Name = "Tong tien hang (VND)")]
        public decimal TongTienHang { get; set; }

        [Range(0, double.MaxValue, ErrorMessage = "Tien giam phai >= 0")]
        [Display(Name = "Tien giam (VND)")]
        public decimal TienGiam { get; set; } = 0;

        [Range(0, double.MaxValue, ErrorMessage = "Phi van chuyen phai >= 0")]
        [Display(Name = "Phi van chuyen (VND)")]
        public decimal PhiVanChuyen { get; set; } = 0;

        [Required]
        [Range(0, double.MaxValue, ErrorMessage = "Tong thanh toan phai >= 0")]
        [Display(Name = "Tong thanh toan (VND)")]
        public decimal TongThanhToan { get; set; }

        [Required(ErrorMessage = "Phuong thuc thanh toan khong duoc de trong")]
        [StringLength(20)]
        [Display(Name = "Phuong thuc thanh toan")]
        public string PhuongThucTT { get; set; }

        [Required(ErrorMessage = "Dia chi giao hang khong duoc de trong")]
        [StringLength(500, ErrorMessage = "Dia chi khong vuot qua 500 ky tu")]
        [Display(Name = "Dia chi giao hang")]
        public string DiaChiGiao { get; set; }

        [Required(ErrorMessage = "So dien thoai lien he khong duoc de trong")]
        [StringLength(15)]
        [Display(Name = "So dien thoai lien he")]
        public string SoDTLienHe { get; set; }

        [StringLength(1000)]
        [Display(Name = "Ghi chu")]
        public string GhiChu { get; set; }

        [StringLength(20)]
        [Display(Name = "Trang thai don hang")]
        public string TrangThai { get; set; } = "CHO_XAC_NHAN";

        // Navigation properties
        public virtual NguoiDung NguoiDung { get; set; }
        public virtual KhuyenMai KhuyenMai { get; set; }
        public virtual ICollection<ChiTietDH> ChiTietDHs { get; set; }
        public virtual ICollection<DanhGia> DanhGias { get; set; }
    }
}
