//
//  DiaryListViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit

class DiaryListViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private weak var emptyStateView: UIView? = {
        let content = UIView()
        return content
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        listenViewModel()
    }
    
    override func listenViewModel() {
    }
    
    override func bindViewModel() {
    }
}

extension DiaryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
