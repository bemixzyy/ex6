CREATE DATABASE Ex6
GO

USE Ex6
GO

-- Tạo bảng
CREATE TABLE PhongBan(
    MaPB VARCHAR(7) PRIMARY KEY,
    TenPB NVARCHAR(50)
)
GO

CREATE TABLE NhanVien(
    MaNV VARCHAR(7) PRIMARY KEY,
    TenNV NVARCHAR(50) NOT NULL,
    NgaySinh DATETIME NOT NULL,
    SoCMND CHAR(13) NOT NULL,
    GioiTinh CHAR(1) NULL,
    DiaChi NVARCHAR(100) NULL,
    NgayVaoLam DATETIME,
    MaPB VARCHAR(7) CONSTRAINT fk FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB)
)
GO

CREATE TABLE LuongDA(
    MaDA VARCHAR(8) PRIMARY KEY,
    MaNV VARCHAR(7) CONSTRAINT fk FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    NgayNhan DATETIME,
    SoTien MONEY CHECK (SoTien>0)
)
GO

-- Chèn dữ liệu và hiển thị thông tin
SELECT * FROM PhongBan
INSERT INTO PhongBan (MaPB, TenPB) 
VALUES ('QL', N'Quản lí nhân sự'),
       ('GS', N'Giám sát'),
       ('TC', N'Tài chính'),
       ('KT', N'Kế Toán'),
       ('KO', N'Kho')
GO

SELECT * FROM NhanVien
INSERT INTO NhanVien
VALUES ('LTH', N'Lò Thu Hằng', '1999/07/16', '011199564', 'F', N'Điện Biên', '2022/12/1', 'QL'),
       ('KMT', N'Kiều Minh Thúy', '1998/09/17', '001198098', 'F', 'Hà Nội', '2018/06/01', 'GS'),
       ('NNP', N'Nguyễn Như Phương', '2002/07/27', '019302345', 'F', 'Thái Nguyên', '2023/01/01', 'TC'),
       ('VKO', N'Vàng Kim Oanh', '2003/11/07', '015302987', 'F', 'Yên Bái', '2022/11/11', 'KT'),
       ('NTM', N'Nguyễn Thảo My', '1998/12/19', '001199652', 'M', 'Hà Nội', '2018/12/01', 'KO')
GO

SELECT * FROM LuongDA
INSERT INTO LuongDA 
VALUES ('BornPink', 'LTH', '2023/07/29', 1800000),
       ('NTPMM', 'KMT', '2024/04/21', 9000000),
       ('Opera', 'NNP', '2024/04/08', 5000000),
       ('Act', 'VKO', '2024/06/21', 15000000),
       ('CD', 'NTM', '2023/12/31', 1200000)
GO

-- Hiển thị nv giới tính F
SELECT * FROM NhanVien WHERE GioiTinh = 'F'
GO

-- hiển thị tca các dự án, mỗi dự án trên 1 dòng
SELECT MaDA FROM LuongDA
GO

-- hiển thị tổng lương của từng nhân viên
SELECT MaNV, SUM(SoTien) AS TongLuong FROM LuongDA GROUP BY MaNV
GO

-- hiển thị các nhân viên trên 1 phòng ban cho trc
SELECT * FROM NhanVien WHERE MaPB = 'GS'
GO

-- hiển thị mức lương của nhân viên phòng tài chính
SELECT SoTien FROM LuongDA WHERE MaNV = 'NNP'
GO

-- hiển thị số lượng nhân viên của từng phòng
SELECT MaPB, COUNT(*) AS SoLuongNhanVien FROM NhanVien GROUP BY MaPB
GO

-- hiển thị nhân viên tham gia ít nhất 1 dự án
SELECT N.* FROM NHANVIEN N JOIN LuongDA LA ON N.MaNV = LA.MaNV
GO

-- hiển thị phòng ban có số lượng nhiều nhân viên nhất


-- Tính tổng các nhân viên phòng Quản lí
SELECT COUNT(*) AS TongSoNhanVien FROM NhanVien WHERE MaNV IN (SELECT MaNV FROM NhanVien WHERE MaPB = 'QL')
GO

-- Xóa dự án có mã dự án là NTPMM
DELETE FROM LuongDA WHERE MaDA = 'NTPMM'
GO

-- xóa đi từ bảng LuongDA những nhân viên có mức lương 5000000
DELETE FROM LuongDA WHERE SoTien = '5000000'
GO

-- Cập nhật lại lương cho những người tham gia dự án BornPink thêm 10% lương cũ
UPDATE LuongDA SET SoTien = SoTien * 1.1
WHERE MaNV IN (SELECT MaNV FROM LuongDA WHERE MaDA = 'BornPink')
GO

-- Xóa bản ghi tương ứng từ bảng NhanVien đối với những nhana viên không có mã nv tồn tại trong bảng LuongDA
DELETE FROM NhanVien WHERE MaNV NOT IN (SELECT MaNV FROM LuongDA)