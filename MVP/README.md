# Test technique iOS 2020 - Capgemini (Mobile Factory, DCX, Paris): Implémentation architecture MVP

## Introduction

Ici, voici une implémentation du test technique avec l'architecture **MVP**.

## L'architecture MVP

L'architecture **MVP** (**Model View Presenter**) est un design pattern qui permet de séparer la logique métier et les interactions de l'interface utilisateur (UI). Cette architecture se compose en 3 éléments:
- Le **modèle (Model)** représente les différents modèles de données de l'application.
- La **vue (View)** représente l'UI (interface graphique) et les interactions utilisateurs (appui sur un bouton, saisie de texte, ...).
- La **présentation (Presenter)** est l'intermédiaire entre la vue et le modèle. Ses responsabilités sont de réagir aux actions de l'utilisateur, de gérer la logique métier (ici, récupérer les données du modèle) et de formater ces données pour la vue en charge de les afficher.

Particularité du **MVP**, la vue a une référence avec la présentation et la présentation ayant une référence avec la vue. La vue ne connait donc plus le modèle, c'est maintenant la présentation qui a une référence avec le modèle.

**ATTENTION: NE PAS CONFONDRE AVEC LA STRATÉGIE DE DÉVELOPPEMENT DE PRODUIT AYANT LE MÊME ACRONYME MVP, SIGNIFIANT ICI Minimum Viable Product.**

![Diagramme architecture MVP](MVPdiagram.png)<br>

### <a name="specificity"></a>Spécificités iOS pour le MVP

En partant du **MVC**, la vue et le contrôleur (`ViewController`) ne font désormais plus qu'un en **MVP**, ici la vue.<br>

**ATTENTION:** Étant donné que la vue a une référence avec la présentation et que la présentation a une référence avec la vue, il y a donc un cycle de référence entre eux. Par défaut les références sont fortes (`strong`), et dans ce cas, si la vue est détruite, il y a rétention de cycle et donc une fuite de mémoire (**memory leak**). L'une des 2 références du cycle doit être faible (`weak`) afin d'éviter le **memory leak**, et ici ce sera la présentation qui aura une référence faible vers la vue, la vue ayant une référence forte vers la présentation.

Concernant la mise à jour de la vue et du cycle de référence entre la vue et la présentation, le design pattern de la délégation (`delegate`) est utilisé en **MVP**.

Comparé à l'architecture **MVVM**, très populaire en entreprise, l'architecture **MVP** est une possibilité, mais à ma connaissance rarement utilisée comme choix d'architecture.

### <a name="advantages"></a>Avantages et inconvénients

Principaux avantages:
- Architecture adaptée pour séparer la vue de la logique métier par le biais de la présentation (**Presenter**).
- `ViewController` allégés.
- Tests facilités de la logique métier (Couverture du code par les tests renforcée), et possibilité d'utiliser des mocks (avec l'**injection de dépendances**) pour tester des services,...

Inconvénients:
- Les `Presenter` peuvent devenir massifs notamment dans des projets de très grande taille. Il est donc difficile de respecter l'ensemble des principes du **SOLID** et particulièrement le premier étant le principe de responsabilité unique (**SRP: Single Responsibility Principle**). La variante **MVP+C** qui utilise un `Coordinator` s'avère utile pour alléger les vues et gérer la navigation entre vues.
- Compréhension et maîtrise potentiellement compliquée pour les débutants, notamment du fait qu'il y a plusieurs façons de faire pour implémenter cette architecture, menant à des confusions et à des doutes.
- Complexité accrue avec davantage de code.
- Pour les grands projets, les `Presenter` peuvent devenir massifs.
- Gestion des rétentions de cycle.
- Inadapté pour la mise en place de la programmation réactive fonctionnelle avec **RxSwift** ou **Combine**, particulièrement pour la mise à jour de la vue par le `Presenter`.
- Architecture plus lourde que l'architecture **MVVM**.

## Ma solution

Pour l'exemple en **MVP**, je peux donc isoler `NewsListViewController` de la logique métier. J'utilise donc le concept clé du **MVP** qui est `NewsViewPresenter` qui va contenir toute cette logique métier. La particularité est que la relation entre `NewsListViewController` et `NewsListPresenter` se fait par une référence circulaire et par la délégation avec un `delegate`. Une référence forte (`strong`) de `NewsListViewController` vers `NewsViewPresenter` va se faire. De l'autre sens, on applique la délégation avec une référence faible (`weak`) vers le `NewsListViewController`, mais de manière indirecte avec une abstraction, ici le protocole `NewsListViewDelegate`. Ces méthodes déléguées du protocole seront implémentées par `NewsListViewController` et appelés depuis `NewsViewPresenter` pour la mise à jour de la vue.

```swift
final class NewsListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    ...
    // Référence circulaire. Forte de la vue avec le présentateur, faible du présentateur vers la vue.
    private lazy var presenter = NewsListPresenter(apiService: NewsAPIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        presenter.setViewDelegate(delegate: self)
        presenter.fetchNews()
    }
    ...
}

extension NewsListViewController: NewsListViewDelegate {
    func didLoadData(with viewModels: [ArticleViewModel]) {
        ...
    }
    
    func didErrorOccured(with errorMessage: String) {
        ...
    }
}
```

