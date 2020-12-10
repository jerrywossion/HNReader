//
//  ConstantExtensions.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/10.
//

import Cocoa

enum HNReader {
    static let userAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36 Edg/87.0.664.55"
}

extension NSToolbarItem.Identifier {
    static let homePage = NSToolbarItem.Identifier("homePage")
    static let prevPage = NSToolbarItem.Identifier("prevPage")
    static let nextPage = NSToolbarItem.Identifier("nextPage")
    static let openInBrowser = NSToolbarItem.Identifier("openInBrowser")
}

extension Notification.Name {
    static let itemClicked = Notification.Name("itemClicked")
    static let homePage = Notification.Name("homePage")
    static let prevPage = Notification.Name("prevPage")
    static let nextPage = Notification.Name("nextPage")
    static let openInBrowser = Notification.Name("openInBrowser")
}
