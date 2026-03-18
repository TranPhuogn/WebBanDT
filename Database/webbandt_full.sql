-- ============================================================
-- WebBanDT — Full Oracle DDL + DML Script
-- Ready to run in Oracle SQL*Plus / SQL Developer
--
-- Execution order:
--   1. DROP existing objects  (safe to re-run)
--   2. CREATE sequences, tables, constraints, indexes
--   3. CREATE triggers for auto-increment PKs
--   4. CREATE views for reporting
--   5. INSERT sample data (182 rows, Jan–Dec 2025)
--   6. COMMIT
-- ============================================================
-- Usage (SQL*Plus):
--   CONNECT username/password@database
--   @webbandt_full.sql
--
-- Usage (SQL Developer):
--   File > Open > webbandt_full.sql > Run Script (F5)
-- ============================================================

-- ============================================================
-- Oracle Database Schema for WebBanDT (Mobile Phone E-Commerce)
-- Course: Oracle DBMS | Team size: 3 | Tables: 10
-- Normalization: 3NF | Supports: 1-year data tracking
-- ============================================================
-- Tables:
--   1. LOAI_HANG    – Product categories  (PK, CHECK, NOT NULL)
--   2. HANG_SX      – Brands/manufacturers (PK, UNIQUE, CHECK)
--   3. SAN_PHAM     – Products             (PK, FK->1,2, CHECK)
--   4. BIEN_THE_SP  – Product variants     (PK, FK->3, UNIQUE, CHECK)
--   5. NGUOI_DUNG   – Users/customers      (PK, UNIQUE, CHECK)
--   6. KHUYEN_MAI   – Promotions           (PK, FK->3, CHECK)
--   7. GIO_HANG     – Shopping cart        (PK, FK->5,4, UNIQUE, CHECK)
--   8. DON_HANG     – Orders               (PK, FK->5,6, CHECK)
--   9. CHI_TIET_DH  – Order line items     (PK, FK->8,4, UNIQUE, CHECK)
--  10. DANH_GIA     – Product reviews      (PK, FK->5,3,8, UNIQUE, CHECK)
-- Sample data (see sample_data.sql): 182 rows spanning Jan–Dec 2025
-- ============================================================

-- ============================================================
-- DROP existing objects (safe to re-run on any Oracle version)
-- Tables dropped in reverse FK dependency order.
-- PL/SQL EXCEPTION WHEN OTHERS ignores "object does not exist".
-- ============================================================
BEGIN
    -- Tables (reverse FK order: children first, then parents)
    FOR tbl IN (
        SELECT table_name FROM (
            SELECT 1 ord, 'DANH_GIA'    table_name FROM DUAL UNION ALL
            SELECT 2,     'CHI_TIET_DH' FROM DUAL UNION ALL
            SELECT 3,     'GIO_HANG'    FROM DUAL UNION ALL
            SELECT 4,     'DON_HANG'    FROM DUAL UNION ALL
            SELECT 5,     'KHUYEN_MAI'  FROM DUAL UNION ALL
            SELECT 6,     'BIEN_THE_SP' FROM DUAL UNION ALL
            SELECT 7,     'NGUOI_DUNG'  FROM DUAL UNION ALL
            SELECT 8,     'SAN_PHAM'    FROM DUAL UNION ALL
            SELECT 9,     'HANG_SX'     FROM DUAL UNION ALL
            SELECT 10,    'LOAI_HANG'   FROM DUAL
        ) ORDER BY ord
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl.table_name || ' CASCADE CONSTRAINTS PURGE';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    -- Sequences
    FOR seq IN (
        SELECT sequence_name FROM (
            SELECT 1 ord, 'SEQ_LOAI_HANG'   sequence_name FROM DUAL UNION ALL
            SELECT 2,     'SEQ_HANG_SX'     FROM DUAL UNION ALL
            SELECT 3,     'SEQ_SAN_PHAM'    FROM DUAL UNION ALL
            SELECT 4,     'SEQ_BIEN_THE'    FROM DUAL UNION ALL
            SELECT 5,     'SEQ_NGUOI_DUNG'  FROM DUAL UNION ALL
            SELECT 6,     'SEQ_KHUYEN_MAI'  FROM DUAL UNION ALL
            SELECT 7,     'SEQ_GIO_HANG'    FROM DUAL UNION ALL
            SELECT 8,     'SEQ_DON_HANG'    FROM DUAL UNION ALL
            SELECT 9,     'SEQ_CHI_TIET_DH' FROM DUAL UNION ALL
            SELECT 10,    'SEQ_DANH_GIA'    FROM DUAL
        ) ORDER BY ord
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || seq.sequence_name;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
END;
/

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

-- ============================================================
-- Sample Data for WebBanDT Oracle Database
-- Total rows: 182  |  Date range: Jan 2025 – Dec 2025
-- Run AFTER schema.sql
-- ============================================================

-- ============================================================
-- 1. LOAI_HANG (Product Categories)  —  3 rows
-- ============================================================
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('Dien thoai', 'Dien thoai thong minh (smartphone) cac hang');
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('May tinh bang', 'May tinh bang (tablet) cac hang');
INSERT INTO LOAI_HANG (TEN_LOAI, MO_TA)
    VALUES ('Phu kien', 'Phu kien dien thoai: op lung, kinh can, cap sac');

-- ============================================================
-- 2. HANG_SX (Brands)  —  8 rows
-- ============================================================
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Apple',   'My');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Samsung', 'Han Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Xiaomi',  'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('OPPO',    'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Vivo',    'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Nokia',   'Phan Lan');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('Realme',  'Trung Quoc');
INSERT INTO HANG_SX (TEN_HANG, NUOC_GC) VALUES ('ASUS',    'Dai Loan');

-- ============================================================
-- 3. SAN_PHAM (Products)  —  12 rows
--    MA_LOAI: 1=Dien thoai  2=May tinh bang  3=Phu kien
--    MA_HANG: 1=Apple  2=Samsung  3=Xiaomi  4=OPPO  5=Vivo
--             6=Nokia  7=Realme   8=ASUS
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

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('iPhone 14', 1, 1, 19990000,
            'RAM: 6GB | Chip: A15 Bionic | Pin: 3279mAh | Man hinh: 6.1" OLED 60Hz | Camera: 12MP+12MP',
            'iPhone 14 van la lua chon pho bien voi chip A15 Bionic on dinh va camera cai thien.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Nokia G42', 1, 6, 4490000,
            'RAM: 6GB | Chip: Snapdragon 480+ | Pin: 5000mAh | Man hinh: 6.56" IPS | Camera: 50MP+2MP+2MP',
            'Nokia G42 ben bi, pin trau, gia re, hop voi nguoi dung can dien thoai co ban.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('Realme 12 Pro+', 1, 7, 9990000,
            'RAM: 12GB | Chip: Snapdragon 6s Gen 3 | Pin: 5000mAh | Man hinh: 6.7" AMOLED 120Hz | Camera: 50MP+64MP+2MP',
            'Realme 12 Pro+ camera tele zoom truoc 50MP an tuong, man hinh cong sac net.');

INSERT INTO SAN_PHAM (TEN_SP, MA_LOAI, MA_HANG, GIA_GOC, THONG_SO_KT, MO_TA)
    VALUES ('iPad Air M2', 2, 1, 18990000,
            'RAM: 8GB | Chip: M2 | Pin: 28.65Wh | Man hinh: 11" Liquid Retina | Camera: 12MP',
            'iPad Air M2 voi chip M2 manh me, man hinh Liquid Retina, ho tro Apple Pencil Pro.');

-- ============================================================
-- 4. BIEN_THE_SP (Product Variants)  —  34 rows
--    IDs follow insertion order (SEQ_BIEN_THE auto-increments).
--    SP 1 (iPhone 15 Pro Max)  : BT  1- 5
--    SP 2 (iPhone 15)          : BT  6- 9
--    SP 3 (Samsung S24 Ultra)  : BT 10-12
--    SP 4 (Samsung A55)        : BT 13-15
--    SP 5 (Xiaomi 14)          : BT 16-18
--    SP 6 (OPPO Find X7)       : BT 19-20
--    SP 7 (Vivo V30)           : BT 21-22
--    SP 8 (Samsung Tab S9)     : BT 23-24
--    SP 9 (iPhone 14)          : BT 25-27
--    SP10 (Nokia G42)          : BT 28-29
--    SP11 (Realme 12 Pro+)     : BT 30-31
--    SP12 (iPad Air M2)        : BT 32-34
-- ============================================================

-- SP 1 — iPhone 15 Pro Max
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien', '256GB',       0, 15);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien', '512GB', 2000000, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Tu Nhien',   '1TB', 5000000,  5);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Den',        '256GB',       0, 12);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (1, 'Titan Den',        '512GB', 2000000,  8);

-- SP 2 — iPhone 15
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Den',  '128GB',       0, 20);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Den',  '256GB', 2000000, 15);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Hong', '128GB',       0, 18);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (2, 'Xanh', '128GB',       0, 14);

