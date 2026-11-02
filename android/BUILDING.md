# Biên dịch bộ mở game Android

Ứng dụng Java dùng Android framework, không có thư viện bên thứ ba và không cần Gradle. Bản phát hành dùng JDK 21, Android SDK Platform 35 và Build Tools 35.0.0. Tải các công cụ từ nhà cung cấp chính thức và kiểm tra checksum công bố.

Chạy trên Windows PowerShell, thay đường dẫn bằng SDK/JDK của bạn:

```powershell
.\android\Build-Launcher.ps1 `
  -JdkPath 'C:\Tools\jdk-21' `
  -BuildToolsPath 'C:\Android\Sdk\build-tools\35.0.0' `
  -AndroidJar 'C:\Android\Sdk\platforms\android-35\android.jar' `
  -KeyStorePath 'C:\Private\albion-player.jks' `
  -KeyPasswordFile 'C:\Private\signing-password.txt'
```

Tự tạo khóa ký của bạn bằng `keytool`, alias mặc định `albion-player`. Mật khẩu khóa và keystore phải giống nhau; file mật khẩu chứa một dòng. Giữ keystore và file mật khẩu ngoài repo, chỉ cho tài khoản cần thiết đọc. Không đưa mật khẩu trực tiếp vào lệnh, log, commit hoặc GitHub Release.

Kết quả mặc định: `dist/android-launcher/Albion-VPS-Android.apk` và `SHA256SUMS.txt`. Script dừng nếu biên dịch, ký hoặc xác minh chữ ký thất bại. Thư mục build dùng tên riêng cho mỗi lần chạy và được giữ để kiểm tra; `dist/` không được Git theo dõi.

Bản tự biên dịch có chữ ký riêng nên không thể cài cập nhật đè lên bản phát hành có chữ ký IplayIshare. Không thay chữ ký client Albion được ghim trong mã để chấp nhận một APK không xác minh được nguồn gốc.

Khi cập nhật client: kiểm tra APK từ CDN, chữ ký, phiên bản và khả năng kết nối VPS trước; sau đó cập nhật đồng bộ `MainActivity.java`, `client-manifest.json`, hướng dẫn và kết quả kiểm thử. Đọc [TESTING.md](TESTING.md) để phân biệt những gì đã kiểm chứng với phần chưa có bằng chứng.
