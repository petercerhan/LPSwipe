//
//  NextStepViewController.swift
//  Albumzor
//
//  Created by Peter Cerhan on 3/18/17.
//  Copyright © 2017 Peter Cerhan. All rights reserved.
//

import UIKit

protocol NextStepViewControllerDelegate: NSObjectProtocol {
    func quit()
    func nextBattery()
}

class NextStepViewController: UIViewController {

    weak var delegate: NextStepViewControllerDelegate!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var symbolLabel1: UILabel!
    @IBOutlet var symbolLabel2: UILabel!
    
    @IBOutlet var moreAlbumsButton: UIButton!
    @IBOutlet var reseedButton: UIButton!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    var likedAlbums = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        symbolLabel1.text = "\u{1F3B5}"
        symbolLabel2.text = "\u{1F3B5}"
        
        countLabel.alpha = 0.0
        questionLabel.alpha = 0.0
        symbolLabel1.alpha = 0.0
        symbolLabel2.alpha = 0.0
        moreAlbumsButton.alpha = 0.0
        reseedButton.alpha = 0.0
        homeButton.alpha = 0.0
        infoButton.alpha = 0.0
        
        if likedAlbums == 1 {
            countLabel.text = "\(likedAlbums) new album"
        } else {
            countLabel.text = "\(likedAlbums) new albums"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    @IBAction func home() {
        delegate.quit()
    }
    
    @IBAction func reseed() {
        let alert = UIAlertController(title: nil, message: "Are you sure you would like to re-seed LPSwipe?\n\nYour saved albums will not be erased. You will need to choose new seed artists.", preferredStyle: .alert)
        
        let reseedAction = UIAlertAction(title: "Re-Seed", style: .default) { action in
            //self.appDelegate.mainContainerViewController!.resetData(action: .reseed)
            self.dismiss(animated: false, completion: nil)
            self.appDelegate.mainContainerViewController!.resetData(action: .reseed)
            //something different
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(reseedAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reseedInfo() {
        alert(title: "Re-Seed", message: "Choose new seed artists. \n\nThe current data used for suggesting albums will be erased, and you can choose a new set of seed artists.\n\nYour liked ablums will not be erased.", buttonTitle: "Done")
    }
    
    @IBAction func continueBrowsing() {
        delegate.nextBattery()
    }
    
    func animateIn() {

        var delay = 0.7
        
        //2) Line 2
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        self.countLabel.alpha = 1.0
                        self.symbolLabel1.alpha = 1.0
                        self.symbolLabel2.alpha = 1.0
        },
                       completion: nil)
        
        delay += 1.0
        //2) Line 3
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        self.questionLabel.alpha = 1.0
        },
                       completion: nil)
        
        
        delay += 0.6
        //2) 1st Button
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        self.moreAlbumsButton.alpha = 1.0
        },
                       completion: nil)
        
        
        delay += 0.1
        //2) 2nd Button
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        self.reseedButton.alpha = 1.0
                        self.infoButton.alpha = 1.0
        },
                       completion: nil)
        
        delay += 0.1
        //2) 3rd Button
        UIView.animate(withDuration: 0.4,
                       delay: delay,
                       options: .curveLinear,
                       animations: {
                        self.homeButton.alpha = 1.0
        },
                       completion: nil)
        
        
    }

}