-- SP 3 — Samsung Galaxy S24 Ultra
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Den Titan', '256GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Den Titan', '512GB', 2000000,  7);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (3, 'Xam Titan', '256GB',       0,  9);

-- SP 4 — Samsung Galaxy A55
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Xanh', '128GB',       0, 25);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Vang', '128GB',       0, 20);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (4, 'Xanh', '256GB', 1000000, 15);

-- SP 5 — Xiaomi 14
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Den',   '256GB',       0, 12);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Trang', '256GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (5, 'Den',   '512GB', 2000000,  8);

-- SP 6 — OPPO Find X7
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (6, 'Den',   '256GB', 0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (6, 'Trang', '256GB', 0,  8);

-- SP 7 — Vivo V30
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (7, 'Xanh Bac Ha', '256GB', 0, 18);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (7, 'Den',         '256GB', 0, 15);

-- SP 8 — Samsung Galaxy Tab S9
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (8, 'Be', '128GB',       0, 10);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (8, 'Be', '256GB', 2000000,  7);

-- SP 9 — iPhone 14
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (9, 'Den',   '128GB',       0, 18);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (9, 'Do',    '128GB',       0, 12);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (9, 'Trang', '256GB', 1500000,  8);

-- SP10 — Nokia G42
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (10, 'Xanh', '128GB', 0, 30);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (10, 'Den',  '128GB', 0, 25);

-- SP11 — Realme 12 Pro+
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (11, 'Den', '256GB', 0, 20);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (11, 'Be',  '256GB', 0, 15);

-- SP12 — iPad Air M2
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (12, 'Bac',  '256GB',       0, 8);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (12, 'Xanh', '256GB',       0, 6);
INSERT INTO BIEN_THE_SP (MA_SP, MAU_SAC, DUNG_LUONG, GIA_THEM, SO_LUONG_TON) VALUES (12, 'Bac',  '512GB', 3000000, 5);

-- ============================================================
-- 5. NGUOI_DUNG (Users)  —  15 rows
--    IDs 1–5 registered Jan–May 2024; 6–12 Jun–Dec 2024;
--    13–15 registered Jan–Mar 2025 (new customers).
-- ============================================================
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Nguyen Van An',    'an.nguyen@email.com',     '$2b$12$hashAn',     '0901234567', 'Nam', DATE '1995-03-15', DATE '2024-01-10');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Tran Thi Binh',    'binh.tran@email.com',     '$2b$12$hashBinh',   '0912345678', 'Nu',  DATE '1998-07-22', DATE '2024-02-05');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Le Van Cuong',     'cuong.le@email.com',      '$2b$12$hashCuong',  '0923456789', 'Nam', DATE '1990-11-30', DATE '2024-03-20');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Pham Thi Dung',    'dung.pham@email.com',     '$2b$12$hashDung',   '0934567890', 'Nu',  DATE '2000-05-08', DATE '2024-04-12');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Hoang Van Em',     'em.hoang@email.com',      '$2b$12$hashEm',     '0945678901', 'Nam', DATE '1993-09-18', DATE '2024-05-01');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Nguyen Thi Phuong','phuong.nguyen@email.com', '$2b$12$hashPhuong', '0956789012', 'Nu',  DATE '1997-02-14', DATE '2024-06-08');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Tran Van Quang',   'quang.tran@email.com',    '$2b$12$hashQuang',  '0967890123', 'Nam', DATE '1992-12-05', DATE '2024-07-15');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Le Thi Huong',     'huong.le@email.com',      '$2b$12$hashHuong',  '0978901234', 'Nu',  DATE '2001-04-20', DATE '2024-08-03');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Vo Van Khanh',     'khanh.vo@email.com',      '$2b$12$hashKhanh',  '0989012345', 'Nam', DATE '1988-07-11', DATE '2024-09-22');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Do Thi Lan',       'lan.do@email.com',        '$2b$12$hashLan',    '0990123456', 'Nu',  DATE '1999-10-30', DATE '2024-10-14');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Bui Van Minh',     'minh.bui@email.com',      '$2b$12$hashMinh',   '0901234568', 'Nam', DATE '1994-01-25', DATE '2024-11-09');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Nguyen Thi Ngoc',  'ngoc.nguyen@email.com',   '$2b$12$hashNgoc',   '0912345679', 'Nu',  DATE '2002-08-17', DATE '2024-12-01');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Tran Van Phuc',    'phuc.tran@email.com',     '$2b$12$hashPhuc',   '0923456780', 'Nam', DATE '1996-06-03', DATE '2025-01-05');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Le Thi Quynh',     'quynh.le@email.com',      '$2b$12$hashQuynh',  '0934567891', 'Nu',  DATE '2003-03-12', DATE '2025-02-18');
INSERT INTO NGUOI_DUNG (HO_TEN, EMAIL, MAT_KHAU, SO_DT, GIOI_TINH, NGAY_SINH, NGAY_DANG_KY)
    VALUES ('Pham Van Son',     'son.pham@email.com',      '$2b$12$hashSon',    '0945678902', 'Nam', DATE '1991-11-08', DATE '2025-03-10');

