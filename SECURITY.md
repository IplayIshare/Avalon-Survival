# Báo lỗi bảo mật

Gửi báo cáo qua [Private vulnerability reporting](https://github.com/IplayIshare/albion-players/security/advisories/new). Mô tả phiên bản, ảnh hưởng và các bước tái hiện tối thiểu. Không đăng mật khẩu, token, dữ liệu tài khoản hay chi tiết khai thác trong issue công khai.

Repo này chỉ phát hành công cụ kết nối cho người chơi. Không đưa mã server, dữ liệu người chơi, file sao lưu, thông tin quản trị hoặc khóa truy cập vào commit, issue hay release.

Tải bộ kết nối từ repository này. Bộ cài Windows tải client từ CDN chính thức và kiểm tra SHA-256 trước khi giải nén. Link Android tải trực tiếp APK client từ CDN chính thức; trình duyệt không tự đối chiếu SHA-256 với thông tin trong repo. Bộ mở game Android kiểm tra chữ ký nhà phát hành cùng tên/mã phiên bản của client đã cài trước mỗi lần mở. Nếu kiểm tra thất bại, ứng dụng dừng. SHA-256 của file giúp đối chiếu nội dung; nó không bảo đảm phần mềm không có lỗ hổng.

Bản được kiểm thử với VPS: bộ kết nối Windows 1.0.0, client 1.32.030.345319. Bản `v1.1.0-android-preview.1` bổ sung bộ mở game Android 0.1.0 cho client 1.32.031.345742; đăng nhập và vào bản đồ trên VPS bằng Android vẫn chưa được kiểm chứng. Xem [kết quả kiểm thử](android/TESTING.md).

Bộ mở game Android không yêu cầu quyền mạng, tệp hoặc quản trị thiết bị; không nhận mật khẩu và không chấp nhận địa chỉ server từ ứng dụng khác. Khóa ký và mật khẩu ký APK được lưu riêng ngoài repo. Chỉ APK do dự án tự viết được phát hành trên GitHub; client chính thức không bị sửa hoặc ký lại.
