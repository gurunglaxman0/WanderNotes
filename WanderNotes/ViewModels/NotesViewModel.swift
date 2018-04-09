//
//  NotesViewModel.swift
//  Wander Notes
//
//  Created by Lakshman Gurung on 08/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import Foundation

protocol NoteItemPresentable {
    var note: String {get}
    var date: String {get}
}

struct NoteItemViewModel: NoteItemPresentable {
    var note: String
    var date: String
    init(note: String) {
        self.note = note
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        self.date = dateFormatter.string(from: currentDate)
    }
    
    init(note: String, date: String) {
        self.note = note
        self.date = date
    }
}

class NotesViewModel {
    var newNoteItem: String?
    var items: [NoteItemViewModel] = []
    
    init(with items: [NoteItemViewModel]) {
        self.items = items
    }
    init() {
        
    }
}


