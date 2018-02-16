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
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewUpdate = { [weak self] (viewData) in
            self?.onViewUpdate(viewData: viewData)
        }
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

    private func onViewUpdate(viewData: StoryScreenViewData) {
        // Change state on main thread
        DispatchQueue.main.async(execute: { [unowned self] in
            // Set all view values based on the view model
            if viewData.activityIndicatorAnimated {
                self.setNetworkActivityIndicator()
                self.activityIndicator.startAnimating()
            } else {
                self.setNetworkActivityIndicator(visible: false)
                self.activityIndicator.stopAnimating()
            }
            // Text values
            self.titleLabel.text = viewData.titleLabelText
            self.authorLabel.text = viewData.authorLabelText
            self.dateLabel.text = viewData.dateLabelText
            self.errorMessageLabel.text = viewData.errorMessageText
            // Which views are being displayed
            self.errorMessageLabel.isHidden = viewData.errorMessageLabelHidden
            self.refreshButton.isHidden = viewData.refreshButtonHidden
            self.titleLabel.isHidden = viewData.titleLabelHidden
            self.authorLabel.isHidden = viewData.authorLabelHidden
            self.dateLabel.isHidden = viewData.dateLabelHidden
            self.backgroundButton.isHidden = viewData.backgroundButtonHidden
        })
    }

    private func setNetworkActivityIndicator(visible: Bool = true) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
}
