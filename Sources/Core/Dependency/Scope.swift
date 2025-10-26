//
//  Scope.swift
//  Core
//
//  Created by Piotrek Jeremicz on 24.10.2025.
//

///
/// Singleton
/// trwa przez cały czas życia kontenera, globalny cache, np. NetworkClient, UserSession
///
/// Graph
/// trwa przez jedno „drzewo” rozwiązywania zależności, tymczasowy cache (per resolve chain),
/// np. ViewModel, który współdzieli zależności z innymi obiektami w tym samym kontekście
///
/// Transient
/// nowa instancja przy każdym resolve(), brak cache, np. obiekty lekkie lub stateless jak Formatter
///
/// UseCase / Repository - graph
/// Formatter, Mapper, Validator - transient
/// NetworkingAssembly / HttpClient - singleton
/// AuthStateManager, AppSettings, SessionStore - singleton

public enum Scope {
    case graph
    case singleton
    case transient
}

