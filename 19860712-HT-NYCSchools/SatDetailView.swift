//
//  SatDetailView.swift
//  19860712-HT-NYCSchools
//
//  Created by Hamid on 3/7/18.
//  Copyright © 2018 PicBlast. All rights reserved.
//

import UIKit

class SatDetailView: UIView {
    // MARK: Constants
    private struct Constants {
        static let DefaultLayoutSpacing: CGFloat = 8.0
        static let PortraitHightDivisionFactor: CGFloat = 14.0
        static let LandscapeHightDivisionFactor: CGFloat = 8.0
    }
    
    
    // MARK: Instance vairables
    var highSchoolName: String? { didSet { updateUI() } }
    var location: String? { didSet { updateUI() } }
    var contactInfo: String? { didSet { updateUI() } }
    var mathScore: String? { didSet { updateUI() } }
    var readingScore: String? { didSet { updateUI() } }
    var writingScore: String? { didSet { updateUI() } }
    var totalParticipants: String? { didSet { updateUI() } }
    var isPortrait: Bool = true { didSet { updateUI()}}
    var heightCompensation: CGFloat? = 0 // for the height of navigation bar
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
   
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private var contactLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private var satInfoTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "SAT Summary"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private var totalParticipantsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var satMathScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private var satCriticalReadingScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private var satWritingScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    // MARK: - Helper functions
    private func setupViews() {
        layer.cornerRadius = 20.0
        if isPortrait {
            setupForPortrait()
        } else {
            setupForLandscape()
        }
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(contactLabel)
        addSubview(satInfoTitle)
        addSubview(totalParticipantsLabel)
        addSubview(satCriticalReadingScoreLabel)
        addSubview(satWritingScoreLabel)
        addSubview(satMathScoreLabel)
    }
    
    private func setupForPortrait() {
        var org = bounds.origin
        org.y += ((Constants.DefaultLayoutSpacing * 2) + (heightCompensation ?? 0) * 2)
        nameLabel.frame = CGRect(origin: org, size: CGSize(width: bounds.width , height: bounds.height / Constants.PortraitHightDivisionFactor))
        
        var frameForLocation = nameLabel.frame
        frameForLocation.origin.y += nameLabel.bounds.height + Constants.DefaultLayoutSpacing
        locationLabel.frame = frameForLocation
        
        var frameForContact = frameForLocation
        frameForContact.origin.y += locationLabel.bounds.height + Constants.DefaultLayoutSpacing
        contactLabel.frame = frameForContact
        
        var frameForSatInfoTitle = frameForContact
        frameForSatInfoTitle.origin.y += contactLabel.bounds.height + Constants.DefaultLayoutSpacing
        satInfoTitle.frame = frameForSatInfoTitle
        
        var frameForTotalParticipants = frameForSatInfoTitle
        frameForTotalParticipants.origin.y += satInfoTitle.bounds.height +  Constants.DefaultLayoutSpacing
        totalParticipantsLabel.frame = frameForTotalParticipants
        
        var frameForReadingLabel = frameForTotalParticipants
        frameForReadingLabel.origin.y += totalParticipantsLabel.bounds.height + Constants.DefaultLayoutSpacing
        satCriticalReadingScoreLabel.frame = frameForReadingLabel
        
        var frameForWritingLabel = frameForReadingLabel
        frameForWritingLabel.origin.y += satCriticalReadingScoreLabel.bounds.height + Constants.DefaultLayoutSpacing
        satWritingScoreLabel.frame = frameForWritingLabel
        
        var frameForMathLabel = frameForWritingLabel
        frameForMathLabel.origin.y +=  satWritingScoreLabel.bounds.height + Constants.DefaultLayoutSpacing
        satMathScoreLabel.frame = frameForMathLabel
    }
    
    private func setupForLandscape() {
        var org = bounds.origin
        org.y += ((Constants.DefaultLayoutSpacing * 2) + (heightCompensation ?? 0))
        nameLabel.frame = CGRect(origin: org, size: CGSize(width: (bounds.width / 2) - Constants.DefaultLayoutSpacing / 2 , height: bounds.height / Constants.LandscapeHightDivisionFactor))
        
        var frameForLocation = nameLabel.frame
        frameForLocation.origin.y += nameLabel.bounds.height + Constants.DefaultLayoutSpacing
        locationLabel.frame = frameForLocation
        
        var frameForContact = frameForLocation
        frameForContact.origin.y += locationLabel.bounds.height + Constants.DefaultLayoutSpacing
        contactLabel.frame = frameForContact
        
        var frameForSatInfoTitle = nameLabel.frame
        frameForSatInfoTitle.origin.x += contactLabel.bounds.width + Constants.DefaultLayoutSpacing
        satInfoTitle.frame = frameForSatInfoTitle
        
        var frameForTotalParticipants = frameForSatInfoTitle
        frameForTotalParticipants.origin.y += satInfoTitle.bounds.height +  Constants.DefaultLayoutSpacing
        totalParticipantsLabel.frame = frameForTotalParticipants
        
        var frameForReadingLabel = frameForTotalParticipants
        frameForReadingLabel.origin.y += totalParticipantsLabel.bounds.height + Constants.DefaultLayoutSpacing
        satCriticalReadingScoreLabel.frame = frameForReadingLabel
        
        var frameForWritingLabel = frameForReadingLabel
        frameForWritingLabel.origin.y += satCriticalReadingScoreLabel.bounds.height + Constants.DefaultLayoutSpacing
        satWritingScoreLabel.frame = frameForWritingLabel
        
        var frameForMathLabel = frameForWritingLabel
        frameForMathLabel.origin.y +=  satWritingScoreLabel.bounds.height + Constants.DefaultLayoutSpacing
        satMathScoreLabel.frame = frameForMathLabel
    }
    
    private func updateUI() {
        let defaultText = "Unknown"
        nameLabel.text = highSchoolName ?? defaultText
        locationLabel.text = location ?? defaultText
        contactLabel.text = contactInfo ?? defaultText
        
        satMathScoreLabel.text = "Math: \(mathScore ?? defaultText)"
        totalParticipantsLabel.text = "Total Test Takers: \(totalParticipants ?? defaultText)"
        satCriticalReadingScoreLabel.text = "Critical Reading: \(readingScore ?? defaultText)"
        satWritingScoreLabel.text = "Writing: \(writingScore ?? defaultText)"
    }
    
}
