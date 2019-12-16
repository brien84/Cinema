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
    
    var url: URL? {
        didSet {
            self.loadImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImage(named: "placeholder")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        image = UIImage(named: "placeholder")
    }
    
    private func loadImage() {
        guard let url = url else {
            self.image = nil
            return
        }
        
        // If image data is found in cache.
        if let cachedData = cache.object(forKey: url.absoluteString as NSString) {
            guard let image = UIImage(data: cachedData as Data) else { return }
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    self?.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                    self?.image = image
                }
            }.resume()
        }
    }
}
