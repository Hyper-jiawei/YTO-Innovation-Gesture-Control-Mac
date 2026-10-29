import AppKit
import AVFoundation

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let project = Bundle.main.bundleURL.deletingLastPathComponent()
let arguments = Array(CommandLine.arguments.dropFirst())
func fail(_ message: String) -> Never {
    let alert = NSAlert()
    alert.messageText = "YTO 手势控制启动失败"
    alert.informativeText = message
    alert.addButton(withTitle: "确定")
    alert.runModal()
    exit(1)
}
func launch() {
    let process = Process()
    process.executableURL = project.appendingPathComponent(".venv/bin/python")
    process.arguments = [project.appendingPathComponent("main.py").path] + arguments
    process.currentDirectoryURL = project
    var environment = ProcessInfo.processInfo.environment
    environment["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"
    environment["OMP_NUM_THREADS"] = "4"
    environment["OPENBLAS_NUM_THREADS"] = "4"
    process.environment = environment
    let logURL = project.appendingPathComponent("outputs/app-launch.log")
    let log: FileHandle
    do {
        try FileManager.default.createDirectory(at: logURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        _ = FileManager.default.createFile(atPath: logURL.path, contents: nil)
        log = try FileHandle(forWritingTo: logURL)
    } catch { fail("无法创建日志：\(error.localizedDescription)") }
    process.standardOutput = log
    process.standardError = log
    process.terminationHandler = { task in
        DispatchQueue.main.async {
            if task.terminationStatus != 0 {
                fail("请查看工程中的 outputs/app-launch.log。\n\n相机权限位于：系统设置 → 隐私与安全性 → 摄像头 → YTO手势控制。")
            }
            exit(task.terminationStatus)
        }
    }
    do { try process.run() }
    catch { fail(error.localizedDescription) }
}
DispatchQueue.main.async {
    if arguments.contains("--demo") {
        launch()
    } else {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: launch()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted { launch() }
                    else { fail("需要允许相机访问。请在系统设置 → 隐私与安全性 → 摄像头中开启 YTO手势控制，然后重新启动。") }
                }
            }
        default: fail("相机权限已关闭。请在系统设置 → 隐私与安全性 → 摄像头中开启 YTO手势控制，然后重新启动。")
        }
    }
}
app.run()
