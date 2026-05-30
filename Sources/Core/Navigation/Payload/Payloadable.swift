public protocol Payloadable: AnyObject, Sendable {
    associatedtype Payload: Core.Payload & Identifiable
    var payload: Payload? { get set }
}