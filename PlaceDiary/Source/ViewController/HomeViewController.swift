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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Setup View
        view.backgroundColor = UIColor.systemBackground
        guard
            let diaryMapViewController = diaryMapViewController,
            let bottomActionBarViewController = bottomActionBarViewController,
            let topBarViewController = topBarViewController,
            let diaryListViewController = diaryListViewController,
            let myProfileViewController = myProfileViewController else {
                return
        }
        addChild(diaryListViewController)
        addChild(diaryMapViewController)
        addChild(bottomActionBarViewController)
        addChild(topBarViewController)
        addChild(myProfileViewController)
        view.addSubview(diaryListViewController.view)
        view.addSubview(diaryMapViewController.view)
        view.addSubview(bottomActionBarViewController.view)
        view.addSubview(topBarViewController.view)
        view.addSubview(myProfileViewController.view)
        diaryListViewController.didMove(toParent: self)
        diaryMapViewController.didMove(toParent: self)
        bottomActionBarViewController.didMove(toParent: self)
        topBarViewController.didMove(toParent: self)
        myProfileViewController.didMove(toParent: self)
        
        //MARK: Setup LayoutConstraints
        topBarViewController.view.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(48)
        }
        
        diaryMapViewController.view.snp.makeConstraints { maker in
            maker.leading.equalTo(diaryListViewController.view.snp.trailing)
            maker.width.equalTo(self.view)
            maker.top.equalTo(topBarViewController.view.snp.bottom)
            maker.bottom.equalTo(bottomActionBarViewController.view.snp.top)
        }
        
        diaryListViewController.view.snp.makeConstraints { maker in
            maker.leading.equalTo(self.view)
            maker.width.equalTo(self.view)
            maker.top.equalTo(topBarViewController.view.snp.bottom)
            maker.bottom.equalTo(bottomActionBarViewController.view.snp.top)
        }
        
        bottomActionBarViewController.view.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide)
            maker.height.equalTo(48)
            maker.trailing.leading.equalTo(self.view)
        }
        
        myProfileViewController.view.snp.makeConstraints { maker in
            maker.top.bottom.leading.equalTo(self.view)
            maker.width.equalTo(0)
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
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self.diaryListViewController?.view.snp.updateConstraints({ maker in
                            maker.leading.equalTo(self.view).offset(-UIScreen.main.bounds.width)
                        })
                        self.view.layoutIfNeeded()
                    })
                    
                case DiaryListViewController.className:
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        self.diaryListViewController?.view.snp.updateConstraints({ maker in
                            maker.leading.equalTo(self.view)
                        })
                        self.view.layoutIfNeeded()
                    })
                    
                case MyProfileViewController.className:
                    break
                    
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
