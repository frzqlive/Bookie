import Foundation

extension Book
{
    static func buildCoverURL(from coverID: Int?) -> String? {
        guard let coverID = coverID else { return nil }
        return "\(APIConstants.coversBaseURL)\(coverID)\(APIConstants.coverSuffix)"
    }
}

