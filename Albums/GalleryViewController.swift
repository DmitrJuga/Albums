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
    
    private var currentIndex = 0

    var albumIndex = 0 {
        didSet {
            if albumIndex != oldValue {
                let direction = (albumIndex - oldValue) / abs(albumIndex - oldValue)
                currentIndex += direction
                currentIndex = (currentIndex > library.albums.count - 1) ? 0 : (currentIndex < 0) ? library.albums.count - 1 : currentIndex
                albumIndex = currentIndex
                currentAlbum = library.albums[albumIndex]
                rollCarousel(direction)
            }
        }
    }
    
    var currentAlbum: Album! {
        didSet {
            albumName.text = currentAlbum.name
            artistName.text = currentAlbum.artist
        }
    }
    
    private let library = AlbumLibrary.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // подписываемся на нотификаций от AlbumLibrary
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeHandler:"), name: nil, object: library)
    }
    
    // обработчик нотификаций об изменениях в AlbumLibrary
    func changeHandler(notification: NSNotification) {
        currentIndex = notification.userInfo!["index"] as! Int
        setupUI()
    }
    
    // отписываемся от нотификаций
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // начальная установка UI
    func setupUI() {
        outImageView.hidden = true
        if library.albums.count != 0 {
            prevBtn.hidden = false
            nextBtn.hidden = false
            detailBtn.hidden = false
            currentAlbum = library.albums[currentIndex]
            albumView.image = currentAlbum.image
        } else {
            prevBtn.hidden = true
            nextBtn.hidden = true
            detailBtn.hidden = true
            albumView.image = UIImage(named: "defaultCover")
            albumName.text = "Нет альбомов"
            artistName.text = "Нажмите (+) чтобы загрузить"
        }
    }
    
    // "Карусель" - анимация смены картинки
    func rollCarousel(direction: Int) {
        // параметры для "отъезда" старой картинки в outImageView
        let outStartX = albumView.frame.origin.x
        let outFinalX = view.frame.size.width * CGFloat(direction) * -1
        outImageView.image = albumView.image
        outImageView.frame.origin.x = outStartX
        outImageView.hidden = false
        outImageView.alpha = 1
        
        // параметры для "прибытия" новой картинки в albumView
        let inStartX = view.frame.size.width * CGFloat(direction)
        let inFinalX = albumView.frame.origin.x
        albumView.image = currentAlbum.image
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
    
    
// MARK: - Action Handlers
    
    @IBAction func nextBtnPressed(sender: UIButton) {
        albumIndex++
    }
    
    @IBAction func prevBtnPressed(sender: UIButton) {
        albumIndex--
    }

    
// MARK: - Navigation
    
    // настраиваем TracksViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? TracksViewController {
                newVC.album = currentAlbum
        }
    }
    
}
