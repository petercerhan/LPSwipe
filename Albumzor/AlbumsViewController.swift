//
//  AlbumsViewController.swift
//  Albumzor
//
//  Created by Peter Cerhan on 3/15/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//

import UIKit

protocol AlbumsViewControllerDelegate {
    func quit()
    func batteryComplete()
}

typealias AlbumUsage = (seen: Bool, liked: Bool, starred: Bool)

class AlbumsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var delegate: AlbumsViewControllerDelegate!
    
    var albumArt: [UIImage]!
    var albums: [Album]!
    var usage: [AlbumUsage]!
    
    var currentIndex: Int = 0
    
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func quit(){
        delegate.quit()
    }
    
    //Album liked
    @IBAction func likeAlbum() {
        print("liked \(currentIndex)")
        
        dataManager.like(album: albums[currentIndex].objectID)
    }
    
    
    //Album starred
    
    
    
    
    
    
    
    
    
    
}

extension AlbumsViewController: UICollectionViewDelegate {
    
}

extension AlbumsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if(indexPath.item < albums.count) {
            let album = albums[indexPath.item]
            cell.imageView.image = albumArt[indexPath.item]
            cell.titleLabel.text = album.name!
            cell.artistLabel.text = album.artist!.name!
        } else {
            cell.imageView.image = nil
            cell.titleLabel.text = ""
            cell.artistLabel.text = ""
        }
        
        return cell
    }
    
}

extension AlbumsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scroll detected")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("will begin dragging")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("did end dragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //print("will begin decelerating")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexDouble = scrollView.contentOffset.x / scrollView.frame.size.width
        let index = Int(indexDouble)
        currentIndex = index
        
        print("index: \(index) seen: \(usage[index].seen) liked: \(usage[index].liked)")
        
        if index == albums.count {
            delegate.batteryComplete()
        }
    }
    
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthPerItem = collectionView.frame.width - 40.0
        let cellHeight = collectionView.frame.height - 40.0
        
        return CGSize(width: widthPerItem, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
    }
}
