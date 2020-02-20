//
//  NetworkImageView.swift
//  Cinema
//
//  Created by Marius on 17/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

/// View for downloading and displaying images.
/// When url property is set, it first checks if image is cached, then either
/// displays image from cache or downloads image.
///
/// - Note: Images are cached as Data to significantly lower memory usage.
final class NetworkImageView: UIImageView {

    private let cache = NSCache<NSString, NSData>()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.startAnimating()
        indicator.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.addSubview(indicator)

        return indicator
    }()

    override var image: UIImage? {
        didSet {
            image == nil ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    var url: URL? {
        didSet {
            loadImage()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        activityIndicator.center = self.center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadImage() {
        guard let url = url else {
            set(.defaultImage)
            return
        }

        /// If image data is found in cache.
        if let cachedData = cache.object(forKey: url.absoluteString as NSString) {
            guard let image = UIImage(data: cachedData as Data) else { return }

            if url == self.url {
                set(image)
            }

        } else {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                self?.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    if url == self?.url {
                        self?.set(image)
                    }
                }

            }.resume()
        }
    }

    private func set(_ image: UIImage?) {
        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}

extension UIImage {
    fileprivate static let defaultImage = UIImage(named: "networkImageViewDefault")!
}
