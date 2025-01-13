//
//  CoreModule.swift
//  Core
//
//  Created by Piotrek Jeremicz on 25.09.2024.
//

public struct CoreModule: Module {
    public init() {}
    
    public func register(container: DependencyContainer, environment: AppEnvironment) {
        container.register(
            type: KeychainRepository.self,
            KeychainRepositoryImpl(environment: environment)
        )

        container.register(
            type: UserDefaultsRepository.self,
            UserDefaultsRepositoryImpl(environment: environment)
        )
        
        container.register(
            type: CoordinatorRegistrar.self,
            CoordinatorRegistrar()
        )
        
        container.register(
            type: DeeplinkNavigator.self,
            DeeplinkNavigator()
        )
    }
}
