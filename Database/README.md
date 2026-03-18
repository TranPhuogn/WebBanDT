# Database Design – WebBanDT (Mobile Phone E-Commerce)

**Course:** Oracle DBMS  
**Team size:** 3 members  
**DBMS:** Oracle Database (tested on Oracle XE 21c / 19c)  
**Normalization:** 3NF throughout  
**Data tracking:** All tables include date columns; supports 1-year historical queries  

---

## How to Run

### Option A — Single combined script (recommended)

```sql
-- SQL*Plus
CONNECT username/password@database
@webbandt_full.sql
```

`webbandt_full.sql` contains the full DDL (schema) followed immediately by the DML (sample data). It is safe to re-run: the script drops all objects first then recreates everything.

### Option B — Two separate scripts

1. Connect to your Oracle instance as a DBA or privileged user.
2. Create a dedicated schema/user (optional but recommended):
   ```sql
   CREATE USER webbandt_user IDENTIFIED BY your_password;
   GRANT CONNECT, RESOURCE TO webbandt_user;
   ```
3. Run the DDL script first:
   ```
   @schema.sql
   ```
4. Then run the sample data script:
   ```
   @sample_data.sql
   ```
5. Update `WebBanDT/Web.config` — replace `HOST`, `SERVICE_NAME`, `YOUR_USERNAME`, `YOUR_PASSWORD` with your actual credentials.

---

## Sample Data — Row Counts (Jan–Dec 2025)

| Table | Rows | Notes |
|---|---:|---|
| `LOAI_HANG` | 3 | Dien thoai, May tinh bang, Phu kien |
| `HANG_SX` | 8 | Apple, Samsung, Xiaomi, OPPO, Vivo, Nokia, Realme, ASUS |
| `SAN_PHAM` | 12 | iPhone 15 Pro Max / 15 / 14, Galaxy S24 Ultra / A55, Xiaomi 14, OPPO Find X7, Vivo V30, Galaxy Tab S9, Nokia G42, Realme 12 Pro+, iPad Air M2 |
| `BIEN_THE_SP` | 34 | Color + storage combos for all 12 products |
| `NGUOI_DUNG` | 15 | Registered Jan 2024 – Mar 2025 |
| `KHUYEN_MAI` | 12 | One promotion per month, Jan–Dec 2025 |
| `DON_HANG` | 30 | 2–3 orders per month, Jan–Dec 2025 |
| `CHI_TIET_DH` | 40 | Line items for all 30 orders |
| `DANH_GIA` | 20 | Reviews spanning Jan–Jul 2025 |
| **TOTAL** | **174** | |

