import Vapor

protocol DataContaining: Content {
  associatedtype DataType: Content
  var data: [DataType] { get set }
}
