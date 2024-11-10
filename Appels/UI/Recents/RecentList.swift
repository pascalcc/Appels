//
//  RecentVC.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 10/11/2024.
//

import UIKit
import Combine


class RecentList : UITableViewController {
        
    
    @IBOutlet var noCall : UIView!
    
    var observer : AnyCancellable!
    
    override func viewDidLoad() {
        tableView.rowHeight = 86
        tableView.backgroundColor = UIColor(named: "Background")
        
        noCall = (Bundle.main.loadNibNamed("NoCall", owner: self)?.first as! UIView)
        noCall.center = tableView.center
        noCall.center.y -= noCall.frame.midX
        view.addSubview(noCall)
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        tableView.reloadData()
        
        observer = allCalls.$callsChanged.sink { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        observer.cancel()
    }
    
}

//MARK: datasource
extension RecentList {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = allCalls.calls.count
        let notEmpty = count != 0
        tableView.isScrollEnabled = notEmpty
        noCall.isHidden = notEmpty
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "call_cell_id") as! RecentCell
        let call = allCalls.calls[indexPath.row]
        cell.fillWith(call)
        return cell
    }
        
}


//MARK: tableview delegate
extension RecentList {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let call = allCalls.calls[indexPath.row]
        guard !call.failed else { return }
        
        // TODO
        print("will open \(call.id)")
    }
    
}
