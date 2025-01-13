//
//  NetworkingRepository.swift
//  Core
//
//  Created by Piotrek Jeremicz on 07.09.2024.
//

import Networking

public protocol NetworkingRepository: Repository {
    var session: Session { get }
    var service: Networking.Service { get }
    
    init(environment: AppEnvironment)
}
