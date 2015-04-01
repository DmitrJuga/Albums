//
//  GalaryViewController.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit


enum RollDirection: Int {
    case prev = -1
    case next = 1
}

class GalaryViewController: UIViewController {

    
    @IBOutlet weak var albumView: UIImageView!
    @IBOutlet weak var outImageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outImageView.hidden = true
        albumView.image = UIImage(named: AlbumLibrary.list[currentAlbumN].coverImage)
        albumName.text = AlbumLibrary.list[currentAlbumN].name
        artistName.text = AlbumLibrary.list[currentAlbumN].artist
    }
    
    
    var currentAlbumN = 0
    
    // Карусель
    func rollCarousel(direction: RollDirection) {
        //Смена номера альбома
        currentAlbumN += direction.rawValue
        if currentAlbumN < 0 {
            currentAlbumN = AlbumLibrary.list.count - 1
        } else if currentAlbumN > AlbumLibrary.list.count - 1 {
            currentAlbumN = 0
        }
        
        // апдейт подписи
        albumName.text = AlbumLibrary.list[currentAlbumN].name
        artistName.text = AlbumLibrary.list[currentAlbumN].artist
        
        //--- Анимация смены картинки ---
        // (анимация работает только при отключеном AutoLayout)
        
        //  "отъезд" старой картинки - в outImageView
        let outStartX = albumView.frame.origin.x
        let outFinalX = (view.frame.size.width) * CGFloat(direction.rawValue) * -1
        outImageView.image = albumView.image
        outImageView.frame.origin.x = outStartX
        outImageView.hidden = false
        outImageView.alpha = 1
        
        //  "прибытие" новой картинки - в albumView
        let inStartX = (view.frame.size.width) * CGFloat(direction.rawValue)
        let inFinalX = albumView.frame.origin.x
        albumView.image = UIImage(named: AlbumLibrary.list[currentAlbumN].coverImage)
        albumView.frame.origin.x = inStartX
        albumView.alpha = 0
        
        // запуск анимации
        UIImageView.animateWithDuration(0.5,
            animations: {self.outImageView.alpha = 0
                self.outImageView.frame.origin.x = outFinalX })
        
        UIView.animateWithDuration(0.5,
            animations: {self.albumView.alpha = 1
                self.albumView.frame.origin.x = inFinalX})
        
    }
    
    
    @IBAction func nextBtn(sender: UIButton) {
        rollCarousel(.next)
    }
    
    @IBAction func prevBtn(sender: UIButton) {
        rollCarousel(.prev)
    }

}
