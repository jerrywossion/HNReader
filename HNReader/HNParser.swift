//
//  HNParser.swift
//  HNReader
//
//  Created by Jie Weng on 2020/12/9.
//

import Foundation
import SwiftSoup

class HNItem: NSObject {
    var rank: String
    var title: String
    var sourceUrl: URL
    var commentUrl: URL
    var score: String
    var age: String
    var comments: String
    var from: String

    init(
        rank: String,
        title: String,
        sourceUrl: URL,
        commentUrl: URL,
        score: String,
        age: String,
        comments: String,
        from: String
    ) {
        self.rank = rank
        self.title = title
        self.sourceUrl = sourceUrl
        self.commentUrl = commentUrl
        self.score = score
        self.age = age
        self.comments = comments
        self.from = from
    }
}

func getHNItems(page: Int = 0, completion: (([HNItem]) -> Void)?) {
    let baseUrlStr = "https://news.ycombinator.com/"
    if let HNUrl = URL(string: "\(baseUrlStr)news?p=\(page)") {
        do {
            let contents = try String(contentsOf: HNUrl)
            let doc: Document = try SwiftSoup.parse(contents)
            let athings = try doc.select(".athing")
            var items: [HNItem] = []
            for athing in athings {
                guard let rankElement = try athing.select(".title").first() else { continue }
                guard let tdElement = try rankElement.select("td").first() else { continue }
                guard let spanElement = try tdElement.select("span").first() else { continue }
                let rank = try spanElement.text()

                guard let titleElement = try athing.select(".title").last() else { continue }
                guard let a = try titleElement.select("a").first() else { continue }
                let title = try a.text()
                let sourceUrlStr = try a.attr("href")

                guard let from = try titleElement.select("span").first()?.select("a").first()?.text() else { continue }

                guard let commentContainerElement = try athing.nextElementSibling() else { continue }

                guard let age = try commentContainerElement.select(".age").first()?.text() else { continue }

                guard let score = try commentContainerElement.select(".score").first()?.text() else { continue }

                guard let commentElement = try commentContainerElement.select("a").last() else { continue }
                var commentUrlStr = try commentElement.attr("href")
                if !commentUrlStr.contains("item?") { continue }
                commentUrlStr = "\(baseUrlStr)\(commentUrlStr)"
                let comments = try commentElement.text()

                guard let sourceUrl = URL(string: sourceUrlStr), let commentUrl = URL(string: commentUrlStr) else {
                    continue
                }
                items.append(
                    HNItem(
                        rank: rank,
                        title: title,
                        sourceUrl: sourceUrl,
                        commentUrl: commentUrl,
                        score: score,
                        age: age,
                        comments: comments,
                        from: from
                    )
                )
            }
            completion?(items)
        } catch {

        }
    }
}
