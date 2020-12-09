//
//  SplitVC.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Cocoa

class SplitVC: NSSplitViewController {
    @IBOutlet weak var leftItem: NSSplitViewItem!
    @IBOutlet weak var rightItem: NSSplitViewItem!

    let moreToolbar = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("moreToolbar"))

    override func viewDidLoad() {
        super.viewDidLoad()

        leftItem.minimumThickness = 400
        leftItem.maximumThickness = 800

        leftItem.collapseBehavior = .preferResizingSiblingsWithFixedSplitView

        preferredContentSize = NSSize(width: 1920, height: 1080)

        moreToolbar.image = NSImage(named: "arrow.forward")
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    override func toggleSidebar(_ sender: Any?) {
        leftItem.isCollapsed = !leftItem.isCollapsed
    }
}
