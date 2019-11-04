//
//  SearchBarCustomController.swift
//  BlastVideo
//
//  Created by Harrison Senesac on 10/20/19.
//  Copyright © 2019 Harrison Senesac. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

protocol SearchBarDelegate {
    func searchBarDidBeginEditing()
    func searchBarCancelClicked()
}

public class SearchBarCustomController: NSObject, QueryInputController {

  public var onQueryChanged: ((String?) -> Void)?
  public var onQuerySubmitted: ((String?) -> Void)?
  public let searchBar: UISearchBar
  var searchDelegate: SearchBarDelegate?

  public init(searchBar: UISearchBar) {
    self.searchBar = searchBar
    super.init()
    setupSearchBar()

  }
  
  public func setQuery(_ query: String?) {
    searchBar.text = query
  }
  
  private func setupSearchBar() {
    searchBar.delegate = self
    searchBar.returnKeyType = .search
  }

}

extension SearchBarCustomController: UISearchBarDelegate {
    
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    onQueryChanged?(searchText)
  }

  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    onQuerySubmitted?(searchBar.text)
  }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDelegate?.searchBarDidBeginEditing()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDelegate?.searchBarCancelClicked()
    }

}

