package api.common

enum AppError:
    case DatabaseError(message: String)
    case ValidationError(message: String)
