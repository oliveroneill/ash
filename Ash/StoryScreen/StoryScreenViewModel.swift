//
//  StoryViewModel.swift
//  Ash
//
//  Created by Oliver ONeill on 3/2/18.
//

import UIKit

/// The states that the StoryScreenViewModel can be in
enum StoryScreenState {
    /// When loading a story
    case loading
    /// Once we've succesfully loaded a story
    case loaded(StoryViewModel)
    /// Error case with message specified
    case error(String)
}

/**
 * A view model for `Story`. This contains the presentation format for a `Story`
 */
struct StoryViewModel: Equatable {
    let authorText: String
    let dateText: String
    let title: String
    let url: String

    init(story: Story) {
        authorText = "By \(story.by)"
        dateText = story.time.timeAgo()
        title = story.title
        url = story.url
    }

    static func ==(lhs: StoryViewModel, rhs: StoryViewModel) -> Bool {
        return lhs.authorText == rhs.authorText &&
            lhs.dateText == rhs.dateText && lhs.title == rhs.title &&
            lhs.url == rhs.url
    }
}

/**
 * A view model for `StoryScreenViewController`. This contains the interaction
 * logic for the controller and sends `StoryViewModel`s to the controller for
 * presentation.
 */

class StoryScreenViewModel {
    /// Set this property to receive state change events
    var onStateChange: ((StoryScreenState) -> Void)?
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
                self.onStateChange?(.error("Something went wrong."))
                return
            }
            // Open the URL in the browser
            // TODO: this may be considered view code
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func changeState(state: StoryScreenState) {
        currentState = state
        onStateChange?(state)
    }

    private func loadNewStory() {
        // Set the state to loading
        self.changeState(state: .loading)
        // Get new stories from the API
        api.getNewStories { [unowned self] (stories) in
            if stories.count == 0 {
                self.changeState(state: .error("Something went wrong."))
            }
            // Get random stories from the list of new ones
            let randomIndex = Int(arc4random_uniform(UInt32(stories.count)))
            let randomID = stories[randomIndex]
            // Request story info
            self.api.getStory(itemNumber: randomID, callback: { (story) in
                // Ensure we successfully received a story
                guard let s = story else {
                    self.changeState(state: .error("Something went wrong."))
                    return
                }
                // Update the state using view model
                let viewModel = StoryViewModel(story: s)
                self.changeState(state: .loaded(viewModel))
            })
        }
    }
}
