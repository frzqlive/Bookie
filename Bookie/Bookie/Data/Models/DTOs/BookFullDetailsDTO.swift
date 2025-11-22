import Foundation

struct BookFullDetailsDTO: Codable
{
    let title: String?
    let description: BookDescriptionFieldDTO?
    let subjects: [String]?
    let firstPublishDate: String?
    let authors: [BookAuthorReferenceDTO]?
    let covers: [Int]?
    let numberOfPages: Int?

    enum CodingKeys: String, CodingKey
    {
        case title
        case description
        case subjects
        case firstPublishDate = "first_publish_date"
        case authors
        case covers
        case numberOfPages = "number_of_pages"
    }
}

struct BookDescriptionFieldDTO: Codable
{
    let value: String

    init(value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
            return
        }

        let object = try container.decode(DescriptionObject.self)
        self.value = object.value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

    private struct DescriptionObject: Codable
    {
        let value: String
    }
}

struct BookAuthorKeyDTO: Codable
{
    let key: String
}

struct BookAuthorReferenceDTO: Codable
{
    let author: BookAuthorKeyDTO?
}

