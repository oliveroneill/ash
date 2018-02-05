//
//  HackerNewsAPITest.swift
//  AshTests
//
//  Created by Oliver ONeill on 4/2/18.
//

import XCTest
@testable import Ash

/**
 * Test the API for retrieving stories.
 *
 * TODO: could also test requests are made correctly
 */
class HackerNewsAPITest: XCTestCase {
    /// Fake error case
    enum FakeError: Error {
        case networkError
    }
    /// Fake HTTP interface for faking the network calls
    class FakeHTTPInterface: HttpInterface {
        private let data: Data?
        private let response: URLResponse?
        private let error: Error?
        /// Will use the callback based on these values
        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        func makeRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
            callback(data, response, error)
        }
    }

    func testGetNewStories() {
        // Given
        let json = "[246, 433, 1, 77, 13]".data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getNewStories { (items) in
            // Then
            XCTAssertEqual(items.count, 5)
            XCTAssertEqual(items[0], 246)
            XCTAssertEqual(items[1], 433)
            XCTAssertEqual(items[2], 1)
            XCTAssertEqual(items[3], 77)
            XCTAssertEqual(items[4], 13)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetNewStoriesError() {
        // Given
        // Error value to be received
        let error: FakeError = .networkError
        let httpInterface = FakeHTTPInterface(data: nil, response: nil, error: error)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getNewStories { (items) in
            // Then
            // Ensure we returned an empty value
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetNewStoriesBadJSON() {
        // Given
        // Bad JSON string
        let json = "[1, dsgs,qw233;;;]".data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getNewStories { (items) in
            // Then
            // Ensure we returned an empty value
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetStory() {
        // Given
        let id = 22
        let author = "test_author1"
        let time = Date()
        let title = "Test tile: Subtitle 123"
        let url = "http://www.domainname.com/page1/page2/x.html/"
        // JSON from above values
        let json = """
            {\"by\" : \"\(author)\",
            \"time\" : \(time.timeIntervalSince1970),
            \"title\" : \"\(title)\",
            \"id\" : \(id),
            \"url\" : \"\(url)\"}
            """.data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getStory(itemNumber: id) { (story) in
            // Then
            // Ensure the values are populated as expected
            XCTAssertNotNil(story)
            XCTAssertEqual(story?.by, author)
            XCTAssertEqual(story?.time.description, time.description)
            XCTAssertEqual(story?.id, id)
            XCTAssertEqual(story?.title, title)
            XCTAssertEqual(story?.url, url)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetStoryError() {
        // Given
        // Error to be returned
        let error: FakeError = .networkError
        let httpInterface = FakeHTTPInterface(data: nil, response: nil, error: error)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getStory(itemNumber: 11) { (story) in
            // Then
            // Ensure we didn't receive a value
            XCTAssertNil(story)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetStoryBadJSON() {
        // Given
        // Invalid JSON
        let json = """
            {\"by\" : \"\\",
            \"url :ss \"sd44\"}
            """.data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = HackerNewsAPI(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getStory(itemNumber: 21) { (story) in
            // Then
            // Ensure a nil value is returned
            XCTAssertNil(story)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
