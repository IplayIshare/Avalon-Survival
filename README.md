# Albion — tải client và kết nối server

**[Tải bộ kết nối Windows](https://github.com/IplayIshare/albion-players/releases/latest/download/Albion-Players.zip)** · **[Tải bộ mở game Android (thử nghiệm)](https://github.com/IplayIshare/albion-players/releases/download/v1.1.0-android-preview.1/Albion-VPS-Android.apk)** · [Hướng dẫn Android và tải client](android/README.md) · [Báo lỗi](https://github.com/IplayIshare/albion-players/issues)

**Android: đã có APK mở game với địa chỉ VPS đặt sẵn. Đây là bản thử nghiệm; chưa xác nhận đăng nhập và vào bản đồ trên Android.**

Server cộng đồng thử nghiệm, mở đăng ký trực tiếp trong game. Đây là dự án độc lập, không phải dịch vụ chính thức của Albion Online hay Sandbox Interactive.

| Thông tin | Giá trị |
| --- | --- |
| Địa chỉ game | `157.10.201.13:5055` |
| Windows đã kiểm thử với VPS | `1.32.030.345319` |
| Android thử nghiệm | Bộ mở game `0.1.0` + client `1.32.031.345742`; kết nối VPS chưa được kiểm chứng |
| Đăng ký trên VPS | **Create account** sau khi mở game bằng bộ kết nối Windows |
| Phí sử dụng bộ kết nối | Miễn phí |

## Tải trên Android

Trên điện thoại, cài **[client Android chính thức](https://live.albiononline.com/clients/Albion-Online.apk)** và **[bộ mở game Albion VPS](https://github.com/IplayIshare/albion-players/releases/download/v1.1.0-android-preview.1/Albion-VPS-Android.apk)**. Sau đó mở ứng dụng **Albion VPS**, bấm **Mở game với địa chỉ VPS**. Bộ mở game kiểm tra chữ ký và phiên bản client trước khi truyền địa chỉ server. Nếu Albion đang chạy, buộc dừng game trong cài đặt ứng dụng trước khi thử.

Xem **[hướng dẫn Android](android/README.md)** và **[kết quả kiểm thử](android/TESTING.md)** trước khi dùng. Client khoảng **211 MB**, có thể tải thêm dữ liệu. Người dùng Android không cần tải gói ZIP Windows hay chạy file `.cmd`.

## Bắt đầu chơi trên Windows

1. Tải **Albion-Players.zip** ở liên kết phía trên và giải nén vào một thư mục riêng, ví dụ `D:\Albion-Players`. Không chạy file ngay bên trong ZIP.
2. Chạy **1-Tai-client.cmd**. Công cụ tải khoảng **3,14 GB** từ CDN chính thức của Albion, kiểm tra SHA-256 và phiên bản rồi giải nén. Cần khoảng **12 GB trống** trong lúc cài đặt. Bộ kết nối không yêu cầu quyền quản trị Windows.
3. Chạy **2-Mo-game.cmd** để vào server.
4. Chọn **Create account**, nhập email đúng định dạng và một mật khẩu riêng cho server này, từ 8–72 ký tự ASCII. Sau đó đăng nhập và tạo nhân vật.

**Không cần xác nhận email.** Client có thể báo đã gửi email, nhưng server thử nghiệm kích hoạt tài khoản ngay và không gửi thư. Tài khoản ở đây độc lập với tài khoản Albion chính thức; không dùng lại mật khẩu của email hay tài khoản khác.

### Nếu đã có đúng client

Chép các file game vào thư mục `client` theo cấu trúc sau, rồi chạy **2-Mo-game.cmd**:

```text
Albion-Players/
  1-Tai-client.cmd
  2-Mo-game.cmd
  Install-Client.ps1
  client-manifest.json
  client/
    Albion-Online_BE.exe
    Albion-Online.exe
    version.txt
    Albion-Online_Data/
    ... các file còn lại của client ...
```

Dòng đầu của `client/version.txt` phải là `albiononline-win32-full-1.32.030.345319`. Giữ một bản client riêng cho server này; cập nhật bằng launcher chính thức có thể làm phiên bản không còn tương thích.

## Nguồn tải và kiểm tra

Client Windows được tải trực tiếp từ [CDN chính thức](https://live.albiononline.com/clients/albion-online-fullgame-win32.zip), không lưu trong repository hay GitHub Release này. [Manifest chính thức](https://live.albiononline.com/autoupdate/manifest.xml) được kiểm tra ngày **02/11/2026**; địa chỉ CDN có thể thay nội dung khi nhà phát hành cập nhật. Thông tin file Android nằm trong [hướng dẫn riêng](android/README.md#thông-tin-file-đã-kiểm-tra).

Bộ cài chỉ chấp nhận archive đã kiểm tra với server:

```text
Phiên bản: 1.32.030.345319
Dung lượng: 3143941770 byte
SHA-256: f646ee4ead147b40a1e86cf6ef92e20e9e95044af7860d6a67a86fff366bec27
```

Nếu CDN đổi sang bản mới, bộ cài sẽ **dừng**, không chạy một phiên bản khác. Kiểm tra mục Releases hoặc báo lỗi để nhận hướng dẫn cập nhật; không bỏ qua kiểm tra SHA-256.

Nếu đã có file ZIP đúng phiên bản, có thể kiểm tra trước mà không tải hay cài:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-Client.ps1 -ArchivePath "D:\Downloads\albion-client.zip" -CheckOnly
```

Bỏ `-CheckOnly` để cài từ file ZIP đó. `ExecutionPolicy Bypass` chỉ áp dụng cho tiến trình chạy script này, không thay chính sách của máy.

## Khi gặp lỗi

| Hiện tượng | Cách xử lý |
| --- | --- |
| Chưa có client | Chạy `1-Tai-client.cmd`, hoặc kiểm tra cấu trúc thư mục ở trên. |
| Sai phiên bản / SHA-256 | Dừng cài đặt và kiểm tra bản phát hành tương thích. Không dùng file tải từ nguồn lạ. |
| Không kết nối được | Mở game bằng `2-Mo-game.cmd`; kiểm tra mạng có cho UDP 5055–5057 đi ra. |
| Sai tài khoản hoặc mật khẩu | Dùng tài khoản đã đăng ký tại server này. Nhập sai 5 lần có thể bị khóa tạm 15 phút. |
| Không có email xác nhận | Không cần email xác nhận; thử đăng nhập ngay sau khi đăng ký. |
| Game bị Windows chặn hoặc báo lỗi bảo vệ | Ghi lại thông báo để báo lỗi; không tắt phần mềm bảo vệ máy theo hướng dẫn không rõ nguồn. |

Khi [báo lỗi](https://github.com/IplayIshare/albion-players/issues), ghi hệ điều hành, tên thiết bị, phiên bản client, thời điểm và các bước gây lỗi. Che email, mật khẩu và thông tin cá nhân trong ảnh chụp hoặc log.

## Phạm vi của repository

Repository chỉ chứa bộ cài, file kết nối và hướng dẫn cho người chơi. Nó không chứa mã server, cơ sở dữ liệu, tài khoản quản trị hoặc khóa SSH. Bộ kết nối không thu thập mật khẩu; người chơi nhập thông tin trực tiếp trong game. Server nhận thông tin đăng ký/đăng nhập và địa chỉ IP cần thiết để cung cấp trò chơi.

Đây vẫn là server thử nghiệm; tính năng và khả năng phục vụ đông người có thể còn hạn chế. Lỗ hổng bảo mật cần được [báo riêng](https://github.com/IplayIshare/albion-players/security/advisories/new), không đăng chi tiết khai thác hay bí mật trong issue công khai.

Các script và hướng dẫn trong repo theo giấy phép MIT. Client Albion Online thuộc nhà phát hành và không nằm trong giấy phép này.
