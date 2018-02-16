//
//  StoryScreenViewData.swift
//  Ash
//
//  Created by Oliver ONeill on 3/2/18.
//

/// The states that the StoryScreenViewModel can be in
enum StoryScreenState {
    /// When loading a story
    case loading
    /// Once we've succesfully loaded a story
    case loaded(StoryViewData)
    /// Error case with message specified
    case error(String)
}

/**
 * View data for a `Story`. This contains the presentation format for a `Story`
 */
struct StoryViewData: Equatable {
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

    /// Used for testing
    static func ==(lhs: StoryViewData, rhs: StoryViewData) -> Bool {
        return lhs.authorText == rhs.authorText &&
            lhs.dateText == rhs.dateText && lhs.title == rhs.title &&
            lhs.url == rhs.url
    }
}

/**
 * View data for `StoryScreenViewController`. This is all the information needed
 * for the story screen
 */
struct StoryScreenViewData: Equatable {
    // Values
    let errorMessageText: String?
    let titleLabelText: String?
    let authorLabelText: String?
    let dateLabelText: String?
    // Hidden and visible views
    let titleLabelHidden: Bool
    let authorLabelHidden: Bool
    let dateLabelHidden: Bool
    let errorMessageLabelHidden: Bool
    let backgroundButtonHidden: Bool
    let refreshButtonHidden: Bool
    /// Whether the loading spinner is displayed or not
    let activityIndicatorAnimated: Bool
    /// Whether the status bar network activity indicator is displayed or not
    let statusBarActivityIndicatorAnimated: Bool

    /// This is private so that you must specify the view based on the state
    private init(titleLabelText: String?,
                 authorLabelText: String?,
                 dateLabelText: String?,
                 errorMessageText: String? = nil,
                 activityIndicatorAnimated: Bool = false,
                 statusBarActivityIndicatorAnimated: Bool = false,
                 errorMessageLabelHidden: Bool = true,
                 refreshButtonHidden: Bool = true,
                 titleLabelHidden: Bool = true,
                 authorLabelHidden: Bool = true,
                 dateLabelHidden: Bool = true,
                 backgroundButtonHidden: Bool = true) {
        self.errorMessageText = errorMessageText
        self.titleLabelText = titleLabelText
        self.authorLabelText = authorLabelText
        self.dateLabelText = dateLabelText
        // This will determine if the loading spinner is spinning and animated
        self.activityIndicatorAnimated = activityIndicatorAnimated
        self.statusBarActivityIndicatorAnimated = statusBarActivityIndicatorAnimated
        // Whether the views are visible or hidden
        self.titleLabelHidden = titleLabelHidden
        self.authorLabelHidden = authorLabelHidden
        self.dateLabelHidden = dateLabelHidden
        self.errorMessageLabelHidden = errorMessageLabelHidden
        self.backgroundButtonHidden = backgroundButtonHidden
        self.refreshButtonHidden = refreshButtonHidden
    }

    init(state: StoryScreenState) {
        // Convert the state into a set of properties that define how the view
        // will appear
        switch state {
        case .loading:
            self.init(
                titleLabelText: nil, authorLabelText: nil,
                dateLabelText: nil, errorMessageText: nil,
                activityIndicatorAnimated: true,
                statusBarActivityIndicatorAnimated: true
            )
            break
        case .error(let message):
            self.init(
                titleLabelText: nil, authorLabelText: nil,
                dateLabelText: nil, errorMessageText: message,
                errorMessageLabelHidden: false, refreshButtonHidden: false
            )
            break
        case .loaded(let story):
            self.init(
                titleLabelText: story.title,
                authorLabelText: story.authorText,
                dateLabelText: story.dateText,
                errorMessageText: nil,
                activityIndicatorAnimated: false,
                statusBarActivityIndicatorAnimated: false,
                errorMessageLabelHidden: true,
                refreshButtonHidden: false,
                titleLabelHidden: false,
                authorLabelHidden: false,
                dateLabelHidden: false,
                backgroundButtonHidden: false
            )
            break
        }
    }

    /// Used for testing
    static func ==(lhs: StoryScreenViewData, rhs: StoryScreenViewData) -> Bool {
        // Check every single property
        return lhs.errorMessageText == rhs.errorMessageText &&
            lhs.titleLabelText == rhs.titleLabelText &&
            lhs.authorLabelText == rhs.authorLabelText &&
            lhs.dateLabelText == rhs.dateLabelText &&
            lhs.titleLabelHidden == rhs.titleLabelHidden &&
            lhs.authorLabelHidden == rhs.authorLabelHidden &&
            lhs.dateLabelHidden == rhs.dateLabelHidden &&
            lhs.errorMessageLabelHidden == rhs.errorMessageLabelHidden &&
            lhs.backgroundButtonHidden == rhs.backgroundButtonHidden &&
            lhs.refreshButtonHidden == rhs.refreshButtonHidden &&
            lhs.activityIndicatorAnimated == rhs.activityIndicatorAnimated &&
            lhs.statusBarActivityIndicatorAnimated == rhs.statusBarActivityIndicatorAnimated
    }
}
