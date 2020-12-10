//
//  RightVC.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Cocoa
import WebKit

class RightVC: NSViewController {
    @IBOutlet var tabView: NSTabView!
    @IBOutlet weak var sourcePage: WKWebView!
    @IBOutlet weak var commentPage: WKWebView!
    @IBOutlet weak var pageItem: NSTabViewItem!
    @IBOutlet weak var commentItem: NSTabViewItem!

    private var sourceUrl: URL?
    private var commentUrl: URL?
    private var currentUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        sourcePage.customUserAgent = HNReader.userAgent
        commentPage.customUserAgent = HNReader.userAgent

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onItemClicked(_:)),
            name: .itemClicked,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openInBrowser(_:)),
            name: .openInBrowser,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onItemClicked(_ notification: NSNotification) {
        guard let item = notification.userInfo?["item"] as? HNItem else { return }

        sourcePage.load(URLRequest(url: item.sourceUrl))
        commentPage.load(URLRequest(url: item.commentUrl))

        sourceUrl = item.sourceUrl
        commentUrl = item.commentUrl
        currentUrl = sourceUrl

        pageItem.label = item.from
        commentItem.label = item.comments

        tabView.selectTabViewItem(at: 0)
    }

    @objc func openInBrowser(_ sender: Any?) {
        if let url = currentUrl {
            NSWorkspace.shared.open(url)
        }
    }
}

extension RightVC: NSTabViewDelegate {
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if tabViewItem == pageItem {
            currentUrl = sourceUrl
        } else if tabViewItem == commentItem {
            currentUrl = commentUrl
        }
    }
}
