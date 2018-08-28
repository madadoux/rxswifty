//
//  ViewController.swift
//  Networking
//
//  Created by Scott Gardner on 6/9/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
struct Repository {
    
    let name: String
    let url: String
    
}
class ViewModel {
    
    let searchText : Variable<String> = Variable("")
    let disposeBag = DisposeBag()
    
    lazy var data: Driver<[Repository]> = {
        
        return searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance )
            .distinctUntilChanged()
            .flatMapLatest({ (s) -> Observable<[Repository]> in
                self.getRepos(githubId: s)
            })
            .asDriver(onErrorJustReturn: [] )
        
    }()
    
    func getRepos( githubId : String) -> Observable<[Repository]>{
        guard !githubId.isEmpty , let url = URL( string:"https://api.github.com/users/\(githubId)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx
            .json(url: url)
            .retry(3)
            .map({
                var reposs = [Repository]()
                if let items = $0 as? [[String:AnyObject]] {
                    items.forEach({ (dic) in
                        if let name = dic["name"] as? String , let url = dic ["html_url"] as? String {
                            reposs.append(Repository(name: name, url: url))
                        }
                    })
                }
                return reposs
            })
    }
    
}

class rxSearchNetworking: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
        .asObservable()
        .subscribe(onNext: { (s) in
            self.viewModel.searchText.value = s!
        })
        .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.map({
            return ""
        }).bind(to: viewModel.searchText).disposed(by: disposeBag)
        
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "scotteg"
        searchBar.placeholder = "Enter GitHub ID, e.g., \"scotteg\""
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
}
