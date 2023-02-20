# Test technique iOS 2020 - Capgemini (Mobile Factory, DCX, Paris): Implémentation architecture VIPER

## Introduction

Ici, voici une implémentation du test technique avec l'architecture **VIPER**, le tout avec **UIKit**.

## L'architecture VIPER

L'architecture **VIPER** (**View Interactor Presenter Entity Router**) est un design pattern qui permet de séparer la logique métier et les interactions de l'interface utilisateur (UI).


 Cette architecture se compose en **modules** représentant chacun un **use case** (cas d'utilisation précis). Chaque module se compose de 5 éléments:
- La **vue (View)** représente l'UI (interface graphique) et les interactions utilisateurs (appui sur un bouton, saisie de texte, ...).
- L'**intéracteur (Interactor)** est l'intermédiaire entre la vue et le modèle. Ses responsabilités sont de réagir aux actions de l'utilisateur, de gérer la logique métier (ici, récupérer les données du modèle), de formater les données récupérées et mettre à jour la vue en disposant d'attributs que la vue affichera par le biais du data binding (liaison de données).
- La **présentation (Presenter)** représente les différents modèles de données de l'application.
- L'**entité (Entity)** représente les différents modèles de données de l'application. Comme le modèle en **MVC**, **MVVM** et **MVP**.
- Le **modèle (Routeur)** représente les différents modèles de données de l'application.

**NOTE: L'entité est souvent commune à plusieurs modules VIPER dans l'application. Il n'est pas nécessaire d'implémenter des modèles de données spécifiques s'il n'y en a pas besoin.** 

![Diagramme architecture VIPER](VIPERdiagram.png)<br>

### <a name="specificity"></a>Spécificités iOS pour le VIPER

En partant du **MVC**, la vue et le contrôleur (`ViewController`) ne font désormais plus qu'un en **VIPER**, ici la vue.<br>

### <a name="advantages"></a>Avantages et inconvénients

- Principaux avantages:
    + Architecture adaptée pour séparer la vue de la logique métier par le biais de la présentation (`Presenter`) et de l'intéracteur (`Interactor`).
    + Le premier principe du **SOLID**, principe de responsabilité unique (SRP: Single Responsibility Principle) est respecté.
    + Adapté pour les projets de grande taille pour bien séparer la
    + `ViewController` et `Presenter` allégés.
    + Grande modularité pour développer et tester indépendamment différentes parties de l'application pour permettre ensuite leur intégration.
    + Maintenabilité renforcée grâce à une séparation précise des responsabilités. La modification d'un partie de l'app en est facilitée sans affecter les autres parties (un des principes de la **Clean Architecture**), respectant ainsi le dernier principe du **SOLID**, l'inversion de dépendances (**DI: Dependency Inversion**)

- Inconvénients:
    + Architecture très complexe: Avec beaucoup de code qui se rajoute, la phase de développement initiale est ralentie.
    + Maîtrise **très difficile** pour les juniors, notamment du fait qu'il y a plusieurs façons de faire pour implémenter cette architecture, menant à des confusions et à des doutes. Il est préférable pour un junior de cheminer avec l'architecture **MVVM** puis **MVP** pour mieux comprendre et implémenter cette architecture.
    + Onboarding projet difficile, la logique de l'application en **VIPER** nécessite un temps d'adaptation beaucoup plus long.
    + Gestion des rétentions de cycle (bien plus qu'en **MVP**).
    + Compatibilité complexe avec **SwiftUI**, les vues étant de type valeur (dans des struct), le concept ici nécessitant des types références (donc des classes).
    + Pour respecter à 100% les principes du **SOLID**, une vraie implémentation des principes de la **Clean Architecture** sera nécessaire.
