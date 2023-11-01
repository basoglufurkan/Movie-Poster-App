//
//  DetailsViewController.swift
//  Movie Poster App
//
//  Created by Furkan BAŞOĞLU on 1.11.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var imageUrl: String = ""
    var titleStr: String = ""
    var subTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let imag = drawImage()
        let title = drawTitle(imag.bottomAnchor, nil)
        drawSubtitle(title.bottomAnchor, nil)
        Services.shared.image(poster: imageUrl) { data  in
            let img = image(data: data)
            DispatchQueue.main.async {
                imag.image = img
            }
        }
    }
    
    func drawTitle(_ topAnchor: NSLayoutYAxisAnchor, _ bottomAnchor: NSLayoutYAxisAnchor?)-> UILabel {
        let lblTitle = UILabel()
        lblTitle.text = self.titleStr
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        self.view.addSubview(lblTitle)
        lblTitle.textAlignment = .center
        lblTitle.textColor = .black
        lblTitle.font = .boldSystemFont(ofSize: 20)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if let anchor = bottomAnchor {
            lblTitle.bottomAnchor.constraint(equalTo: anchor).isActive = true
        }
        lblTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        return lblTitle
    }
    
    func drawSubtitle(_ topAnchor: NSLayoutYAxisAnchor, _ bottomAnchor: NSLayoutYAxisAnchor?) {
        let lblTitle = UILabel()
        lblTitle.text = self.subTitle
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        self.view.addSubview(lblTitle)
        lblTitle.textAlignment = .center
        lblTitle.textColor = .black
        lblTitle.font = .systemFont(ofSize: 14)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if let anchor = bottomAnchor {
            lblTitle.bottomAnchor.constraint(equalTo: anchor).isActive = true
        }
        lblTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func drawImage()-> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 40, y: 40, width: UIScreen.main.bounds.width-80, height: 150))
        imageView.image = UIImage(named: "img")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        return imageView
    }

}