-- ============================================================
-- 6. KHUYEN_MAI (Promotions)  —  12 rows (one per month 2025)
--    KM  1: Jan — 10% off any iPhone, min 15M
--    KM  2: Feb — 2M off Samsung S24 Ultra, min 25M
--    KM  3: Mar — Free shipping, min 5M
--    KM  4: Apr — 15% off Xiaomi 14, min 18M
--    KM  5: May — 1M off any order, min 10M
--    KM  6: Jun — 8% off any order, min 8M
--    KM  7: Jul — 500K off any order, min 5M
--    KM  8: Aug — 12% off Samsung Tab S9, min 15M
--    KM  9: Sep — Free shipping, min 5M
--    KM 10: Oct — 20% off OPPO Find X7, min 20M
--    KM 11: Nov — 15% off any order (Black Friday), min 10M
--    KM 12: Dec — 10% off any order (Giang Sinh), min 5M
-- ============================================================
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Giam 10% iPhone thang 1',
            'Ap dung cho tat ca don hang co san pham iPhone, gia tri don tu 15 trieu',
            'PHAN_TRAM', 10, NULL, 15000000, DATE '2025-01-01', DATE '2025-01-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Samsung Sale mung nam moi',
            'Giam 2 trieu khi mua Samsung Galaxy S24 Ultra, don tu 25 trieu',
            'SO_TIEN', 2000000, 3, 25000000, DATE '2025-02-01', DATE '2025-02-28');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Mien phi van chuyen thang 3',
            'Mien phi van chuyen cho tat ca don hang tu 5 trieu trong thang 3',
            'MIEN_PHI_VC', 50000, NULL, 5000000, DATE '2025-03-01', DATE '2025-03-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Flash sale Xiaomi 14 thang 4',
            'Giam 15% khi mua Xiaomi 14, gia tri don tu 18 trieu',
            'PHAN_TRAM', 15, 5, 18000000, DATE '2025-04-01', DATE '2025-04-30');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Giam gia thang 5 - Ngay gia dinh',
            'Giam 1 trieu cho moi don hang tu 10 trieu trong thang 5',
            'SO_TIEN', 1000000, NULL, 10000000, DATE '2025-05-01', DATE '2025-05-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Khuyen mai he thang 6',
            'Giam 8% cho tat ca don hang tu 8 trieu trong thang 6',
            'PHAN_TRAM', 8, NULL, 8000000, DATE '2025-06-01', DATE '2025-06-30');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Sale cuoi thuan thang 7',
            'Giam 500 nghin cho don hang tu 5 trieu vao cuoi tuan thang 7',
            'SO_TIEN', 500000, NULL, 5000000, DATE '2025-07-01', DATE '2025-07-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Giam gia Tab S9 thang 8',
            'Giam 12% khi mua Samsung Galaxy Tab S9, gia tri don tu 15 trieu',
            'PHAN_TRAM', 12, 8, 15000000, DATE '2025-08-01', DATE '2025-08-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Mien phi van chuyen thang 9 - Back to School',
            'Mien phi van chuyen cho tat ca don hang tu 5 trieu trong thang 9',
            'MIEN_PHI_VC', 50000, NULL, 5000000, DATE '2025-09-01', DATE '2025-09-30');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Flash sale OPPO Find X7 thang 10',
            'Giam 20% khi mua OPPO Find X7, gia tri don tu 20 trieu',
            'PHAN_TRAM', 20, 6, 20000000, DATE '2025-10-01', DATE '2025-10-31');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Black Friday thang 11',
            'Giam 15% cho tat ca don hang tu 10 trieu - Black Friday',
            'PHAN_TRAM', 15, NULL, 10000000, DATE '2025-11-01', DATE '2025-11-30');
