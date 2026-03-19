using System;
using System.ComponentModel.DataAnnotations;

namespace WebBanDT.Models
{
    /// <summary>
    /// Table: CHI_TIET_DH — Transaction data for order line items.
    /// DON_GIA is snapshotted at purchase time so price changes do not alter order history.
    /// THANH_TIEN = SO_LUONG * DON_GIA (also stored for reporting performance).
    /// UNIQUE constraint on (MA_DH, MA_BIEN_THE) prevents duplicate items in one order.
    /// 3NF: all attributes depend only on MA_CTDH.
    /// </summary>
    public class ChiTietDH
    {
        public int MaCTDH { get; set; }

        [Required]
        [Display(Name = "Don hang")]
        public int MaDH { get; set; }

        [Required]
        [Display(Name = "Bien the san pham")]
        public int MaBienThe { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "So luong phai >= 1")]
        [Display(Name = "So luong mua")]
        public int SoLuong { get; set; }

        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Don gia phai > 0")]
        [Display(Name = "Don gia tai thoi diem mua (VND)")]
        public decimal DonGia { get; set; }

        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Thanh tien phai > 0")]
        [Display(Name = "Thanh tien (VND)")]
        public decimal ThanhTien { get; set; }

        // Navigation properties
        public virtual DonHang DonHang { get; set; }
        public virtual BienTheSP BienTheSP { get; set; }
    }
}
