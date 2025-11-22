import Foundation

enum ReadingStatus: String, CaseIterable, Codable
{
    case wantToRead
    case reading
    case finished

    static let orderedCases: [ReadingStatus] = [
        .reading,
        .wantToRead,
        .finished
    ]
}

