package app.repositories


enum RepositoryError:
    case DatabaseError(message: String)
    case ValidationError(message: String)