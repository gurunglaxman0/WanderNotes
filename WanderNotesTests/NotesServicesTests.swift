//
//  NotesServicesTests.swift
//  WanderNotesTests
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//


import XCTest
@testable import WanderNotes
import Moya

class NotesServicesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadNotes(){
        let sut = MoyaProvider<NoteServices>(stubClosure: { (_) -> Moya.StubBehavior in
            return .immediate
        })
        
        sut.request(.readNote()) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    guard let jsonObj =  json as? [[String: String]] else {
                        XCTAssert(false)
                        return
                    }
                    let notes = jsonObj.map({
                        return NoteItemViewModel(note: ($0["note"] ?? "" ), date: ($0["date"] ?? ""))
                    })
                     XCTAssert(notes.count == 4)
                } catch {
                    XCTAssert(false)
                }
                
                
                break
            case .failure(_):
                XCTAssert(false)
                break
            }
        }
    }
    
    
    func test_createNote(){
        let sut = MoyaProvider<NoteServices>(stubClosure: { (_) -> Moya.StubBehavior in
            return .immediate
        })
        
        let newItem = NoteItemViewModel(note: "This is test", date: "12/04/18")
        sut.request(.createNote(note: newItem.note, date: newItem.date)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    guard let jsonObj =  json as? [String: String], let noteStr = jsonObj["note"], let date = jsonObj["date"] else {
                        XCTAssert(false)
                        return
                    }
                    let note =  NoteItemViewModel(note: noteStr, date:date)
                    
                    
                    XCTAssertEqual(note.note, newItem.note)
                    XCTAssertEqual(note.date, newItem.date)
                } catch {
                    XCTAssert(false)
                }
                
                
                break
            case .failure(_):
                XCTAssert(false)
                break
            }
        }
    }
    
}
