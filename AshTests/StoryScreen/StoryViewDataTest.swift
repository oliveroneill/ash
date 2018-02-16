//
//  StoryViewDataTest.swift
//  AshTests
//
//  Created by Oliver ONeill on 5/2/18.
//

import XCTest
@testable import Ash

class StoryViewDataTest: XCTestCase {
    func testInit() {
        // Given
        let model = Story(
            by: "Author Name",
            id: 321,
            time: Date(),
            title: "Story Title 1",
            url: "http://www.hostname.com/page1/x.html"
        )
        // When
        let viewData = StoryViewData(story: model)
        // Then
        XCTAssertEqual(viewData.authorText, "By \(model.by)")
        XCTAssertEqual(viewData.dateText, model.time.timeAgo())
        XCTAssertEqual(viewData.title, model.title)
        XCTAssertEqual(viewData.url, model.url)
    }
}
