//
//  NotesViewModelTests.swift
//  WanderNotesTests
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import XCTest
@testable import WanderNotes

class NotesViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   

    func test_NoteItemInitialization(){
        let note = "This is test"
        let sut = NoteItemViewModel(note: note)
        XCTAssertEqual(sut.note , note)
        XCTAssertEqual(sut.date , getCurrentDateString())
    }
    
    
    func test_NoteIsViewModelDefaultInitialization(){
        let sut = NotesViewModel()
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func test_NoteIsViewModelInitialization(){
        let sut = NotesViewModel(with: [NoteItemViewModel(note: "Hello this is test"), NoteItemViewModel(note: "Hi this is test"), NoteItemViewModel(note: "Hola this is test")])
        XCTAssertEqual(sut.items.count, 3)
    }
    
    private func getCurrentDateString()->String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: currentDate)
    }
    
}
