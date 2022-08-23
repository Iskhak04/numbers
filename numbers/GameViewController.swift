//
//  GameViewController.swift
//  numbers
//
//  Created by Iskhak Zhutanov on 22/8/22.
//

import UIKit

class GameViewController: UIViewController {
    
    lazy var numberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(NumberCell.self, forCellWithReuseIdentifier: "number-cell")
        return view
    }()
    
    var timerLabel = UILabel()
    
    var squareCount = 0

    var numbers: [NumberModel] = []
    
    var checkNums = [0, 0]
    
    var timer = Timer()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
    }
    
    func layout() {
        for i in 1...squareCount {
            numbers.append(NumberModel(num: i, isRemoved: false))
        }
        
        numbers.shuffle()
        
        view.backgroundColor = .white
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        view.addSubview(numberCollectionView)
        numberCollectionView.translatesAutoresizingMaskIntoConstraints = false
        numberCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        numberCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        numberCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        numberCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        timerLabel.font = timerLabel.font.withSize(50)
    }
    
    @objc func timerCounter() {
        count += 1
        let time = solve(seconds: count)
        let timeString = makeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func solve(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func makeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += "  :  "
        timeString += String(format: "%02d", minutes)
        timeString += "  :  "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "number-cell", for: indexPath) as! NumberCell
        cell.fillNums(model: numbers[indexPath.row])
        if numbers[indexPath.row].isRemoved {
            cell.backgroundColor = .white
            cell.number.isHidden = true
        } else {
            cell.backgroundColor = .blue
            cell.layer.cornerRadius = 20
            cell.number.isHidden = false
        }
        return cell
    }
}


extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Int(exactly: numbers[indexPath.row].num)! - 1 == checkNums[checkNums.count - 1] {
            checkNums.append(Int(exactly: numbers[indexPath.row].num)!)
            numbers[indexPath.row].isRemoved = true
            numberCollectionView.reloadData()
        }
        if numbers.filter({$0.isRemoved == true}).count == numbers.count {
            timer.invalidate()
            numberCollectionView.reloadData()
        }
    }
}
