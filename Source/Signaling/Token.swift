// Please help improve quicktype by enabling anonymous telemetry with:
//
//   $ quicktype --telemetry enable
//
// You can also enable telemetry on any quicktype invocation:
//
//   $ quicktype pokedex.json -o Pokedex.cs --telemetry enable
//
// This helps us improve quicktype by measuring:
//
//   * How many people use quicktype
//   * Which features are popular or unpopular
//   * Performance
//   * Errors
//
// quicktype does not collect:
//
//   * Your filenames or input data
//   * Any personally identifiable information (PII)
//   * Anything not directly related to quicktype's usage
//
// If you don't want to help improve quicktype, you can dismiss this message with:
//
//   $ quicktype --telemetry disable
//
// For a full privacy policy, visit app.quicktype.io/privacy
//

import Foundation
import SocketIO

struct Token: Codable, SocketData{
    let tokenID, host: String
    let secure: Bool
    let signature: String

    enum CodingKeys: String, CodingKey {
        case tokenID = "tokenId"
        case host, secure, signature
    }

    func socketRepresentation() -> SocketData {
        let jsonData = try! self.jsonData()
        let token = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        return token
    }
}

// MARK: Convenience initializers and mutators

extension Token {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Token.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        tokenID: String? = nil,
        host: String? = nil,
        secure: Bool? = nil,
        signature: String? = nil
    ) -> Token {
        return Token(
            tokenID: tokenID ?? self.tokenID,
            host: host ?? self.host,
            secure: secure ?? self.secure,
            signature: signature ?? self.signature
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


