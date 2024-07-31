package api.common

import api.services.PlaidService.PlaidError

enum AppError:
    case DatabaseError(message: String)
    case ValidationError(message: String)
    case ServiceError(error: PlaidError)
    case NetworkError(message: String)
