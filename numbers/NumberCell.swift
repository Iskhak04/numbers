import UIKit

class NumberCell: UICollectionViewCell {
    var number = UILabel()
    var isRem = false
    
    func fillNums(model: NumberModel) {
        number.text = String(model.num)
        isRem = model.isRemoved
    }
    
    override func layoutSubviews() {
        addSubview(number)
        number.translatesAutoresizingMaskIntoConstraints = false
        number.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        number.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        number.font = number.font.withSize(30)
        number.textColor = .white
    }
}
