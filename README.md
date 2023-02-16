# Test technique iOS 2020 - Capgemini (Mobile Factory, DCX, Paris)

## Introduction

Ici un test technique que j'ai réalisé lors de mon stage de fin d'études en 2020, au sein de Capgemini, à Paris, plus précisément à Issy-les-Moulineaux. 

En interne, au sein de la Mobile Factory de la Business Unit DCX (Digital Customer eXperience) Paris, lors de mon upskilling iOS, cet exercice ci-dessous m'a été proposé par l'un des leads iOS internes.

En 2020, pendant le COVID, durant mon stage, je n'étais pas au top de mes capacités, j'étais vraiment en position de pur débutant d'iOS ayant enfin eu l'opportunité de travailler avec un Mac ayant suffisamment de capacité (surtout la RAM avec 16 GB) pour faire de développement iOS avec Xcode. Moralement, je n'étais pas bien aussi. C'est aussi là que je commence à peine à me sensibiliser aux différentes architectures, mais je ne savais clairement pas comment m'y prendre pour les implémenter. Je n'avais fait ce test qu'avec l'architecture MVC. L'architecture la plus appréciée par le lead à cette époque en 2020: **Clean Swift**, c'est-à-dire une **Clean Architecture** avec le cycle **VIP**.

Pour information, c'est aussi de ce test technique que j'ai eu l'inspiration de mon projet personnel qu'est [SuperNews](https://github.com/Kous92/SuperNews-iOS-Swift5).

Aujourd'hui en 2023, avec le recul et tout ce que j'ai appris, je vous montre maintenant mes différentes implémentations avec les architectures qu'on utilise en iOS, ici **MVC**, **MVVM**, **MVP** et Clean (ici Clean Swift).

J'invite tout développeur iOS junior et débutant à s'exercer en effectuant ce test.

### Mes implémentations

Pour mes réalisations, vos reviews seront plus que les bienvenus

Voici le sujet ci-dessous.

## Sujet

Développer une application qui consomme l’API News en affichant les articles dans une `tableView`. Au clic sur un article, l’article est affiché (`push`) dans un nouvel écran (voir maquettes ci-dessous).

### API à utiliser: NewsAPI

- Endpoint de l'API: https://newsapi.org/v2/top-headlines?country=fr&apiKey=API_KEY
- Clé d'API: à récupérer sur https://newsapi.org en y créeant un compte.
- Documentation: https://newsapi.org/docs

### Obligatoire

- Vue principale
- Architecture (MVC, MVP, MVVM, Clean)
- Langage: Swift
- Appel REST avec Alamofire (intégration avec CocoaPods)
- Téléchargement asynchrone des images
- Utilisation d’un ou plusieurs `Storyboard` (`AutoLayout`)

### Facultatif

- Vue détail
- RxSwift
- Tests unitaires
- Search bar pour chercher en fonction des sources/titre
- Layout Anchors
- Parsing avec Swift (ici `Decodable`)

### Maquettes

1) Vue principale (obligatoire)

![ListView](ListView.png)

2) Vue détail (facultative)

![DetailView](DetailView.png)