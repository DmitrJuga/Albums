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
    
    var albumIndex = 0
    var currentAlbum: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outImageView.hidden = true
        currentAlbum = AlbumLibrary.getAlbum(albumIndex)
        albumView.image = UIImage(named: currentAlbum.coverImage)
        albumName.text = currentAlbum.name
        artistName.text = currentAlbum.artist
    }

    
    // Карусель
    func rollCarousel(direction: RollDirection) {
        
        //Смена номера текущего альбома
        albumIndex += direction.rawValue
        //Корректировка номера для зацикливания
        albumIndex = (albumIndex > AlbumLibrary.count - 1) ? 0 : (albumIndex < 0) ? AlbumLibrary.count - 1 : albumIndex
        //Загрузка текущего альбома
        currentAlbum = AlbumLibrary.getAlbum(albumIndex)

        
        // апдейт подписей
        albumName.text = currentAlbum.name
        artistName.text = currentAlbum.artist
        
        //--- Анимация смены картинки ---
        
        // параметры для "отъезда" старой картинки в outImageView
        let outStartX = albumView.frame.origin.x
        let outFinalX = (view.frame.size.width) * CGFloat(direction.rawValue) * -1
        outImageView.image = albumView.image
        outImageView.frame.origin.x = outStartX
        outImageView.hidden = false
        outImageView.alpha = 1
        
        // параметры для "прибытия" новой картинки в albumView
        let inStartX = (view.frame.size.width) * CGFloat(direction.rawValue)
        let inFinalX = albumView.frame.origin.x
        albumView.image = UIImage(named: currentAlbum.coverImage)
        albumView.frame.origin.x = inStartX
        albumView.alpha = 0
        
        // запуск анимации
        UIImageView.animateWithDuration(0.5,
            animations: {self.outImageView.alpha = 0
                self.outImageView.frame.origin.x = outFinalX})
        
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

    
    // MARK: - Navigation
    
    // настраиваем AlbumDetailsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? AlbumDetailsViewController {
                newVC.currentAlbum = currentAlbum
        }
    }
    
}
