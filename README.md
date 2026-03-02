# 📱 ClothesShop iOS App

iOS application built with **UIKit + MVVM + RxSwift**.

---

## 🚀 Requirements

- macOS 13+
- Xcode 15+
- Swift 5.9+
- CocoaPods 1.12+

---

## 📦 Dependencies

Project sử dụng:

- RxSwift
- RxCocoa
- Moya
- SnapKit
- Kingfisher
- RxDataSources

---

## 🛠 Setup Project (CocoaPods)

### 1️⃣ Clone project

```bash
git clone https://github.com/your-username/ClothesShop.git
cd ClothesShop
```

---

### 2️⃣ Install CocoaPods (nếu chưa có)

```bash
sudo gem install cocoapods
```

Kiểm tra version:

```bash
pod --version
```

---

### 3️⃣ Install dependencies

```bash
pod install
```

Sau khi hoàn tất, mở:

```bash
open ClothesShop.xcworkspace
```

⚠️ **Luôn mở `.xcworkspace`, không mở `.xcodeproj`**

---

### 4️⃣ Clean build (nếu gặp lỗi)

Clean project:

```
Shift + Command + K
```

Hoặc xoá DerivedData:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

---

## 🔁 Khi Podfile thay đổi

Nếu bạn thêm library mới:

```bash
pod install
```

Nếu pod bị lỗi version:

```bash
pod repo update
pod install
```

Nếu muốn update tất cả pods:

```bash
pod update
```

---

## 🧹 Nếu gặp lỗi "Multiple commands produce Info.plist"

1. Vào **Target → Build Phases**
2. Xóa `Info.plist` khỏi **Copy Bundle Resources**
3. Clean project

---

## 📂 Project Structure

```
ClothesShop
│
├── Core
├── Network
├── Modules
│   ├── Home
│   ├── Product
│   └── Notifications
├── Resources
└── Supporting Files
```

---

## 👨‍💻 Architecture

- MVVM
- Reactive Programming (RxSwift)
- Modular feature-based structure

---

## 🧪 Run Project

1. Select iPhone Simulator
2. Press `Command + R`

---

## 🛑 Common Issues

### ❌ Pods not found

```bash
pod deintegrate
pod install
```

---

### ❌ Build failed after pulling code

```bash
pod install
```

Sau đó clean build (`Shift + Command + K`)

---

## 📄 License

Internal project – not for public distribution.
