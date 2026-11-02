# Android: mở Albion với địa chỉ VPS

**[Tải bộ mở game Albion VPS (APK)](https://github.com/IplayIshare/albion-players/releases/download/v1.1.0-android-preview.1/Albion-VPS-Android.apk)** · **[Tải client Albion chính thức](https://live.albiononline.com/clients/Albion-Online.apk)** · [Trang chính](../README.md)

**Bản thử nghiệm:** bộ mở game đã cấu hình `157.10.201.13:5055`, nhưng chưa xác nhận đăng nhập và vào bản đồ bằng client Android. Không coi APK này là bản Android đã chơi được đầy đủ. Xem [kết quả kiểm thử](TESTING.md).

## Cài và sử dụng

1. Tải **client Albion chính thức** từ liên kết phía trên, cài file `Albion-Online.apk` (khoảng 211 MB). Game có thể tải thêm dữ liệu.
2. Tải **bộ mở game Albion VPS**, cài file `Albion-VPS-Android.apk` từ GitHub Release của `IplayIshare/albion-players`.
3. Mở ứng dụng **Albion VPS**. Ứng dụng chỉ bật nút mở game khi chữ ký nhà phát hành và phiên bản client khớp bản đã kiểm tra.
4. Nếu Albion đang chạy, bấm **Cài đặt ứng dụng Albion → Buộc dừng**, rồi quay lại **Albion VPS**. Bước này giúp lần mở sau nhận cấu hình mới.
5. Bấm **Mở game với địa chỉ VPS**. Bộ mở game truyền sẵn địa chỉ server; không cần nhập IP hay sửa file trên điện thoại.

Nếu Android yêu cầu quyền cài APK từ trình duyệt hoặc trình quản lý tệp, chỉ cấp cho ứng dụng đang dùng và thu hồi sau khi cài. Không tắt Play Protect, root máy hoặc cấp quyền trợ năng/quản trị thiết bị cho bộ mở game này.

Client cần Android 7.1 trở lên theo manifest APK; cấu hình đồ họa, RAM và khả năng chơi trên từng máy chưa được kiểm chứng. APK chính thức dùng mã ứng dụng `com.sandboxinteractive.albiononline`, nên có thể cập nhật bản Albion đang cài trên máy. Không gỡ bản hiện có chỉ để hạ phiên bản nếu chưa giữ dữ liệu cần thiết.

**Tài khoản VPS và tài khoản Albion chính thức độc lập.** Dùng mật khẩu riêng cho server cộng đồng. Ứng dụng Albion VPS không có ô nhập tài khoản hay mật khẩu. Khi gặp màn hình đăng nhập mà chưa xác định được server đích, dừng lại và báo lỗi.

## Cấu hình và bảo mật

- Địa chỉ cố định: `157.10.201.13:5055`; người dùng hoặc ứng dụng khác không thể truyền địa chỉ tùy ý cho bộ mở game.
- Mở đúng activity `com.albion.AlbionActivity` của client chính thức và truyền `unity = +server 157.10.201.13:5055`.
- Kiểm tra chữ ký ký APK hiện tại và cả tên/mã phiên bản trước mỗi lần mở; sai thông tin sẽ dừng.
- Không sửa hoặc ký lại game. Bộ mở game có mã ứng dụng riêng `com.iplayishare.albionplayers`.
- Không yêu cầu quyền mạng, tệp, danh bạ, trợ năng hay quản trị thiết bị; không có quảng cáo hoặc phân tích hành vi. Game và trình duyệt được mở có quyền riêng của chúng.
- Mã nguồn bộ mở game công khai; khóa ký riêng không được đưa lên GitHub. Dấu vân tay chứng chỉ bộ mở game: `b96a715f1e26cb817a5d9cdba81cbad4f1c204f482f5dc5983197bff205af936`.

Việc Unity nhận tham số khởi động chưa chứng minh phần game dùng tham số đó để kết nối VPS. Nếu game bỏ qua tham số hoặc giao thức không tương thích, bộ mở game không thể tự khắc phục. Đây là phần cần thử tiếp trên thiết bị Android chạy được client.

## Thông tin file đã kiểm tra

Client được tải từ CDN chính thức và kiểm tra ngày **02/11/2026**:

| Thông tin | Giá trị |
| --- | --- |
| Phiên bản | `1.32.031.345742` |
| Version code | `345742` |
| Dung lượng APK | `211172778` byte |
| SHA-256 của file | `b530e9815728d753a0a1c34a13e38dcc790bf3e3cd66a0c5f017d8e92439ec40` |
| SHA-256 chứng chỉ ký client | `f119a66ba0030495633513d548ff3082aae880b434a4824789b9558e719c7742` |

CDN có thể đổi sang bản mới. Trình duyệt không tự đối chiếu SHA-256 với repo; bộ mở game kiểm tra **chữ ký và phiên bản của ứng dụng đã cài**, không tính SHA-256 toàn bộ file APK. Nếu client đổi phiên bản, nút mở game sẽ khóa cho đến khi có bản cập nhật đã kiểm tra. Không có tùy chọn bỏ qua kiểm tra.

File `SHA256SUMS.txt` trong [bản phát hành Android](https://github.com/IplayIshare/albion-players/releases/tag/v1.1.0-android-preview.1) dùng để đối chiếu **bộ mở game**, không phải APK client. Client thuộc nhà phát hành và chỉ được liên kết tới CDN chính thức; GitHub Release này không phát hành lại client.

Thông tin máy đọc: [client-manifest.json](client-manifest.json). Mã nguồn: [launcher](launcher). Cách biên dịch: [BUILDING.md](BUILDING.md).

## Báo lỗi

Gửi [issue](https://github.com/IplayIshare/albion-players/issues) với tên máy, phiên bản Android/client, nội dung lỗi và các bước đã làm. Che thông tin cá nhân; không gửi mật khẩu, token hoặc khóa truy cập. Lỗ hổng bảo mật gửi qua [báo cáo riêng](https://github.com/IplayIshare/albion-players/security/advisories/new).
