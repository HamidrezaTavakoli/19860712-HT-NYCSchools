//
//  NYCOpenDataAPIClient.swift
//  19860712-HT-NYCSchools
//
//  Created by Hamid on 3/6/18.
//  Copyright © 2018 PicBlast. All rights reserved.
//

import Foundation

class NYCOpenDataAPIClient {
    // MARK: - Constants
    private struct APIKeysAndEndpoints {
        static let AppToken = " "
        static let HighSchoolsInfoEndpoint = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
        static let SatScoresInfoEndpoint = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    }
    
    // MARK: Initialization -- the only instance is available through sharedInstance
    private init() {
        // forcing singleton
    }
    
    static var sharedInstance: NYCOpenDataAPIClient? {
        get {
            if _sharedInstance ==  nil {
                _sharedInstance = NYCOpenDataAPIClient()
            }
            return _sharedInstance
        }
    }
    private static var _sharedInstance: NYCOpenDataAPIClient?
    // MARK: Instance Variables
    private var highSchoolData: [String:NYCHighSchool]? // nameOfSchool:NYCHighSchool(struct)
    private var highSchoolSatInfo: [String:NYCHighSchoolSatInfo]? // nameOfSchool: NYCHighSchoolSatInfo(struct)
    
    // only one of the two will ever send the notification and at that time both the general info and the SAT scores are here
    private var didFinishLoadingGeneralInfo = false {
        didSet {
            if didFinishLoadingGeneralInfo && didFinishLoadingSATInfo  {
                NotificationCenter.default.post(name: .NYCOpenDataAPIClientReceivedHighSchoolData, object: NYCOpenDataAPIClient.sharedInstance)
            }
        }
    }
    private var didFinishLoadingSATInfo = false {
        didSet {
            if didFinishLoadingGeneralInfo && didFinishLoadingSATInfo  {
                NotificationCenter.default.post(name: .NYCOpenDataAPIClientReceivedHighSchoolData, object: NYCOpenDataAPIClient.sharedInstance)
            }
        }
    }
    
    private var highSchoolInfoAPIManager = NYCHighSchoolAPIManager(
        endpoint:APIKeysAndEndpoints.HighSchoolsInfoEndpoint,
        token: APIKeysAndEndpoints.AppToken,
        httpMethod: "GET")
    private var highSchoolSatInfoAPIManager = NYCHighSchoolAPIManager(
        endpoint: APIKeysAndEndpoints.SatScoresInfoEndpoint,
        token: APIKeysAndEndpoints.AppToken,
        httpMethod: "GET")
    
    // MARK: API
    func loadNYCHighSchoolData() {
        // If this was a commercial applicaiton we could have saved the retreievd data with a proper scheme in CoreData so we don't have to fetch the data from network every time
        loadHighSchoolGeneralInfo()
        loadHighSchoolSatInfo()
    }
    
    func getAllHighSchools() -> [NYCHighSchool]? {
        var highSchoolsInfo: [NYCHighSchool]?
        if  highSchoolData != nil {
            let sortedInfo = highSchoolData!.sorted(by: {$0.0 < $1.0}) // sorting based on highschool names
            highSchoolsInfo = [NYCHighSchool]()
            for (_,highSchool) in sortedInfo {
                highSchoolsInfo?.append(highSchool)
            }
        }
        return highSchoolsInfo
    }
    
    func getNYCHighSchool(name: String) -> NYCHighSchool? {
        return highSchoolData?[name]
    }
    
    func getSATScoreForHighSchool(name: String) -> NYCHighSchoolSatInfo? {
        let nameUppercase = name.uppercased()
        return highSchoolSatInfo?[nameUppercase]
    }
    
    
    // MARK: Helper Functions
    private func loadHighSchoolGeneralInfo() {
        // loading the high school's general info
        highSchoolInfoAPIManager.loadDataInBackground {[weak self] (results, error) in
            if error == nil, results != nil {
                var parsedHighSchools = [String:NYCHighSchool]()
                for highSchoolInfo in results! {
                    let highSchool = NYCHighSchool(jsonFormat: highSchoolInfo)
                    let name = highSchool.name
                    parsedHighSchools[name] = highSchool
                }
                self?.highSchoolData = parsedHighSchools
                self?.didFinishLoadingGeneralInfo = true
            } else {
                // We can send a notification so our controller can present an alert or some other appropriate feed back to the user -- for just a demo we only print it
                print("Unable to load the data for high schools with erorr: \(String(describing: error))")
            }
        }
    }
    
    private func loadHighSchoolSatInfo() {
        // loading the high school's SAT info
        highSchoolSatInfoAPIManager.loadDataInBackground {[weak self] (results, error) in
            if error ==  nil, results != nil {
                var parsedSatInfo = [String: NYCHighSchoolSatInfo]()
                for satInfo in results! {
                    let highSchoolSatInfo = NYCHighSchoolSatInfo(jsonFormat: satInfo)
                    let schoolName = highSchoolSatInfo.schoolName
                    parsedSatInfo[schoolName] = highSchoolSatInfo
                }
                self?.highSchoolSatInfo = parsedSatInfo
                self?.didFinishLoadingSATInfo = true
            } else {
                // We can send a notification so our controller can present an alert or some other appropriate feed back to the user -- for just a demo we only print it
                print("Unable to load the data for SAT with erorr: \(String(describing: error))")
            }
        }
    }
    
}

fileprivate class NYCHighSchoolAPIManager {
    
    // MARK: Constants
    private static let ApiAppTokenHeader = "app_token"
    
    // MARK: Instance Variables
    private var endpoint: String
    private var token: String
    private var httpMethod: String
    init(endpoint: String, token: String, httpMethod: String) {
        self.endpoint = endpoint
        self.token = token
        self.httpMethod = httpMethod
    }
    
    fileprivate func loadDataInBackground(withCompletion completion: @escaping ( [[String: String]]?, Error?)->Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: self.endpoint) {
                let request = NSMutableURLRequest(url: url)
                request.setValue(self.token, forHTTPHeaderField: NYCHighSchoolAPIManager.ApiAppTokenHeader)
                request.httpMethod = self.httpMethod
                URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    if error == nil, data != nil {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!)
                            // the API response is an array of json objects
                            if let receivedJsonArray = json as? [[String:String]] {
                                completion(receivedJsonArray,nil)
                            } else {
                                let parsingError = NSError(domain: "Unable to parse the JSON data.", code: 103, userInfo: nil)
                                completion(nil,parsingError)
                            }
                        } catch let tryError {
                            completion(nil,tryError)
                        }
                    } else {
                        completion(nil,error)
                    }
                }).resume()
                
                
            } else {
                // we need to come up with a struct that holds all of the constants for our custom error messages and their corresponding codes -- but it is hardcoded since this is just a demo
                let endpointError = NSError(domain: "Please check the provided endpoint", code: 101, userInfo: nil)
                completion(nil, endpointError)
            }
        }
    }
}

extension Notification.Name {
    static let NYCOpenDataAPIClientReceivedHighSchoolData = NSNotification.Name("NYCOpenDataAPIClientReceivedHighSchoolData")
}