INSERT INTO KHUYEN_MAI (TEN_KM, MO_TA, LOAI_KM, GIA_TRI, MA_SP, GIA_TOI_THIEU, NGAY_BAT_DAU, NGAY_KET_THUC)
    VALUES ('Khuyen mai le Giang Sinh thang 12',
            'Giam 10% cho tat ca don hang tu 5 trieu dip Giang Sinh',
            'PHAN_TRAM', 10, NULL, 5000000, DATE '2025-12-01', DATE '2025-12-31');

-- ============================================================
-- 7. GIO_HANG (Shopping Cart)  —  8 rows
--    Active cart items for users browsing (not yet ordered)
-- ============================================================
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (13,  1, 1);  -- Phuc: iPhone 15 Pro Max Titan Tu Nhien 256GB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (14,  3, 1);  -- Quynh: iPhone 15 Pro Max Titan Tu Nhien 1TB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (15, 10, 1);  -- Son: Samsung S24 Ultra Den Titan 256GB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES ( 1, 33, 1);  -- An: iPad Air M2 Xanh 256GB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES ( 2,  5, 1);  -- Binh: iPhone 15 Pro Max Titan Den 512GB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES ( 5, 24, 2);  -- Em: Samsung Tab S9 Be 256GB x2
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES ( 8, 16, 1);  -- Huong: Xiaomi 14 Den 256GB
INSERT INTO GIO_HANG (MA_ND, MA_BIEN_THE, SO_LUONG) VALUES (10, 34, 1);  -- Lan: iPad Air M2 Bac 512GB

-- ============================================================
-- 8. DON_HANG (Orders)  —  30 rows spanning Jan–Dec 2025
--    Status: all DA_GIAO (delivered) since we are in 2026.
--    Promotion cross-reference:
--      KM1(Jan,10%), KM2(Feb,2M), KM3(Mar,FreeVC), KM4(Apr,15%),
--      KM5(May,1M),  KM6(Jun,8%), KM7(Jul,500K),   KM8(Aug,12%),
--      KM9(Sep,FreeVC), KM10(Oct,20%), KM11(Nov,15%), KM12(Dec,10%)
-- ============================================================

-- === JANUARY 2025 ===
-- Order  1: ND=1  KM=1  iPhone 15 Pro Max 256GB (BT=1)  33990000 -10%= 30591000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (1, 1,
            DATE '2025-01-15', DATE '2025-01-18', DATE '2025-01-17',
            33990000, 3399000, 0, 30591000,
            'VNPAY', '123 Nguyen Trai, Quan 1, TP.HCM', '0901234567', 'DA_GIAO');

-- Order  2: ND=2  KM=NULL  Samsung A55 Xanh 128GB (BT=13)  10490000 + vc=30000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (2, NULL,
            DATE '2025-01-22', DATE '2025-01-25', DATE '2025-01-24',
            10490000, 0, 30000, 10520000,
            'CHUYEN_KHOAN', '456 Le Loi, Hai Ba Trung, Ha Noi', '0912345678', 'DA_GIAO');

-- Order  3: ND=3  KM=1  iPhone 14 Den 128GB (BT=25) + iPad Air M2 Bac 256GB (BT=32)  38980000 -10%
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (3, 1,
            DATE '2025-01-28', DATE '2025-01-31', DATE '2025-01-30',
            38980000, 3898000, 0, 35082000,
            'MOMO', '789 Tran Hung Dao, Quan 5, TP.HCM', '0923456789', 'DA_GIAO');

-- === FEBRUARY 2025 ===
-- Order  4: ND=4  KM=2  Samsung S24 Ultra Den Titan 256GB (BT=10)  31990000 -2M
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (4, 2,
            DATE '2025-02-10', DATE '2025-02-13', DATE '2025-02-12',
            31990000, 2000000, 0, 29990000,
            'VNPAY', '321 Vo Van Tan, Quan 3, TP.HCM', '0934567890', 'DA_GIAO');

-- Order  5: ND=5  KM=NULL  Vivo V30 Xanh Bac Ha 256GB (BT=21)  10990000 + vc=30000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (5, NULL,
            DATE '2025-02-18', DATE '2025-02-21', DATE '2025-02-20',
            10990000, 0, 30000, 11020000,
            'TIEN_MAT', '654 Nguyen Hue, Quan 1, TP.HCM', '0945678901', 'DA_GIAO');

-- Order  6: ND=6  KM=NULL  iPhone 15 Hong 128GB (BT=8)  22990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (6, NULL,
            DATE '2025-02-25', DATE '2025-02-28', DATE '2025-02-27',
            22990000, 0, 0, 22990000,
            'MOMO', '987 Le Van Sy, Phu Nhuan, TP.HCM', '0956789012', 'DA_GIAO');

