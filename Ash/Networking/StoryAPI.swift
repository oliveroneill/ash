//
//  StoryAPI.swift
//  Ash
//
//  Created by Oliver ONeill on 4/2/18.
//

// TODO: propogate errors through here
protocol StoryAPI {
    /// A callback for retrieving a list of story IDs
    typealias StoriesCallback = (([ItemID]) -> Void)
    /// a callback for receiving a story
    typealias StoryCallback = ((Story?) -> Void)
    /// Get new stories. This returns a list of IDs that can be used to query
    /// specific stories
    func getNewStories(callback: @escaping StoriesCallback)
    /// Get a story based on an ID that can be retrieved via `getNewStories`
    func getStory(itemNumber: ItemID, callback: @escaping StoryCallback)
}
