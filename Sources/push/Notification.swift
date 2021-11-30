import Foundation
import APNSwift
import ArgumentParser

struct Notification: APNSwiftNotification, ExpressibleByArgument {
    init?(argument: String) {
        guard let data = argument.data(using: .utf8) else { return nil }
        
        do {
            let conversion = try JSONDecoder().decode(Notification.self, from: data)
            self = conversion
            return
        } catch {
            return nil
        }
    }
    
    let aps: APNSwiftPayload
    let custom: [String: AnyCodable]?

    init(aps: APNSwiftPayload, custom: [String: AnyCodable]? = nil) {
        self.aps = aps
        self.custom = custom
    }
}
