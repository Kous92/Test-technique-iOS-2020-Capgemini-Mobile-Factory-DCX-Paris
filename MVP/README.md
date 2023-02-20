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

### <a name="advantages"></a>Avantages et inconvénients

Principaux avantages:
- Architecture adaptée pour séparer la vue de la logique métier par le biais de la présentation (**Presenter**).
- `ViewController` allégés.
- Tests facilités de la logique métier (Couverture du code par les tests renforcée), et possibilité d'utiliser des mocks (avec l'**injection de dépendances**) pour tester des services,...

Inconvénients:
- Les `Presenter` peuvent devenir massifs notamment dans des projets de très grande taille. Il est donc difficile de respecter l'ensemble des principes du **SOLID** et particulièrement le premier étant le principe de responsabilité unique (**SRP: Single Responsibility Principle**). La variante **MVP+C** qui utilise un `Coordinator` s'avère utile pour alléger les vues et gérer la navigation entre vues.
- Compréhension et maîtrise compliquée pour les débutants, notamment du fait qu'il y a plusieurs façons de faire pour implémenter cette architecture, menant à des confusions et à des doutes.
- Complexité accrue avec davantage de code.
- Pour les grands projets, les `Presenter` peuvent devenir massifs.
- Gestion des rétentions de cycle.
- Inadapté pour la mise en place de la programmation réactive fonctionnelle avec **RxSwift** ou **Combine**, particulièrement pour la mise à jour de la vue par le `Presenter`.

## Ma solution