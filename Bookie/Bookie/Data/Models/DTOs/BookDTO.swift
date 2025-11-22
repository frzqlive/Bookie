import Foundation

struct BookDTO: Codable
{
    let key: String
    let title: String
    let authorName: [String]?
    let coverID: Int?
    let firstPublishYear: Int?
    let description: String?
    let workKey: [String]?

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case coverID = "cover_i"
        case firstPublishYear = "first_publish_year"
        case description
        case workKey = "work_key"
    }
}

struct BookSearchResponseDTO: Codable
{
    let docs: [BookDTO]
}

