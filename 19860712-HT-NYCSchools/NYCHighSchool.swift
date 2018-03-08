//
//  NYCHighSchool.swift
//  19860712-HT-NYCSchools
//
//  Created by Hamid on 3/6/18.
//  Copyright © 2018 PicBlast. All rights reserved.
//

import Foundation
/*
 API response format
 {
 "academicopportunities1": "Free college courses at neighboring universities",
 "academicopportunities2": "International Travel, Special Arts Programs, Music, Internships, College Mentoring English Language Learner Programs: English as a New Language",
 "admissionspriority11": "Priority to continuing 8th graders",
 "admissionspriority21": "Then to Manhattan students or residents",
 "admissionspriority31": "Then to New York City residents",
 "attendance_rate": "0.970000029",
 "bbl": "1008420034",
 "bin": "1089902",
 "boro": "M",
 "borough": "MANHATTAN",
 "building_code": "M868",
 "bus": "BM1, BM2, BM3, BM4, BxM10, BxM6, BxM7, BxM8, BxM9, M1, M101, M102, M103, M14A, M14D, M15, M15-SBS, M2, M20, M23, M3, M5, M7, M8, QM21, X1, X10, X10B, X12, X14, X17, X2, X27, X28, X37, X38, X42, X5, X63, X64, X68, X7, X9",
 "census_tract": "52",
 "city": "Manhattan",
 "code1": "M64A",
 "community_board": "5",
 "council_district": "2",
 "dbn": "02M260",
 "directions1": "See theclintonschool.net for more information.",
 "ell_programs": "English as a New Language",
 "extracurricular_activities": "CUNY College Now, Technology, Model UN, Student Government, School Leadership Team, Music, School Musical, National Honor Society, The Clinton Post (School Newspaper), Clinton Soup (Literary Magazine), GLSEN, Glee",
 "fax_number": "212-524-4365",
 "finalgrades": "6-12",
 "grade9geapplicants1": "1515",
 "grade9geapplicantsperseat1": "19",
 "grade9gefilledflag1": "Y",
 "grade9swdapplicants1": "138",
 "grade9swdapplicantsperseat1": "9",
 "grade9swdfilledflag1": "Y",
 "grades2018": "6-11",
 "interest1": "Humanities & Interdisciplinary",
 "latitude": "40.73653",
 "location": "10 East 15th Street, Manhattan NY 10003 (40.736526, -73.992727)",
 "longitude": "-73.9927",
 "method1": "Screened",
 "neighborhood": "Chelsea-Union Sq",
 "nta": "Hudson Yards-Chelsea-Flatiron-Union Square                                 ",
 "offer_rate1": "\u00c2\u201457% of offers went to this group",
 "overview_paragraph": "Students who are prepared for college must have an education that encourages them to take risks as they produce and perform. Our college preparatory curriculum develops writers and has built a tight-knit community. Our school develops students who can think analytically and write creatively. Our arts programming builds on our 25 years of experience in visual, performing arts and music on a middle school level. We partner with New Audience and the Whitney Museum as cultural partners. We are a International Baccalaureate (IB) candidate school that offers opportunities to take college courses at neighboring universities.",
 "pct_stu_enough_variety": "0.899999976",
 "pct_stu_safe": "0.970000029",
 "phone_number": "212-524-4360",
 "primary_address_line_1": "10 East 15th Street",
 "program1": "M.S. 260 Clinton School Writers & Artists",
 "requirement1_1": "Course Grades: English (87-100), Math (83-100), Social Studies (90-100), Science (88-100)",
 "requirement2_1": "Standardized Test Scores: English Language Arts (2.8-4.5), Math (2.8-4.5)",
 "requirement3_1": "Attendance and Punctuality",
 "requirement4_1": "Writing Exercise",
 "requirement5_1": "Group Interview (On-Site)",
 "school_10th_seats": "1",
 "school_accessibility_description": "1",
 "school_email": "admissions@theclintonschool.net",
 "school_name": "Clinton School Writers & Artists, M.S. 260",
 "school_sports": "Cross Country, Track and Field, Soccer, Flag Football, Basketball",
 "seats101": "Yes\u00c2\u20139",
 "seats9ge1": "80",
 "seats9swd1": "16",
 "state_code": "NY",
 "subway": "1, 2, 3, F, M to 14th St - 6th Ave; 4, 5, L, Q to 14th St-Union Square; 6, N, R to 23rd St",
 "total_students": "376",
 "website": "www.theclintonschool.net",
 "zip": "10003"
 },
 */

struct NYCHighSchool {
    // we can create a constant struct for all the JSON keys that we are interested in, for now I just hardcoded it
    var name: String
    var location: String
    var email: String
    var phoneNumber: String
    var city: String
    static let defaultText = " "
    init (jsonFormat json: [String: String]) {
        name = json["school_name"] ?? NYCHighSchool.defaultText
        email = json["school_email"] ?? NYCHighSchool.defaultText
        phoneNumber = json["phone_number"] ?? NYCHighSchool.defaultText
        city = json["city"] ?? "New York"
        // format for location value : "location": "10 East 15th Street, Manhattan NY 10003 (40.736526, -73.992727)"
        let locationInfo = json["location"]!
        let parts = locationInfo.components(separatedBy: "(")
        location = parts[0].stringByTrimmingLeadingAndTrailingWhitespace()
    }
    
}

/*
 API response format
 {
 "dbn": "01M450",
 "num_of_sat_test_takers": "70",
 "sat_critical_reading_avg_score": "377",
 "sat_math_avg_score": "402",
 "sat_writing_avg_score": "370",
 "school_name": "EAST SIDE COMMUNITY SCHOOL"
 }
 */
struct NYCHighSchoolSatInfo {
    // SAT Info
    var schoolName: String
    var numberOfSatTakers: String
    var avarageSatMathScore: String
    var avarageSatCriticalReadingScore: String
    var avarageSatWritingScore: String
    static let defaultText = " "
    init (jsonFormat json: [String: String]) {
        // if we are here the data was successfully retreived so we can force unwrap
        schoolName = json["school_name"] ?? NYCHighSchoolSatInfo.defaultText
        numberOfSatTakers = json["num_of_sat_test_takers"] ?? NYCHighSchoolSatInfo.defaultText
        avarageSatMathScore = json["sat_math_avg_score"] ??  NYCHighSchoolSatInfo.defaultText
        avarageSatCriticalReadingScore = json["sat_critical_reading_avg_score"] ?? NYCHighSchoolSatInfo.defaultText
        avarageSatWritingScore = json["sat_writing_avg_score"] ?? NYCHighSchoolSatInfo.defaultText
    }
}