-- === MARCH 2025 ===
-- Order  7: ND=7  KM=3  Xiaomi 14 Den 256GB (BT=16)  18990000 + free vc (saved 50K)
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (7, 3,
            DATE '2025-03-05', DATE '2025-03-08', DATE '2025-03-07',
            18990000, 0, 0, 18990000,
            'VNPAY', '111 Dinh Tien Hoang, Hoan Kiem, Ha Noi', '0967890123', 'DA_GIAO');

-- Order  8: ND=8  KM=NULL  Samsung A55 Vang 128GB (BT=14)  10490000 + vc=30000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (8, NULL,
            DATE '2025-03-12', DATE '2025-03-15', DATE '2025-03-14',
            10490000, 0, 30000, 10520000,
            'TIEN_MAT', '222 Tran Phu, Hai Chau, Da Nang', '0978901234', 'DA_GIAO');

-- Order  9: ND=1  KM=NULL  iPhone 15 Den 128GB (BT=6) + iPhone 14 Trang 256GB (BT=27)
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (1, NULL,
            DATE '2025-03-20', DATE '2025-03-23', DATE '2025-03-22',
            44480000, 0, 0, 44480000,
            'VNPAY', '123 Nguyen Trai, Quan 1, TP.HCM', '0901234567', 'DA_GIAO');

-- === APRIL 2025 ===
-- Order 10: ND=2  KM=4  Xiaomi 14 Trang 256GB (BT=17)  18990000 -15%=2848500 => 16141500
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (2, 4,
            DATE '2025-04-15', DATE '2025-04-18', DATE '2025-04-17',
            18990000, 2848500, 0, 16141500,
            'MOMO', '456 Le Loi, Hai Ba Trung, Ha Noi', '0912345678', 'DA_GIAO');

-- Order 11: ND=9  KM=NULL  Nokia G42 Xanh 128GB (BT=28)  4490000 + vc=30000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (9, NULL,
            DATE '2025-04-20', DATE '2025-04-23', DATE '2025-04-22',
            4490000, 0, 30000, 4520000,
            'CHUYEN_KHOAN', '333 Hung Vuong, Ngo Quyen, Hai Phong', '0989012345', 'DA_GIAO');

-- Order 12: ND=10  KM=NULL  OPPO Find X7 Den 256GB (BT=19)  21990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (10, NULL,
            DATE '2025-04-25', DATE '2025-04-28', DATE '2025-04-27',
            21990000, 0, 0, 21990000,
            'VNPAY', '444 Ly Tu Trong, Quan 1, TP.HCM', '0990123456', 'DA_GIAO');

-- === MAY 2025 ===
-- Order 13: ND=3  KM=5  Samsung S24 Ultra Den 512GB (BT=11)  33990000 -1M=32990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (3, 5,
            DATE '2025-05-08', DATE '2025-05-11', DATE '2025-05-10',
            33990000, 1000000, 0, 32990000,
            'VNPAY', '789 Tran Hung Dao, Quan 5, TP.HCM', '0923456789', 'DA_GIAO');

-- Order 14: ND=11  KM=NULL  Realme 12 Pro+ Den 256GB (BT=30) + Nokia G42 Den 128GB (BT=29)
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (11, NULL,
            DATE '2025-05-20', DATE '2025-05-23', DATE '2025-05-22',
            14480000, 0, 30000, 14510000,
            'TIEN_MAT', '555 Bach Dang, Son Tra, Da Nang', '0901234568', 'DA_GIAO');

-- === JUNE 2025 ===
-- Order 15: ND=12  KM=6  iPhone 15 Pro Max Titan Den 256GB (BT=4)  33990000 -8%=2719200 => 31270800
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (12, 6,
            DATE '2025-06-10', DATE '2025-06-13', DATE '2025-06-12',
            33990000, 2719200, 0, 31270800,
            'MOMO', '666 Nguyen Du, Hoan Kiem, Ha Noi', '0912345679', 'DA_GIAO');

-- Order 16: ND=4  KM=NULL  Samsung Tab S9 Be 128GB (BT=23)  20990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (4, NULL,
            DATE '2025-06-22', DATE '2025-06-25', DATE '2025-06-24',
            20990000, 0, 0, 20990000,
            'CHUYEN_KHOAN', '321 Vo Van Tan, Quan 3, TP.HCM', '0934567890', 'DA_GIAO');

-- === JULY 2025 ===
-- Order 17: ND=5  KM=7  iPhone 14 Do 128GB (BT=26) + Realme 12 Pro+ Be 256GB (BT=31)  29980000 -500K
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (5, 7,
            DATE '2025-07-05', DATE '2025-07-08', DATE '2025-07-07',
            29980000, 500000, 0, 29480000,
            'TIEN_MAT', '654 Nguyen Hue, Quan 1, TP.HCM', '0945678901', 'DA_GIAO');

-- Order 18: ND=13  KM=NULL  Xiaomi 14 Den 512GB (BT=18) + Vivo V30 Den 256GB (BT=22)  31980000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (13, NULL,
            DATE '2025-07-18', DATE '2025-07-21', DATE '2025-07-20',
            31980000, 0, 0, 31980000,
            'VNPAY', '777 Pham Van Dong, Bac Tu Liem, Ha Noi', '0923456780', 'DA_GIAO');

-- === AUGUST 2025 ===
-- Order 19: ND=6  KM=8  Samsung Tab S9 Be 256GB (BT=24)  22990000 -12%=2758800 => 20231200
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (6, 8,
            DATE '2025-08-05', DATE '2025-08-08', DATE '2025-08-07',
            22990000, 2758800, 0, 20231200,
            'MOMO', '987 Le Van Sy, Phu Nhuan, TP.HCM', '0956789012', 'DA_GIAO');

