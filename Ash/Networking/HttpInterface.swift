//
//  HttpInterface.swift
//  Ash
//
//  Created by Oliver ONeill on 4/2/18.
//

import UIKit

/// A protocol for making network requests
protocol HttpInterface {
    /// Make a network request asynchronously
    func makeRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?) -> Void)
}
