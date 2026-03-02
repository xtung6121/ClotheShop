//
//  NotificationsModel.swift
//  TruyenFull
//
//  Created by macmimi on 1/3/26.
//

// MARK: - Models

public struct NotificationSection: Equatable, Codable {
    public static func == (lhs: NotificationSection, rhs: NotificationSection) -> Bool {
        lhs.sectionDate == rhs.sectionDate
    }
    
    public let sectionDate: String
    public let items: [NotificationItem]
}

public struct NotificationItem: Codable {
    public let id: String
    public let title: String
    public let description: String
    public let isRead: Bool
    public let iconType: String
}
