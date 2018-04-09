//
//  NotesTableViewController.swift
//  Wander Notes
//
//  Created by Lakshman Gurung on 08/04/18.
//  Copyright © 2018 Lakshman Gurung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import  Moya

class NotesTableViewController: UITableViewController {
    
    var viewModel: NotesViewModel?
    var notesProvider = MoyaProvider<NoteServices>(stubClosure: { (_) -> Moya.StubBehavior in
        return .immediate
    })
    var disposeBag = DisposeBag()
    private let identifire = "noteItemCellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.gothemRoundedBook(size: 17)]
        navigationItem.title = "Notes"
        viewModel = NotesViewModel()
        
        notesProvider.request(.readNote()) { [weak self] result  in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    guard let jsonObj =  json as? [[String: String]] else {return}
                    let notes = jsonObj.map({
                        return NoteItemViewModel(note: ($0["note"] ?? "" ), date: ($0["date"] ?? ""))
                    })
                    
                    strongSelf.viewModel?.items.append(contentsOf: notes)
                    strongSelf.tableView.reloadData()
                    
                } catch {
                    print("\(error.localizedDescription)")
                }
               
                break
                
            case .failure(let error):
                print("\(error)")
                break;
            }
        }
        
        
//        MoyaProvider.StubClosure = { (_) -> Moya.StubBehavior in
//            return StubBehavior.immediate
//        }
        
//        notesProvider
       
//        notesProvider.stubRequest(.readNote(), request: URLRequest(url: URL("/")!), callbackQueue: DispatchQueue.main, completion: { (response, error) in
//            print("\(response)")
//        }, endpoint: "", stubBehavior: StubBehavior.immediate)
        
        
//        notesProvider.re
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (viewModel?.items.count) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as! NoteItemTableViewCell
        cell.configure(withViewModel: (viewModel?.items[indexPath.item])!)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onAddNote(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addNoteVC") as! AddNoteViewController
        navigationController?.pushViewController(vc, animated: true)
        
        vc.newNoteItem.asObservable().subscribe(onNext: { [weak self] (newItem) in
            guard let strongSelf = self, !newItem.note.isEmpty  else {return}
            strongSelf.viewModel?.items.append(newItem)
            strongSelf.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
}