-- Order 20: ND=7  KM=NULL  iPhone 15 Xanh 128GB (BT=9)  22990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (7, NULL,
            DATE '2025-08-15', DATE '2025-08-18', DATE '2025-08-17',
            22990000, 0, 0, 22990000,
            'VNPAY', '111 Dinh Tien Hoang, Hoan Kiem, Ha Noi', '0967890123', 'DA_GIAO');

-- Order 21: ND=14  KM=NULL  OPPO Find X7 Trang 256GB (BT=20)  21990000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (14, NULL,
            DATE '2025-08-25', DATE '2025-08-28', DATE '2025-08-27',
            21990000, 0, 0, 21990000,
            'CHUYEN_KHOAN', '888 Hoang Dieu, Quan 4, TP.HCM', '0934567891', 'DA_GIAO');

-- === SEPTEMBER 2025 ===
-- Order 22: ND=8  KM=9  Realme 12 Pro+ Be 256GB (BT=31) + Nokia G42 Den 128GB (BT=29)  14480000 + free vc
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (8, 9,
            DATE '2025-09-08', DATE '2025-09-11', DATE '2025-09-10',
            14480000, 0, 0, 14480000,
            'MOMO', '222 Tran Phu, Hai Chau, Da Nang', '0978901234', 'DA_GIAO');

-- Order 23: ND=15  KM=NULL  Samsung S24 Ultra Xam 256GB (BT=12) + Samsung A55 Xanh 256GB (BT=15)
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (15, NULL,
            DATE '2025-09-20', DATE '2025-09-23', DATE '2025-09-22',
            43480000, 0, 0, 43480000,
            'VNPAY', '999 Khanh Hoi, Quan 4, TP.HCM', '0945678902', 'DA_GIAO');

-- === OCTOBER 2025 ===
-- Order 24: ND=9  KM=10  OPPO Find X7 Den 256GB (BT=19)  21990000 -20%=4398000 => 17592000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (9, 10,
            DATE '2025-10-10', DATE '2025-10-13', DATE '2025-10-12',
            21990000, 4398000, 0, 17592000,
            'TIEN_MAT', '333 Hung Vuong, Ngo Quyen, Hai Phong', '0989012345', 'DA_GIAO');

-- Order 25: ND=1  KM=NULL  iPad Air M2 Bac 256GB (BT=32) + iPad Air M2 Bac 512GB (BT=34)  40980000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (1, NULL,
            DATE '2025-10-25', DATE '2025-10-28', DATE '2025-10-27',
            40980000, 0, 0, 40980000,
            'VNPAY', '123 Nguyen Trai, Quan 1, TP.HCM', '0901234567', 'DA_GIAO');

-- === NOVEMBER 2025 ===
-- Order 26: ND=2  KM=11  Samsung S24 Ultra Den 256GB (BT=10) + iPhone 15 Den 256GB (BT=7)  56980000 -15%=8547000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (2, 11,
            DATE '2025-11-05', DATE '2025-11-08', DATE '2025-11-07',
            56980000, 8547000, 0, 48433000,
            'VNPAY', '456 Le Loi, Hai Ba Trung, Ha Noi', '0912345678', 'DA_GIAO');

-- Order 27: ND=10  KM=11  Xiaomi 14 Trang 256GB (BT=17)  18990000 -15%=2848500 => 16141500
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (10, 11,
            DATE '2025-11-20', DATE '2025-11-23', DATE '2025-11-22',
            18990000, 2848500, 0, 16141500,
            'MOMO', '444 Ly Tu Trong, Quan 1, TP.HCM', '0990123456', 'DA_GIAO');

-- Order 28: ND=11  KM=NULL  Nokia G42 Xanh 128GB (BT=28)  4490000 + vc=30000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (11, NULL,
            DATE '2025-11-28', DATE '2025-12-01', DATE '2025-11-30',
            4490000, 0, 30000, 4520000,
            'TIEN_MAT', '555 Bach Dang, Son Tra, Da Nang', '0901234568', 'DA_GIAO');

-- === DECEMBER 2025 ===
-- Order 29: ND=12  KM=12  iPhone 15 Pro Max Titan Tu Nhien 512GB (BT=2)  35990000 -10%=3599000 => 32391000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (12, 12,
            DATE '2025-12-10', DATE '2025-12-13', DATE '2025-12-12',
            35990000, 3599000, 0, 32391000,
            'MOMO', '666 Nguyen Du, Hoan Kiem, Ha Noi', '0912345679', 'DA_GIAO');

-- Order 30: ND=3  KM=12  Samsung Tab S9 Be 256GB (BT=24) + iPad Air M2 Xanh 256GB (BT=33)  41980000 -10%=4198000
INSERT INTO DON_HANG (MA_ND, MA_KM, NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE,
                      TONG_TIEN_HANG, TIEN_GIAM, PHI_VAN_CHUYEN, TONG_THANH_TOAN,
                      PHUONG_THUC_TT, DIA_CHI_GIAO, SO_DT_LIEN_HE, TRANG_THAI)
    VALUES (3, 12,
            DATE '2025-12-25', DATE '2025-12-28', DATE '2025-12-27',
            41980000, 4198000, 0, 37782000,
            'CHUYEN_KHOAN', '789 Tran Hung Dao, Quan 5, TP.HCM', '0923456789', 'DA_GIAO');

-- ============================================================
-- 9. CHI_TIET_DH (Order Items)  —  40 rows
--    DON_GIA = GIA_GOC (of MA_SP) + GIA_THEM (of MA_BIEN_THE)
-- ============================================================

