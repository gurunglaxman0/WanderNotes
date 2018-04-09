//
//  NoteServices.swift
//  Wander Notes
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import Foundation
import Moya

enum NoteServices {
    case createNote(note: String, date: String)
    case readNote()
}

extension NoteServices:  TargetType {
    
    
    var baseURL: URL {
        return URL(string: "http://example.com")!
    }
    
    var path: String {
        return "/notes"
    }
    
    var method: Moya.Method {
        switch self {
        case .createNote(_, _):
            return .post
        case .readNote():
            return .get
            
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createNote(let note, let date):
            let str = "{\"note\":\"\(note)\", \"date\": \"\(date)\"}"
            return str.data(using: .utf8)!
        case .readNote():
            guard let path = Bundle.main.path(forResource: "Users", ofType: "json") else {return Data()}
            do {
                let fullText = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                return fullText.data(using: .utf8) ?? Data()
            } catch {
                print("\(error)")
            }
            
           return Data()
            
        }
    }
    
    var task: Task {
        switch self {
        case .createNote(let note, let date):
            return .requestParameters(parameters: ["note": note, "date" : date], encoding: JSONEncoding.default)
        case .readNote():
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
