#!/bin/bash
set -e

echo "=== 1. Cập nhật hệ thống và cài đặt Nginx ==="
sudo apt update
sudo apt install -y nginx

echo "=== 2. Tạo thư mục chứa web và phân quyền ==="
sudo mkdir -p /var/www/ptit-web/html
sudo chown -R $USER:$USER /var/www/ptit-web/html
sudo chmod -R 755 /var/www/ptit-web

echo "=== 3. Tạo file index.html ==="
cat << 'EOF' | sudo tee /var/www/ptit-web/html/index.html > /dev/null
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PTIT DevOps Course - Session 02</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #f8fafc;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.05);
            padding: 3rem 4rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }
        h1 {
            font-size: 2.2rem;
            color: #38bdf8;
            margin-bottom: 1rem;
        }
        p {
            font-size: 1.1rem;
            color: #94a3b8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to PTIT DevOps Course - Session 02</h1>
        <p>Basic Nginx Web Server successfully configured!</p>
    </div>
</body>
</html>
EOF

echo "=== 4. Tạo file cấu hình Server Block ==="
cat << 'EOF' | sudo tee /etc/nginx/sites-available/ptit-web.conf > /dev/null
server {
    listen 80;
    listen [::]:80;

    server_name _;

    root /var/www/ptit-web/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

echo "=== 5. Kích hoạt Server Block và hủy trang mặc định ==="
sudo ln -sf /etc/nginx/sites-available/ptit-web.conf /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

echo "=== 6. Kiểm tra cú pháp Nginx ==="
sudo nginx -t

echo "=== 7. Reload lại Nginx ==="
sudo systemctl reload nginx

echo "=== HOÀN THÀNH SETUP NGINX! ==="
