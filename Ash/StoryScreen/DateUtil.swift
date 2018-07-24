//
//  DateUtil.swift
//  Ash
//
//  Created by Oliver ONeill on 4/2/18.
//

import UIKit

/**
 * Courtesy of Linus Oleander
 * See: https://gist.github.com/minorbug/468790060810e0d29545#gistcomment-2272953
 */
extension Date {
    private struct Item {
        /// The plural form of the human readable time since self
        let plural: String
        /// The singular form of the human readable time since self
        let single: String
        /// The number of days/weeks/months etc. since date
        let value: Int?
    }

    /// Returns the components from self to now
    private var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: self,
            to: Date()
        )
    }

    /// Lazy load human readable components since self
    private var items: [Item] {
        return [
            Item(plural: "years ago", single: "1 year ago", value: components.year),
            Item(plural: "months ago", single: "1 month ago", value: components.month),
            Item(plural: "weeks ago", single: "1 week ago", value: components.weekday),
            Item(plural: "days ago", single: "1 day ago", value: components.day),
            Item(plural: "minutes ago", single: "1 minute ago", value: components.minute),
            Item(plural: "seconds ago", single: "Just now", value: components.second)
        ]
    }

    /// Get how long ago this date was in human readable form, ie. the time
    /// since now.
    ///
    /// - Returns: human readable form of time between this date and now
    func timeAgo() -> String {
        // Run through all of them items that make up this date. These are
        // all lazy loaded to ensure the latest date is used
        for item in items {
            switch (item.value) {
            case let .some(step) where step == 0:
                continue
            case let .some(step) where step == 1:
                return item.single
            case let .some(step):
                return String(step) + " " + item.plural
            default:
                continue
            }
        }
        return "Just now"
    }
}

