//
//  HNItemCell.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Cocoa

class HNItemCell: NSTableCellView {
    @IBOutlet weak var rankLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var scoreLabel: NSTextField!
    @IBOutlet weak var ageLabel: NSTextField!
    @IBOutlet weak var commentsLabel: NSTextField!
    @IBOutlet weak var fromLabel: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
