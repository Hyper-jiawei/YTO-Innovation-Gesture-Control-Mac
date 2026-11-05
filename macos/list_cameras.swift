import Foundation
import AVFoundation
// Match OpenCV 4.11 cap_avfoundation_mac.mm: video + muxed, sorted by uniqueID.
let devices = (AVCaptureDevice.devices(for: .video) + AVCaptureDevice.devices(for: .muxed))
    .sorted { $0.uniqueID.compare($1.uniqueID) == .orderedAscending }
let cameras = devices.enumerated().map { index, device in
    ["index": index, "name": device.localizedName, "uniqueID": device.uniqueID] as [String: Any]
}
let data = try JSONSerialization.data(withJSONObject: cameras, options: [.sortedKeys])
print(String(data: data, encoding: .utf8)!)
