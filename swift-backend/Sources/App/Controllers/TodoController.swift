import Fluent
import Vapor

struct TodoController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let todos = routes.grouped("todos")

    todos.get(use: { try await self.index(req: $0) })
    todos.post(use: { try await self.create(req: $0) })
    todos.group(":todoID") { todo in
      todo.delete(use: { try await self.delete(req: $0) })
    }
  }

  func index(req: Request) async throws -> [TodoDb] {
    try await TodoDb.query(on: req.db).all()
  }

  func create(req: Request) async throws -> TodoDb {
    let todo = try req.content.decode(TodoDb.self)

    try await todo.save(on: req.db)
    return todo
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let todo = try await TodoDb.find(req.parameters.get("todoID"), on: req.db) else {
      throw Abort(.notFound)
    }

    try await todo.delete(on: req.db)
    return .noContent
  }
}
