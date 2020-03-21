//
//  HomeViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

	private weak var bottomActionBarViewController: BottomActionBarViewController? = {
		return UIStoryboard(name: BottomActionBarViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> BottomActionBarViewController in
            guard let viewController = BottomActionBarViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })
	}()
    
    private weak var topBarViewController: TopBarViewController? = {
        return UIStoryboard(name: TopBarViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> TopBarViewController in
            guard let viewController = TopBarViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })
    }()
	
	private weak var diaryMapViewController: DiaryMapViewController? = {
        return UIStoryboard(name: DiaryMapViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> DiaryMapViewController in
            guard let viewController = DiaryMapViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })
	}()
    
    private weak var diaryListViewController: DiaryListViewController? = {
        return UIStoryboard(name: DiaryListViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> DiaryListViewController in
            guard let viewController = DiaryListViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })
    }()
    
    private weak var myProfileViewController: MyProfileViewController? = {
        return UIStoryboard(name: MyProfileViewController.className, bundle: nil).instantiateInitialViewController(creator: { coder -> MyProfileViewController in
            guard let viewController = MyProfileViewController(coder: coder) else {
                fatalError()
            }
            return viewController
        })
    }()
	
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        topBarViewController.view.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(48)
        }
        
        diaryMapViewController.view.snp.makeConstraints { maker in
            maker.trailing.equalTo(self.view)
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
        
        bindViewModel()
        listenViewModel()
    }
    
    override func listenViewModel() {
        bottomActionBarViewController?
            .viewModel
            .selectingViewControllerName
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] name in
                switch name {
                case DiaryMapViewController.className:
                    self?.diaryListViewController?.view.snp.updateConstraints({ maker in
                        maker.width.equalTo(0)
                    })
                    self?.diaryMapViewController?.view.snp.updateConstraints({ maker in
                        guard let self = self else {
                            assert(false)
                            return
                        }
                        maker.width.equalTo(self.view)
                    })
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.view.layoutIfNeeded()
                    }
                    
                case DiaryListViewController.className:
                    self?.diaryListViewController?.view.snp.updateConstraints({ maker in
                        maker.width.equalTo(0)
                    })
                    self?.diaryListViewController?.view.snp.updateConstraints({ maker in
                        guard let self = self else {
                            assert(false)
                            return
                        }
                        maker.width.equalTo(self.view)
                    })
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.view.layoutIfNeeded()
                    }
                    
                case MyProfileViewController.className:
                    break
                    
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
    }
}
