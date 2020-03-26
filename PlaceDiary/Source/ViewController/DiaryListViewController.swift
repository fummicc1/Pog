//
//  DiaryListViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DiaryListViewController: UIViewController, BaseViewController {
    
    typealias Input = _Input
    
    struct _Input {
        
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var writeDiaryButton: UIButton!
    
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
        bindViewModel()
        
        //MARK: Setup Rx
        writeDiaryButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let navigationController = UIStoryboard(name: WriteDiaryViewController.className, bundle: nil).instantiateInitialViewController() as? UINavigationController,
                    let _ = navigationController.viewControllers.first as? WriteDiaryViewController else {
                        assert(false)
                        return
                }
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let dataSources = RxTableViewSectionedReloadDataSource<DiaryListViewModel.DiarySection>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListTableViewCell.className) as? DiaryListTableViewCell else {
                    return UITableViewCell()
                }
                cell.diary = item
                return cell
        })
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
