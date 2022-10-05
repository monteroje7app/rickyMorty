
import UIKit

class CharacterCell: UICollectionViewCell {
 @IBOutlet weak var imageView: UIImageView!

 @IBOutlet private weak var lbPlanet: UILabel!
 @IBOutlet private weak var lbName: UILabel!
 @IBOutlet private weak var lbStatus: UILabel!
    

    var data: Character? {
        didSet {
            guard let data = data else { return }
            self.lbName.text = data.name.capitalized
            self.lbPlanet.text = data.origin.name
            self.lbStatus.text = data.status
            setupImage(imageName: data.image)
        }
    }
    
  override func awakeFromNib() {
    super.awakeFromNib()
  }
    
    func setupImage(imageName: String) {
        let url = URL(string: imageName )
        self.imageView.kf.setImage(with: url)
        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
        self.imageView.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
     
}
