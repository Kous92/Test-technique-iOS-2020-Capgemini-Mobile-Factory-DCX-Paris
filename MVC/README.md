# Test technique iOS 2020 - Capgemini (Mobile Factory, DCX, Paris): Implémentation architecture MVC

## Introduction

Ici, voici une implémentation du test technique avec l'architecture **MVC**.

## L'architecture MVC

L'architecture **MVC** (**Model View Controller**) se compose en 3 éléments:
- Le **modèle (Model)** représente les différents modèles de données de l'application (la logique).
- La **vue (View)** représente l'UI (interface graphique) et les interactions utilisateurs (appui sur un bouton, saisie de texte, ...).
- Le **contrôleur (Controller)** est l'intermédiaire entre la vue et le modèle. Ses responsabilités sont de réagir aux actions de l'utilisateur, de gérer la logique métier (ici, récupérer les données du modèle) et de formater ces données pour la vue en charge de les afficher.

### <a name="specificity"></a>Spécificités iOS pour le MVC

- Pour le `View`, ce sont les `Storyboard`, les `XIB` et toutes les vues comme les `TableViewCell` ou les `UIView`.
- Pour le `Controller`, c'est le `ViewController`. `View` est souvent associé avec `Controller` dans **UIKit**, d'où `ViewController` mis en place par Apple.

**MVC l'architecture par défaut avec `UIKit`**.

### <a name="problems"></a>Problèmes du MVC en iOS

Le seul avantage du **MVC**, c'est sa simplicité d'implémentation.

L'architecture **MVC** a déjà un énorme point faible, sa testabilité. En effet, dans le `ViewController`, on y met les vues, la logique métier (business logic), les liens vers les modèles, la navigation, ... Avec ces dépendances à la vue, tester la logique métier devient impossible si elle est dépendante du `ViewController`.

Le second problème est sa maintenabilité, du fait que lorsque le projet devient plus grand et complexe, le `ViewController` devient alors massif. D'où la seconde signification de **MVC: Massive View Controller**. Du fait qu'il y ait toutes les responsabilités et les dépendances, la maintenance devient plus compliquée (au risque de tout casser). Et le 1er principe du **SOLID** de la responsabilité unique **(S: Single Responsibility Principle)** est absolument impossible à respecter.

Aujourd'hui, l'écrasante majorité des projets iOS en entreprise avec **UIKit** ne se font pas avec **MVC**.

## Ma solution

Pour l'exemple en MVC, j'essaie ici de séparer les responsabilités dans `NewsListViewController`. Pour cela, j'utilise une extension pour y placer le code de la logique métier, ici les appels d'API lors de l'initialisation de la vue pour récupérer les news en tendance et lors d'une recherche avec un sujet précis.

Utilisant aussi `RxSwift` et `RxCocoa`, on place les sujets (`PublishSubject`) de la liste d'articles et du message d'erreur dans le `ViewController`. Dès lors que l'appel API est terminé, en fonction du résultat, on émet un événement asynchrone avec `onNext()` qui contiendra soit la liste d'articles pour la `TableView`, soit un message d'erreur. La vue réagira avec les abonnements, définis dans `setBindings()` afin d'actualiser la vue en temps réel. L'utilisation de `RxSwift` permet de se dispenser de `DispatchQueue.main.async`.

```swift
import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* Partie RxSwift:
     - PublishSubject: un sujet (Subject) faisant office d'émetteur (Observer) et de récepteur (Observable, abonné). Avec .onNext(), on émet une valeur. Particularité de ce type de sujet: démarre sans valeur et émet seulement des nouveaux éléments aux abonnés.
       -> La partie qui va s'abonner au sujet recevra la valeur avec .subscribe(onNext: { value in })
    */
    private let disposeBag = DisposeBag()
    private let articles = PublishSubject<[Article]>()
    private let error = PublishSubject<NewsAPIError>()
    private var apiService = NewsAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        fetchNews()
    }

    ...
}
// Logique métier (Business logic), pour effectuer les appels d'API REST.
extension NewsListViewController {
    private func fetchNews() {
        apiService.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func searchNews(with query: String) {
        apiService.searchNews(query: query) { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) {
        switch result {
            case .success(let output):
                print("\(output.totalResults ?? 0) articles")
                
                guard let data = output.articles else {
                    print("ERREUR")
                    self.error.onNext(.decodeError)
                    return
                }
                
                articles.onNext(data)
                
            case .failure(let error):
                self.error.onNext(error)
        }
    }
}
```