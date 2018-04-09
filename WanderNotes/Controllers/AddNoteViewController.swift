//
//  AddNoteViewController.swift
//  Wander Notes
//
//  Created by Lakshman Gurung on 09/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya

class AddNoteViewController: UIViewController {

    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var hintLable: UILabel!
    var newNoteItem = Variable<NoteItemViewModel>(NoteItemViewModel(note: "", date: ""))

    var disposeBag = DisposeBag()
    var noteProvider = MoyaProvider<NoteServices>(stubClosure: { (_) -> Moya.StubBehavior in
        return .immediate
    })
    
    var saveButon: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveBarButton()
        // Do any additional setup after loading the view.
        noteTextView?.rx.text.orEmpty.map({
            return $0.count
        }).bind(onNext: { [weak self] (noteLength) in
            let length = (300 - noteLength)
            if length >= 0 {
                self?.hintLable?.text = "\(length) characters left"
            }  else {
                self?.hintLable?.text = "\(-length) characters exceeded"
            }
            if noteLength <= 0 || noteLength > 300 {
                self?.saveButon.isEnabled = false
            } else {
                self?.saveButon.isEnabled = true
            }
        }).disposed(by: disposeBag)
        
        saveButon.rx.tap
            .subscribe(onNext: { [weak self] _ in //self?.showAlert()
                self?.createNote()
            })
            .disposed(by: disposeBag)
    }

    private func addSaveBarButton(){
        
        saveButon = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
//        saveButon.title = "Save Note"
        
        navigationItem.rightBarButtonItems = [saveButon]
    }
    
    func createNote(){
        let noteStr = (noteTextView?.text)!
        let newNote = NoteItemViewModel(note: noteStr)
        noteProvider.request(.createNote(note: newNote.note, date: newNote.date)) { [weak self] (result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    guard let jsonObj =  json as? [String: String], let noteStr = jsonObj["note"], let date = jsonObj["date"] else {return}
                    strongSelf.newNoteItem.value = NoteItemViewModel(note: noteStr, date:date)
                    strongSelf.navigationController?.popViewController(animated: true)
                    
                } catch {
                    print("\(error.localizedDescription)")
                }
                break
            case .failure(let error):
                print("\(error)")
                break;
            }
        }
        
    }
}
