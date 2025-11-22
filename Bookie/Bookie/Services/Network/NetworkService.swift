import Foundation

protocol INetworkService
{
    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: INetworkService
{
    private enum Constants
    {
        static let noDataMessage = AppStrings.Network.noDataMessage
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func performRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        self.session.dataTask(with: url) { data, response, error in
            let result: Result<Data, Error>

            if let requestError = error {
                result = .failure(requestError)
            } else if let httpResponse = response as? HTTPURLResponse,
                      !APIConstants.successStatusCodeRange.contains(httpResponse.statusCode) {
                let error = NSError(
                    domain: APIConstants.ErrorDomain.networkService,
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"]
                )
                result = .failure(error)
            } else if let responseData = data {
                result = .success(responseData)
            } else {
                let error = NSError(
                    domain: APIConstants.ErrorDomain.networkService,
                    code: APIConstants.unknownErrorCode,
                    userInfo: [NSLocalizedDescriptionKey: Constants.noDataMessage]
                )
                result = .failure(error)
            }

            completion(result)
        }.resume()
    }
}
