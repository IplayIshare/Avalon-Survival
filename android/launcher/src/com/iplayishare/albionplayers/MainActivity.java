package com.iplayishare.albionplayers;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import java.security.MessageDigest;

/** Opens the unmodified official client. No network or account access. */
public final class MainActivity extends Activity {
    private static final String CLIENT = "com.sandboxinteractive.albiononline";
    private static final String CLIENT_ACTIVITY = "com.albion.AlbionActivity";
    private static final String VERSION = "1.32.031.345742";
    private static final long VERSION_CODE = 345742L;
    private static final String CERT_SHA256 =
        "f119a66ba0030495633513d548ff3082aae880b434a4824789b9558e719c7742";
    private static final String SERVER = "157.10.201.13:5055";
    private TextView status;
    private Button launch;

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        int pad = (int) (24 * getResources().getDisplayMetrics().density);
        layout.setPadding(pad, pad, pad, pad);
        // Keep controls clear of system bars on Android 15 and later.
        scroll.setOnApplyWindowInsetsListener((view, insets) -> {
            layout.setPadding(pad + insets.getSystemWindowInsetLeft(),
                pad + insets.getSystemWindowInsetTop(), pad + insets.getSystemWindowInsetRight(),
                pad + insets.getSystemWindowInsetBottom());
            return insets;
        });
        scroll.addView(layout);
        text(layout, "Albion VPS", 28);
        text(layout, "Server cộng đồng: " + SERVER, 16);
        text(layout, "Bản thử nghiệm 0.1.0. Đã đặt sẵn địa chỉ VPS; khả năng đăng nhập và vào bản đồ trên Android đang được kiểm chứng.", 16);
        status = text(layout, "Đang kiểm tra client…", 16);
        launch = button(layout, "Mở game với địa chỉ VPS", view -> openGame());
        button(layout, "Tải client Android chính thức", view -> openUrl(
            "https://live.albiononline.com/clients/Albion-Online.apk"));
        button(layout, "Cài đặt ứng dụng Albion", view -> {
            try {
                startActivity(new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                    Uri.parse("package:" + CLIENT)));
            } catch (ActivityNotFoundException ex) { show("Không mở được cài đặt ứng dụng."); }
        });
        button(layout, "Hướng dẫn và trạng thái hỗ trợ", view -> openUrl(
            "https://github.com/IplayIshare/albion-players/blob/main/android/README.md"));
        text(layout, "Nếu Albion đang chạy, hãy vào Cài đặt ứng dụng Albion → Buộc dừng, rồi quay lại đây mở game. Không dùng tài khoản hay mật khẩu Albion chính thức trên server cộng đồng.", 15);
        text(layout, "Ứng dụng độc lập của IplayIshare. Không phải ứng dụng của Sandbox Interactive. Không thu thập mật khẩu; không yêu cầu quyền mạng, tệp hay quản trị thiết bị.", 14);
        setContentView(scroll);
    }

    @Override public void onResume() {
        super.onResume();
        String problem = clientProblem();
        status.setText(problem == null ? "Đúng phiên bản và chữ ký client: " + VERSION : problem);
        status.setTextColor(problem == null ? Color.rgb(20, 110, 60) : Color.rgb(160, 50, 20));
        launch.setEnabled(problem == null);
    }

    @SuppressWarnings("deprecation")
    private String clientProblem() {
        try {
            int flags = Build.VERSION.SDK_INT >= 28
                ? PackageManager.GET_SIGNING_CERTIFICATES : PackageManager.GET_SIGNATURES;
            PackageInfo info = getPackageManager().getPackageInfo(CLIENT, flags);
            Signature[] signers = Build.VERSION.SDK_INT >= 28
                ? (info.signingInfo == null ? null : info.signingInfo.getApkContentsSigners())
                : info.signatures;
            // Only the current signer is accepted; an unverified signer rotation fails closed.
            if (signers == null || signers.length != 1 || !CERT_SHA256.equals(sha256(signers[0].toByteArray()))) {
                return "Chữ ký client không khớp bản chính thức đã kiểm tra. Không mở game; kiểm tra lại nguồn cài.";
            }
            long code = Build.VERSION.SDK_INT >= 28 ? info.getLongVersionCode() : info.versionCode;
            if (code != VERSION_CODE || !VERSION.equals(info.versionName)) {
                return "Client hiện tại: " + info.versionName + ". Bộ kết nối này chỉ chấp nhận " + VERSION
                    + ". Xem hướng dẫn cập nhật; không gỡ game nếu chưa giữ dữ liệu cần thiết.";
            }
            return null;
        } catch (PackageManager.NameNotFoundException ex) {
            return "Chưa cài client Albion chính thức. Tải và cài client trước, rồi quay lại đây.";
        } catch (Exception ex) {
            return "Không xác minh được client. Bộ kết nối đã dừng để tránh mở nhầm ứng dụng.";
        }
    }

    private void openGame() {
        String problem = clientProblem();
        if (problem != null) { show(problem); return; }
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.setComponent(new ComponentName(CLIENT, CLIENT_ACTIVITY));
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        intent.putExtra("unity", "+server " + SERVER);
        try { startActivity(intent); }
        catch (ActivityNotFoundException | SecurityException ex) {
            show("Không mở được client. Kiểm tra phiên bản và xem hướng dẫn hỗ trợ.");
        }
    }

    private static String sha256(byte[] bytes) throws Exception {
        byte[] digest = MessageDigest.getInstance("SHA-256").digest(bytes);
        StringBuilder result = new StringBuilder(64);
        for (byte value : digest) result.append(String.format(java.util.Locale.ROOT, "%02x", value & 255));
        return result.toString();
    }

    private TextView text(LinearLayout layout, String value, int size) {
        TextView view = new TextView(this);
        view.setText(value);
        view.setTextSize(size);
        view.setPadding(0, 0, 0, 18);
        layout.addView(view);
        return view;
    }
    private Button button(LinearLayout layout, String label, View.OnClickListener action) {
        Button button = new Button(this);
        button.setText(label);
        button.setAllCaps(false);
        button.setOnClickListener(action);
        layout.addView(button);
        return button;
    }
    private void openUrl(String url) {
        try { startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url))); }
        catch (ActivityNotFoundException ex) { show("Máy chưa có trình duyệt để mở liên kết."); }
    }
    private void show(String message) {
        new AlertDialog.Builder(this).setMessage(message).setPositiveButton("Đóng", null).show();
    }
}
