//
//  WindowController.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/10.
//

import Cocoa

class WindowController: NSWindowController {
    let toolbarItemIdentifiers: [NSToolbarItem.Identifier] = [
        .homePage,
        .flexibleSpace,
        .prevPage,
        .nextPage,
        .toggleSidebar,
        .sidebarTrackingSeparator,
        .flexibleSpace,
        .reload,
        .openInBrowser,
    ]

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.setContentSize(NSSize(width: 1920, height: 1080))
    }

    override func mouseUp(with event: NSEvent) {
        if event.clickCount >= 2 {
            window?.performZoom(nil)
        }
        super.mouseUp(with: event)
    }
}

extension WindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case .homePage:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.target = self
            item.action = #selector(onHomePage(_:))
            let label = "HackerNews homepage"
            item.image = NSImage(systemSymbolName: "newspaper", accessibilityDescription: label)
            return item
        case .prevPage:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.target = self
            item.action = #selector(onPrevPage(_:))
            let label = "HackerNews homepage"
            item.image = NSImage(systemSymbolName: "arrow.backward", accessibilityDescription: label)
            return item
        case .nextPage:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.target = self
            item.action = #selector(onNextPage(_:))
            let label = "HackerNews homepage"
            item.image = NSImage(systemSymbolName: "arrow.forward", accessibilityDescription: label)
            return item
        case .reload:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.target = self
            item.action = #selector(reload(_:))
            let label = "Reload"
            item.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: label)
            return item
        case .openInBrowser:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.target = self
            item.action = #selector(openInBrowser(_:))
            let label = "Open in browser"
            item.image = NSImage(systemSymbolName: "safari", accessibilityDescription: label)
            return item
        default:
            break
        }
        return nil
    }

    @objc func onHomePage(_ sender: Any?) {
        NotificationCenter.default.post(name: .homePage, object: nil)
    }

    @objc func onPrevPage(_ sender: Any?) {
        NotificationCenter.default.post(name: .prevPage, object: nil)
    }

    @objc func onNextPage(_ sender: Any?) {
        NotificationCenter.default.post(name: .nextPage, object: nil)
    }

    @objc func reload(_ sender: Any?) {
        NotificationCenter.default.post(name: .reload, object: nil)
    }

    @objc func openInBrowser(_ sender: Any?) {
        NotificationCenter.default.post(name: .openInBrowser, object: nil)
    }
}
