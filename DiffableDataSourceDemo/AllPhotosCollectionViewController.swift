//
//  AllPhotosCollectionViewController.swift
//  DiffableDataSourceDemo
//
//  Created by Russell Archer on 24/12/2019.
//  Copyright © 2019 Russell Archer. All rights reserved.
//

import UIKit

enum Section {
    case allPhotos
    case allVideos
}

class AllPhotosCollectionViewController: UICollectionViewController {
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var data = DataHelper()
    fileprivate var images = [UIImage]()
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = configureDataSource()
        
        // Get all images from the photo library
        data.loadAllImages { [unowned self] imgs in
            self.images = imgs
                
            DispatchQueue.main.async {
                self.updateDataSource(with: self.images)
            }
        }
    }
}

// MARK:- Collection View Flow Layout Delegate

extension AllPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}

// MARK:-   

extension AllPhotosCollectionViewController {
  
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, UIImage> {
        
        return UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, imageData: UIImage) -> PhotoCollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            cell.photo.image = self.images[indexPath.row]
            
            return cell
        }
    }
    
    func updateDataSource(with data: [UIImage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.allPhotos])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
