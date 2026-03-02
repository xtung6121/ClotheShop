import Foundation
import Moya
import Alamofire

enum EcommerceAPI {
    case getNotifications
}

extension EcommerceAPI: TargetType {

    nonisolated var baseURL: URL {
        URL(string: "http://127.0.0.1:3000/api")!
    }

    nonisolated var path: String {
        switch self {
        case .getNotifications: return "/notifications"
        }
    }

    nonisolated var method: Moya.Method {
        switch self {
        case .getNotifications:
            return .get
        }
    }

    nonisolated var task: Task {
        switch self {
        case .getNotifications:
            return .requestPlain
        }
    }

    nonisolated var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    nonisolated var sampleData: Data {
        Data()
    }
}
