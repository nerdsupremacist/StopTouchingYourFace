
import Cocoa
import SwiftUI
import GRDB
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    // Database
    private lazy var databasePool: DatabasePool = {
        let pathToSupport = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        let file = URL(fileURLWithPath: pathToSupport)
            .appendingPathComponent("db.sqlite3")

        try! FileManager.default.createDirectory(atPath: file.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)

        if !FileManager.default.fileExists(atPath: file.path) {
            FileManager.default.createFile(atPath: file.path, contents: nil, attributes: nil)
        }

        return try! DatabasePool(path: file.path)
    }()

    private lazy var db = try! FaceTouchDatabase(databasePool: databasePool)

    // Services
    private let faceDetectionService = FaceTouchDetector.Service()
    private lazy var faceTouchAggregationService = FaceTouchAggregationService(service: faceDetectionService, db: db)

    // View Models
    private let authorizationViewModel = AuthorizationRequestViewModel()
    private lazy var stopTouchingYourFaceViewModel = StopTouchingYourFaceViewModel(faceDetectionService: faceDetectionService,
                                                                                   faceTouchAggregationService: faceTouchAggregationService)


    var cancellables = Set<AnyCancellable>()
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        stopTouchingYourFaceViewModel.frameRate = 1
        stopTouchingYourFaceViewModel.start()

        let contentView = MainView(authorizationViewModel: authorizationViewModel, stopTouchingYourFaceViewModel: stopTouchingYourFaceViewModel)

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 600, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.delegate = self
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        stopTouchingYourFaceViewModel
            .$status
            .sink { status in
                switch status {
                case .faceTouch:
                    self.statusBarItem.button?.layer?.backgroundColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
                case .noFacePresent, .untouchedFace:
                    self.statusBarItem.button?.layer?.backgroundColor = nil
                }
            }
            .store(in: &cancellables)

        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "menubar-icon")
            button.action = #selector(togglePopover(_:))
        }
    }

    func applicationWillResignActive(_ notification: Notification) {
        popover.performClose(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        stopTouchingYourFaceViewModel.stop()
    }

    func popoverWillShow(_ notification: Notification) {
        stopTouchingYourFaceViewModel.frameRate = nil
    }

    func popoverWillClose(_ notification: Notification) {
        stopTouchingYourFaceViewModel.frameRate = 1
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

}

