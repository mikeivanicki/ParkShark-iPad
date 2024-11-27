//
//  LotAnnotationView.swift
//  iPad Testing
//
//  Created by Michael Ivanicki on 10/16/24.
//

import UIKit
import MapKit

class LotAnnotationView: MKAnnotationView {

    static let reuseIdentifier = "CustomAnnotationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        // Configure the custom annotation view
    private func setupUI() {
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        // Create the blue box
        //let lightBlueBox = UIView(frame: self.bounds)
        let lightBlueBox = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 70))
        
        let lightBlue = UIColor(red: 243/255.0, green: 250/255.0, blue: 255/255.0, alpha: 1.0)
        
        let darkBlue = UIColor(red: 0/255.0, green: 0/255.0, blue: 54/255.0, alpha: 1.0)
        
        lightBlueBox.backgroundColor = lightBlue
       
        lightBlueBox.layer.cornerRadius = 5
        lightBlueBox.clipsToBounds = true
        addSubview(lightBlueBox)
        
        let padding: CGFloat = 10
        
        // Add the text label
        let label = UILabel(frame: lightBlueBox.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = darkBlue
        label.numberOfLines = 0
        label.text = (annotation?.title ?? "") ?? ""
        lightBlueBox.addSubview(label)
        
        // Add the subtitle
        let subtitle = UILabel(frame: lightBlueBox.bounds)
        subtitle.textAlignment = .center
        subtitle.font = UIFont.systemFont(ofSize: 15)
        subtitle.textColor = darkBlue
        subtitle.numberOfLines = 1
        subtitle.text = (annotation?.subtitle ?? "") ?? ""
        lightBlueBox.addSubview(subtitle)
        
        // Add title and subtitle to stack view
        let stackView = UIStackView(arrangedSubviews: [label, subtitle])
                stackView.axis = .vertical
                stackView.alignment = .center
                stackView.distribution = .equalSpacing
                stackView.spacing = 5
                
                // Set stack view frame with padding
                stackView.frame = CGRect(x: padding, y: padding, width: lightBlueBox.bounds.width - 2 * padding, height: lightBlueBox.bounds.height - 2 * padding) // Adjusted frame to include padding
                
                lightBlueBox.addSubview(stackView)
    }
}
