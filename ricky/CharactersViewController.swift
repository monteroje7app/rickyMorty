//
//  CharactersViewController.swift
//  ricky
//
//  Created by Jose Montero on 3/10/22.
//

import UIKit
import Alamofire
import Kingfisher

enum RickyConstants {
    static let reuseIdentifier = "CharacterCell"
    static let sectionInsets = UIEdgeInsets(top: 8.0, left: 4.0, bottom: 8.0, right: 4.0)
    static let itemsPerRow: CGFloat = 5
}

class CharactersViewController: BaseViewController {

    var characters: [Character] = []
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var lbPagination: UILabel!
    
    var page: Int = 1
    var pageNext: URL?
    var pagePrev: URL?
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Personajes"
        tabBar.delegate = self
        collectionView.register(UINib.init(nibName: "collectionView", bundle: nil), forCellWithReuseIdentifier: "collectionView")

        fetchCharacters(filterBy: nil)
    }
}

extension CharactersViewController {
    
    func fetchCharacters(filterBy: String?) {
        let url = Constants.K.ProductionServer.baseURL +  Constants.Endopint.characters.rawValue
        var parameters: [String: String] = [:]
        
        if let filterBy = filterBy {
            parameters["status"] = filterBy
            parameters["page"] = self.page.formatted()
        }
        showSpinner()
        AF.request(url, parameters: parameters).validate().responseDecodable(of: CharacatersDto.self) { [self] (response) in
            hideSpinner()
            guard let char = response.value else { return }
            self.characters = char.results
            self.characters.sorted(by: ({ $0.id
                < $1.id }) )
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.lbCount.text = "Total: \(char.info.count)"
            self.lbPagination.text = "Pág \(self.page.formatted()) /\(char.info.pages.formatted())"
            collectionView.isScrollEnabled = true

        }
    }
}

extension CharactersViewController : UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return characters.count
    }
    
     func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RickyConstants.reuseIdentifier,
                for: indexPath
            ) as? CharacterCell
                
        else {
            preconditionFailure("Invalid cell type")
        }
        cell.data =  self.characters[indexPath.row]
        cell.layoutIfNeeded()
        
        // 1
    //    cell.activityIndicator.stopAnimating()
        
        // 2
//        guard indexPath == largePhotoIndexPath else {
//            cell.imageView.image = flickrPhoto.thumbnail
//            return cell
//        }
        
        // 3
//        cell.isSelected = true
//        guard flickrPhoto.largeImage == nil else {
//            cell.imageView.image = flickrPhoto.largeImage
//            return cell
//        }
        
        // 4
     //   cell.imageView.image = flickrPhoto.thumbnail
        
        // 5
     //   performLargeImageFetch(for: indexPath, flickrPhoto: flickrPhoto, cell: cell)
        
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let paddingSpace = RickyConstants.sectionInsets.left * (RickyConstants.itemsPerRow + 1)
        let paddingSpaceH = RickyConstants.sectionInsets.top * (RickyConstants.itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / RickyConstants.itemsPerRow
        let availableHeight = collectionView.frame.height - paddingSpaceH
        let heightPerItem = availableHeight / ( 20 / RickyConstants.itemsPerRow )
        
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return RickyConstants.sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return RickyConstants.sectionInsets.left
    }
    
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         
         if offsetY >= contentHeight - scrollView.frame.size.height {
             scrollView.isScrollEnabled = false
             if (tabBar.selectedItem?.tag == 1) {
                 page += 1
                 fetchCharacters(filterBy: "alive")
                 scrollView.scrollsToTop
             }
         }
    }
}

extension CharactersViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 1:
                fetchCharacters(filterBy: "alive")
                break
            case 2:
                fetchCharacters(filterBy: "dead")
                break
            case 3:
                fetchCharacters(filterBy: "unknown")
                break
            default:
                fetchCharacters(filterBy: nil)
        }
    }
}
