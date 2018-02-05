//
//  StoryScreenViewModelTest.swift
//  AshTests
//
//  Created by Oliver ONeill on 4/2/18.
//

import XCTest
@testable import Ash

/**
 * Test the view model.
 *
 * TODO: need better tests around going from one state to another
 * TODO: need better tests around verifying that the correct requests are made
 */
class StoryScreenViewModelTest: XCTestCase {
    /// Input that we'll test
    private let model = Story(
        by: "Author Name",
        id: 321,
        time: Date(),
        title: "Story Title 1",
        url: "http://www.hostname.com/page1/x.html"
    )

    /// A fake API that will return data as needed without any actual networking
    class FakeAPI : StoryAPI {
        private let story: Story?
        private let loadForever: Bool
        /**
         * Create a FakeAPI
         *
         * - Parameter story: The story that should be returned immediately
         * when requested via `getStory`
         * - Parameter loadForever: Set this if you want the API to never send
         * back data
         */
        init(story: Story? = nil, loadForever: Bool = false) {
            self.story = story
            self.loadForever = loadForever
        }
        /// Will always return a list with one element unless `loadForever`
        /// is set to true
        func getNewStories(callback: @escaping StoriesCallback) {
            if loadForever {
                // never call the callback
                return
            }
            callback([2])
        }

        func getStory(itemNumber: ItemID, callback: @escaping StoryCallback) {
            if loadForever {
                // never call the callback
                return
            }
            callback(story)
        }
    }

    func testOnViewAppearedLoading() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(loadForever: true))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            switch state {
            case .loading:
                // Complete once we've reached this state
                expectation.fulfill()
                break
            default:
                // Ensure that only the loading state is reached
                XCTFail()
                break
            }
        }
        // When
        viewModel.onViewAppeared()
        wait(for: [expectation], timeout: 1.0)
    }

    func testOnViewAppeared() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(story: model))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            // Wait for loaded event
            switch state {
            case .loaded(let story):
                XCTAssertEqual(story, StoryViewModel(story: self.model))
                expectation.fulfill()
                break
            default:
                // We'll ignore all other states and just test that we
                // *eventually* reach the loaded state
                // TODO: test that we go straight from `loading` to `loaded`
                break
            }
        }
        // When
        viewModel.onViewAppeared()
        wait(for: [expectation], timeout: 1.0)
    }

    func testOnViewAppearedError() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(story: nil))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            // Wait for error event
            switch state {
            case .error:
                expectation.fulfill()
                break
            default:
                // Ignore all other states
                break
            }
        }
        // When
        viewModel.onViewAppeared()
        wait(for: [expectation], timeout: 1.0)
    }

    func tesRefreshLoading() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(loadForever: true))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            switch state {
            case .loading:
                // We've succesfully reached the loading state
                expectation.fulfill()
                break
            default:
                // Ensure that only the loading state is reached
                XCTFail()
                break
            }
        }
        // When
        viewModel.refresh()
        wait(for: [expectation], timeout: 1.0)
    }

    func tesRefresh() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(story: model))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            // Wait for loaded event
            switch state {
            case .loaded(let story):
                // Ensure that we received the model we'd expect
                XCTAssertEqual(story, StoryViewModel(story: self.model))
                expectation.fulfill()
                break
            default:
                // Ignore all other states
                break
            }
        }
        // When
        viewModel.refresh()
        wait(for: [expectation], timeout: 1.0)
    }

    func tesRefreshError() {
        // Given
        let viewModel = StoryScreenViewModel(api: FakeAPI(story: nil))
        let expectation = XCTestExpectation(description: "Make network request")
        viewModel.onStateChange = { (state) in
            // Then
            // Wait for error event
            switch state {
            case .error:
                expectation.fulfill()
                break
            default:
                // Ignore all other states
                break
            }
        }
        // When
        viewModel.refresh()
        wait(for: [expectation], timeout: 1.0)
    }
}
