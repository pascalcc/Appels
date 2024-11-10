//
//  RecentVC.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 10/11/2024.
//

import UIKit
import Combine
import SwiftUI


class RecentList : UITableViewController {
        
    
    @IBOutlet var noCall : UIView!
    
    var observer : AnyCancellable!
    
    override func viewDidLoad() {
        tableView.rowHeight = 86
        tableView.backgroundColor = UIColor(named: "Background")
        
        noCall = (Bundle.main.loadNibNamed("NoCall", owner: self)!.first as! UIView)
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

//MARK: - datasource
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


//MARK: - tableview delegate
extension RecentList {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let call = allCalls.calls[indexPath.row]
        guard !call.failed else { return }
                        
        guard let t = prepareTranscription(call.id) else { return }
        
        let vc = UIHostingController(rootView: TranscriptionView(transcription: t))
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.hidesBottomBarWhenPushed = true
 
        //FIX: try custom navbarTitle
        let title = NavBarTitle(frame: CGRect(x: 0, y: 10, width: NavBarTitle.WIDTH, height: NavBarTitle.HEIGHT))
        title.title.text = call.phoneNumber
        title.subtitle.text = call.startedAt
        vc.navigationItem.titleView = title
        //FIX: try custom navbarTitle
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}


//MARK: - navbar title view

fileprivate class NavBarTitle: UIView {

    static let HEIGHT = 46
    static let WIDTH = 180
    
    let title : UILabel!
    let subtitle : UILabel!
    
    override init(frame: CGRect) {
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: NavBarTitle.WIDTH, height: 25))
        title.font = .boldSystemFont(ofSize: 19)
        title.textColor = Colors.enabledFont
        title.textAlignment = .center
        
        subtitle = UILabel(frame: CGRect(x: 0, y: NavBarTitle.HEIGHT-20, width: NavBarTitle.WIDTH, height: 20))
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = Colors.disabledFont
        subtitle.textAlignment = .center

        super.init(frame: frame)

        addSubview(title)
        addSubview(subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
