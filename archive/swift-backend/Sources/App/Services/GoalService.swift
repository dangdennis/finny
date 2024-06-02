import Fluent
import Vapor

struct GoalService {
    let db: Database

    func getGoals(userID: UUID) async throws -> [Goal] {
        return try await Goal.query(on: db)
            .filter(\.$user.$id == userID)
            .all()
    }

    func createGoal(
        userID: UUID,
        name: String,
        amount: Double,
        targetDate: Date
    ) async throws -> Goal {
        let goal = Goal(
            name: name,
            amount: amount,
            targetDate: targetDate,
            userID: userID
        )
        try await goal.save(on: db)
        return goal
    }

    func updateGoal(
        id: UUID,
        name: String?,
        amount: Double?,
        targetDate: Date?
    ) async throws -> Goal {
        guard let goal = try await Goal.find(id, on: db) else {
            throw Abort(.notFound)
        }

        if let name = name {
            goal.name = name
        }
        if let amount = amount {
            goal.amount = amount
        }
        if let targetDate = targetDate {
            goal.targetDate = targetDate
        }

        try await goal.save(on: db)

        return goal
    }

}