Comme en **MVVM**, le `Presenter` permettant ainsi de mieux tester la logique métier, j'utiliserai donc ici une injection de dépendance pour la récupération de données, avec une abstraction. Si j'effectue des tests unitaires avec `XCTest`, je fournirai donc un mock pour simuler les appels API, sinon dans l'appli je fournis une instance gérant les appels réseau. Dans les tests unitaires avec un presenter, il faudra simuler la vue avec la délégation.
```swift
protocol NewsListViewDelegate: AnyObject {
    func didLoadData(with viewModels: [ArticleViewModel])
    func didErrorOccured(with errorMessage: String)
}

final class NewsListPresenter {
    private let apiService: NewsAPIService?
    
    // Référence avec la vue, attention à la rétention de cycle (memory leak)
    weak private var delegate: NewsListViewDelegate?
    
    // Grâce à une injection de dépendance par le biais d'un type abstrait, la testabilité sera assurée si on utilise un mock pour simuler les appels d'API REST.
    init(apiService: NewsAPIService) {
        self.apiService = apiService
    }
    
    func setViewDelegate(delegate: NewsListViewDelegate){
        self.delegate = delegate
    }
    
    func fetchNews() {
        print("Call depuis le Presenter")
        apiService?.fetchNews { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    func searchNews(with query: String) {
        print("Call search depuis le Presenter")
        apiService?.searchNews(query: query) { [weak self] result in
            self?.handleResult(with: result)
        }
    }
    
    private func handleResult(with result: Result<ArticleOutput, NewsAPIError>) {
        switch result {
            case .success(let output):
                print("\(output.totalResults ?? 0) articles")
                
                guard let data = output.articles else {
                    print("ERREUR")
                    delegate?.didErrorOccured(with: NewsAPIError.decodeError.rawValue)
                    return
                }
                
                delegate?.didLoadData(with: parseViewModels(with: data))
                
            case .failure(let error):
                delegate?.didErrorOccured(with: error.rawValue)
        }
    }
    
    private func parseViewModels(with articles: [Article]) -> [ArticleViewModel] {
        var viewModels = [ArticleViewModel]()
        articles.forEach { viewModels.append(ArticleViewModel(article: $0)) }
        
        return viewModels
    }
}
```

Concernant l'utilisation de `RxSwift` et `RxCocoa` en **MVP**, on ne pourra pas faire comme en **MVVM**, les flux se feront comme en **MVC**. Pour l'émission des flux vers les abonnements de `NewsListViewController`, ils s'effectueront par le biais des méthodes déléguées de `NewsListViewDelegate`.

```swift
import UIKit
import RxSwift
import RxCocoa

final class NewsListViewController: UIViewController {
    ..
    private let disposeBag = DisposeBag()
    private let articles = PublishSubject<[ArticleViewModel]>()
    private let error = PublishSubject<String>()
    
    // Référence circulaire. Forte de la vue avec le présentateur, faible du présentateur vers la vue.
    private lazy var presenter = NewsListPresenter(apiService: NewsNetworkAPIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBindings()
        presenter.setViewDelegate(delegate: self)
        presenter.fetchNews()
    }
    
    private func setBindings() {
        // Recherche réactive
        searchBar.rx.text
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe { [weak self] query in
                self?.presenter.searchNews(with: query)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        // Les cellules une fois les données récupérées. L'actualisation est automatique et asynchrone.
        articles.bind(to: tableView.rx.items(cellIdentifier: "newsCell", cellType: NewsListTableViewCell.self)) { (row, element, cell) in
            cell.configure(with: element)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ArticleViewModel.self)
            .subscribe { [weak self] article in
                self?.openDetailView(with: article)
            }
            .disposed(by: disposeBag)
        
        // Affichage des erreurs
        error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    print("OK")
                }))
                
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension NewsListViewController: NewsListViewDelegate {
    func didLoadData(with viewModels: [ArticleViewModel]) {
        articles.onNext(viewModels)
    }
    
    func didErrorOccured(with errorMessage: String) {
        error.onNext(errorMessage)
    }
}
```

Pour terminer, je reprends un concept du **MVVM**, où le `ViewModel` peut aussi avoir comme simple responsabilité d'avoir des données formatées prêtes à afficher par la vue, c'est donc ici ce je mets en place avec `ArticleViewModel`. Je m'assure donc ainsi que `NewsListViewController` n'ait aucune connaissance du modèle, ici `Article`. `ArticleViewModel` pourra être utilisé dans chaque `TableViewCell` du `TableView`, mais aussi dans la vue détail.

```swift
struct ArticleViewModel {
    let source: String
    let author: String
    let title: String
    let description: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    // Injection de dépendance
    init(article: Article) {
        self.source = article.source?.name ?? "Source inconnue"
        self.author = article.author ?? "Auteur inconnu"
        self.title = article.title ?? "Titre indisponible"
        self.description = article.description ?? "Aucune description"
        self.urlToImage = article.urlToImage ?? ""
        self.publishedAt = article.publishedAt ?? "Date inconnue"
        self.content = article.content ?? "Contenu indisponible"
    }
}
```

Pour la suite du cheminement vers les autres architectures **VIPER**, ce type de `ViewModel` sera réutilisé, mais aussi la base avec le `Presenter`. 

Pour améliorer cette base en **MVP**, il sera alors possible d'isoler la navigation avec le pattern de la coordination (`Coordinator`), ce qui donnera donnera donc la variante **MVP+C**. Mais aussi d'imbriquer cette base **MVP** dans une **Clean Architecture**, au quel cas d'utiliser les design patterns appropriés pour bien gérer la séparation des responsabilités en couches, l'indépendance et améliorer davantage la testabilté. **MVVM** reste préférable que **MVP** car **MVP** est une architecture plus lourde que le **MVVM**.