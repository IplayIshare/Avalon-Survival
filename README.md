# Avalon Survival — PC / AZDIGI

**[Tải bộ kết nối Survival cho PC](https://github.com/IplayIshare/albion-players/releases/download/v2.0.0-survival/Albion-Survival-PC.zip)** · [Bản phát hành](https://github.com/IplayIshare/albion-players/releases/tag/v2.0.0-survival)

Server Survival đang thay bản cũ tại **157.10.201.13:5055** (AZDIGI). Bộ kết nối nhỏ, không chứa client gốc, tài khoản quản trị hay dữ liệu người chơi.

## Cài trên PC

Cần Windows và client **1.32.030.345319**. Ngày 11/11/2026, đường tải chính thức đã chuyển sang **1.32.040.346594**; bản mới đó **chưa được xác minh tương thích**. Bộ cài sẽ dừng trước khi tải sai phiên bản.

1. Tải **Albion-Survival-PC.zip** phía trên, giải nén ra thư mục riêng.
2. Nếu đã có client đúng phiên bản, chép cả thư mục game vào `client` (bên trong có `Albion-Online_BE.exe`, `GameAssembly.dll`, `version.txt` và `Albion-Online_Data`).
3. Nếu đã có ZIP gốc đúng phiên bản, đặt cạnh bộ cài, đặt tên `albion-client-official.zip`, rồi chạy **1-Tai-client.cmd**. Bộ cài kiểm tra SHA-256 trước khi giải nén. Cần khoảng 12 GB trống khi cài.
4. Chạy **2-Mo-game.cmd**. Lần đầu công cụ chuẩn bị dữ liệu Survival; những lần sau chỉ cập nhật khi danh mục skin thay đổi. Công cụ luôn giữ DLL gốc và mở qua BattlEye Launcher.
5. Nhập tên đăng nhập và mật khẩu riêng (8–72 ký tự ASCII). Đăng nhập lần đầu tự tạo tài khoản và một nhân vật, bỏ qua phần tạo nhân vật/tutorial. Chọn nhân vật và vào Brecilien. Tài khoản online độc lập với bản offline.

Có thể chỉ định ZIP ở nơi khác:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-Client.ps1 -ArchivePath "D:\Downloads\albion-client-official.zip"
```

ZIP gốc đã kiểm tra: **3.143.941.770 byte**, SHA-256:

```text
f646ee4ead147b40a1e86cf6ef92e20e9e95044af7860d6a67a86fff366bec27
```

Repo hiện **không cung cấp link tải client gốc đúng phiên bản**. Cần có ZIP hoặc thư mục client tương thích trước khi dùng bộ kết nối. Không dùng launcher chính thức để cập nhật đè lên bản riêng này.

## Luật Survival

- Mua đồ ở Brecilien, đi cổng Avalon để vào vòng chung **20 phút**. Vào muộn chỉ còn thời gian của vòng hiện tại.
- Mỗi nhóm bản đồ giữ tối đa **50 người**; đủ chỗ thì người mới sang nhóm khác. Một map chính và các map Avalon phụ nối với nhau.
- Đội **1–6 người**, vào cùng nhóm. Chết thì mua đồ, trở lại đúng nhóm đó trong thời gian còn lại. Chỗ của người đã vào được giữ trong vòng.
- Hết vòng, người tham gia được đưa về Brecilien; đồ còn nằm trong túi rơi mà không ai nhặt được thu hồi về chợ.
- Full fame chiến đấu, không dùng VIP. Chợ có hàng hữu hạn, sản xuất theo nhịp cố định và giá thay đổi theo cung/cầu.
- Siphoned Energy có trong chợ, giá tham chiếu 50.000 bạc; NPC cấp Siphon đã bỏ.
- Đổi bạc sang vàng trong cửa sổ đổi vàng: khởi điểm 1.000 bạc/vàng, tăng 100 sau mỗi 10 triệu bạc đã đổi toàn server. Không đổi vàng ngược sang bạc.
- **606 ngoại hình** có giá vàng; **115 ngoại hình mặc định** vẫn miễn phí. Các mức mặc định: mount 5.000, áo skin 2.500, phần skin khác 1.500, emote 1.000, loại khác 500 vàng. Món đã có giá gốc giữ giá gốc. Quản trị viên có thể thay giá hoặc ngừng bán.
- Số kill quyết định reputation/danh hiệu theo mốc 0 / 50 / 150 / 500 / 1.000. Bảng stats có vàng và kill, nhưng còn các dòng thống kê gốc do giữ DLL nguyên bản để client khởi động được.

Lệnh trong kênh Say:

```text
/s .survival
/s .gold 100
/s .goldbuy
/s .skins SWORD
/s .skinbuy 123 1500
```

`skinbuy` dùng **đúng mã và giá hiện ra từ .skins**, không dùng số ví dụ một cách máy móc. Server kiểm tra giá, số dư, quyền sở hữu và trạng thái đang bán. Giá thay đổi giữa chừng sẽ bị từ chối; mở lại game để làm mới cửa hàng gốc hoặc xem giá bằng `.skins`.

## Khắc phục sự cố

- **Kẹt 19% ở bản Survival cũ:** dùng bộ kết nối mới và client gốc; lỗi đóng gói dữ liệu đã được sửa. Bản mới lưu dữ liệu gốc trong `client/SurvivalOriginals`.
- **Failed to load il2cpp / BattlEye chặn GameAssembly.dll:** bản mới giữ DLL gốc; đóng game rồi mở bằng `2-Mo-game.cmd`. Không tắt phần mềm bảo vệ.
- **Không kết nối:** kiểm tra mạng cho UDP 5055–5057. TCP 18081 chỉ cung cấp danh mục skin, không nhận mật khẩu.
- **Sai phiên bản:** dừng cài đặt, dùng đúng ZIP/thư mục được kiểm tra ở trên.

## Android

**Chưa công bố Android chơi được Survival.** Theo kế hoạch hiện tại, hoàn tất PC trước. Bộ mở game Android cũ chỉ truyền địa chỉ VPS; chưa xác nhận đăng nhập và vào map trên điện thoại thật. Không dùng APK thử nghiệm như một bản Android hoàn chỉnh. [Kết quả kiểm tra cũ](android/TESTING.md).

## Dự án

Bộ kết nối và hướng dẫn theo MIT. Tài sản/client Albion Online thuộc nhà phát hành. Dự án server cộng đồng độc lập, không phải dịch vụ chính thức. Mã server và bản sao lưu cũ được quản lý ở các repo riêng; không chứa trong gói người chơi.
