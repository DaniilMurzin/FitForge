import Foundation

enum Endpoints {
    case searchByType(type: String)
    case searchByDifficulty(difficulty: String)
    case searchByMuscle(muscle: String)
    case custom
    
    var path: String {
        switch self {
        case .searchByType:
            return "/v1/exercises?type"
        case .searchByDifficulty:
            return "/v1/exercises?difficulty"
        case .searchByMuscle:
            return "/v1/exercises?muscle"
        case .custom:
            return "/v1/exercises"
        }
    }
}