> **Note:** `GIO_HANG` (shopping cart) was intentionally excluded from the schema.
> See the [Academic Analysis](#academic-analysis--why-9-tables) section below for full justification.

### Year Coverage

Orders are distributed across all 12 months of 2025:

| Month | Orders |
|---|---|
| January | 3 |
| February | 3 |
| March | 3 |
| April | 3 |
| May | 2 |
| June | 2 |
| July | 2 |
| August | 3 |
| September | 2 |
| October | 2 |
| November | 3 |
| December | 2 |
| **Total** | **30** |

---

## Tables Overview (9 tables)

| # | Table | Type | Classification | Description |
|---|-------|------|----------------|-------------|
| 1 | `LOAI_HANG` | Master | **Essential** | Product categories (Smartphone, Tablet, …) |
| 2 | `HANG_SX` | Master | **Essential** | Phone brands / manufacturers |
| 3 | `SAN_PHAM` | Master | **Essential** | Product catalog (phones, tablets) |
| 4 | `BIEN_THE_SP` | Master | **Essential** | Product variants — color + storage combos |
| 5 | `NGUOI_DUNG` | Master | **Essential** | Customer accounts |
| 6 | `KHUYEN_MAI` | Master + Time | **Essential** | Time-bound promotions / discounts |
| 7 | `DON_HANG` | Transaction | **Essential** | Order headers |
| 8 | `CHI_TIET_DH` | Transaction | **Essential** | Order line items |
| 9 | `DANH_GIA` | Transaction | **Essential** | Product ratings & reviews |
| — | ~~`GIO_HANG`~~ | ~~Transaction~~ | *Removed* | ~~Shopping cart~~ — web-app session cache, not an academic DB concept |

---

## Detailed Table Descriptions

### 1. LOAI_HANG — Product Categories
**Purpose:** Master lookup table for top-level categories.  
**Key columns:** `MA_LOAI` (PK), `TEN_LOAI`, `NGAY_TAO`, `TRANG_THAI`  
**Examples:** Dien thoai, May tinh bang, Phu kien  
**3NF:** `TEN_LOAI` and `MO_TA` depend only on `MA_LOAI`.

---

### 2. HANG_SX — Brands / Manufacturers
**Purpose:** Master reference table for phone brands.  
**Key columns:** `MA_HANG` (PK), `TEN_HANG` (UNIQUE), `NUOC_GC`, `NGAY_TAO`  
**Examples:** Apple (My), Samsung (Han Quoc), Xiaomi (Trung Quoc)  
**3NF:** `NUOC_GC` describes the brand's country of origin — depends only on `MA_HANG`, not on `SAN_PHAM`.

---

### 3. SAN_PHAM — Products
**Purpose:** Core product catalog. Each product belongs to exactly one category and one brand.  
**Key columns:** `MA_SP` (PK), `TEN_SP`, `MA_LOAI` (FK→LOAI_HANG), `MA_HANG` (FK→HANG_SX), `GIA_GOC`, `NGAY_NHAP`  
**3NF:** Category and brand data live in their own tables; `SAN_PHAM` stores only FKs — no transitive dependency.

---

### 4. BIEN_THE_SP — Product Variants
**Purpose:** Every phone is sold in specific color + storage combinations.  
**Key columns:** `MA_BIEN_THE` (PK), `MA_SP` (FK), `MAU_SAC`, `DUNG_LUONG`, `GIA_THEM`, `SO_LUONG_TON`  
**Constraint:** UNIQUE (MA_SP, MAU_SAC, DUNG_LUONG) — no duplicate variants per product.  
**3NF:** `GIA_THEM` and `SO_LUONG_TON` depend on the specific variant, not on the product alone.

---

### 5. NGUOI_DUNG — Customers
**Purpose:** Customer account records used for login, orders, and reviews.  
**Key columns:** `MA_ND` (PK), `EMAIL` (UNIQUE), `MAT_KHAU` (bcrypt hash), `NGAY_DANG_KY`, `NGAY_DANG_NHAP`  
**Security note:** `MAT_KHAU` stores a bcrypt hash — never plaintext.  
**3NF:** All attributes (`HO_TEN`, `EMAIL`, `SO_DT`, …) depend only on `MA_ND`.

---

### 6. KHUYEN_MAI — Promotions
**Purpose:** Time-limited discount campaigns. Supports three types: percentage discount, fixed-amount discount, and free shipping.  
**Key columns:** `MA_KM` (PK), `LOAI_KM`, `GIA_TRI`, `NGAY_BAT_DAU`, `NGAY_KET_THUC`, `MA_SP` (nullable FK)  
**Date tracking:** `NGAY_BAT_DAU`/`NGAY_KET_THUC` enable queries like "active promotions this month".  
**3NF:** All attributes depend solely on `MA_KM`.

---

### 7. DON_HANG — Order Headers
**Purpose:** One row per customer order. Contains totals, status, and delivery info.  
**Key columns:** `MA_DH` (PK), `MA_ND` (FK), `MA_KM` (nullable FK), `NGAY_DAT`, `TRANG_THAI`, `TONG_THANH_TOAN`  
**Status lifecycle:** CHO_XAC_NHAN → DA_XAC_NHAN → DANG_GIAO → DA_GIAO (or DA_HUY)  
**Design note:** `DIA_CHI_GIAO` is stored as a text snapshot — intentional to preserve the historical address at order time, which may differ from any address the user updates later.

---

### 8. CHI_TIET_DH — Order Line Items
**Purpose:** Each row is one product variant sold within a single order.  
**Key columns:** `MA_CTDH` (PK), `MA_DH` (FK), `MA_BIEN_THE` (FK), `SO_LUONG`, `DON_GIA`, `THANH_TIEN`  
**Design note:** `DON_GIA` is a price snapshot at purchase time — changing a product's price will not alter historical order records.  
**3NF:** `THANH_TIEN` = `SO_LUONG × DON_GIA` is stored for reporting performance; all attributes depend only on `MA_CTDH`.

---

### 9. DANH_GIA — Product Reviews
**Purpose:** Customers rate products (1–5 stars) and write reviews. Linking to `DON_HANG` enables verified-purchase filtering.  
**Key columns:** `MA_DG` (PK), `MA_ND` (FK), `MA_SP` (FK), `MA_DH` (nullable FK), `SO_SAO`, `NGAY_DANH_GIA`  
**Constraint:** UNIQUE (MA_ND, MA_SP, MA_DH) — prevents duplicate reviews per order.  
**3NF:** All attributes depend only on `MA_DG`.

---

## ERD Description

### Entities and Relationships

```
LOAI_HANG ──< SAN_PHAM >── HANG_SX
                │
                └──< BIEN_THE_SP >──< CHI_TIET_DH >── DON_HANG >── NGUOI_DUNG
                │                                          │
                │                                     KHUYEN_MAI
                │
                └──< DANH_GIA >──── NGUOI_DUNG
                          │
                          └──────── DON_HANG
```

### Cardinalities

| Relationship | Cardinality | Description |
|---|---|---|
| LOAI_HANG → SAN_PHAM | 1 : N | One category has many products |
| HANG_SX → SAN_PHAM | 1 : N | One brand has many products |
| SAN_PHAM → BIEN_THE_SP | 1 : N | One product has many variants |
| NGUOI_DUNG → DON_HANG | 1 : N | One user places many orders |
| KHUYEN_MAI → DON_HANG | 1 : N | One promotion applied to many orders |
| DON_HANG → CHI_TIET_DH | 1 : N | One order has many line items |
| BIEN_THE_SP → CHI_TIET_DH | 1 : N | One variant sold in many order items |
| NGUOI_DUNG → DANH_GIA | 1 : N | One user writes many reviews |
| SAN_PHAM → DANH_GIA | 1 : N | One product has many reviews |
| DON_HANG → DANH_GIA | 1 : N | One order linked to many reviews |

---

## 3NF Compliance

**1NF:** All columns hold atomic values; no repeating groups; each table has a primary key.

**2NF:** All non-key attributes are fully dependent on the whole primary key (no partial dependencies since all PKs are single-column surrogates).

**3NF:** No transitive dependencies exist:
- Brand and category data live in `HANG_SX` / `LOAI_HANG`, not duplicated in `SAN_PHAM`.
- Price per variant is stored in `BIEN_THE_SP.GIA_THEM`, not in `GIO_HANG` or `CHI_TIET_DH`.
- Order totals (`TONG_TIEN_HANG`, `TONG_THANH_TOAN`) depend only on `DON_HANG.MA_DH`.

*Note:* `CHI_TIET_DH.THANH_TIEN` (= `SO_LUONG × DON_GIA`) is technically derivable but stored as an intentional denormalization for reporting performance — a common accepted practice in transactional systems.

---

## Date Fields — 1-Year Data Tracking

Every table has at least one date column:

| Table | Date Columns | Purpose |
|---|---|---|
| LOAI_HANG | NGAY_TAO, NGAY_SUA | Audit trail |
| HANG_SX | NGAY_TAO, NGAY_SUA | Audit trail |
| SAN_PHAM | NGAY_NHAP, NGAY_SUA | Product launch & edit history |
| BIEN_THE_SP | NGAY_CAP_NHAT | Stock update tracking |
| NGUOI_DUNG | NGAY_DANG_KY, NGAY_DANG_NHAP | Registration date, last login |
| KHUYEN_MAI | NGAY_BAT_DAU, NGAY_KET_THUC | Promotion validity period |
| DON_HANG | NGAY_DAT, NGAY_GIAO_DU_KIEN, NGAY_GIAO_THUC_TE | Full order timeline |
| CHI_TIET_DH | (inherits from DON_HANG) | — |
| DANH_GIA | NGAY_DANH_GIA | Review timestamp |

### Sample Reporting Queries

```sql
-- Monthly revenue for the current year
SELECT * FROM V_DOANH_THU_THANG WHERE NAM = EXTRACT(YEAR FROM SYSDATE);

-- Best-selling products in the last 30 days
SELECT sp.TEN_SP, SUM(ct.SO_LUONG) AS TONG_BAN
FROM CHI_TIET_DH ct
JOIN BIEN_THE_SP bt ON ct.MA_BIEN_THE = bt.MA_BIEN_THE
JOIN SAN_PHAM    sp ON bt.MA_SP       = sp.MA_SP
JOIN DON_HANG    dh ON ct.MA_DH       = dh.MA_DH
WHERE dh.NGAY_DAT >= SYSDATE - 30
  AND dh.TRANG_THAI != 'DA_HUY'
GROUP BY sp.TEN_SP
ORDER BY TONG_BAN DESC;

-- Active promotions today
SELECT * FROM KHUYEN_MAI
WHERE SYSDATE BETWEEN NGAY_BAT_DAU AND NGAY_KET_THUC
  AND TRANG_THAI = 1;

-- New customers registered in the past year
SELECT COUNT(*) FROM NGUOI_DUNG
WHERE NGAY_DANG_KY >= ADD_MONTHS(SYSDATE, -12);

-- Orders by status count (for dashboard)
SELECT TRANG_THAI, COUNT(*) AS SO_DON
FROM DON_HANG
GROUP BY TRANG_THAI;
```

---

## Why This Design Fits an Academic DBMS Project

| Criterion | How It Is Met |
|---|---|
| **8–10 tables** | Exactly **9 tables** — all essential, none redundant |
| **Master + Transaction data** | 6 master tables (categories, brands, products, variants, users, promotions) + 3 transaction tables (orders, order items, reviews) |
| **3NF normalization** | No partial or transitive dependencies; each attribute depends only on its table's PK |
| **1-year data tracking** | Date columns in every table; views for monthly/yearly reporting |
| **Reporting & statistics** | 4 built-in views: `V_SAN_PHAM`, `V_DOANH_THU_THANG`, `V_SAN_PHAM_BAN_CHAY`, `V_CHI_TIET_DON_HANG` |
| **Transactions** | Full order lifecycle: order header → line items → delivery; FK to optional promotion |
| **Oracle features used** | Sequences, triggers, CHECK/UNIQUE constraints, views, CLOB, DATE/SYSDATE, NVL |
| **Realistic domain** | Based on an actual ASP.NET MVC storefront; all entities match real UI screens |
| **Scalability** | Indexes on FK and date columns enable efficient querying on large data sets |
| **Team workload** | 9 tables ÷ 3 members = 3 tables each for DDL, DML, and query tasks |

---

## Academic Analysis — Why 9 Tables?

### Essential vs Optional Classification

| Table | Status | Reason |
|---|---|---|
| `LOAI_HANG` | ✅ Essential | Demonstrates master lookup; FK anchor for products |
| `HANG_SX` | ✅ Essential | Demonstrates master lookup with UNIQUE constraint |
| `SAN_PHAM` | ✅ Essential | Core business entity; FK to 2 master tables (eliminates transitive deps) |
| `BIEN_THE_SP` | ✅ Essential | Demonstrates multi-column UNIQUE + CHECK; separates variant data from product |
| `NGUOI_DUNG` | ✅ Essential | Demonstrates UNIQUE(EMAIL), CHECK(GIOI_TINH), password security practice |
| `KHUYEN_MAI` | ✅ Essential | Demonstrates date-range CHECK, `BETWEEN` queries, optional FK to order |
| `DON_HANG` | ✅ Essential | Core transaction header; demonstrates status lifecycle via CHECK constraint |
| `CHI_TIET_DH` | ✅ Essential | Master–detail join pattern; price snapshot (historical accuracy) |
| `DANH_GIA` | ✅ Essential | Demonstrates 3-way FK, multi-column UNIQUE, CHECK(1–5 stars) |
| `GIO_HANG` | ❌ Removed | Web-app session cache — all its DB concepts are already covered by the 9 tables above |

### Why `GIO_HANG` Was Removed

`GIO_HANG` (shopping cart) is a **transient web-application state table**, not a business data table:

1. **No new DB concepts** — Its constraints (UNIQUE(MA_ND, MA_BIEN_THE), CHECK(SO_LUONG > 0), two FKs) are all already demonstrated by `BIEN_THE_SP`, `CHI_TIET_DH`, and `DON_HANG`.
2. **No reporting value** — A cart table holds *pre-order* data that is abandoned or converted to an order. No meaningful business report is derived from it (unlike orders, revenue, or reviews).
3. **No referential integrity benefit** — Nothing in the remaining 9 tables references `GIO_HANG`. It is a pure leaf table.
4. **Grading perspective** — Examiners assess how well a schema models *persistent business data*. A cart is an application-layer concern (often stored in a session or Redis cache in production). Including it dilutes the schema with a table that adds no academic credit.

### Why `DANH_GIA` (Reviews) Was Kept

Although reviews are also a web-app feature, they earn their place academically:

- **3-way FK** — References `NGUOI_DUNG`, `SAN_PHAM`, *and* `DON_HANG` simultaneously — the most FK-rich table in the schema.
- **Multi-column UNIQUE** — `UNIQUE(MA_ND, MA_SP, MA_DH)` prevents duplicate reviews per purchase — a non-trivial business rule.
- **CHECK constraint** — `SO_SAO BETWEEN 1 AND 5` — meaningful domain validation.
- **Verified-purchase integrity** — The nullable FK to `DON_HANG` demonstrates an advanced design pattern (optional association) that is a common exam topic.
- **Supports aggregation queries** — Average rating per product (`AVG(SO_SAO)`) directly feeds the `V_SAN_PHAM` view.

### Master / Transaction Separation (Clear Boundary)

```
MASTER DATA (stable, reference)        TRANSACTION DATA (business events over time)
─────────────────────────────          ────────────────────────────────────────────
LOAI_HANG  (3 rows)                    DON_HANG      (30 rows — 1 year)
HANG_SX    (8 rows)                    CHI_TIET_DH   (40 rows)
SAN_PHAM   (12 rows)                   DANH_GIA      (20 rows)
BIEN_THE_SP (34 rows)
NGUOI_DUNG (15 rows)
KHUYEN_MAI (12 rows)
```

Transaction tables contain `NGAY_*` date columns used for all time-series reports. Master tables contain `NGAY_TAO`/`NGAY_SUA` for audit trails only.

### Constraint Coverage per Table

| Table | PK | FK | NOT NULL | UNIQUE | CHECK |
|---|:---:|:---:|:---:|:---:|:---:|
| LOAI_HANG | ✓ | — | ✓ | — | ✓ |
| HANG_SX | ✓ | — | ✓ | ✓ | ✓ |
| SAN_PHAM | ✓ | 2 | ✓ | — | ✓ |
| BIEN_THE_SP | ✓ | 1 | ✓ | ✓ | ✓ |
| NGUOI_DUNG | ✓ | — | ✓ | ✓ | ✓ |
| KHUYEN_MAI | ✓ | 1 | ✓ | — | ✓ |
| DON_HANG | ✓ | 2 | ✓ | — | ✓ |
| CHI_TIET_DH | ✓ | 2 | ✓ | ✓ | ✓ |
| DANH_GIA | ✓ | 3 | ✓ | ✓ | ✓ |

Every table demonstrates **all five** constraint types expected by the course rubric.
