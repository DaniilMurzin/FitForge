import UIKit

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func createURL(
    for endpoint: Endpoints,
    with query: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endpoint.path
     
        components.queryItems = makeParameters(for: endpoint, with: query).compactMap{
            
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
    
    private func makeParameters(for endpoint: Endpoints, with query: String?)
    -> [String:String] {
        
        var parameters = [String:String]()
        
        parameters["X-Api-Key"] = API.apiKey
        
        query?.components(separatedBy: " ").forEach { component in
            
            if ["cardio",
                "olympic_weightlifting",
                "plyometrics",
                "powerlifting",
                "strength",
                "stretching",
                "strongman"].contains(component) {
                
                parameters["type"] = component
                
            } else if ["beginner",
                       "intermediate",
                       "expert"].contains(component) {
                
                parameters["difficulty"] = component
                
            } else if ["abdominals",
                       "abductors",
                       "adductors",
                       "biceps",
                       "calves",
                       "chest",
                       "forearms",
                       "glutes",
                       "hamstrings",
                       "lats",
                       "lower_back",
                       "middle_back",
                       "neck",
                       "quadriceps",
                       "traps",
                       "triceps"].contains(component) {
                
                parameters["muscle"] = component
                
            } else {
                parameters["name"] = component
            }
         }
        
        switch endpoint {
        case .searchByType(let type):
            parameters["type"] = type
        case .searchByDifficulty(let difficulty):
            parameters["difficulty"] = difficulty
        case .searchByMuscle(let muscle):
            parameters["muscle"] = muscle
        case .custom:
            break
        }
        return parameters
    }
    
    func makeRequest<T: Codable>(endpoint: Endpoints, query: String? = nil) async throws -> T {
        
        guard let url = createURL(for: endpoint, with: query) else {
                   throw GFError.invalidURL
               }
        
        print("Request URL: \(url.absoluteString)")
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw GFError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw GFError.invalidData
            }
    }
    
    func searchExercises(query: String) async throws -> [Exercise] {
        return try await makeRequest(endpoint: .custom  , query: query)
    }
}
