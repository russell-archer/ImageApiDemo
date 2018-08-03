//
//  ViewController.swift
//  ImageApiDemo
//
//  Created by Russell Archer on 18/06/2018.
//  Copyright © 2018 Russell Archer. All rights reserved.
//

// This app requests image data using the Pixabay API.
// Documentation: https://pixabay.com/api/docs/
// Example Query: https://pixabay.com/api/?key=your-api-key&image_type=photo&q=your-search-text

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // Create a search controller, passing nil to indicate that results will be displayed in the same view
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var pixabayHelper = PixabayHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        pixabayHelper.delegate = self
        
        // Add an integrated search controller to the navigation bar
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Ensure that the search bar does not remain on the screen if the user navigates to another
        // view controller while the UISearchController is active
        definesPresentationContext = true
        
        // Load some default images
        pixabayHelper.loadImages(searchFor: "kittens")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixabayHelper.pixabayData != nil ? pixabayHelper.pixabayData!.hits.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        
        // Convert the preview URL in the data returned from Pixabay to a UIImage
        if let pbd = pixabayHelper.pixabayData {
            let url = URL(string: pbd.hits[(indexPath as NSIndexPath).row].webformatURL)  // previewURL
            if let imageData = try? Data(contentsOf: url!) {
                cell.previewImage.image = UIImage(data: imageData)!
            }
        }
        
        return cell
    }
}

extension ViewController: PixabayHelperDelegate {
    func dataDidLoad() {
        imageCollectionView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating {
    // The UISearchResultsUpdating protocol allows us to be informed of text changes in UISearchBar
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        guard text != nil && text!.count > 2 else { return }
        
        pixabayHelper.loadImages(searchFor: text!)
    }
}
