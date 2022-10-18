import UIKit

//MARK: Enum to track connection status
enum NetworkError: Error{
    case invalidURL
    case nilData
    case descriptionError
}


//MARK: The class is whitch we receive data from JSON
class NetworkManager {
    private let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"


    func AvitoJSON(status: @escaping(Result<List, NetworkError>) -> Void){
        
        guard let url = URL(string: urlString) else {
            status(.failure(.invalidURL)) ; return }
    
        let configurator = URLSessionConfiguration.default
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 30 * 1024 * 1024)
        configurator.urlCache = cache
        let session = URLSession(configuration: configurator)
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data{
            guard let tryToReceiveData = try? JSONDecoder().decode(List.self, from: data) else { return }
            status(.success(tryToReceiveData))
            return
        } else{
            session.dataTask(with: request) { data, response, error in
                if error != nil {
                    status(.failure(.descriptionError))
                }
                
                guard let data = data else { status(.failure(.nilData))
                    return
                }
                
                do{
                    let parseData = try JSONDecoder().decode(List.self, from: data)
                    status(.success(parseData))
                } catch{
                    status(.failure(.descriptionError))
                }
            }.resume()
        }
    }
}
        
    




