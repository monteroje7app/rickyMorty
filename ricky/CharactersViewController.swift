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
    
    var isLoading: Bool = false
    var page: Int = 1
    var pageNext: URL?
    var pagePrev: URL?
    var pageCount = 0
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
        if !self.isLoading {
            self.isLoading = true
            let url = Constants.K.ProductionServer.baseURL +  Constants.Endopint.characters.rawValue
            var parameters: [String: String] = [:]
            
            if let filterBy = filterBy {
                parameters["status"] = filterBy
                parameters["page"] = self.page.formatted()
            }
            showSpinner()
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                AF.request(url, parameters: parameters).validate().responseDecodable(of: CharacatersDto.self) { [self] (response) in
                    guard let char = response.value else { return }
                    self.characters = char.results
                    self.characters.sorted(by: ({ $0.id
                        < $1.id }) )
                    self.lbCount.text = "Total: \(char.info.count)"
                    self.pageCount = char.info.pages
                    self.lbPagination.text = "Pág \(self.page.formatted()) /\(char.info.pages.formatted())"
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.isLoading = false
                        self.collectionView.layoutIfNeeded()
                        hideSpinner()
                    }
                }
            }
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
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CharacterViewController else {return}
        vc.character_ = sender as? Character
     }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard !isLoading else {
            return CGSize.zero
        }
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
    

    fileprivate func fetchByFiltred() {
        switch tabBar.selectedItem?.tag {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         
         if offsetY > contentHeight - scrollView.frame.size.height {
             guard page <= pageCount, !isLoading else { return }
             page += 1
         } else if offsetY < 0 {
             guard page > 1, !isLoading else { return }
             page -= 1
         }
        
        fetchByFiltred()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCharacterDetail", sender:  self.characters[indexPath.row])
    }
    
}

extension CharactersViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        page = 1
        fetchByFiltred()
    }
}

