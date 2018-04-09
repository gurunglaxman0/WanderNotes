//
//  NoteItemTableViewCell.swift
//  Wander Notes
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import UIKit

class NoteItemTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func configure(withViewModel viewModel: NoteItemPresentable){
        noteLabel?.text = viewModel.note
        dateLabel?.text = viewModel.date
    }

}
