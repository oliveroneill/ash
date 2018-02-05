//
//  StoryViewModelTest.swift
//  AshTests
//
//  Created by Oliver ONeill on 5/2/18.
//

import XCTest
@testable import Ash

class StoryViewModelTest: XCTestCase {
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
        let viewModel = StoryViewModel(story: model)
        // Then
        XCTAssertEqual(viewModel.authorText, "By \(model.by)")
        XCTAssertEqual(viewModel.dateText, model.time.timeAgo())
        XCTAssertEqual(viewModel.title, model.title)
        XCTAssertEqual(viewModel.url, model.url)
    }
}
