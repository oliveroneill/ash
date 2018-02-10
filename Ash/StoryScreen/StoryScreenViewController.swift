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
    private let viewModel = StoryScreenDataSource()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var backgroundButton: RoundButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewModelChange = { [unowned self] (viewModel) in
            self.onViewModelChange(viewModel: viewModel)
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

    private func onViewModelChange(viewModel: StoryScreenViewModel) {
        // Change state on main thread
        DispatchQueue.main.async(execute: { [unowned self] in
            // Set all view values based on the view model
            if viewModel.activityIndicatorAnimated {
                self.setNetworkActivityIndicator()
                self.activityIndicator.startAnimating()
            } else {
                self.setNetworkActivityIndicator(visible: false)
                self.activityIndicator.stopAnimating()
            }
            // Text values
            self.titleLabel.text = viewModel.titleLabelText
            self.authorLabel.text = viewModel.authorLabelText
            self.dateLabel.text = viewModel.dateLabelText
            self.errorMessageLabel.text = viewModel.errorMessageText
            // Which views are being displayed
            self.errorMessageLabel.isHidden = viewModel.errorMessageLabelHidden
            self.refreshButton.isHidden = viewModel.refreshButtonHidden
            self.titleLabel.isHidden = viewModel.titleLabelHidden
            self.authorLabel.isHidden = viewModel.authorLabelHidden
            self.dateLabel.isHidden = viewModel.dateLabelHidden
            self.backgroundButton.isHidden = viewModel.backgroundButtonHidden
        })
    }

    private func setNetworkActivityIndicator(visible: Bool = true) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
}
