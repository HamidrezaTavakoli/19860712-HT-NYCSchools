//
//  ViewController.swift
//  19860712-HT-NYCSchools
//
//  Created by Hamid on 3/6/18.
//  Copyright © 2018 PicBlast. All rights reserved.
//

import UIKit

class SchoolsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /*
     We can present the detail information using a segue (a popover) as well, but I think the application looks better and privides a much better UX if we use a custom animation for showing the details (as it has been done here)
     Given more time, the application can provide a much better UX if a search controller is added to it (remains for the future)
     */
    
    // MARK: - Constants
    private struct Constants {
        static let HighSchoolCellReusableIdentifire = "highschool cell"
        static let SchoolDetailViewControllerSegueIdentifier = "show details"
        static let StandardStoryboardMarginValue: CGFloat = 16.0
        static let AnimationDuration: TimeInterval = 0.5
        static let TransitionAnimationDuration: TimeInterval = 0.1
        static let TableViewCornerRadius: CGFloat = 20.0
    }
    
    // MARK: model
    private var highSchools: [NYCHighSchool]? {
        didSet {
            DispatchQueue.main.async {
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
    // MARK: Instance Variables
    private var highSchoolInfoObserver: NSObjectProtocol?
    private var spinner: UIActivityIndicatorView?
    private var backButton: UIBarButtonItem?
    private var blurView: UIView?
    private var detailView: SatDetailView?
    private var initialFrameForDetailViewAnimation: CGRect?
    private var finalFrameForDetailViewAnimation: CGRect?
    private var lightBlueColor = UIColor(patternImage: #imageLiteral(resourceName: "lightblue"))
    private var lightYellowColor = UIColor(patternImage: #imageLiteral(resourceName: "lightyellow"))
    private var deviceIsPortrait = true {
        didSet {
            detailView?.isPortrait = deviceIsPortrait ? true : false
            detailView?.heightCompensation = navigationController?.navigationBar.bounds.height
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layer.cornerRadius = Constants.TableViewCornerRadius
            tableView.backgroundColor = UIColor.clear // no white background during the initial load
        }
    }

    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        view.backgroundColor = lightBlueColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        highSchoolInfoObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.NYCOpenDataAPIClientReceivedHighSchoolData,
            object: NYCOpenDataAPIClient.sharedInstance,
            queue: nil) { (notification) in
                self.highSchools = NYCOpenDataAPIClient.sharedInstance?.getAllHighSchools()
        }
        NYCOpenDataAPIClient.sharedInstance?.loadNYCHighSchoolData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if spinner == nil {
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinner!.frame = CGRect(center: view.bounds.mid, size: spinner!.intrinsicContentSize)
            spinner!.hidesWhenStopped = true
            spinner!.startAnimating()
            view.addSubview(spinner!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deviceIsPortrait = UIDevice.current.orientation.isPortrait ? true : false
        detailView = SatDetailView(frame: CGRect(center: view.bounds.mid,
                                                 size: CGSize(width: view.bounds.width * 2 / 3, height: view.bounds.height * 2 / 3)))
        detailView?.heightCompensation = self.navigationController?.navigationBar.bounds.height
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(highSchoolInfoObserver as Any)
    }
    
}
// MARK: TableView Delegate and DataSource
extension SchoolsTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highSchools?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HighSchoolCellReusableIdentifire, for: indexPath)
        if let highSchool = highSchools?[indexPath.row] {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = highSchool.name
            cell.detailTextLabel?.text = highSchool.city
        }
        cell.backgroundColor = lightYellowColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let school = highSchools?[indexPath.row] {
            for subview in cell.subviews {
                if subview is UIButton {
                    initialFrameForDetailViewAnimation = cell.convert(subview.frame, to: view) // getting the frame of the disclosure button
                    detailView?.highSchoolName = school.name
                    detailView?.location = school.location
                    detailView?.contactInfo = "\(school.email)\n\(school.phoneNumber)"
                    if let satInfo = NYCOpenDataAPIClient.sharedInstance?.getSATScoreForHighSchool(name: school.name) {
                        detailView?.totalParticipants = "\(satInfo.numberOfSatTakers)"
                        detailView?.mathScore = "\(satInfo.avarageSatMathScore)"
                        detailView?.readingScore = "\(satInfo.avarageSatCriticalReadingScore)"
                        detailView?.writingScore = "\(satInfo.avarageSatWritingScore)"
                    }
                    detailView?.frame = initialFrameForDetailViewAnimation! // just got initialized
                    blurView?.frame = initialFrameForDetailViewAnimation!
                    finalFrameForDetailViewAnimation = CGRect(center: view.bounds.mid,
                                                              size: CGSize(width: view.bounds.width - (2 * Constants.StandardStoryboardMarginValue), height: view.bounds.height - (2 * Constants.StandardStoryboardMarginValue)))
                    detailView?.isPortrait = deviceIsPortrait ? true : false
                    detailView?.alpha = 1.0
                    blurView?.alpha = 1.0
                    blurView?.isHidden = false
                    detailView?.isHidden = false
                    view.addSubview(blurView!)
                    view.addSubview(detailView!)
                    UIView.animate(withDuration: Constants.AnimationDuration, animations: {
                        self.blurView?.frame = self.view.bounds
                        self.detailView?.frame = self.finalFrameForDetailViewAnimation! // will never be nil here, and no memory cycle
                    }, completion: { (_) in
                        self.navigationItem.leftBarButtonItem = self.backButton
                    })
                }
            }
        }
    }
}
// MARK: Helper Functions
extension SchoolsTableViewController {
    @objc func goBack() {
        performDismissAnimation()
    }
    
    private func performDismissAnimation() {
        UIView.animate(withDuration: Constants.AnimationDuration, animations: {
            self.blurView?.frame = self.initialFrameForDetailViewAnimation! // it will never be nil here and no memory cycle
            self.detailView?.frame = self.initialFrameForDetailViewAnimation!
            self.detailView?.alpha = 0.2
            self.blurView?.alpha = 0.2
            
        }, completion: { (_) in
            self.blurView?.isHidden = true
            self.detailView?.isHidden = true
            self.blurView?.removeFromSuperview()
            self.detailView?.removeFromSuperview()
            self.cleanupDetailView()
            self.navigationItem.leftBarButtonItem = nil
        })
    }
    
    private func cleanupDetailView() {
        detailView?.highSchoolName = nil
        detailView?.location = nil
        detailView?.contactInfo = nil
        detailView?.totalParticipants = nil
        detailView?.mathScore = nil
        detailView?.readingScore = nil
        detailView?.writingScore = nil
    }
    
    private func handleRotation() {
        let frameForTransition = CGRect(center: view.bounds.mid,
                                        size: CGSize(width: view.bounds.width - (2 * Constants.StandardStoryboardMarginValue),
                                                     height: view.bounds.height - (2 * Constants.StandardStoryboardMarginValue)))
        UIView.animate(withDuration: Constants.TransitionAnimationDuration, animations: {
            self.blurView?.frame = self.view.bounds
            self.detailView?.frame = frameForTransition
        }, completion: { (_) in
            self.detailView?.setNeedsDisplay()
        })
    }
}

// MARK: Orientation handling
extension SchoolsTableViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let duration = coordinator.transitionDuration - (coordinator.transitionDuration + 0.05)
        if UIDevice.current.orientation.isPortrait {
            deviceIsPortrait = true
        } else {
            deviceIsPortrait = false
        }
        if blurView != nil, detailView != nil {
            if !blurView!.isHidden, !detailView!.isHidden {
                Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: {(timer) in
                    self.handleRotation()
                    timer.invalidate()
                })
            }
        }
        
    }
}

