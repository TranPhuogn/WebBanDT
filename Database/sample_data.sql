-- ============================================================
-- Sample Data for WebBanDT Oracle Database
-- Run AFTER schema.sql
-- ============================================================

-- ============================================================
-- 1. LOAI_HANG (Categories)
-- ============================================================
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('Dien thoai', 'Dien thoai thong minh (smartphone) cac hang');
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('May tinh bang', 'May tinh bang (tablet) cac hang');
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('Phu kien', 'Phu kien dien thoai: op lung, kinh can, cap sac');

-- ============================================================
-- 2. HANG_SX (Brands)
-- ============================================================
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Apple',   'My');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Samsung', 'Han Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Xiaomi',  'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('OPPO',    'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Vivo',    'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Nokia',   'Phan Lan');

-- ============================================================
-- 3. SAN_PHAM (Products)
-- ============================================================
INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('iPhone 15 Pro Max', 1, 1, 33990000,
            'RAM: 8GB | Chip: A17 Pro | Pin: 4422mAh | Man hinh: 6.7" OLED 120Hz | Camera: 48MP+12MP+12MP',
            'iPhone 15 Pro Max voi chip A17 Pro manh me, he thong camera duoc nang cap va thiet ke titan sang trong.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('iPhone 15', 1, 1, 22990000,
            'RAM: 6GB | Chip: A16 Bionic | Pin: 3877mAh | Man hinh: 6.1" OLED 60Hz | Camera: 48MP+12MP',
            'iPhone 15 voi tinh nang Dynamic Island, sac USB-C va camera chinh 48MP.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Samsung Galaxy S24 Ultra', 1, 2, 31990000,
            'RAM: 12GB | Chip: Snapdragon 8 Gen 3 | Pin: 5000mAh | Man hinh: 6.8" AMOLED 120Hz | Camera: 200MP+50MP+10MP+12MP',
            'Galaxy S24 Ultra voi but S Pen tich hop, camera 200MP va AI tich hop.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Samsung Galaxy A55', 1, 2, 10490000,
            'RAM: 8GB | Chip: Exynos 1480 | Pin: 5000mAh | Man hinh: 6.6" AMOLED 120Hz | Camera: 50MP+12MP+5MP',
            'Galaxy A55 thiet ke cao cap, man hinh AMOLED va pin 5000mAh ben bi.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Xiaomi 14', 1, 3, 18990000,
            'RAM: 12GB | Chip: Snapdragon 8 Gen 3 | Pin: 4610mAh | Man hinh: 6.36" OLED 120Hz | Camera: 50MP+50MP+50MP Leica',
            'Xiaomi 14 voi camera Leica ba ong kinh, chip hang dau va sac nhanh 90W.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('OPPO Find X7', 1, 4, 21990000,
            'RAM: 16GB | Chip: Dimensity 9300 | Pin: 5000mAh | Man hinh: 6.82" AMOLED 120Hz | Camera: 50MP+64MP+6MP Hasselblad',
            'OPPO Find X7 voi camera Hasselblad, sac nhanh SuperVOOC 100W.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Vivo V30', 1, 5, 10990000,
            'RAM: 12GB | Chip: Snapdragon 6 Gen 1 | Pin: 5000mAh | Man hinh: 6.78" AMOLED 120Hz | Camera: 50MP+50MP+2MP',
            'Vivo V30 noi bat voi thiet ke mong nhe, camera selfie AI va pin trau.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Samsung Galaxy Tab S9', 2, 2, 20990000,
            'RAM: 8GB | Chip: Snapdragon 8 Gen 2 | Pin: 8400mAh | Man hinh: 11" AMOLED 120Hz | Camera: 13MP+12MP',
            'Galaxy Tab S9 voi man hinh AMOLED 11 inch, chip manh va kem but S Pen.');

