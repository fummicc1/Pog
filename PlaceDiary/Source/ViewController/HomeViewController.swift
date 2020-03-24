//
//  HomeViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, BaseViewController {
    
    typealias Input = Void
    
    var disposeBag: DisposeBag = DisposeBag()
    private let currentSelectingViewControllerNameRelay: BehaviorRelay<String> = .init(value: DiaryListViewController.className)
    
    private weak var bottomActionBarViewController: BottomActionBarViewController! = {
        return UIStoryboard(name: BottomActionBarViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> BottomActionBarViewController in
            guard let viewController = BottomActionBarViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })!
    }()
    
    private weak var topBarViewController: TopBarViewController! = {
        return UIStoryboard(name: TopBarViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> TopBarViewController in
            guard let viewController = TopBarViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })!
    }()
    
    private weak var diaryMapViewController: DiaryMapViewController! = {
        return UIStoryboard(name: DiaryMapViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> DiaryMapViewController in
            guard let viewController = DiaryMapViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })!
    }()
    
    private weak var diaryListViewController: DiaryListViewController! = {
        return UIStoryboard(name: DiaryListViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> DiaryListViewController in
            guard let viewController = DiaryListViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })!
    }()
    
    private weak var myProfileViewController: MyProfileViewController! = {
        return UIStoryboard(name: MyProfileViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> MyProfileViewController in
            guard let viewController = MyProfileViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })!
    }()
    
    private weak var diaryContentsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Setup View
        let diaryContentsView = UIView()
        diaryContentsView.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        addChild(diaryListViewController)
        addChild(diaryMapViewController)
        addChild(bottomActionBarViewController)
        addChild(topBarViewController)
        addChild(myProfileViewController)
        view.addSubview(diaryContentsView)
        view.addSubview(bottomActionBarViewController.view)
        view.addSubview(myProfileViewController.view)
        diaryContentsView.addSubview(diaryListViewController.view)
        diaryContentsView.addSubview(diaryMapViewController.view)
        diaryContentsView.addSubview(topBarViewController.view)
        diaryListViewController.didMove(toParent: self)
        diaryMapViewController.didMove(toParent: self)
        bottomActionBarViewController.didMove(toParent: self)
        topBarViewController.didMove(toParent: self)
        myProfileViewController.didMove(toParent: self)
        self.diaryContentsView = diaryContentsView
        
        //MARK: Setup LayoutConstraints
        diaryContentsView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(self.view)
            maker.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalTo(self.bottomActionBarViewController.view.snp.top)
        }
        
        topBarViewController.view.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(48)
        }
        
        diaryMapViewController.view.snp.makeConstraints { maker in
            maker.leading.bottom.width.equalToSuperview()
            maker.top.equalTo(topBarViewController.view.snp.bottom)
        }
        
        diaryListViewController.view.snp.makeConstraints { maker in
            maker.leading.width.equalToSuperview()
            maker.top.equalTo(topBarViewController.view.snp.bottom)
            maker.bottom.equalToSuperview()
        }
        
        bottomActionBarViewController.view.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide)
            maker.height.equalTo(48)
            maker.trailing.leading.equalTo(self.view)
        }
        
        myProfileViewController.view.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.bottomActionBarViewController.view.snp.top)
        }
        
        //MARK: Call Configure Method
        configure(input: ())
    }
    
    func configure(input: Input) {
        
        //MARK: Setup BottomActionBarViewController
        bottomActionBarViewController.configure(input: BottomActionBarViewController.Input(
            currentSelectingViewControllerNameByTopBar: currentSelectingViewControllerNameRelay.asObservable()
        ))
        
        currentSelectingViewControllerNameRelay
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] name in
                guard let self = self else {
                    assert(false)
                    return
                }
                switch name {
                case DiaryMapViewController.className:
                    self.diaryContentsView.sendSubviewToBack(self.diaryListViewController.view)
                    self.view.sendSubviewToBack(self.myProfileViewController.view)
                    
                case DiaryListViewController.className:
                    self.diaryContentsView.sendSubviewToBack(self.diaryMapViewController.view)
                    self.view.sendSubviewToBack(self.myProfileViewController.view)
                    
                case MyProfileViewController.className:
                    self.view.bringSubviewToFront(self.myProfileViewController.view)
                    
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        //MARK: Setup TopBarViewController
        topBarViewController.configure(
            input: TopBarViewController.Input(
                viewControllerNameChangedByTabBar: currentSelectingViewControllerNameRelay.asObservable()
            )
        )
        
        //MARK: Setup DiaryMapViewController
        diaryMapViewController.configure(input: DiaryMapViewController.Input())
        
        //MARK: Setup DiaryListViewController
        diaryListViewController.configure(input: DiaryListViewController.Input())
        
        //MARK: Setup MyProfileViewController
        myProfileViewController.configure(input: MyProfileViewController.Input())
        
        
        //MARK: Listen Children`s ViewModel
        Observable
            .merge(
                topBarViewController.viewModel.currentSelectingDiaryViewControllerNameByTopBar,
                bottomActionBarViewController.viewModel.selectingViewControllerName)
            .distinctUntilChanged()
            .bind(to: currentSelectingViewControllerNameRelay)
            .disposed(by: disposeBag)
    }
}
