//
//  LeftVC.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Cocoa

class LeftVC: NSViewController {
    @IBOutlet weak var itemList: NSTableView!

    let itemCellID = "ItemCellID"

    var items: [HNItem] = []
    var currentPage: Int = 1

    let urlCacheKey = "urlCache"
    var urlCache: [String: Int] = [:]

    var isLoading: Bool = false {
        didSet {

        }
    }

    private func reloadItems(page: Int) {
        isLoading = true
        DispatchQueue.main.async {
            getHNItems(page: page) { [self] items in
                self.items = items
                itemList.reloadData()
                isLoading = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        itemList.delegate = self
        itemList.dataSource = self

        let defaults = UserDefaults.standard
        urlCache = defaults.object(forKey: urlCacheKey) as? [String: Int] ?? [:]

        reloadItems(page: currentPage)

        NotificationCenter.default.addObserver(self, selector: #selector(onHomePage(_:)), name: .homePage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPrevPage(_:)), name: .prevPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNextPage(_:)), name: .nextPage, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onHomePage(_ sender: NSButton) {
        guard !isLoading else { return }

        currentPage = 1
        reloadItems(page: currentPage)
    }

    @objc func onPrevPage(_ sender: NSButton) {
        guard !isLoading else { return }

        currentPage -= 1
        if currentPage < 1 {
            currentPage = 1
        }
        reloadItems(page: currentPage)
        itemList.scroll(.zero)
    }

    @objc func onNextPage(_ sender: NSButton) {
        guard !isLoading else { return }

        currentPage += 1
        reloadItems(page: currentPage)
        itemList.scroll(.zero)
    }
}

extension LeftVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        items.count
    }
}

extension LeftVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell =
            tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(itemCellID), owner: nil)
            as? NSTableCellView as? HNItemCell

        let item = items[row]

        cell?.rankLabel.stringValue = item.rank
        cell?.titleLabel.stringValue = item.title
        if urlCache.contains(where: { (key, _) in key == item.sourceUrl.path }) {
            cell?.titleLabel.textColor = .systemGray
        } else {
            cell?.titleLabel.textColor = .white
        }

        cell?.scoreLabel.stringValue = item.score

        cell?.ageLabel.stringValue = item.age

        cell?.commentsLabel.stringValue = item.comments

        cell?.fromLabel.stringValue = "(\(item.from))"

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard itemList.selectedRow >= 0 else { return }

        let clickedItem = items[itemList.selectedRow]
        let userInfo = ["item": clickedItem]
        NotificationCenter.default.post(
            name: .itemClicked,
            object: nil,
            userInfo: userInfo
        )
        urlCache[clickedItem.sourceUrl.path] = 1
        let defaults = UserDefaults.standard
        defaults.setValue(urlCache, forKey: urlCacheKey)
        itemList.reloadData(
            forRowIndexes: IndexSet(integer: itemList.selectedRow),
            columnIndexes: IndexSet(integer: 0)
        )
    }
}
