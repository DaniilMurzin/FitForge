import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        Task {
            do {
                let exercises = try await NetworkManager.shared.searchExercises(query: "push ups")
                
                print(exercises)
            } catch {
                // Обработка ошибок
                print(error)
            }
            
        }
    }
}

