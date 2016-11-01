import Foundation
import KeyedMapper

public struct Program {
    let title: String
    let chanId: String
    let description: String?
    let subtitle: String?
    let recording: Recording
    let season: String?
    let episode: String?
}

extension Program: Mappable {
    public enum Key: String, JSONKey {
        case Title
        case ChannelID = "Channel.ChanId"
        case Description
        case SubTitle
        case Recording
        case Season
        case Episode
    }

    public init(map: KeyedMapper<Program>) throws {
        title = try map.from(.Title)
        chanId = try map.from(.ChannelID)
        description = map.optionalFrom(.Description)
        subtitle = map.optionalFrom(.SubTitle)
        recording = try map.from(.Recording)
        season = map.optionalFrom(.Season)
        episode = map.optionalFrom(.Episode)
    }
}
