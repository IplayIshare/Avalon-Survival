# Kết quả kiểm thử Android — 02/11/2026

Phạm vi: bộ mở game **0.1.0**, client chính thức **1.32.031.345742**.

## Đã xác minh

- Tải APK client trực tiếp từ CDN chính thức; xác nhận dung lượng, SHA-256, mã ứng dụng và phiên bản. `apksigner verify` xác minh được chữ ký; chứng chỉ khớp giá trị được ghim trong bộ mở game.
- Kiểm tra đường khởi động Java của APK: `AlbionActivity` đi qua `UnityPlayerActivity`, đọc chuỗi extra `unity` và chuyển qua `updateUnityCommandLineArguments` trước khi tạo Unity Player.
- Build bộ mở game bằng JDK 21 và Android SDK 35; APK vượt qua `apksigner verify`, có chữ ký v2/v3. Manifest không yêu cầu quyền nào.
- Trên Android Emulator API 30: chưa cài Albion → hiện hướng dẫn và vô hiệu hóa nút mở game.
- Cài đúng APK chính thức → bộ mở game nhận đúng chữ ký/phiên bản, bật nút mở game. Bấm nút mở được `com.sandboxinteractive.albiononline/com.albion.AlbionActivity`; Android ghi nhận Intent có extras và client bắt đầu khởi tạo Unity.
- Thay client trên giả lập bằng ứng dụng kiểm thử tự viết có cùng mã ứng dụng và phiên bản nhưng chữ ký khác → bộ mở game báo chữ ký không khớp và khóa nút mở. Ứng dụng kiểm thử được gỡ sau khi kiểm tra và không phát hành.
- Đối chiếu dữ liệu game Android/Windows: 3277/3278 file GameData giống CRC và dung lượng; file khác là `spells.bin`. Bảy file dữ liệu cốt lõi được đối chiếu thêm SHA-256; sáu file giống hoàn toàn. Thay đổi XML trong spell liên quan thuộc tính `reflectdamage="never"`, server đã hỗ trợ. Kiểm thử nạp dữ liệu server với spell Android: 1 đạt, 0 lỗi, 3 bỏ qua do thiếu dữ liệu tham chiếu. **Đây không phải kiểm thử giao thức hoặc chơi game Android.**

## Giới hạn hiện tại

Môi trường giả lập Android 11 x86_64 có lớp dịch ARM64. Với đồ họa phần mềm, client dừng ở lỗi `Unable to initialize the Unity Engine Graphics API`. Khi dùng GPU của máy, client khởi tạo thêm được Unity/Wwise nhưng dừng với `SIGILL` ở `UnityMain`, trước màn hình đăng nhập. Mở trực tiếp client không truyền tham số VPS cũng gặp `SIGILL`. Chưa xác định nguyên nhân gốc của lỗi này.

Vì vậy, **chưa xác nhận** phần game sử dụng `+server` trên Android, bắt tay mạng với VPS, đăng ký/đăng nhập, tạo nhân vật hoặc vào bản đồ. Việc kiểm tra Java/Intent không chứng minh các bước đó. Chưa có kết quả trên điện thoại Android thật hoặc Android phiên bản khác.

Bản phát hành giữ nhãn **pre-release / thử nghiệm**. Cần chạy đúng cặp APK trên thiết bị Android hỗ trợ client và xác nhận lưu lượng đến VPS, rồi kiểm tra đăng ký → đăng nhập → tạo nhân vật → vào bản đồ trước khi công bố Android chơi được.
