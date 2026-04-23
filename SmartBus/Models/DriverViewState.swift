import Foundation

enum CameraAngle: String, CaseIterable {
    case forward = "Forward View"
    case leftSide = "Left Side View"
    case rightSide = "Right Side View"

    var icon: String {
        switch self {
        case .forward: return "arrow.up.circle.fill"
        case .leftSide: return "arrow.left.circle.fill"
        case .rightSide: return "arrow.right.circle.fill"
        }
    }

    var imageName: String {
        switch self {
        case .forward: return "athens-forward"
        case .leftSide: return "athens-left"
        case .rightSide: return "athens-right"
        }
    }
}
