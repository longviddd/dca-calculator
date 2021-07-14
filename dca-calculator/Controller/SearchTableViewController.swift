//
//  ViewController.swift
//  dca-calculator
//
//  Created by user195395 on 7/12/21.
//

import UIKit
import Combine
import MBProgressHUD
class SearchTableViewController: UITableViewController, UIAnimatable  {
    //call the api service
    private let apiService = APIService()
    //create subscribers to receive info from publisher
    private var subscribers = Set<AnyCancellable>()
    //create searchController and add published in order to track the changes in searchQuery
    @Published private var searchQuery = String()
    private var searchResults : SearchResults?
    //creating enum to decide which mode the UI should be in
    private enum Mode{
        case onboarding
        case search
    }
    //add published keyword in order to observe the mode
    @Published private var mode : Mode = .onboarding
    
    private lazy var searchController : UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up navigation bar
        setupNavigationBar()
        observeForm()
        setupTableView()
    }
    private func observeForm(){
        //function to observe the search query
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main).sink(receiveValue: {[unowned self](searchQuery) in
            showLoadingAnimation()
            self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink(receiveCompletion: {(completion) in
                hideLoadingAnimation()
                //handle completion
                switch completion{
                //
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished: break
                }
                //handle result if successful
            }, receiveValue: {(searchResults) in
                self.searchResults = searchResults
                self.tableView.reloadData()
                //reload data everytime searchResults are found
                //store in subscribers
            }).store(in: &self.subscribers)
        }).store(in: &subscribers)
        $mode.sink{[unowned self](mode) in
            switch mode{
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    private func setupNavigationBar(){
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    private func setupTableView(){
        tableView.tableFooterView = UIView()
    }
    //return number of row in tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    //cellforrowat function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //declare cell as the searchtableviewcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults{
            //check if searchResults exist and configure the cells accordingly
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }
    
}
//add extension in order to conform to the searchResultUpdater and deleate
extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        //guard let in order to unwrap optional value
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else{
            return
        }
        self.searchQuery = searchQuery
        
        
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
    
}

