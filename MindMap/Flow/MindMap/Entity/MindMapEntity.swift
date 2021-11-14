
import Foundation

// MARK: - MindMapEntity
struct MindMapEntity {
    let ideas: Ideas?
    let lines: Lines?
    let title: String
}

// MARK: - Ideas
struct Ideas {
    let uuid, center, text: String?
}

// MARK: - Lines
struct Lines {
    let fromUuid, toUuid: String?
}
