//
//  HomeViewController.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/01/30.
//

import UIKit
import CoreLocation

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
	
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let diaryMapViewController = diaryMapViewController, let bottomActionBarViewController = bottomActionBarViewController, let topBarViewController = topBarViewController else {
            return
        }
        addChild(diaryMapViewController)
        addChild(bottomActionBarViewController)
        addChild(topBarViewController)
		view.addSubview(diaryMapViewController.view)
		view.addSubview(bottomActionBarViewController.view)
        view.addSubview(topBarViewController.view)
        diaryMapViewController.didMove(toParent: self)
        bottomActionBarViewController.didMove(toParent: self)
        topBarViewController.didMove(toParent: self)
        
        topBarViewController.view.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(64)
        }
        
        diaryMapViewController.view.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalTo(self.view)
            maker.bottom.equalTo(bottomActionBarViewController.view.snp.top)
        }
        
		bottomActionBarViewController.view.snp.makeConstraints { maker in
            maker.bottom.equalTo(self.view)
			maker.height.equalTo(96)
            maker.trailing.leading.equalTo(self.view)
		}
    }
}
