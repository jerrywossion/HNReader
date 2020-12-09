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

    override func viewDidLoad() {
        super.viewDidLoad()

        let userAgent =
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36 Edg/87.0.664.55"
        sourcePage.customUserAgent = userAgent
        commentPage.customUserAgent = userAgent

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onItemClicked(_:)),
            name: Notification.Name("ItemClicked"),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onItemClicked(_ notification: NSNotification) {
        guard let item = notification.userInfo?["item"] as? HNItem else { return }

        tabView.selectTabViewItem(at: 0)
        sourcePage.load(URLRequest(url: item.sourceUrl))
        commentPage.load(URLRequest(url: item.commentUrl))

        pageItem.label = item.from
        commentItem.label = item.comments
    }
}
