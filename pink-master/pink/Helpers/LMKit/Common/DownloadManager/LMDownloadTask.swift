import Foundation
class LMDownloadTask: Operation {
    let url: URL
    let destinationURL: URL
    var progress: Progress = Progress()
    var completionHandler: ((URL?, Error?) -> Void)?
    init(url: URL, destinationURL: URL, completionHandler: @escaping (URL?, Error?) -> Void) {
        self.url = url
        self.destinationURL = destinationURL
        self.completionHandler = completionHandler
        super.init()
    }
    override func main() {
        if isCancelled {
            return
        }
        let session = URLSession(configuration: .default)
        let downloadTask = session.downloadTask(with: url) { (temporaryURL, _, error) in
            if let error = error {
                self.completionHandler?(nil, error)
                return
            }
            guard let temporaryURL = temporaryURL else {
                self.completionHandler?(nil, NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Temporary file URL is nil"]))
                return
            }
            do {
                try FileManager.default.moveItem(at: temporaryURL, to: self.destinationURL)
                self.completionHandler?(self.destinationURL, nil)
            } catch let error {
                self.completionHandler?(nil, error)
            }
        }
        downloadTask.resume()
    }
}
