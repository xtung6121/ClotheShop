📱 ClothesShop iOS App

iOS application built with UIKit + MVVM + RxSwift.

🚀 Requirements

macOS 13+

Xcode 15+

Swift 5.9+

CocoaPods 1.12+

📦 Dependencies

Project sử dụng:

RxSwift

RxCocoa

Moya

SnapKit

Kingfisher

RxDataSources

🛠 Setup Project (CocoaPods)
1️⃣ Clone project
git clone https://github.com/your-username/ClothesShop.git
cd ClothesShop
2️⃣ Install CocoaPods (nếu chưa có)
sudo gem install cocoapods

Kiểm tra version:

pod --version
3️⃣ Install dependencies

Chạy:

pod install

Sau khi hoàn tất, mở:

open ClothesShop.xcworkspace

⚠️ Luôn mở .xcworkspace, không mở .xcodeproj

4️⃣ Clean build (nếu gặp lỗi)

Clean project:

Shift + Command + K

Hoặc xoá DerivedData:

rm -rf ~/Library/Developer/Xcode/DerivedData
🔁 Khi Podfile thay đổi

Nếu bạn thêm library mới:

pod install

Nếu pod bị lỗi version:

pod repo update
pod install

Nếu muốn update tất cả pods:

pod update
🧹 Nếu gặp lỗi "Multiple commands produce Info.plist"

Vào Target → Build Phases

Xóa Info.plist khỏi Copy Bundle Resources

Clean project

📂 Project Structure
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
👨‍💻 Architecture

MVVM

Reactive Programming (RxSwift)

Modular feature-based structure

🧪 Run Project

Select iPhone Simulator

Press Command + R

🛑 Common Issues
❌ Pods not found
pod deintegrate
pod install
❌ Build failed after pulling code
pod install

Sau đó clean build (Shift + Command + K)

📄 License

Internal project – not for public distribution.
