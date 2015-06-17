# ![](https://github.com/DmitrJuga/Albums/blob/master/Albums/Images.xcassets/AppIcon.appiconset/depositphotos_8950241-Music-cd-icon-29@2x.png)  Фонотека / Albums

**"Фонотека"** - простая библиотека музыкальных альбомов. Учебный (тестовый) проект на **Swift** c использованием  **CoreData**, **Alamofire**, **SwiftyJSON** и серверного приложенияи на [parse.com](http://parse.com).

![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot6.png)
![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot1.png)


## Функционал

- Хранение и отображение *"фонотеки"* - библиотеки музыкальных альбомов.
- Отображение сожержимого альбома - списка треков.
- Возможность добавления новых альбомов с сервера.
- Возможность удаления альбомов из локальной библиотеки.
- Каждый альбом содержит следующую информацию: название, исполнитель, изображение обложки альбома, год издания, кол-во треков, общая длительность, а также список треков с номером, названием и длительностью каждого трека.
- Просмотр фонотеки возможен как в виде списка альбомов, так и в виде галереи изображений - обложек альбомов (перелистывание кнопками или свайпами, с анимированной сменой изображения).
- При добавление новых альбомов в локальную фонотеку сначала загружается общий список альбомов на сервере, а затем производится загрузка выбранного альбома и его сохранение.


## Технические детали

**Модель данных**:

- Использование **CoreData** для локального хранения библиотеки альбомов.
- Cобственный хелпер (класс `CoreDataHelper`) для работы с CoreData (инициализация стека, загрузка данных, другие операции).
- Хранимая модель данных содержит две связанные сущности (*entity*): `Album` и `Track`, представленные в приложении соответствующими классами - `Album` и `Track`, наследниками `NSManagedObject`.
- Классы `Album` и `Track` расширены методами для маппинга из JSON-формата и вычисляемыми свойствами для удобного представления данных.
- Логика управления списком альбомов реализована в классе `AlbumLibrary` (в т.ч. оповещение контроллеров об изменениях данных нотификациями через `NSNotificationCenter`).

**Работа с сетью**
- На сервере [parse.com](http://parse.com) развёрнуто самодельное тестовое приложение *Albums*, возвращающее список альбомов, треки и изображения для обложек альбомов.
- Взаимодействие с сервером осуществляется по REST API.
- Логика взаимодействия с серверным API реализована в классе `AlbumServer` (в т.ч. авторизация путём добавления ключей доступа в HTTP-заголовки запросов).
- Для работы с сетью используется внешниняя библиотека **Alamofire** (через *CocoaPods*).
- Для парсинга JSON используется внешниняя библиотека **SwiftyJson** (через *CocoaPods*).

**App UI**
- В UI приложения построено в Storyboard; используется 4 `UIViewController`-а, `UITabBarController`, `UINavigationController`, Segue-переходы.
- Используется `UITableView` c кастомными ячейками и удалением строк, а также `UITableView` со стандартными ячеками.
- Анимация смены картинок в Галерее с помощью `UIView.animateWithDuration`.
- Обновление данных во view при получении нотификацих через `NSNotificationCenter`.
- Auto Layout (констрейнты в Storyboard).
- Launch Screen, App Icon (изображения из свободных web-источников).

## Ещё скриншоты

![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot3.png)
![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot2.png)
![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot5.png)
![](https://github.com/DmitrJuga/Albums/blob/master/screenshots/screenshot4.png)

## Основа проекта

Проект создан на основе моих домашних работ к урокам 2, 3, 4, 5 по курсу **"Swift. Современные технологии программирования под Apple"** в [НОЧУ ДО «Школа программирования» (http://geekbrains.ru)](http://geekbrains.ru/) и доработан после окончания курса. Домашнее задание и пояснения к выполненой работе - см. в [homework_readme.md](https://github.com/DmitrJuga/Albums/blob/master/homework_readme.md).

---

### Контакты

**Дмитрий Долотенко / Dmitry Dolotenko**

Krasnodar, Russia   
Phone: +7 (918) 464-02-63   
E-mail: <dmitrjuga@gmail.com>   
Skype: d2imas

:]