-- ============================================================
-- 4. BIEN_THE_SP (Product Variants)
-- ============================================================
-- iPhone 15 Pro Max (MA_SP = 1)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien', '256GB',        0, 15);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien', '512GB',  2000000, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien',   '1TB',  5000000,  5);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Den',        '256GB',        0, 12);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Den',        '512GB',  2000000,  8);

-- iPhone 15 (MA_SP = 2)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Den',    '128GB',       0, 20);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Den',    '256GB', 2000000, 15);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Hong',   '128GB',       0, 18);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Xanh',   '128GB',       0, 14);

-- Samsung Galaxy S24 Ultra (MA_SP = 3)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Den Titan', '256GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Den Titan', '512GB', 2000000,  7);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Xam Titan', '256GB',       0,  9);

-- Samsung Galaxy A55 (MA_SP = 4)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Xanh',   '128GB',       0, 25);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Vang',   '128GB',       0, 20);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Xanh',   '256GB', 1000000, 15);

-- Xiaomi 14 (MA_SP = 5)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Den',    '256GB',       0, 12);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Trang',  '256GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Den',    '512GB', 2000000,  8);

-- OPPO Find X7 (MA_SP = 6)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (6, 'Den',    '256GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (6, 'Trang',  '256GB',       0,  8);

-- Vivo V30 (MA_SP = 7)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (7, 'Xanh Bac Ha', '256GB',       0, 18);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (7, 'Den',         '256GB',       0, 15);

-- Samsung Galaxy Tab S9 (MA_SP = 8)
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (8, 'Be', '128GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (8, 'Be', '256GB', 2000000,  7);

-- ============================================================
-- 5. NGUOI_DUNG (Users)
-- ============================================================
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Nguyen Van An', 'an.nguyen@email.com',
            '$2a$12$example_bcrypt_hash_an',
            '0901234567', 'Nam', DATE '1995-03-15', DATE '2024-01-10');

INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Tran Thi Binh', 'binh.tran@email.com',
            '$2a$12$example_bcrypt_hash_binh',
            '0912345678', 'Nu', DATE '1998-07-22', DATE '2024-02-05');

INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Le Van Cuong', 'cuong.le@email.com',
            '$2a$12$example_bcrypt_hash_cuong',
            '0923456789', 'Nam', DATE '1990-11-30', DATE '2024-03-20');

INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Pham Thi Dung', 'dung.pham@email.com',
            '$2a$12$example_bcrypt_hash_dung',
            '0934567890', 'Nu', DATE '2000-05-08', DATE '2024-04-12');

INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Hoang Van Em', 'em.hoang@email.com',
            '$2a$12$example_bcrypt_hash_em',
            '0945678901', 'Nam', DATE '1993-09-18', DATE '2024-05-01');

-- ============================================================
-- 6. KHUYEN_MAI (Promotions)
-- ============================================================
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Giam 10% iPhone thang 1', 'Ap dung cho tat ca iPhone trong thang 1/2025',
            'PHAN_TRAM', 10, NULL, 15000000,
            DATE '2025-01-01', DATE '2025-01-31');

INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Samsung Sale mung nam moi', 'Giam 2 trieu cho Samsung Galaxy S24 Ultra',
            'SO_TIEN', 2000000, 3, 25000000,
            DATE '2025-02-01', DATE '2025-02-28');

INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Mien phi van chuyen T3', 'Mien phi van chuyen cho don hang tren 5 trieu',
            'MIEN_PHI_VC', 50000, NULL, 5000000,
            DATE '2025-03-01', DATE '2025-03-31');

INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Flash sale Xiaomi 14', 'Giam 15% Xiaomi 14 trong 1 ngay',
            'PHAN_TRAM', 15, 5, 18000000,
            DATE '2025-04-15', DATE '2025-04-15');

-- ============================================================
-- 7. GIO_HANG (Shopping Cart)
-- ============================================================
-- User 1 has iPhone 15 Pro Max 256GB (Titan Den) x2 and Samsung A55 Xanh 128GB x1
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (1, 4, 2);
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (1, 14, 1);

