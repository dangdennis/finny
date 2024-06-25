package app.utils

enum AppError:
  case DatabaseError(message: String)
  case ValidationError(message: String)