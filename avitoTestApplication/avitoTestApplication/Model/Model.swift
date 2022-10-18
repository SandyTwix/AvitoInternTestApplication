import Foundation

struct List: Codable{
    let company: Company
}

struct Company: Codable{
    let name: String
    let employees: [Employee]
}

struct Employee: Codable{
    let name: String
    let phone_number: String
    let skills: [String]
    
    enum CodingKeys: String, CodingKey{
        case name
        case phone_number = "phone_number"
        case skills
    }
}

