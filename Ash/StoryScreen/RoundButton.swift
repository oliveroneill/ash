//
//  RoundButton.swift
//  Ash
//
//  Created by Oliver ONeill on 4/2/18.
//

import UIKit

/**
 * A UIButton with rounded edges. This is rendered in storyboards and editable
 * within the Identity Inspector.
 */
@IBDesignable
class RoundButton: UIButton {
    /// Keep track of the original background colour, so that it can be
    /// modified on button press
    private var originalBackgroundColor: UIColor?
    override open var isHighlighted: Bool {
        didSet {
            // Store it on first press
            // TODO: we should store it earlier than this
            if originalBackgroundColor == nil {
                originalBackgroundColor = backgroundColor
            }
            // Switch between the original color and the tint color
            backgroundColor = isHighlighted ? tintColor : originalBackgroundColor
        }
    }
    /// Set how rounded the edges should be
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}

