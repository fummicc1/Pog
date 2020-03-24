//
//  DiaryListViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit
import RxSwift

class DiaryListViewController: UIViewController, BaseViewController {

    typealias Input = _Input
    
    struct _Input {
        
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    let viewModel: DiaryListViewModel
    
    private weak var emptyStateView: UIView? = {
        let content = UIView()
        return content
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @available(iOS 13, *)
    init?(viewModel: DiaryListViewModel = DiaryListViewModel(), coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        viewModel = DiaryListViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(input: DiaryListViewController._Input) {
        viewModel.configure(input: DiaryListViewModel._Input())
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
