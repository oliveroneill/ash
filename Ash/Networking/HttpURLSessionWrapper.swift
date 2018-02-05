//
//  HttpURLSessionWrapper.swift
//  Ash
//
//  Created by Oliver ONeill on 4/2/18.
//

import UIKit

/// `URLSession` wrapper that conforms to `HttpInterface`
class HttpURLSessionWrapper: HttpInterface {
    /// Make a request as you would via `URLSession`. This will return
    /// immediately and send the response via the callback.
    func makeRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: callback)
        task.resume()
    }
}
