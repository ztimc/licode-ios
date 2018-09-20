//
//  RoomMeta.swift
//  licode
//
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

public struct RoomMeta: Codable {
    let streams: [Stream]
    let id, clientID: String
    let maxVideoBW, defaultVideoBW: Int
    let iceServers: [IceServer]
    
    enum CodingKeys: String, CodingKey {
        case streams, id
        case clientID = "clientId"
        case maxVideoBW, defaultVideoBW, iceServers
    }
}

public struct IceServer: Codable {
    let url: String
}

public struct Stream: Codable {
    let id, audio, data, video: Int
    let attributes: Attributes
}

public struct Attributes: Codable {
    let audio: Bool
    let name: String
    let video: Bool
    let actualName: String
}

// MARK: Convenience initializers and mutators

extension RoomMeta {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RoomMeta.self, from: data)
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
        streams: [Stream]? = nil,
        id: String? = nil,
        clientID: String? = nil,
        maxVideoBW: Int? = nil,
        defaultVideoBW: Int? = nil,
        iceServers: [IceServer]? = nil
        ) -> RoomMeta {
        return RoomMeta(
            streams: streams ?? self.streams,
            id: id ?? self.id,
            clientID: clientID ?? self.clientID,
            maxVideoBW: maxVideoBW ?? self.maxVideoBW,
            defaultVideoBW: defaultVideoBW ?? self.defaultVideoBW,
            iceServers: iceServers ?? self.iceServers
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension IceServer {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IceServer.self, from: data)
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
        url: String? = nil
        ) -> IceServer {
        return IceServer(
            url: url ?? self.url
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Stream {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Stream.self, from: data)
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
        id: Int? = nil,
        audio: Int? = nil,
        data: Int? = nil,
        video: Int? = nil,
        attributes: Attributes? = nil
        ) -> Stream {
        return Stream(
            id: id ?? self.id,
            audio: audio ?? self.audio,
            data: data ?? self.data,
            video: video ?? self.video,
            attributes: attributes ?? self.attributes
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Attributes {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Attributes.self, from: data)
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
        audio: Bool? = nil,
        name: String? = nil,
        video: Bool? = nil,
        actualName: String? = nil
        ) -> Attributes {
        return Attributes(
            audio: audio ?? self.audio,
            name: name ?? self.name,
            video: video ?? self.video,
            actualName: actualName ?? self.actualName
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
