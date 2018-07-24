//
//  HackerNewsAPI.swift
//  Ash
//
//  Created by Oliver ONeill on 3/2/18.
//

import UIKit

/// An item ID is a unique identifier for a story
typealias ItemID = Int
/// The model that will be used within `StoryScreenViewModel` to display a story
/// to the screen
struct Story : Codable {
    /// The author
    let by: String
    /// Unique identifier
    let id: ItemID
    /// When the story was posted
    let time: Date
    /// The title of the story
    let title: String
    /// A link to the story
    let url: String
}

class HackerNewsAPI: StoryAPI {
    private let httpInterface: HttpInterface

    /// Create a HackerNewsAPI.
    ///
    /// - Parameter httpInterface: The interface used to make network requests.
    init(httpInterface: HttpInterface = HttpURLSessionWrapper()) {
        self.httpInterface = httpInterface
    }

    func getNewStories(callback: @escaping StoriesCallback) {
        let urlString = "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"
        guard let url = URL(string: urlString) else {
            callback([])
            return
        }
        let request = URLRequest(url: url)
        httpInterface.makeRequest(request: request) { (data, response, error) in
            // Ensure the request succeeded
            guard let jsonData = data else {
                callback([])
                return
            }
            // Parse the JSON
            let parsed = try? JSONDecoder().decode([ItemID].self, from: jsonData)
            // If we failed to parse the JSON, then send back an empty list
            // TODO: propogate errors
            guard let stories = parsed else {
                callback([])
                return
            }
            callback(stories)
        }
    }

    func getStory(itemNumber: ItemID, callback: @escaping StoryCallback) {
        let urlString = "https://hacker-news.firebaseio.com/v0/item/\(itemNumber).json?print=pretty"
        guard let url = URL(string: urlString) else {
            callback(nil)
            return
        }
        let request = URLRequest(url: url)
        httpInterface.makeRequest(request: request) { (data, response, error) in
            // Ensure the request succeeded
            guard let jsonData = data else {
                callback(nil)
                return
            }
            // Parse the JSON
            let decoder = JSONDecoder()
            // The dates are unix timestamps
            decoder.dateDecodingStrategy = .secondsSince1970
            let story = try? decoder.decode(Story.self, from: jsonData)
            callback(story)
        }
    }
}
