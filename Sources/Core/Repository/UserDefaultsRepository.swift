//
//  UserDefaultsRepository.swift
//  Core
//
//  Created by Jeremicz Piotr on 26/09/2024.
//

import Foundation

public protocol UserDefaultsRepository: Repository {
    var appGroup: UserDefaults? { get }
}

final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    let appGroup: UserDefaults?
    let environment: any AppEnvironment

    init(environment: any AppEnvironment) {
        self.environment = environment
        self.appGroup = UserDefaults(suiteName: "group." + environment.appBundleIdentifier)
    }
}

public extension UserDefaults {
#if DEBUG
    static let appGroup = UserDefaults(suiteName: "group." + Bundle.main.bundleIdentifier! + ".dev")
#else
    static let appGroup = UserDefaults(suiteName: "group." + Bundle.main.bundleIdentifier!)
#endif
}
