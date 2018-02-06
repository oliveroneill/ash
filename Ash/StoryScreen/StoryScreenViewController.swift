//
//  StoryViewController
//  Ash
//
//  Created by Oliver ONeill on 3/2/18.
//

import UIKit

/**
 * StoryScreenViewController shows a story that can be pressed to open in the
 * browser.
 *
 * TODO: don't use storyboards, I think this would be nicer to set up the views
 * entirely in code.
 */
class StoryScreenViewController: UIViewController {
    private let viewModel = StoryScreenViewModel()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var backgroundButton: RoundButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onStateChange = self.onStateChange
        viewModel.onViewAppeared()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onRefreshPressed(_ sender: AnyObject) {
        viewModel.refresh()
    }

    @IBAction func onButtonPressed(_ sender: AnyObject) {
        viewModel.onStoryPressed()
    }

    private func onStateChange(state: StoryScreenState) {
        // Change state on main thread
        DispatchQueue.main.async(execute: { [unowned self] in
            // Clear all views
            self.clearScreen()
            // Run through states
            switch state {
            case .loading:
                self.startLoading()
                break
            case .error(let message):
                self.showError(message: message)
                break
            case .loaded(let story):
                self.showStory(story: story)
                break
            }
        })
    }

    private func clearScreen() {
        // hide views
        titleLabel.isHidden = true
        authorLabel.isHidden = true
        dateLabel.isHidden = true
        errorMessageLabel.isHidden = true
        backgroundButton.isHidden = true
        stopLoading()
    }

    private func startLoading() {
        setNetworkActivityIndicator()
        activityIndicator.startAnimating()
    }

    private func stopLoading() {
        setNetworkActivityIndicator(visible: false)
        activityIndicator.stopAnimating()
    }

    private func showError(message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }

    private func showStory(story: StoryViewModel) {
        // Show views
        titleLabel.isHidden = false
        authorLabel.isHidden = false
        dateLabel.isHidden = false
        backgroundButton.isHidden = false
        // Set values
        titleLabel.text = story.title
        authorLabel.text = story.authorText
        dateLabel.text = story.dateText
    }

    private func setNetworkActivityIndicator(visible: Bool = true) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
}
