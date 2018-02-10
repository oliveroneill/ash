//
//  StoryScreenViewModelTest.swift
//  AshTests
//
//  Created by Oliver ONeill on 11/2/18.
//  Copyright © 2018 Oliver ONeill. All rights reserved.
//

import XCTest
@testable import Ash

class StoryScreenViewModelTest: XCTestCase {
    func testInitLoadingState() {
        // Given
        let state = StoryScreenState.loading
        // When
        let viewModel = StoryScreenViewModel(state: state)
        // Then
        XCTAssertEqual(viewModel.errorMessageText, nil)
        XCTAssertEqual(viewModel.titleLabelText, nil)
        XCTAssertEqual(viewModel.authorLabelText, nil)
        XCTAssertEqual(viewModel.dateLabelText, nil)
        XCTAssertEqual(viewModel.titleLabelHidden, true)
        XCTAssertEqual(viewModel.authorLabelHidden, true)
        XCTAssertEqual(viewModel.dateLabelHidden, true)
        XCTAssertEqual(viewModel.errorMessageLabelHidden, true)
        XCTAssertEqual(viewModel.backgroundButtonHidden, true)
        XCTAssertEqual(viewModel.refreshButtonHidden, true)
        XCTAssertEqual(viewModel.activityIndicatorAnimated, true)
    }

    func testInitErrorState() {
        // Given
        let message = "Error message to be shown on screen"
        let state = StoryScreenState.error(message)
        // When
        let viewModel = StoryScreenViewModel(state: state)
        // Then
        XCTAssertEqual(viewModel.errorMessageText, message)
        XCTAssertEqual(viewModel.titleLabelText, nil)
        XCTAssertEqual(viewModel.authorLabelText, nil)
        XCTAssertEqual(viewModel.dateLabelText, nil)
        XCTAssertEqual(viewModel.titleLabelHidden, true)
        XCTAssertEqual(viewModel.authorLabelHidden, true)
        XCTAssertEqual(viewModel.dateLabelHidden, true)
        XCTAssertEqual(viewModel.errorMessageLabelHidden, false)
        XCTAssertEqual(viewModel.backgroundButtonHidden, true)
        XCTAssertEqual(viewModel.refreshButtonHidden, false)
        XCTAssertEqual(viewModel.activityIndicatorAnimated, false)
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
        let storyViewModel = StoryViewModel(story: model)
        let state = StoryScreenState.loaded(storyViewModel)
        // When
        let viewModel = StoryScreenViewModel(state: state)
        // Then
        XCTAssertEqual(viewModel.errorMessageText, nil)
        XCTAssertEqual(viewModel.titleLabelText, storyViewModel.title)
        XCTAssertEqual(viewModel.authorLabelText, storyViewModel.authorText)
        XCTAssertEqual(viewModel.dateLabelText, storyViewModel.dateText)
        XCTAssertEqual(viewModel.titleLabelHidden, false)
        XCTAssertEqual(viewModel.authorLabelHidden, false)
        XCTAssertEqual(viewModel.dateLabelHidden, false)
        XCTAssertEqual(viewModel.errorMessageLabelHidden, true)
        XCTAssertEqual(viewModel.backgroundButtonHidden, false)
        XCTAssertEqual(viewModel.refreshButtonHidden, false)
        XCTAssertEqual(viewModel.activityIndicatorAnimated, false)
    }
}
