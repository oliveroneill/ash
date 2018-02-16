//
//  StoryScreenViewModel.swift
//  Ash
//
//  Created by Oliver ONeill on 10/2/18.
//  Copyright © 2018 Oliver ONeill. All rights reserved.
//

import UIKit

struct AshConstants {
    static let genericErrorMessage = "Something went wrong."
}
/**
 * A view model for `StoryScreenViewController`. This contains the interaction
 * logic for the controller and sends `StoryScreenViewData`s to the
 * view-controller for presentation.
 */
class StoryScreenViewModel {
    /// Set this property to receive state change events
    var onViewUpdate: ((StoryScreenViewData) -> Void)?
    private let api: StoryAPI
    // The current state of the view model
    private var currentState: StoryScreenState = .loading

    /**
     * Create a StoryScreenViewModel.
     *
     * - Parameter api: Used to interact with the network
     */
    init(api: StoryAPI = HackerNewsAPI()) {
        self.api = api
    }

    /**
     * Called when the view is on screen
     */
    func onViewAppeared() {
        loadNewStory()
    }

    /**
     * Refresh the currently displayed story
     */
    func refresh() {
        loadNewStory()
    }

    /**
     * Called when a story is pressed. This should open the story in the browser
     */
    func onStoryPressed() {
        // Ensure we've successfully loaded a story before allowing press
        if case .loaded(let story) = currentState {
            // Check URL
            guard let url = URL(string: story.url) else {
                changeState(state: .error(AshConstants.genericErrorMessage))
                return
            }
            // Open the URL in the browser
            // TODO: this may be considered view code. It probably makes sense
            // to have a coordinator class that does this.
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func changeState(state: StoryScreenState) {
        currentState = state
        onViewUpdate?(StoryScreenViewData(state: state))
    }

    private func loadNewStory() {
        // Set the state to loading
        self.changeState(state: .loading)
        // Get new stories from the API
        api.getNewStories { [unowned self] (stories) in
            if stories.count == 0 {
                self.changeState(state: .error(AshConstants.genericErrorMessage))
                return
            }
            // Get random stories from the list of new ones
            let randomIndex = Int(arc4random_uniform(UInt32(stories.count)))
            let randomID = stories[randomIndex]
            // Request story info
            self.api.getStory(itemNumber: randomID, callback: { (story) in
                // Ensure we successfully received a story
                guard let s = story else {
                    self.changeState(state: .error(AshConstants.genericErrorMessage))
                    return
                }
                // Update the state using new view data
                let viewData = StoryViewData(story: s)
                self.changeState(state: .loaded(viewData))
            })
        }
    }
}
