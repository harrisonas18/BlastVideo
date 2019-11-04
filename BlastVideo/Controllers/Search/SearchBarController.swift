//
//  SearchBarController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/18/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import InstantSearch
import Kingfisher

class SearchController: UIViewController {
    
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "ME05ZIHAUV",
                                                            apiKey: "fad40b242d806b5c389b9256a1cd9a4b",
                                                            indexName: "dev_Users")

    let queryInputInteractor: QueryInputInteractor = .init()
    let searchBarController: SearchBarCustomController = .init(searchBar: UISearchBar())

    let statsInteractor: StatsInteractor = .init()
    let statsController: LabelStatsController = .init(label: UILabel())

    let hitsInteractor: HitsInteractor<JSON> = HitsInteractor<JSON>(showItemsOnEmptyQuery: false)
    let hitsTableController: HitsTableController<HitsInteractor<JSON>> = .init(tableView: UITableView())
    
    let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.midX-50, y: UIScreen.main.bounds.midY-25, width: 100, height: 50))
    
    let table = UITableView()
    var searchHistory: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
        hitsTableController.tableView.alpha = 0
        hitsTableController.tableView.separatorStyle = .none
        hitsTableController.tableView.rowHeight = 55
        label.text = "No Results"
        label.isHidden = true
        view.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func configureSearchHistory(){
        table.translatesAutoresizingMaskIntoConstraints = false
        table.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth(), height: UIScreen.screenHeight())
        table.register(SearchTableViewCell.self, forCellReuseIdentifier: "cellID")
    }

    func configureUI() {

        view.backgroundColor = .white

        // Declare a stack view containing all the components
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // Add searchBar
        let searchBar = searchBarController.searchBar
        searchBarController.searchDelegate = self
        searchBar.tintColor = .systemBlue
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        searchBar.searchBarStyle = .minimal
        stackView.addArrangedSubview(searchBar)
        
        // Add statsLabel
        let statsLabel = statsController.label
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        statsLabel.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        statsLabel.textColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        
        stackView.addArrangedSubview(statsLabel)
        
        // Add hits tableView
        stackView.addArrangedSubview(hitsTableController.tableView)

        // Pin stackView to ViewController's view
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
          stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

    }

    func setup() {
        // Notify searcher about query text changes and launch a new search
        queryInputInteractor.connectSearcher(searcher)

        // Update query text in interactor each time query text changed in a UISearchBar
        queryInputInteractor.connectController(searchBarController)

        // Update search stats each time searcher receives new search results
        statsInteractor.connectSearcher(searcher)

        // Update label with up-to-date stats data
        statsInteractor.connectController(statsController)

        // Update hitsInteractor with up-to-date search results
        hitsInteractor.connectSearcher(searcher)

        // Dispatch search results to tableView
        hitsInteractor.connectController(hitsTableController)

        // Register cell in tableView
        hitsTableController.tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        // Dequeue and setup cell with hit data
        hitsTableController.dataSource = .init() { tableView, hit, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SearchTableViewCell
            cell.usernameLabel.text = [String: Any](hit)?["username"] as? String
            let user = [String: Any](hit)?["userID"] as? String
            Api.Follow.isFollowing(userId: user!) { (bool) in
                if bool {
                    cell.followButton.isSelected = true
                    cell.isFollowSelected = true
                    cell.followButton.backgroundColor = .systemPink
                } else {
                    cell.followButton.isSelected = false
                    cell.isFollowSelected = false
                    cell.followButton.backgroundColor = .black
                }
            }
            let url = URL(string: [String: Any](hit)?["profileImageUrl"] as? String ?? "")
            cell.userImg.kf.setImage(with: url)
            cell.followButton.titleLabel?.text = "Follow"
            return cell
        }
        
        hitsTableController.delegate = .init(clickHandler: { (tableView, hit, indexPath) in
            print("Item pressed")
            tableView.deselectRow(at: indexPath, animated: false)
            let vc = PushProfileViewController()
            let user = UserObject()
            
            user.id = [String: Any](hit)?["userID"] as? String
            user.username = [String: Any](hit)?["username"] as? String
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        searcher.onResults.subscribe(with: self) { (_, results) in
            if results.hits.isEmpty {
                self.label.isHidden = false
            } else {
                self.label.isHidden = true
            }
        }

        // Launch initial search
        searcher.search()
        
    }
    
}

extension SearchController: SearchBarDelegate {
    
    func searchBarDidBeginEditing() {
        searchBarController.searchBar.showsCancelButton = true
        hitsTableController.tableView.alpha = 100
    }
    
    func searchBarCancelClicked() {
        searchBarController.searchBar.text = nil
        searchBarController.searchBar.showsCancelButton = false
        searchBarController.searchBar.endEditing(true)
        hitsTableController.tableView.alpha = 0
    }
    
}

extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SearchTableViewCell
        cell.usernameLabel.text = ""
        let user = ""
        Api.Follow.isFollowing(userId: user) { (bool) in
            if bool {
                cell.followButton.setTitle("Unfollow", for: .normal)
                cell.followButton.backgroundColor = .white
                cell.followButton.setTitleColor(.black, for: .normal)
                cell.followButton.layer.borderColor = UIColor.black.cgColor
                cell.followButton.layer.borderWidth = 1
            } else {
                cell.followButton.setTitle("Follow", for: .normal)
                cell.followButton.setTitleColor(.white, for: .normal)
            }
        }
        let url = URL(string: "")
        cell.userImg.kf.setImage(with: url)
        cell.followButton.titleLabel?.text = "Follow"
        return cell
    }
    
    
}

