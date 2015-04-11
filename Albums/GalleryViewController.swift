//
//  GalleryViewController.swift
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

class GalleryViewController: UIViewController {

    
    @IBOutlet weak var albumView: UIImageView!
    @IBOutlet weak var outImageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var detailBtn: UIButton!
    
    private var albumIndex = 0
    private var currentAlbum: Album!
    private let library = AlbumLibrary.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        albumIndex = library.albums.count - 1
        refresh()
    }
    
    // обновление
    func refresh() {
        
        outImageView.hidden = true
        if library.albums.count != 0 {
            prevBtn.hidden = false
            nextBtn.hidden = false
            detailBtn.hidden = false
            currentAlbum = library.albums[albumIndex]
            albumView.image = UIImage(named: currentAlbum.coverImage)
            albumName.text = currentAlbum.name
            artistName.text = currentAlbum.artist
        } else {
            prevBtn.hidden = true
            nextBtn.hidden = true
            detailBtn.hidden = true
            albumView.image = UIImage(named: "coverImg0")
            albumName.text = "Нет альбомов"
            artistName.text = "Нажмите (+) чтобы загрузить"
        }
    }
    
    // Карусель
    func rollCarousel(direction: RollDirection) {
        
        // смена номера текущего альбома
        albumIndex += direction.rawValue
        // корректировка номера для зацикливания
        albumIndex = (albumIndex > library.albums.count - 1) ? 0 : (albumIndex < 0) ? library.albums.count - 1 : albumIndex
        // загрузка текущего альбома
        currentAlbum = library.albums[albumIndex]
        
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
        UIImageView.animateWithDuration(0.5) {
                        self.outImageView.alpha = 0
                        self.albumView.alpha = 1
                        self.outImageView.frame.origin.x = outFinalX
                        self.albumView.frame.origin.x = inFinalX
                        }

    }
    
    @IBAction func nextBtn(sender: UIButton) {
        
        rollCarousel(.next)
    }
    
    @IBAction func prevBtn(sender: UIButton) {
        
        rollCarousel(.prev)
    }

    
    // MARK: - Navigation
    
    // настраиваем TracksViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let newVC = segue.destinationViewController as? TracksViewController {
                newVC.currentAlbum = currentAlbum
        }
    }
    
}