-- DH=1  : BT=1  SP=1  iPhone 15 Pro Max Tu Nhien 256GB  33990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (1, 1, 1, 33990000, 33990000);
-- DH=2  : BT=13 SP=4  Samsung A55 Xanh 128GB  10490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (2, 13, 1, 10490000, 10490000);
-- DH=3  : BT=25 SP=9  iPhone 14 Den 128GB  19990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (3, 25, 1, 19990000, 19990000);
-- DH=3  : BT=32 SP=12 iPad Air M2 Bac 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (3, 32, 1, 18990000, 18990000);
-- DH=4  : BT=10 SP=3  Samsung S24 Ultra Den 256GB  31990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (4, 10, 1, 31990000, 31990000);
-- DH=5  : BT=21 SP=7  Vivo V30 Xanh Bac Ha 256GB  10990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (5, 21, 1, 10990000, 10990000);
-- DH=6  : BT=8  SP=2  iPhone 15 Hong 128GB  22990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (6, 8, 1, 22990000, 22990000);
-- DH=7  : BT=16 SP=5  Xiaomi 14 Den 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (7, 16, 1, 18990000, 18990000);
-- DH=8  : BT=14 SP=4  Samsung A55 Vang 128GB  10490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (8, 14, 1, 10490000, 10490000);
-- DH=9  : BT=6  SP=2  iPhone 15 Den 128GB  22990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (9, 6, 1, 22990000, 22990000);
-- DH=9  : BT=27 SP=9  iPhone 14 Trang 256GB  19990000+1500000=21490000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (9, 27, 1, 21490000, 21490000);
-- DH=10 : BT=17 SP=5  Xiaomi 14 Trang 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (10, 17, 1, 18990000, 18990000);
-- DH=11 : BT=28 SP=10 Nokia G42 Xanh 128GB  4490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (11, 28, 1, 4490000, 4490000);
-- DH=12 : BT=19 SP=6  OPPO Find X7 Den 256GB  21990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (12, 19, 1, 21990000, 21990000);
-- DH=13 : BT=11 SP=3  Samsung S24 Ultra Den 512GB  31990000+2000000=33990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (13, 11, 1, 33990000, 33990000);
-- DH=14 : BT=30 SP=11 Realme 12 Pro+ Den 256GB  9990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (14, 30, 1, 9990000, 9990000);
-- DH=14 : BT=29 SP=10 Nokia G42 Den 128GB  4490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (14, 29, 1, 4490000, 4490000);
-- DH=15 : BT=4  SP=1  iPhone 15 Pro Max Titan Den 256GB  33990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (15, 4, 1, 33990000, 33990000);
-- DH=16 : BT=23 SP=8  Samsung Tab S9 Be 128GB  20990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (16, 23, 1, 20990000, 20990000);
-- DH=17 : BT=26 SP=9  iPhone 14 Do 128GB  19990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (17, 26, 1, 19990000, 19990000);
-- DH=17 : BT=31 SP=11 Realme 12 Pro+ Be 256GB  9990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (17, 31, 1, 9990000, 9990000);
-- DH=18 : BT=18 SP=5  Xiaomi 14 Den 512GB  18990000+2000000=20990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (18, 18, 1, 20990000, 20990000);
-- DH=18 : BT=22 SP=7  Vivo V30 Den 256GB  10990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (18, 22, 1, 10990000, 10990000);
-- DH=19 : BT=24 SP=8  Samsung Tab S9 Be 256GB  20990000+2000000=22990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (19, 24, 1, 22990000, 22990000);
-- DH=20 : BT=9  SP=2  iPhone 15 Xanh 128GB  22990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (20, 9, 1, 22990000, 22990000);
-- DH=21 : BT=20 SP=6  OPPO Find X7 Trang 256GB  21990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (21, 20, 1, 21990000, 21990000);
-- DH=22 : BT=31 SP=11 Realme 12 Pro+ Be 256GB  9990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (22, 31, 1, 9990000, 9990000);
-- DH=22 : BT=29 SP=10 Nokia G42 Den 128GB  4490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (22, 29, 1, 4490000, 4490000);
-- DH=23 : BT=12 SP=3  Samsung S24 Ultra Xam 256GB  31990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (23, 12, 1, 31990000, 31990000);
-- DH=23 : BT=15 SP=4  Samsung A55 Xanh 256GB  10490000+1000000=11490000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (23, 15, 1, 11490000, 11490000);
-- DH=24 : BT=19 SP=6  OPPO Find X7 Den 256GB  21990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (24, 19, 1, 21990000, 21990000);
-- DH=25 : BT=32 SP=12 iPad Air M2 Bac 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (25, 32, 1, 18990000, 18990000);
-- DH=25 : BT=34 SP=12 iPad Air M2 Bac 512GB  18990000+3000000=21990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (25, 34, 1, 21990000, 21990000);
-- DH=26 : BT=10 SP=3  Samsung S24 Ultra Den Titan 256GB  31990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (26, 10, 1, 31990000, 31990000);
-- DH=26 : BT=7  SP=2  iPhone 15 Den 256GB  22990000+2000000=24990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (26, 7, 1, 24990000, 24990000);
-- DH=27 : BT=17 SP=5  Xiaomi 14 Trang 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (27, 17, 1, 18990000, 18990000);
-- DH=28 : BT=28 SP=10 Nokia G42 Xanh 128GB  4490000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (28, 28, 1, 4490000, 4490000);
-- DH=29 : BT=2  SP=1  iPhone 15 Pro Max Titan Tu Nhien 512GB  33990000+2000000=35990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (29, 2, 1, 35990000, 35990000);
-- DH=30 : BT=24 SP=8  Samsung Tab S9 Be 256GB  20990000+2000000=22990000
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (30, 24, 1, 22990000, 22990000);
-- DH=30 : BT=33 SP=12 iPad Air M2 Xanh 256GB  18990000+0
INSERT INTO CHI_TIET_DH (MA_DH, MA_BIEN_THE, SO_LUONG, DON_GIA, THANH_TIEN) VALUES (30, 33, 1, 18990000, 18990000);