-- User 2 has Xiaomi 14 Den 256GB x1
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (2, 17, 1);

-- ============================================================
-- 8. DON_HANG (Orders)
-- ============================================================
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                       TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                       PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (1, 1,
            DATE '2025-01-15', DATE '2025-01-18', DATE '2025-01-17',
            33990000, 3399000, 0, 30591000,
            'VNPAY', '123 Nguyen Trai, Quan 1, TP.HCM', '0901234567', 'DA_GIAO');

INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                       TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                       PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (2, 2,
            DATE '2025-02-10', DATE '2025-02-13', DATE '2025-02-12',
            31990000, 2000000, 0, 29990000,
            'MOMO', '456 Le Loi, Quan Hai Ba Trung, Ha Noi', '0912345678', 'DA_GIAO');

INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                       TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                       PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (3, 3,
            DATE '2025-03-05', DATE '2025-03-08', NULL,
            18990000, 0, 0, 18990000,
            'TIEN_MAT', '789 Tran Hung Dao, Quan 5, TP.HCM', '0923456789', 'DANG_GIAO');

INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                       TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                       PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (4, NULL,
            DATE '2025-03-10', DATE '2025-03-13', NULL,
            10490000, 0, 30000, 10520000,
            'CHUYEN_KHOAN', '321 Vo Van Tan, Quan 3, TP.HCM', '0934567890', 'DA_XAC_NHAN');

INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                       TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                       PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (1, NULL,
            DATE '2025-03-15', DATE '2025-03-18', NULL,
            22990000, 0, 0, 22990000,
            'VNPAY', '123 Nguyen Trai, Quan 1, TP.HCM', '0901234567', 'CHO_XAC_NHAN');

-- ============================================================
-- 9. CHI_TIET_DH (Order Items)
-- ============================================================
-- Order 1: iPhone 15 Pro Max 256GB Titan Tu Nhien x1 @ 33,990,000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN)
    VALUES (1, 1, 1, 33990000, 33990000);

-- Order 2: Samsung S24 Ultra 256GB Den Titan x1 @ 31,990,000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN)
    VALUES (2, 10, 1, 31990000, 31990000);

-- Order 3: Xiaomi 14 Den 256GB x1 @ 18,990,000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN)
    VALUES (3, 17, 1, 18990000, 18990000);

-- Order 4: Samsung A55 Xanh 128GB x1 @ 10,490,000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN)
    VALUES (4, 14, 1, 10490000, 10490000);

-- Order 5: iPhone 15 Den 128GB x1 @ 22,990,000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN)
    VALUES (5, 6, 1, 22990000, 22990000);

-- ============================================================
-- 10. DANH_GIA (Reviews)
-- ============================================================
-- User 1 rates iPhone 15 Pro Max (from order 1)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (1, 1, 1, 5,
            'San pham tuyet voi! Camera chup anh dep, pin trau, chip A17 Pro qua manh. Rat xung dang voi muc gia.',
            DATE '2025-01-20');

-- User 2 rates Samsung S24 Ultra (from order 2)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (2, 3, 2, 5,
            'But S Pen rat tien loi, man hinh sac net, camera 200MP chup anh sieu chi tiet. Phan AI rat huu ich.',
            DATE '2025-02-15');

-- User 3 rates Xiaomi 14 (from order 3 - review before delivery confirmed)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (3, 5, 3, 4,
            'Camera Leica chup dep, chip manh. Chi tiec pin sac nhanh nhung cung nhanh can. Nhin chung rat hoa long.',
            DATE '2025-03-12');

-- User 4 rates Samsung A55
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (4, 4, 4, 4,
            'Man hinh AMOLED dep, thiet ke cao cap, pin ben. Gia hop ly cho tam phan khuc. Giao hang nhanh.',
            DATE '2025-03-14');

COMMIT;
