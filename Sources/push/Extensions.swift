import APNSwift
import ArgumentParser

extension APNSwiftConnection.PushType: ExpressibleByArgument {}

extension APNSwiftConnection.PushType: EnumerableFlag {
    public static var allCases: [APNSwiftConnection.PushType] {
        return [.alert, .background, .fileprovider, .mdm, .voip]
    }
}

extension APNSwiftConfiguration.Environment: ExpressibleByArgument {
    public init?(argument: String) {
        switch argument {
        case "production":
            self = .production
        default:
            self = .sandbox
        }
    }
}

extension APNSwiftConfiguration.Environment: EnumerableFlag {
    public static var allCases: [APNSwiftConfiguration.Environment] {
        return [.sandbox, .production]
    }
}