-- ============================================================
-- 10. DANH_GIA (Product Reviews)  —  20 rows
--     Spread across Jan–Jul 2025 (5–7 days after delivery).
--     UNIQUE constraint: (MA_ND, MA_SP, MA_DH).
-- ============================================================
-- R1 : ND=1  SP=1  DH=1  (iPhone 15 Pro Max)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (1, 1, 1, 5, 'San pham tuyet voi! Camera chup anh rat dep, pin trau, chip A17 Pro qua manh.', DATE '2025-01-20');
-- R2 : ND=2  SP=4  DH=2  (Samsung Galaxy A55)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (2, 4, 2, 4, 'Samsung A55 dep, man hinh AMOLED sang, gia hop ly, giao hang nhanh.', DATE '2025-01-27');
-- R3 : ND=3  SP=9  DH=3  (iPhone 14)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (3, 9, 3, 4, 'iPhone 14 van dung tot, camera dep, pin kha. Gia re hon sau 1 nam ra mat.', DATE '2025-02-04');
-- R4 : ND=3  SP=12  DH=3  (iPad Air M2)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (3, 12, 3, 5, 'iPad Air M2 manh, man hinh Liquid Retina dep, phu hop hoc va lam viec rat tot.', DATE '2025-02-04');
-- R5 : ND=4  SP=3  DH=4  (Samsung S24 Ultra)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (4, 3, 4, 5, 'Galaxy S24 Ultra dinh nhat tu truoc toi nay, but S Pen tien loi, camera 200MP sieu net.', DATE '2025-02-16');
-- R6 : ND=5  SP=7  DH=5  (Vivo V30)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (5, 7, 5, 3, 'Vivo V30 tam duoc, thiet ke dep nhung pin hao khi chay nhieu ung dung.', DATE '2025-02-25');
-- R7 : ND=6  SP=2  DH=6  (iPhone 15)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (6, 2, 6, 4, 'iPhone 15 rat dep, Dynamic Island hay, camera tot. Chi tiec gia kha cao.', DATE '2025-03-04');
-- R8 : ND=7  SP=5  DH=7  (Xiaomi 14)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (7, 5, 7, 5, 'Xiaomi 14 camera Leica dep khong ke, chip Snapdragon 8 Gen 3 manh, dang tien mua.', DATE '2025-03-12');
-- R9 : ND=8  SP=4  DH=8  (Samsung A55)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (8, 4, 8, 4, 'Samsung A55 tot, man hinh dep, cau hinh on cho tam gia. Giao hang nhanh.', DATE '2025-03-19');
-- R10: ND=1  SP=2  DH=9  (iPhone 15)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (1, 2, 9, 4, 'iPhone 15 Den dep, pin kha, USB-C tien loi hon Lightning. Mua kem iPhone 14 lam qua.', DATE '2025-03-27');
-- R11: ND=2  SP=5  DH=10 (Xiaomi 14)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (2, 5, 10, 5, 'Xiaomi 14 Trang mau sac tuoi mat, chip nhanh, camera Leica an tuong. Gia khuyen mai rat tot.', DATE '2025-04-22');
-- R12: ND=9  SP=10 DH=11 (Nokia G42)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (9, 10, 11, 3, 'Nokia G42 dung duoc, pin trau nhung camera binh thuong. Phu hop nguoi dung it tien.', DATE '2025-04-28');
-- R13: ND=10 SP=6  DH=12 (OPPO Find X7)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (10, 6, 12, 4, 'OPPO Find X7 dep, camera Hasselblad sac net, sac nhanh 100W an tuong. Rat hai long.', DATE '2025-05-02');
-- R14: ND=3  SP=3  DH=13 (Samsung S24 Ultra 512GB)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (3, 3, 13, 5, 'S24 Ultra 512GB bo nho lon, chup anh nhu may anh chuyen nghiep. Dang dong tien.', DATE '2025-05-15');
-- R15: ND=11 SP=11 DH=14 (Realme 12 Pro+)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (11, 11, 14, 4, 'Realme 12 Pro+ camera tele zoom 50MP front an tuong, man hinh dep, hieu nang on.', DATE '2025-05-27');
-- R16: ND=12 SP=1  DH=15 (iPhone 15 Pro Max)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (12, 1, 15, 5, 'iPhone 15 Pro Max Titan Den sang trong, chip A17 Pro qua khoet, camera dinh nhat!', DATE '2025-06-17');
-- R17: ND=4  SP=8  DH=16 (Samsung Tab S9)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (4, 8, 16, 4, 'Galaxy Tab S9 man hinh AMOLED dep, dung hoc truc tuyen rat thich. But S Pen tien loi.', DATE '2025-06-29');
-- R18: ND=5  SP=9  DH=17 (iPhone 14)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (5, 9, 17, 3, 'iPhone 14 con dung tot nhung gia kha cao, nen mua iPhone 15 cho hon.', DATE '2025-07-12');
-- R19: ND=13 SP=5  DH=18 (Xiaomi 14 512GB)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (13, 5, 18, 5, 'Xiaomi 14 512GB dung luong lon, chip manh, camera Leica chup sieu dep. Rat ung y!', DATE '2025-07-25');
-- R20: ND=13 SP=7  DH=18 (Vivo V30)
INSERT INTO DANH_GIA (MA_ND, MA_SP, MA_DH, SO_SAO, BINH_LUAN, NGAY_DANH_GIA)
    VALUES (13, 7, 18, 4, 'Vivo V30 mong nhe, man hinh dep, selfie AI chup sang dep. Kem Xiaomi rat xung.', DATE '2025-07-25');

COMMIT;
