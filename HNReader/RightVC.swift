//
//  RightVC.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Cocoa
import Combine
import WebKit

class RightVC: NSViewController {
    @IBOutlet var tabView: NSTabView!
    @IBOutlet weak var sourcePage: WKWebView!
    @IBOutlet weak var commentPage: WKWebView!
    @IBOutlet weak var sourceItem: NSTabViewItem!
    @IBOutlet weak var commentItem: NSTabViewItem!
    @IBOutlet weak var sourceProgress: NSProgressIndicator!

    private var sourceUrl: URL?
    private var commentUrl: URL?
    private var currentUrl: URL?

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        sourcePage.customUserAgent = HNReader.userAgent
        commentPage.customUserAgent = HNReader.userAgent

        sourceProgress.isHidden = true

        NotificationCenter.default.publisher(for: .itemClicked)
            .sink { [weak self] notification in
                self?.onItemClicked(notification)
            }
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .openInBrowser)
            .sink { [weak self] _ in
                self?.openInBrowser()
            }
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .reload)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.currentUrl == self.sourceUrl {
                    self.sourcePage.reload()
                } else if self.currentUrl == self.commentUrl {
                    self.commentPage.reload()
                }
            }
            .store(in: &subscriptions)

        let sourcePub = sourcePage.publisher(for: \.estimatedProgress).share()
        sourcePub
            .sink { [weak self] progress in
                self?.sourceProgress.doubleValue = progress
                if progress >= 1 {
                    self?.sourceProgress.doubleValue = 0
                }
            }
            .store(in: &subscriptions)
        sourcePub
            .map { (progress) -> Bool in
                if progress <= 0 || progress >= 1 {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isHidden, on: sourceProgress)
            .store(in: &subscriptions)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func onItemClicked(_ notification: Notification) {
        guard let item = notification.userInfo?["item"] as? HNItem else { return }

        sourcePage.load(URLRequest(url: item.sourceUrl))
        commentPage.load(URLRequest(url: item.commentUrl))

        sourceUrl = item.sourceUrl
        commentUrl = item.commentUrl
        currentUrl = sourceUrl

        sourceItem.label = item.from
        commentItem.label = item.comments

        tabView.selectTabViewItem(at: 0)
    }

    func openInBrowser() {
        if let url = currentUrl {
            NSWorkspace.shared.open(url)
        }
    }
}

extension RightVC: NSTabViewDelegate {
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if tabViewItem == sourceItem {
            currentUrl = sourceUrl
        } else if tabViewItem == commentItem {
            currentUrl = commentUrl
        }
    }
}
