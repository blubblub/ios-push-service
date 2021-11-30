import Foundation
import APNSwift
import JWTKit
import Logging
import NIO
import NIOHTTP2
import NIOSSL
import ArgumentParser

struct Push: ParsableCommand {
    
    @Flag(help: "Push type")
    var pushType: APNSwiftConnection.PushType = .alert
    
    @Flag(help: "Enable logging.")
    var verbose: Bool = false
    
    @Flag(help: "Environment")
    var environment: APNSwiftConfiguration.Environment = .sandbox
    
    @Option(name: .shortAndLong, help: "Device token")
    var token: String

    @Option(name: .shortAndLong, help: "Notification payload")
    var notification: Notification
    
    @Argument(help: "Path to the .p8 authentication key.")
    var authKey: String
    
    @Argument(help: "Topic.")
    var topic: String
    
    @Argument(help: "Key identifier.")
    var keyId: String
    
    @Argument(help: "Team identifier.")
    var teamIdentifier: String

    mutating func run() throws {
        
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var logger = Logger(label: "com.apn.swift")
        logger.logLevel = .debug
        let apnsConfig = try APNSwiftConfiguration(
            authenticationMethod: .jwt(
                key: .private(filePath: authKey),
                keyIdentifier: JWKIdentifier(string: keyId),
                teamIdentifier: teamIdentifier
            ),
            topic: topic,
            environment: environment,
            logger: verbose ? logger : nil
        )

        let apns = try APNSwiftConnection.connect(configuration: apnsConfig, on: group.next()).wait()
        
        do {            
            let expiry = Date().addingTimeInterval(5)
            try apns.send(notification,
                          pushType: pushType,
                          to: token,
                          expiration: expiry,
                          priority: 10).wait()
        } catch {
            if verbose {
                logger.debug(Logger.Message(stringLiteral: error.localizedDescription))
            }
        }

        try apns.close().wait()
        try group.syncShutdownGracefully()
    }
}

Push.main()
