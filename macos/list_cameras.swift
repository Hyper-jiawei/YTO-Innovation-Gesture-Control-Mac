import Foundation
import AVFoundation
let cameras = AVCaptureDevice.devices(for: .video).enumerated().map { index, device in
    ["index": index, "name": device.localizedName] as [String: Any]
}
let data = try JSONSerialization.data(withJSONObject: cameras, options: [.sortedKeys])
print(String(data: data, encoding: .utf8)!)
