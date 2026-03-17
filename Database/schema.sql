-- ============================================================
-- Oracle Database Schema for WebBanDT (Mobile Phone E-Commerce)
-- Course: Oracle DBMS | Team size: 3 | Tables: 10
-- Normalization: 3NF | Supports: 1-year data tracking
-- ============================================================

-- ============================================================
-- SEQUENCES (Oracle auto-increment equivalent)
-- ============================================================
CREATE SEQUENCE SEQ_LOAI_HANG   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_HANG_SX     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_SAN_PHAM    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_BIEN_THE    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_NGUOI_DUNG  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_KHUYEN_MAI  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_GIO_HANG    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_DON_HANG    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CHI_TIET_DH START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_DANH_GIA    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- TABLE 1: LOAI_HANG (Product Categories) — MASTER DATA
-- Stores product categories: Smartphones, Tablets, etc.
-- 3NF: No transitive dependencies; all attributes depend solely on MA_LOAI.
-- ============================================================
CREATE TABLE LOAI_HANG (
    MA_LOAI     NUMBER(5)       NOT NULL,
    TEN_LOAI    VARCHAR2(100)   NOT NULL,
    MO_TA       VARCHAR2(500),
    NGAY_TAO    DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_SUA    DATE,
    TRANG_THAI  NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_LOAI_HANG     PRIMARY KEY (MA_LOAI),
    CONSTRAINT CK_LH_TRANG_THAI CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  LOAI_HANG              IS 'Danh muc loai san pham (Dien thoai, May tinh bang, ...)';
COMMENT ON COLUMN LOAI_HANG.MA_LOAI     IS 'Ma loai hang - khoa chinh';
COMMENT ON COLUMN LOAI_HANG.TEN_LOAI   IS 'Ten loai hang';
COMMENT ON COLUMN LOAI_HANG.MO_TA      IS 'Mo ta loai hang';
COMMENT ON COLUMN LOAI_HANG.NGAY_TAO   IS 'Ngay tao ban ghi';
COMMENT ON COLUMN LOAI_HANG.NGAY_SUA   IS 'Ngay cap nhat ban ghi lan cuoi';
COMMENT ON COLUMN LOAI_HANG.TRANG_THAI IS '1=Hoat dong, 0=Khoa';

-- ============================================================
-- TABLE 2: HANG_SX (Brands / Manufacturers) — MASTER DATA
-- Stores phone brands: Apple, Samsung, Xiaomi, OPPO, etc.
-- 3NF: NUOC_GC depends only on MA_HANG (brand of origin).
-- ============================================================
CREATE TABLE HANG_SX (
    MA_HANG     NUMBER(5)       NOT NULL,
    TEN_HANG    VARCHAR2(100)   NOT NULL,
    NUOC_GC     VARCHAR2(100),
    LOGO_URL    VARCHAR2(500),
    NGAY_TAO    DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_SUA    DATE,
    TRANG_THAI  NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_HANG_SX       PRIMARY KEY (MA_HANG),
    CONSTRAINT UQ_HANG_SX_TEN   UNIQUE (TEN_HANG),
    CONSTRAINT CK_HS_TRANG_THAI CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  HANG_SX              IS 'Hang san xuat dien thoai (Apple, Samsung, Xiaomi, ...)';
COMMENT ON COLUMN HANG_SX.MA_HANG     IS 'Ma hang san xuat - khoa chinh';
COMMENT ON COLUMN HANG_SX.TEN_HANG    IS 'Ten hang san xuat';
COMMENT ON COLUMN HANG_SX.NUOC_GC     IS 'Nuoc goc cua hang';
COMMENT ON COLUMN HANG_SX.LOGO_URL    IS 'Duong dan anh logo';
COMMENT ON COLUMN HANG_SX.NGAY_TAO    IS 'Ngay tao ban ghi';
COMMENT ON COLUMN HANG_SX.NGAY_SUA    IS 'Ngay cap nhat ban ghi lan cuoi';
COMMENT ON COLUMN HANG_SX.TRANG_THAI  IS '1=Hoat dong, 0=Khoa';

-- ============================================================
-- TABLE 3: SAN_PHAM (Products) — MASTER DATA
-- Core product catalog. Each product belongs to one category and brand.
-- 3NF: GIA_GOC, TEN_SP, etc. depend only on MA_SP.
--      Category/brand data is NOT stored here — only FKs (eliminating transitive deps).
-- ============================================================
CREATE TABLE SAN_PHAM (
    MA_SP           NUMBER(10)      NOT NULL,
    TEN_SP          VARCHAR2(200)   NOT NULL,
    MA_LOAI         NUMBER(5)       NOT NULL,
    MA_HANG         NUMBER(5)       NOT NULL,
    GIA_GOC         NUMBER(15,2)    NOT NULL,
    MO_TA           CLOB,
    THONG_SO_KT     VARCHAR2(2000),
    ANH_DAI_DIEN    VARCHAR2(500),
    LUOT_XEM        NUMBER(10)      DEFAULT 0 NOT NULL,
    NGAY_NHAP       DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_SUA        DATE,
    TRANG_THAI      NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_SAN_PHAM          PRIMARY KEY (MA_SP),
    CONSTRAINT FK_SP_LOAI           FOREIGN KEY (MA_LOAI) REFERENCES LOAI_HANG(MA_LOAI),
    CONSTRAINT FK_SP_HANG           FOREIGN KEY (MA_HANG)  REFERENCES HANG_SX(MA_HANG),
    CONSTRAINT CK_SP_GIA_GOC        CHECK (GIA_GOC > 0),
    CONSTRAINT CK_SP_TRANG_THAI     CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  SAN_PHAM                IS 'Danh muc san pham (dien thoai, may tinh bang)';
COMMENT ON COLUMN SAN_PHAM.MA_SP         IS 'Ma san pham - khoa chinh';
COMMENT ON COLUMN SAN_PHAM.TEN_SP        IS 'Ten san pham';
COMMENT ON COLUMN SAN_PHAM.MA_LOAI       IS 'Khoa ngoai -> LOAI_HANG';
COMMENT ON COLUMN SAN_PHAM.MA_HANG       IS 'Khoa ngoai -> HANG_SX';
COMMENT ON COLUMN SAN_PHAM.GIA_GOC       IS 'Gia co ban (VND)';
COMMENT ON COLUMN SAN_PHAM.MO_TA         IS 'Mo ta chi tiet san pham';
COMMENT ON COLUMN SAN_PHAM.THONG_SO_KT   IS 'Thong so ky thuat (RAM, chip, pin, man hinh, ...)';
COMMENT ON COLUMN SAN_PHAM.ANH_DAI_DIEN  IS 'Duong dan anh dai dien';
COMMENT ON COLUMN SAN_PHAM.LUOT_XEM      IS 'So luot xem san pham';
COMMENT ON COLUMN SAN_PHAM.NGAY_NHAP     IS 'Ngay them san pham vao he thong';
COMMENT ON COLUMN SAN_PHAM.NGAY_SUA      IS 'Ngay cap nhat thong tin san pham lan cuoi';
COMMENT ON COLUMN SAN_PHAM.TRANG_THAI    IS '1=Dang ban, 0=Ngung ban';

-- ============================================================
-- TABLE 4: BIEN_THE_SP (Product Variants) — MASTER DATA
-- Each product can have multiple variants (color + storage combos).
-- 3NF: MAU_SAC, DUNG_LUONG, GIA_THEM depend solely on MA_BIEN_THE.
--      MA_SP is only a FK, no transitive dependency.
-- ============================================================
CREATE TABLE BIEN_THE_SP (
    MA_BIEN_THE     NUMBER(10)      NOT NULL,
    MA_SP           NUMBER(10)      NOT NULL,
    MAU_SAC         VARCHAR2(50)    NOT NULL,
    DUNG_LUONG      VARCHAR2(20)    NOT NULL,
    GIA_THEM        NUMBER(15,2)    DEFAULT 0 NOT NULL,
    SO_LUONG_TON    NUMBER(10)      DEFAULT 0 NOT NULL,
    NGAY_CAP_NHAT   DATE            DEFAULT SYSDATE NOT NULL,
    TRANG_THAI      NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_BIEN_THE_SP       PRIMARY KEY (MA_BIEN_THE),
    CONSTRAINT FK_BT_SAN_PHAM       FOREIGN KEY (MA_SP) REFERENCES SAN_PHAM(MA_SP),
    CONSTRAINT UQ_BIEN_THE          UNIQUE (MA_SP, MAU_SAC, DUNG_LUONG),
    CONSTRAINT CK_BT_GIA_THEM       CHECK (GIA_THEM >= 0),
    CONSTRAINT CK_BT_SO_LUONG       CHECK (SO_LUONG_TON >= 0),
    CONSTRAINT CK_BT_TRANG_THAI     CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  BIEN_THE_SP                IS 'Bien the san pham (mau sac + dung luong luu tru)';
COMMENT ON COLUMN BIEN_THE_SP.MA_BIEN_THE    IS 'Ma bien the - khoa chinh';
COMMENT ON COLUMN BIEN_THE_SP.MA_SP          IS 'Khoa ngoai -> SAN_PHAM';
COMMENT ON COLUMN BIEN_THE_SP.MAU_SAC        IS 'Mau sac (Den, Trang, Xanh, ...)';
COMMENT ON COLUMN BIEN_THE_SP.DUNG_LUONG     IS 'Dung luong luu tru (64GB, 128GB, 256GB, 512GB, 1TB)';
COMMENT ON COLUMN BIEN_THE_SP.GIA_THEM       IS 'Gia cong them so voi gia co ban (VND)';
COMMENT ON COLUMN BIEN_THE_SP.SO_LUONG_TON   IS 'So luong con trong kho';
COMMENT ON COLUMN BIEN_THE_SP.NGAY_CAP_NHAT  IS 'Ngay cap nhat ton kho lan cuoi';
COMMENT ON COLUMN BIEN_THE_SP.TRANG_THAI     IS '1=Con hang, 0=Het hang';

-- ============================================================
-- TABLE 5: NGUOI_DUNG (Users / Customers) — MASTER DATA
-- Customer accounts for login, order tracking, and reviews.
-- 3NF: Every non-key attribute depends directly on MA_ND only.
-- ============================================================
CREATE TABLE NGUOI_DUNG (
    MA_ND           NUMBER(10)      NOT NULL,
    HO_TEN          VARCHAR2(200)   NOT NULL,
    EMAIL           VARCHAR2(150)   NOT NULL,
    MAT_KHAU        VARCHAR2(256)   NOT NULL,
    SO_DT           VARCHAR2(15),
    GIOI_TINH       VARCHAR2(10),
    NGAY_SINH       DATE,
    NGAY_DANG_KY    DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_DANG_NHAP  DATE,
    TRANG_THAI      NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_NGUOI_DUNG        PRIMARY KEY (MA_ND),
    CONSTRAINT UQ_ND_EMAIL          UNIQUE (EMAIL),
    CONSTRAINT CK_ND_GIOI_TINH     CHECK (GIOI_TINH IN ('Nam', 'Nu', 'Khac')),
    CONSTRAINT CK_ND_TRANG_THAI    CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  NGUOI_DUNG                    IS 'Tai khoan nguoi dung / khach hang';
COMMENT ON COLUMN NGUOI_DUNG.MA_ND              IS 'Ma nguoi dung - khoa chinh';
COMMENT ON COLUMN NGUOI_DUNG.HO_TEN             IS 'Ho va ten day du';
COMMENT ON COLUMN NGUOI_DUNG.EMAIL              IS 'Dia chi email (dung de dang nhap)';
COMMENT ON COLUMN NGUOI_DUNG.MAT_KHAU           IS 'Mat khau da ma hoa (bcrypt hash)';
COMMENT ON COLUMN NGUOI_DUNG.SO_DT              IS 'So dien thoai lien lac';
COMMENT ON COLUMN NGUOI_DUNG.GIOI_TINH          IS 'Gioi tinh: Nam / Nu / Khac';
COMMENT ON COLUMN NGUOI_DUNG.NGAY_SINH          IS 'Ngay sinh';
COMMENT ON COLUMN NGUOI_DUNG.NGAY_DANG_KY       IS 'Ngay tao tai khoan';
COMMENT ON COLUMN NGUOI_DUNG.NGAY_DANG_NHAP     IS 'Thoi diem dang nhap gan nhat';
COMMENT ON COLUMN NGUOI_DUNG.TRANG_THAI         IS '1=Hoat dong, 0=Bi khoa';

-- ============================================================
-- TABLE 6: KHUYEN_MAI (Promotions / Discounts) — MASTER DATA
-- Time-bound promotions. Supports percentage, fixed-amount,
-- and free-shipping discount types.
-- 3NF: All attributes depend only on MA_KM.
-- ============================================================
CREATE TABLE KHUYEN_MAI (
    MA_KM           NUMBER(10)      NOT NULL,
    TEN_KM          VARCHAR2(200)   NOT NULL,
    MO_TA           VARCHAR2(1000),
    LOAI_KM         VARCHAR2(20)    NOT NULL,
    GIA_TRI         NUMBER(10,2)    NOT NULL,
    MA_SP           NUMBER(10),
    GIA_TOI_THIEU   NUMBER(15,2)    DEFAULT 0 NOT NULL,
    NGAY_BAT_DAU    DATE            NOT NULL,
    NGAY_KET_THUC   DATE            NOT NULL,
    TRANG_THAI      NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_KHUYEN_MAI        PRIMARY KEY (MA_KM),
    CONSTRAINT FK_KM_SAN_PHAM       FOREIGN KEY (MA_SP) REFERENCES SAN_PHAM(MA_SP),
    CONSTRAINT CK_KM_LOAI           CHECK (LOAI_KM IN ('PHAN_TRAM', 'SO_TIEN', 'MIEN_PHI_VC')),
    CONSTRAINT CK_KM_GIA_TRI        CHECK (GIA_TRI > 0),
    CONSTRAINT CK_KM_NGAY           CHECK (NGAY_KET_THUC > NGAY_BAT_DAU),
    CONSTRAINT CK_KM_TRANG_THAI     CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  KHUYEN_MAI                    IS 'Chuong trinh khuyen mai / giam gia co thoi han';
COMMENT ON COLUMN KHUYEN_MAI.MA_KM              IS 'Ma khuyen mai - khoa chinh';
COMMENT ON COLUMN KHUYEN_MAI.TEN_KM             IS 'Ten chuong trinh khuyen mai';
COMMENT ON COLUMN KHUYEN_MAI.MO_TA              IS 'Mo ta dieu kien ap dung';
COMMENT ON COLUMN KHUYEN_MAI.LOAI_KM            IS 'Loai KM: PHAN_TRAM=% giam | SO_TIEN=giam co dinh | MIEN_PHI_VC=mien phi van chuyen';
COMMENT ON COLUMN KHUYEN_MAI.GIA_TRI            IS 'Gia tri khuyen mai (% hoac VND)';
COMMENT ON COLUMN KHUYEN_MAI.MA_SP              IS 'Khoa ngoai -> SAN_PHAM (NULL = ap dung cho tat ca SP)';
COMMENT ON COLUMN KHUYEN_MAI.GIA_TOI_THIEU      IS 'Gia tri don hang toi thieu de duoc ap dung KM (VND)';
COMMENT ON COLUMN KHUYEN_MAI.NGAY_BAT_DAU       IS 'Ngay bat dau hieu luc khuyen mai';
COMMENT ON COLUMN KHUYEN_MAI.NGAY_KET_THUC      IS 'Ngay ket thuc hieu luc khuyen mai';
COMMENT ON COLUMN KHUYEN_MAI.TRANG_THAI         IS '1=Dang ap dung, 0=Da ket thuc';

-- ============================================================
-- TABLE 7: GIO_HANG (Shopping Cart) — TRANSACTION DATA
-- Tracks items added to cart before placing an order.
-- Each row = 1 user + 1 variant. Updated when quantity changes.
-- 3NF: SO_LUONG depends only on (MA_ND, MA_BIEN_THE).
-- ============================================================
CREATE TABLE GIO_HANG (
    MA_GH           NUMBER(10)      NOT NULL,
    MA_ND           NUMBER(10)      NOT NULL,
    MA_BIEN_THE     NUMBER(10)      NOT NULL,
    SO_LUONG        NUMBER(5)       DEFAULT 1 NOT NULL,
    NGAY_THEM       DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_CAP_NHAT   DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_GIO_HANG          PRIMARY KEY (MA_GH),
    CONSTRAINT FK_GH_NGUOI_DUNG     FOREIGN KEY (MA_ND) REFERENCES NGUOI_DUNG(MA_ND),
    CONSTRAINT FK_GH_BIEN_THE       FOREIGN KEY (MA_BIEN_THE) REFERENCES BIEN_THE_SP(MA_BIEN_THE),
    CONSTRAINT UQ_GIO_HANG          UNIQUE (MA_ND, MA_BIEN_THE),
    CONSTRAINT CK_GH_SO_LUONG       CHECK (SO_LUONG > 0)
);

COMMENT ON TABLE  GIO_HANG                   IS 'Gio hang tam thoi cua nguoi dung';
COMMENT ON COLUMN GIO_HANG.MA_GH             IS 'Ma gio hang - khoa chinh';
COMMENT ON COLUMN GIO_HANG.MA_ND             IS 'Khoa ngoai -> NGUOI_DUNG';
COMMENT ON COLUMN GIO_HANG.MA_BIEN_THE       IS 'Khoa ngoai -> BIEN_THE_SP';
COMMENT ON COLUMN GIO_HANG.SO_LUONG          IS 'So luong san pham trong gio hang';
COMMENT ON COLUMN GIO_HANG.NGAY_THEM         IS 'Ngay them san pham vao gio';
COMMENT ON COLUMN GIO_HANG.NGAY_CAP_NHAT     IS 'Ngay chinh sua so luong lan cuoi';

-- ============================================================
-- TABLE 8: DON_HANG (Orders) — TRANSACTION DATA
-- Order header: one record per customer order.
-- References user and optional promotion.
-- 3NF: Delivery address/phone stored here (snapshot at order time,
--       not FK to a live address table) — intentional denormalization
--       to preserve historical accuracy.
-- ============================================================
CREATE TABLE DON_HANG (
    MA_DH               NUMBER(10)      NOT NULL,
    MA_ND               NUMBER(10)      NOT NULL,
    MA_KM               NUMBER(10),
    NGAY_DAT            DATE            DEFAULT SYSDATE NOT NULL,
    NGAY_GIAO_DU_KIEN   DATE,
    NGAY_GIAO_THUC_TE   DATE,
    TONG_TIEN_HANG      NUMBER(15,2)    NOT NULL,
    TIEN_GIAM           NUMBER(15,2)    DEFAULT 0 NOT NULL,
    PHI_VAN_CHUYEN      NUMBER(10,2)    DEFAULT 0 NOT NULL,
    TONG_THANH_TOAN     NUMBER(15,2)    NOT NULL,
    PHUONG_THUC_TT      VARCHAR2(20)    NOT NULL,
    DIA_CHI_GIAO        VARCHAR2(500)   NOT NULL,
    SO_DT_LIEN_HE       VARCHAR2(15)    NOT NULL,
    GHI_CHU             VARCHAR2(1000),
    TRANG_THAI          VARCHAR2(20)    DEFAULT 'CHO_XAC_NHAN' NOT NULL,
    CONSTRAINT PK_DON_HANG          PRIMARY KEY (MA_DH),
    CONSTRAINT FK_DH_NGUOI_DUNG     FOREIGN KEY (MA_ND) REFERENCES NGUOI_DUNG(MA_ND),
    CONSTRAINT FK_DH_KHUYEN_MAI     FOREIGN KEY (MA_KM) REFERENCES KHUYEN_MAI(MA_KM),
    CONSTRAINT CK_DH_PTTT           CHECK (PHUONG_THUC_TT IN ('TIEN_MAT', 'CHUYEN_KHOAN', 'VNPAY', 'MOMO')),
    CONSTRAINT CK_DH_TRANG_THAI     CHECK (TRANG_THAI IN ('CHO_XAC_NHAN','DA_XAC_NHAN','DANG_GIAO','DA_GIAO','DA_HUY')),
    CONSTRAINT CK_DH_TIEN_GIAM      CHECK (TIEN_GIAM >= 0),
    CONSTRAINT CK_DH_PHI_VC         CHECK (PHI_VAN_CHUYEN >= 0),
    CONSTRAINT CK_DH_NGAY_GIAO      CHECK (NGAY_GIAO_DU_KIEN >= NGAY_DAT)
);

COMMENT ON TABLE  DON_HANG                      IS 'Don hang cua khach hang (header)';
COMMENT ON COLUMN DON_HANG.MA_DH                IS 'Ma don hang - khoa chinh';
COMMENT ON COLUMN DON_HANG.MA_ND                IS 'Khoa ngoai -> NGUOI_DUNG';
COMMENT ON COLUMN DON_HANG.MA_KM                IS 'Khoa ngoai -> KHUYEN_MAI (NULL neu khong ap dung)';
COMMENT ON COLUMN DON_HANG.NGAY_DAT             IS 'Ngay va gio dat hang';
COMMENT ON COLUMN DON_HANG.NGAY_GIAO_DU_KIEN    IS 'Ngay giao hang du kien';
COMMENT ON COLUMN DON_HANG.NGAY_GIAO_THUC_TE    IS 'Ngay giao hang thuc te';
COMMENT ON COLUMN DON_HANG.TONG_TIEN_HANG       IS 'Tong tien hang truoc khi giam gia (VND)';
COMMENT ON COLUMN DON_HANG.TIEN_GIAM            IS 'So tien duoc giam tu khuyen mai (VND)';
COMMENT ON COLUMN DON_HANG.PHI_VAN_CHUYEN       IS 'Phi van chuyen (VND)';
COMMENT ON COLUMN DON_HANG.TONG_THANH_TOAN      IS 'Tong tien khach phai tra (VND)';
COMMENT ON COLUMN DON_HANG.PHUONG_THUC_TT       IS 'Phuong thuc thanh toan: TIEN_MAT | CHUYEN_KHOAN | VNPAY | MOMO';
COMMENT ON COLUMN DON_HANG.DIA_CHI_GIAO         IS 'Dia chi giao hang (snapshot tai thoi diem dat hang)';
COMMENT ON COLUMN DON_HANG.SO_DT_LIEN_HE        IS 'So dien thoai lien he giao hang';
COMMENT ON COLUMN DON_HANG.GHI_CHU              IS 'Ghi chu them cua khach hang';
COMMENT ON COLUMN DON_HANG.TRANG_THAI           IS 'Trang thai don hang: CHO_XAC_NHAN | DA_XAC_NHAN | DANG_GIAO | DA_GIAO | DA_HUY';

-- ============================================================
-- TABLE 9: CHI_TIET_DH (Order Items) — TRANSACTION DATA
-- Order line items: each row is one variant sold in an order.
-- DON_GIA is snapshotted at purchase time (historical accuracy).
-- 3NF: THANH_TIEN is a derived value (SO_LUONG * DON_GIA) stored
--       for performance/reporting; all other attrs depend only on MA_CTDH.
-- ============================================================
CREATE TABLE CHI_TIET_DH (
    MA_CTDH         NUMBER(10)      NOT NULL,
    MA_DH           NUMBER(10)      NOT NULL,
    MA_BIEN_THE     NUMBER(10)      NOT NULL,
    SO_LUONG        NUMBER(5)       NOT NULL,
    DON_GIA         NUMBER(15,2)    NOT NULL,
    THANH_TIEN      NUMBER(15,2)    NOT NULL,
    CONSTRAINT PK_CHI_TIET_DH       PRIMARY KEY (MA_CTDH),
    CONSTRAINT FK_CTDH_DON_HANG     FOREIGN KEY (MA_DH) REFERENCES DON_HANG(MA_DH),
    CONSTRAINT FK_CTDH_BIEN_THE     FOREIGN KEY (MA_BIEN_THE) REFERENCES BIEN_THE_SP(MA_BIEN_THE),
    CONSTRAINT UQ_CTDH              UNIQUE (MA_DH, MA_BIEN_THE),
    CONSTRAINT CK_CTDH_SO_LUONG     CHECK (SO_LUONG > 0),
    CONSTRAINT CK_CTDH_DON_GIA      CHECK (DON_GIA > 0),
    CONSTRAINT CK_CTDH_THANH_TIEN   CHECK (THANH_TIEN > 0)
);

COMMENT ON TABLE  CHI_TIET_DH                IS 'Chi tiet san pham trong tung don hang';
COMMENT ON COLUMN CHI_TIET_DH.MA_CTDH        IS 'Ma chi tiet don hang - khoa chinh';
COMMENT ON COLUMN CHI_TIET_DH.MA_DH          IS 'Khoa ngoai -> DON_HANG';
COMMENT ON COLUMN CHI_TIET_DH.MA_BIEN_THE    IS 'Khoa ngoai -> BIEN_THE_SP';
COMMENT ON COLUMN CHI_TIET_DH.SO_LUONG       IS 'So luong mua';
COMMENT ON COLUMN CHI_TIET_DH.DON_GIA        IS 'Don gia tai thoi diem mua (VND) - snapshot';
COMMENT ON COLUMN CHI_TIET_DH.THANH_TIEN     IS 'Thanh tien = SO_LUONG * DON_GIA (VND)';

-- ============================================================
-- TABLE 10: DANH_GIA (Product Reviews & Ratings) — TRANSACTION DATA
-- Customers rate and review products they have purchased.
-- MA_DH links to the verified purchase (ensures authentic reviews).
-- 3NF: All attributes depend only on MA_DG.
-- ============================================================
CREATE TABLE DANH_GIA (
    MA_DG           NUMBER(10)      NOT NULL,
    MA_ND           NUMBER(10)      NOT NULL,
    MA_SP           NUMBER(10)      NOT NULL,
    MA_DH           NUMBER(10),
    SO_SAO          NUMBER(1)       NOT NULL,
    BINH_LUAN       VARCHAR2(2000),
    NGAY_DANH_GIA   DATE            DEFAULT SYSDATE NOT NULL,
    TRANG_THAI      NUMBER(1)       DEFAULT 1 NOT NULL,
    CONSTRAINT PK_DANH_GIA          PRIMARY KEY (MA_DG),
    CONSTRAINT FK_DG_NGUOI_DUNG     FOREIGN KEY (MA_ND) REFERENCES NGUOI_DUNG(MA_ND),
    CONSTRAINT FK_DG_SAN_PHAM       FOREIGN KEY (MA_SP) REFERENCES SAN_PHAM(MA_SP),
    CONSTRAINT FK_DG_DON_HANG       FOREIGN KEY (MA_DH) REFERENCES DON_HANG(MA_DH),
    CONSTRAINT UQ_DANH_GIA          UNIQUE (MA_ND, MA_SP, MA_DH),
    CONSTRAINT CK_DG_SO_SAO         CHECK (SO_SAO BETWEEN 1 AND 5),
    CONSTRAINT CK_DG_TRANG_THAI     CHECK (TRANG_THAI IN (0, 1))
);

COMMENT ON TABLE  DANH_GIA                   IS 'Danh gia va binh luan san pham cua khach hang';
COMMENT ON COLUMN DANH_GIA.MA_DG             IS 'Ma danh gia - khoa chinh';
COMMENT ON COLUMN DANH_GIA.MA_ND             IS 'Khoa ngoai -> NGUOI_DUNG';
COMMENT ON COLUMN DANH_GIA.MA_SP             IS 'Khoa ngoai -> SAN_PHAM';
COMMENT ON COLUMN DANH_GIA.MA_DH             IS 'Khoa ngoai -> DON_HANG (NULL = cho phep danh gia khong qua mua hang)';
COMMENT ON COLUMN DANH_GIA.SO_SAO            IS 'So sao danh gia: 1 den 5';
COMMENT ON COLUMN DANH_GIA.BINH_LUAN        IS 'Noi dung binh luan cua khach hang';
COMMENT ON COLUMN DANH_GIA.NGAY_DANH_GIA    IS 'Ngay viet danh gia';
COMMENT ON COLUMN DANH_GIA.TRANG_THAI       IS '1=Hien thi, 0=An';

-- ============================================================
-- INDEXES (performance for common query patterns)
-- ============================================================

-- Products: filter by category and brand
CREATE INDEX IDX_SP_LOAI    ON SAN_PHAM(MA_LOAI);
CREATE INDEX IDX_SP_HANG    ON SAN_PHAM(MA_HANG);
CREATE INDEX IDX_SP_NGAY    ON SAN_PHAM(NGAY_NHAP);

-- Variants: look up by product
CREATE INDEX IDX_BT_SP      ON BIEN_THE_SP(MA_SP);

-- Promotions: date-range queries for active promotions
CREATE INDEX IDX_KM_NGAY    ON KHUYEN_MAI(NGAY_BAT_DAU, NGAY_KET_THUC);
CREATE INDEX IDX_KM_SP      ON KHUYEN_MAI(MA_SP);

-- Cart: look up cart items by user
CREATE INDEX IDX_GH_ND      ON GIO_HANG(MA_ND);

-- Orders: filter by user, date, status (reporting & statistics)
CREATE INDEX IDX_DH_ND      ON DON_HANG(MA_ND);
CREATE INDEX IDX_DH_NGAY    ON DON_HANG(NGAY_DAT);
CREATE INDEX IDX_DH_TRANG   ON DON_HANG(TRANG_THAI);

-- Order items: look up items in a given order
CREATE INDEX IDX_CTDH_DH    ON CHI_TIET_DH(MA_DH);
CREATE INDEX IDX_CTDH_BT    ON CHI_TIET_DH(MA_BIEN_THE);

-- Reviews: look up by product (for rating aggregation)
CREATE INDEX IDX_DG_SP      ON DANH_GIA(MA_SP);
CREATE INDEX IDX_DG_ND      ON DANH_GIA(MA_ND);
CREATE INDEX IDX_DG_NGAY    ON DANH_GIA(NGAY_DANH_GIA);

-- ============================================================
-- TRIGGERS (auto-assign PKs from sequences on INSERT)
-- ============================================================

CREATE OR REPLACE TRIGGER TRG_LOAI_HANG_BI
    BEFORE INSERT ON LOAI_HANG FOR EACH ROW
BEGIN
    IF :NEW.MA_LOAI IS NULL THEN
        SELECT SEQ_LOAI_HANG.NEXTVAL INTO :NEW.MA_LOAI FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_HANG_SX_BI
    BEFORE INSERT ON HANG_SX FOR EACH ROW
BEGIN
    IF :NEW.MA_HANG IS NULL THEN
        SELECT SEQ_HANG_SX.NEXTVAL INTO :NEW.MA_HANG FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_SAN_PHAM_BI
    BEFORE INSERT ON SAN_PHAM FOR EACH ROW
BEGIN
    IF :NEW.MA_SP IS NULL THEN
        SELECT SEQ_SAN_PHAM.NEXTVAL INTO :NEW.MA_SP FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_BIEN_THE_BI
    BEFORE INSERT ON BIEN_THE_SP FOR EACH ROW
BEGIN
    IF :NEW.MA_BIEN_THE IS NULL THEN
        SELECT SEQ_BIEN_THE.NEXTVAL INTO :NEW.MA_BIEN_THE FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_NGUOI_DUNG_BI
    BEFORE INSERT ON NGUOI_DUNG FOR EACH ROW
BEGIN
    IF :NEW.MA_ND IS NULL THEN
        SELECT SEQ_NGUOI_DUNG.NEXTVAL INTO :NEW.MA_ND FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_KHUYEN_MAI_BI
    BEFORE INSERT ON KHUYEN_MAI FOR EACH ROW
BEGIN
    IF :NEW.MA_KM IS NULL THEN
        SELECT SEQ_KHUYEN_MAI.NEXTVAL INTO :NEW.MA_KM FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_GIO_HANG_BI
    BEFORE INSERT ON GIO_HANG FOR EACH ROW
BEGIN
    IF :NEW.MA_GH IS NULL THEN
        SELECT SEQ_GIO_HANG.NEXTVAL INTO :NEW.MA_GH FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_DON_HANG_BI
    BEFORE INSERT ON DON_HANG FOR EACH ROW
BEGIN
    IF :NEW.MA_DH IS NULL THEN
        SELECT SEQ_DON_HANG.NEXTVAL INTO :NEW.MA_DH FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_CHI_TIET_DH_BI
    BEFORE INSERT ON CHI_TIET_DH FOR EACH ROW
BEGIN
    IF :NEW.MA_CTDH IS NULL THEN
        SELECT SEQ_CHI_TIET_DH.NEXTVAL INTO :NEW.MA_CTDH FROM DUAL;
    END IF;
    -- Auto-calculate THANH_TIEN if not provided
    IF :NEW.THANH_TIEN IS NULL THEN
        :NEW.THANH_TIEN := :NEW.SO_LUONG * :NEW.DON_GIA;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_DANH_GIA_BI
    BEFORE INSERT ON DANH_GIA FOR EACH ROW
BEGIN
    IF :NEW.MA_DG IS NULL THEN
        SELECT SEQ_DANH_GIA.NEXTVAL INTO :NEW.MA_DG FROM DUAL;
    END IF;
END;
/

-- ============================================================
-- USEFUL VIEWS (for reporting & statistics)
-- ============================================================

-- View: Product with category and brand info (avoids repeated JOINs)
CREATE OR REPLACE VIEW V_SAN_PHAM AS
SELECT
    sp.MA_SP,
    sp.TEN_SP,
    sp.GIA_GOC,
    sp.MO_TA,
    sp.ANH_DAI_DIEN,
    sp.LUOT_XEM,
    sp.NGAY_NHAP,
    sp.TRANG_THAI,
    lh.MA_LOAI,
    lh.TEN_LOAI,
    hs.MA_HANG,
    hs.TEN_HANG,
    hs.NUOC_GC,
    NVL(AVG(dg.SO_SAO), 0)   AS DIEM_TRUNG_BINH,
    COUNT(dg.MA_DG)           AS TONG_DANH_GIA
FROM SAN_PHAM   sp
JOIN LOAI_HANG  lh ON sp.MA_LOAI = lh.MA_LOAI
JOIN HANG_SX    hs ON sp.MA_HANG  = hs.MA_HANG
LEFT JOIN DANH_GIA dg ON sp.MA_SP = dg.MA_SP AND dg.TRANG_THAI = 1
GROUP BY
    sp.MA_SP, sp.TEN_SP, sp.GIA_GOC, sp.MO_TA, sp.ANH_DAI_DIEN,
    sp.LUOT_XEM, sp.NGAY_NHAP, sp.TRANG_THAI,
    lh.MA_LOAI, lh.TEN_LOAI,
    hs.MA_HANG, hs.TEN_HANG, hs.NUOC_GC;

-- View: Monthly revenue report (supports 1-year statistics)
CREATE OR REPLACE VIEW V_DOANH_THU_THANG AS
SELECT
    EXTRACT(YEAR  FROM dh.NGAY_DAT)   AS NAM,
    EXTRACT(MONTH FROM dh.NGAY_DAT)   AS THANG,
    COUNT(DISTINCT dh.MA_DH)          AS TONG_DON_HANG,
    COUNT(DISTINCT dh.MA_ND)          AS TONG_KHACH_HANG,
    SUM(dh.TONG_THANH_TOAN)           AS DOANH_THU,
    SUM(dh.TIEN_GIAM)                 AS TONG_TIEN_GIAM
FROM DON_HANG dh
WHERE dh.TRANG_THAI != 'DA_HUY'
GROUP BY
    EXTRACT(YEAR  FROM dh.NGAY_DAT),
    EXTRACT(MONTH FROM dh.NGAY_DAT)
ORDER BY NAM, THANG;

-- View: Best-selling products (top sellers by revenue)
CREATE OR REPLACE VIEW V_SAN_PHAM_BAN_CHAY AS
SELECT
    sp.MA_SP,
    sp.TEN_SP,
    hs.TEN_HANG,
    SUM(ct.SO_LUONG)        AS TONG_SO_LUONG_BAN,
    SUM(ct.THANH_TIEN)      AS TONG_DOANH_THU,
    COUNT(DISTINCT dh.MA_ND) AS TONG_KHACH_HANG
FROM CHI_TIET_DH    ct
JOIN BIEN_THE_SP    bt ON ct.MA_BIEN_THE = bt.MA_BIEN_THE
JOIN SAN_PHAM       sp ON bt.MA_SP       = sp.MA_SP
JOIN HANG_SX        hs ON sp.MA_HANG     = hs.MA_HANG
JOIN DON_HANG       dh ON ct.MA_DH       = dh.MA_DH
WHERE dh.TRANG_THAI != 'DA_HUY'
GROUP BY sp.MA_SP, sp.TEN_SP, hs.TEN_HANG
ORDER BY TONG_DOANH_THU DESC;

-- View: Order details (full order info for tracking page)
CREATE OR REPLACE VIEW V_CHI_TIET_DON_HANG AS
SELECT
    dh.MA_DH,
    dh.NGAY_DAT,
    dh.TRANG_THAI           AS TRANG_THAI_DH,
    dh.TONG_TIEN_HANG,
    dh.TIEN_GIAM,
    dh.PHI_VAN_CHUYEN,
    dh.TONG_THANH_TOAN,
    dh.DIA_CHI_GIAO,
    dh.SO_DT_LIEN_HE,
    nd.HO_TEN,
    nd.EMAIL,
    ct.MA_CTDH,
    sp.TEN_SP,
    bt.MAU_SAC,
    bt.DUNG_LUONG,
    ct.SO_LUONG,
    ct.DON_GIA,
    ct.THANH_TIEN
FROM DON_HANG       dh
JOIN NGUOI_DUNG     nd ON dh.MA_ND        = nd.MA_ND
JOIN CHI_TIET_DH    ct ON dh.MA_DH        = ct.MA_DH
JOIN BIEN_THE_SP    bt ON ct.MA_BIEN_THE  = bt.MA_BIEN_THE
JOIN SAN_PHAM       sp ON bt.MA_SP        = sp.MA_SP;

COMMIT;
