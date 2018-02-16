//
//  StoryScreenViewDataTest.swift
//  AshTests
//
//  Created by Oliver ONeill on 11/2/18.
//  Copyright © 2018 Oliver ONeill. All rights reserved.
//

import XCTest
@testable import Ash

class StoryScreenViewDataTest: XCTestCase {
    func testInitLoadingState() {
        // Given
        let state = StoryScreenState.loading
        // When
        let viewData = StoryScreenViewData(state: state)
        // Then
        XCTAssertEqual(viewData.errorMessageText, nil)
        XCTAssertEqual(viewData.titleLabelText, nil)
        XCTAssertEqual(viewData.authorLabelText, nil)
        XCTAssertEqual(viewData.dateLabelText, nil)
        XCTAssertEqual(viewData.titleLabelHidden, true)
        XCTAssertEqual(viewData.authorLabelHidden, true)
        XCTAssertEqual(viewData.dateLabelHidden, true)
        XCTAssertEqual(viewData.errorMessageLabelHidden, true)
        XCTAssertEqual(viewData.backgroundButtonHidden, true)
        XCTAssertEqual(viewData.refreshButtonHidden, true)
        XCTAssertEqual(viewData.activityIndicatorAnimated, true)
        XCTAssertEqual(viewData.statusBarActivityIndicatorAnimated, true)
    }

    func testInitErrorState() {
        // Given
        let message = "Error message to be shown on screen"
        let state = StoryScreenState.error(message)
        // When
        let viewData = StoryScreenViewData(state: state)
        // Then
        XCTAssertEqual(viewData.errorMessageText, message)
        XCTAssertEqual(viewData.titleLabelText, nil)
        XCTAssertEqual(viewData.authorLabelText, nil)
        XCTAssertEqual(viewData.dateLabelText, nil)
        XCTAssertEqual(viewData.titleLabelHidden, true)
        XCTAssertEqual(viewData.authorLabelHidden, true)
        XCTAssertEqual(viewData.dateLabelHidden, true)
        XCTAssertEqual(viewData.errorMessageLabelHidden, false)
        XCTAssertEqual(viewData.backgroundButtonHidden, true)
        XCTAssertEqual(viewData.refreshButtonHidden, false)
        XCTAssertEqual(viewData.activityIndicatorAnimated, false)
        XCTAssertEqual(viewData.statusBarActivityIndicatorAnimated, false)
    }

    func testInitLoadedState() {
        // Given
        let model = Story(
            by: "Author Name",
            id: 321,
            time: Date(),
            title: "Story Title 1",
            url: "http://www.hostname.com/page1/x.html"
        )
        let storyViewData = StoryViewData(story: model)
        let state = StoryScreenState.loaded(storyViewData)
        // When
        let viewData = StoryScreenViewData(state: state)
        // Then
        XCTAssertEqual(viewData.errorMessageText, nil)
        XCTAssertEqual(viewData.titleLabelText, storyViewData.title)
        XCTAssertEqual(viewData.authorLabelText, storyViewData.authorText)
        XCTAssertEqual(viewData.dateLabelText, storyViewData.dateText)
        XCTAssertEqual(viewData.titleLabelHidden, false)
        XCTAssertEqual(viewData.authorLabelHidden, false)
        XCTAssertEqual(viewData.dateLabelHidden, false)
        XCTAssertEqual(viewData.errorMessageLabelHidden, true)
        XCTAssertEqual(viewData.backgroundButtonHidden, false)
        XCTAssertEqual(viewData.refreshButtonHidden, false)
        XCTAssertEqual(viewData.activityIndicatorAnimated, false)
        XCTAssertEqual(viewData.statusBarActivityIndicatorAnimated, false)
    }
}
