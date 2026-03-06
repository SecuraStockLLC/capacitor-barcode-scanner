import CoreGraphics
import Foundation
import OSBarcodeLib

extension OSBARCScanParameters: Decodable {

    enum CodingKeys: CodingKey {
        case scanButton
        case scanInstructions
        case scanText
        case cameraDirection
        case scanOrientation
        case hint
        case highlightEnabled
        case highlightColor
        case highlightStrokeWidth
        case closeDelay
        case vibrationEnabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let scanInstructions = try container.decode(String.self, forKey: .scanInstructions)

        var scanButtonText: String? // property is set based on `scanButton` and `scanText`.
        let scanButton = try container.decode(Bool.self, forKey: .scanButton)
        if scanButton { // only set `scanButtonText` if `scanButton` is enabled
            scanButtonText = try container.decode(String.self, forKey: .scanText)
        }

        let cameraDirectionInt = try container.decode(Int.self, forKey: .cameraDirection)
        let cameraDirection = OSBARCCameraModel.map(value: cameraDirectionInt)

        let scanOrientationInt = try container.decode(Int.self, forKey: .scanOrientation)
        let scanOrientation = OSBARCOrientationModel.map(value: scanOrientationInt)

        let hintInt = try container.decode(Int.self, forKey: .hint)
        let hint = OSBARCScannerHint(rawValue: hintInt)

        let highlightEnabled = try container.decodeIfPresent(Bool.self, forKey: .highlightEnabled) ?? true
        let highlightColor = try container.decodeIfPresent(String.self, forKey: .highlightColor) ?? "#00FF00"
        let highlightStrokeWidth = try container.decodeIfPresent(CGFloat.self, forKey: .highlightStrokeWidth) ?? 4.0
        let closeDelayMs = try container.decodeIfPresent(Double.self, forKey: .closeDelay) ?? 500
        let closeDelay = closeDelayMs / 1000.0  // Convert ms to seconds
        let vibrationEnabled = try container.decodeIfPresent(Bool.self, forKey: .vibrationEnabled) ?? true

        self.init(
            scanInstructions: scanInstructions,
            scanButtonText: scanButtonText,
            cameraDirection: cameraDirection,
            scanOrientation: scanOrientation,
            hint: hint,
            highlightEnabled: highlightEnabled,
            highlightColor: highlightColor,
            highlightStrokeWidth: highlightStrokeWidth,
            closeDelay: closeDelay,
            vibrationEnabled: vibrationEnabled
        )
    }
}
