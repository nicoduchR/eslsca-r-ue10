# GUIDE DE RÉFÉRENCE : Analyse Statistique Complète

## But de ce document

Ce document est une référence pour réaliser une analyse statistique complète d'un fichier de données. Il permet de :

1. Identifier correctement le type de chaque variable
2. Choisir le test statistique approprié selon la question posée
3. Vérifier les conditions de validité avant d'appliquer un test
4. Interpréter correctement les résultats
5. Structurer un rapport Word professionnel

---

# ÉTAPE 1 : Identification des Types de Variables

## 1.1 Classification des variables

Avant toute analyse, chaque variable du jeu de données doit être classifiée.

### Variables Quantitatives (numériques)

| Type | Description | Exemples | Opérations possibles |
|------|-------------|----------|---------------------|
| **Continue** | Peut prendre n'importe quelle valeur dans un intervalle | Taille, poids, température, salaire, concentration | Moyenne, écart-type, corrélation |
| **Discrète** | Valeurs entières dénombrables | Nombre d'enfants, nombre de défauts, score sur 10 | Moyenne, médiane, comptage |

### Variables Qualitatives (catégorielles)

| Type | Description | Exemples | Opérations possibles |
|------|-------------|----------|---------------------|
| **Nominale** | Catégories sans ordre | Couleur, sexe, pays, type de produit | Fréquences, proportions, mode |
| **Ordinale** | Catégories avec ordre logique | Niveau d'études, satisfaction (faible/moyen/élevé), stade de maladie | Médiane, rangs, fréquences |
| **Binaire** | Deux modalités uniquement | Oui/Non, Succès/Échec, Homme/Femme | Proportion, odds ratio |

## 1.2 Règles de détection automatique

Pour classifier automatiquement une variable :

1. **Si la variable contient du texte** → Qualitative nominale
2. **Si la variable est numérique avec seulement 2 valeurs distinctes** → Binaire
3. **Si la variable est numérique avec 3 à 7 valeurs distinctes** → Probablement ordinale (vérifier le contexte)
4. **Si la variable est numérique avec plus de 10 valeurs distinctes** → Quantitative continue
5. **Si la variable contient des dates** → Temporelle (traiter séparément)

## 1.3 Statistiques descriptives selon le type

### Pour les variables quantitatives

| Mesure | Description | Quand l'utiliser |
|--------|-------------|------------------|
| Moyenne | Centre de gravité des données | Distribution symétrique |
| Médiane | Valeur centrale (50e percentile) | Distribution asymétrique ou présence d'outliers |
| Écart-type | Dispersion autour de la moyenne | Distribution symétrique |
| Intervalle interquartile (IQR) | Étendue entre Q1 et Q3 | Distribution asymétrique |
| Min / Max | Valeurs extrêmes | Toujours |
| Skewness (asymétrie) | < 0 asymétrie gauche, > 0 asymétrie droite | Évaluer la forme |
| Kurtosis (aplatissement) | > 0 pic aigu, < 0 distribution plate | Évaluer la forme |

### Pour les variables qualitatives

| Mesure | Description |
|--------|-------------|
| Effectif | Nombre d'observations par catégorie |
| Fréquence relative | Proportion (%) de chaque catégorie |
| Mode | Catégorie la plus fréquente |

---

# ÉTAPE 2 : Vérification des Conditions de Validité

Avant d'appliquer un test paramétrique, il faut vérifier certaines conditions. Si elles ne sont pas respectées, utiliser l'alternative non-paramétrique.

## 2.1 Condition de normalité

### Quand la vérifier ?

- Avant un test t (1 échantillon, indépendant, ou apparié)
- Avant une ANOVA
- Avant une corrélation de Pearson

### Comment la vérifier ?

| Méthode | Utilisation recommandée |
|---------|------------------------|
| Test de Shapiro-Wilk | Échantillons de taille n < 50 (le plus puissant) |
| Test de D'Agostino-Pearson | Échantillons de taille 20 ≤ n < 300 |
| Inspection visuelle (histogramme, QQ-plot) | Grands échantillons (n > 300) où les tests sont trop sensibles |
| Skewness et Kurtosis | Règle pratique : \|skewness\| < 2 et \|kurtosis\| < 7 |

### Interprétation

- **p > 0.05** : La normalité n'est pas rejetée → Test paramétrique possible
- **p ≤ 0.05** : La normalité est rejetée → Utiliser le test non-paramétrique

### Robustesse des tests

Le test t et l'ANOVA sont relativement robustes aux écarts de normalité si :
- L'échantillon est suffisamment grand (n ≥ 30 par groupe)
- Les distributions sont symétriques
- Les tailles de groupes sont équilibrées

## 2.2 Condition d'homogénéité des variances (homoscédasticité)

### Quand la vérifier ?

- Avant un test t pour échantillons indépendants
- Avant une ANOVA

### Comment la vérifier ?

| Test | Caractéristiques |
|------|-----------------|
| Test de Levene | Robuste à la non-normalité (recommandé par défaut) |
| Test de Bartlett | Plus puissant mais sensible à la non-normalité |

### Interprétation

- **p > 0.05** : Les variances sont homogènes → Test classique
- **p ≤ 0.05** : Les variances sont hétérogènes → Utiliser Welch

### Règle pratique

Si le ratio entre la plus grande et la plus petite variance est inférieur à 4, l'hétérogénéité est généralement tolérable.

## 2.3 Condition d'indépendance des observations

Cette condition est vérifiée par le design de l'étude, pas par un test statistique.

**Observations indépendantes** : Chaque mesure provient d'un individu différent, sans lien entre eux.

**Observations appariées/dépendantes** : 
- Mesures répétées sur les mêmes individus (avant/après)
- Paires naturelles (jumeaux, couples)
- Mesures sur le même sujet dans différentes conditions

## 2.4 Conditions pour le test du Khi²

| Condition | Règle |
|-----------|-------|
| Effectifs théoriques | Tous les effectifs théoriques doivent être ≥ 5 |
| Si effectifs < 5 | Utiliser le test exact de Fisher (tableaux 2×2) ou la méthode de Monte Carlo |
| Tolérance | Certains acceptent jusqu'à 20% de cellules avec effectif < 5, si aucune < 1 |

---

# ÉTAPE 3 : Choix du Test Statistique

## 3.1 Comparer des moyennes / positions

### Un seul groupe comparé à une valeur de référence

| Situation | Test paramétrique | Alternative non-paramétrique |
|-----------|------------------|------------------------------|
| Comparer la moyenne d'un échantillon à une valeur théorique | **Test t pour un échantillon** | **Test de Wilcoxon signé** |

**Hypothèse nulle (H0)** : La moyenne (ou médiane) de la population est égale à la valeur de référence.

**Exemple** : Le taux de cholestérol moyen des patients est-il différent de la norme de 200 mg/dL ?

---

### Deux groupes indépendants

| Situation | Conditions respectées | Test à utiliser |
|-----------|----------------------|-----------------|
| Comparer 2 groupes distincts | Normalité OK + Variances égales | **Test t pour échantillons indépendants** |
| Comparer 2 groupes distincts | Normalité OK + Variances inégales | **Test t de Welch** |
| Comparer 2 groupes distincts | Normalité NON respectée | **Test U de Mann-Whitney** |

**Hypothèse nulle (H0)** : Les deux groupes ont la même moyenne (paramétrique) ou la même distribution (non-paramétrique).

**Exemple** : Les hommes et les femmes ont-ils le même salaire moyen ?

---

### Deux groupes appariés (mesures répétées)

| Situation | Conditions respectées | Test à utiliser |
|-----------|----------------------|-----------------|
| Comparer avant/après sur les mêmes individus | Normalité des différences OK | **Test t pour échantillons appariés** |
| Comparer avant/après sur les mêmes individus | Normalité des différences NON respectée | **Test de Wilcoxon signé** |

**Hypothèse nulle (H0)** : La moyenne des différences est nulle.

**Exemple** : Le traitement a-t-il modifié la tension artérielle des patients ?

**Important** : Tester la normalité sur les différences (après - avant), pas sur les valeurs brutes.

---

### Plus de deux groupes indépendants

| Situation | Conditions respectées | Test à utiliser |
|-----------|----------------------|-----------------|
| Comparer 3+ groupes distincts | Normalité OK + Variances égales | **ANOVA à un facteur** |
| Comparer 3+ groupes distincts | Normalité OK + Variances inégales | **ANOVA de Welch** |
| Comparer 3+ groupes distincts | Normalité NON respectée | **Test de Kruskal-Wallis** |

**Hypothèse nulle (H0)** : Toutes les moyennes sont égales.

**Exemple** : Le rendement diffère-t-il selon les 4 types d'engrais utilisés ?

**Tests post-hoc** (si le test global est significatif) :
- Après ANOVA classique : **Test de Tukey HSD**
- Après ANOVA de Welch : **Test de Games-Howell**
- Après Kruskal-Wallis : **Test de Dunn** avec correction de Bonferroni

---

### Plus de deux mesures répétées (même sujets)

| Situation | Conditions respectées | Test à utiliser |
|-----------|----------------------|-----------------|
| Comparer 3+ temps/conditions sur les mêmes individus | Normalité OK + Sphéricité OK | **ANOVA à mesures répétées** |
| Comparer 3+ temps/conditions sur les mêmes individus | Conditions NON respectées | **Test de Friedman** |

**Hypothèse nulle (H0)** : Toutes les conditions ont le même effet.

**Exemple** : La concentration du médicament varie-t-elle entre T0, T1, T2 et T3 ?

**Tests post-hoc** :
- Après ANOVA répétée : Comparaisons par paires avec correction de Bonferroni
- Après Friedman : **Test de Nemenyi** ou Wilcoxon par paires avec correction

---

## 3.2 Comparer des proportions

### Une proportion vs. valeur théorique

| Situation | Test à utiliser |
|-----------|-----------------|
| Une proportion observée comparée à une proportion attendue | **Test binomial exact** (petit n) ou **Test du Khi² pour une proportion** (grand n) |

**Hypothèse nulle (H0)** : La proportion observée est égale à la proportion théorique.

**Exemple** : La proportion de femmes dans l'échantillon (58%) est-elle différente de 50% ?

---

### Deux proportions ou plus (tableau de contingence)

| Situation | Conditions | Test à utiliser |
|-----------|------------|-----------------|
| Tableau 2×2, petits effectifs | Effectifs théoriques < 5 | **Test exact de Fisher** |
| Tableau 2×2, grands effectifs | Effectifs théoriques ≥ 5 | **Test du Khi²** |
| Tableau plus grand (r×c) | Effectifs théoriques ≥ 5 | **Test du Khi²** |
| Tableau plus grand, petits effectifs | Effectifs théoriques < 5 | **Méthode de Monte Carlo** |

**Hypothèse nulle (H0)** : Les proportions sont identiques entre les groupes / Les variables sont indépendantes.

**Exemple** : Le taux de guérison est-il différent entre le groupe traité et le groupe placebo ?

---

### Proportions observées vs. proportions théoriques multiples

| Situation | Test à utiliser |
|-----------|-----------------|
| Comparer une distribution observée à une distribution théorique | **Test du Khi² d'ajustement** (goodness of fit) |

**Hypothèse nulle (H0)** : Les proportions observées sont conformes aux proportions théoriques.

**Exemple** : Les proportions de génotypes observées suivent-elles les proportions mendéliennes 1:2:1 ?

---

## 3.3 Tester une association / corrélation

### Entre deux variables qualitatives

| Situation | Test à utiliser |
|-----------|-----------------|
| Tester l'indépendance entre deux variables catégorielles | **Test du Khi² d'indépendance** |
| Si effectifs faibles (tableau 2×2) | **Test exact de Fisher** |

**Hypothèse nulle (H0)** : Les deux variables sont indépendantes.

**Exemple** : Y a-t-il un lien entre le tabagisme et le cancer du poumon ?

---

### Entre deux variables quantitatives

| Situation | Conditions | Test à utiliser |
|-----------|------------|-----------------|
| Relation linéaire entre deux variables | Normalité bivariée OK | **Corrélation de Pearson** |
| Relation monotone (pas forcément linéaire) | Normalité NON respectée ou variables ordinales | **Corrélation de Spearman** |

**Hypothèse nulle (H0)** : Il n'y a pas de corrélation (ρ = 0).

**Exemple** : Existe-t-il une relation entre l'âge et la pression artérielle ?

### Interprétation du coefficient de corrélation

| Valeur absolue de r ou ρ | Interprétation |
|--------------------------|----------------|
| 0.00 - 0.10 | Négligeable |
| 0.10 - 0.30 | Faible |
| 0.30 - 0.50 | Modérée |
| 0.50 - 0.70 | Forte |
| 0.70 - 1.00 | Très forte |

**Attention** : Corrélation ≠ Causalité

---

## 3.4 Comparer des variances

| Situation | Test à utiliser |
|-----------|-----------------|
| Comparer les variances de 2 groupes | **Test F de Fisher** |
| Comparer les variances de 3+ groupes | **Test de Levene** (robuste) ou **Test de Bartlett** (si normalité) |

**Hypothèse nulle (H0)** : Les variances sont égales.

---

## 3.5 Tester la normalité d'une distribution

| Taille d'échantillon | Test recommandé |
|---------------------|-----------------|
| n < 50 | **Test de Shapiro-Wilk** |
| 50 ≤ n < 300 | **Test de Shapiro-Wilk** ou **D'Agostino-Pearson** |
| n ≥ 300 | **Inspection visuelle** + skewness/kurtosis |

---

## 3.6 Détecter les valeurs aberrantes

| Méthode | Description |
|---------|-------------|
| Méthode IQR | Valeur aberrante si < Q1 - 1.5×IQR ou > Q3 + 1.5×IQR |
| Z-score | Valeur aberrante si \|z\| > 3 |
| Test de Grubbs | Test formel pour une valeur extrême |
| Test de Dixon | Pour petits échantillons (n < 25) |

---

# ÉTAPE 4 : Interprétation des Résultats

## 4.1 La p-value

| p-value | Interprétation | Notation courante |
|---------|----------------|-------------------|
| p > 0.05 | Non significatif | ns |
| p ≤ 0.05 | Significatif | * |
| p ≤ 0.01 | Très significatif | ** |
| p ≤ 0.001 | Hautement significatif | *** |

**Interprétation correcte** : La p-value est la probabilité d'observer un résultat au moins aussi extrême que celui obtenu, si H0 était vraie.

**Ce que la p-value n'est PAS** :
- La probabilité que H0 soit vraie
- La probabilité que le résultat soit dû au hasard
- Une mesure de l'importance de l'effet

## 4.2 Tailles d'effet

La p-value indique si un effet existe, la taille d'effet indique son ampleur.

### d de Cohen (comparaison de moyennes)

| Valeur | Interprétation |
|--------|----------------|
| \|d\| < 0.2 | Effet négligeable |
| 0.2 ≤ \|d\| < 0.5 | Effet petit |
| 0.5 ≤ \|d\| < 0.8 | Effet moyen |
| \|d\| ≥ 0.8 | Effet grand |

### η² eta-squared (ANOVA)

| Valeur | Interprétation |
|--------|----------------|
| η² < 0.01 | Effet négligeable |
| 0.01 ≤ η² < 0.06 | Effet petit |
| 0.06 ≤ η² < 0.14 | Effet moyen |
| η² ≥ 0.14 | Effet grand |

### V de Cramer (Khi²)

| Valeur (df* = 1) | Valeur (df* = 2) | Valeur (df* ≥ 3) | Interprétation |
|------------------|------------------|------------------|----------------|
| < 0.10 | < 0.07 | < 0.06 | Effet négligeable |
| 0.10 - 0.30 | 0.07 - 0.21 | 0.06 - 0.17 | Effet petit |
| 0.30 - 0.50 | 0.21 - 0.35 | 0.17 - 0.29 | Effet moyen |
| ≥ 0.50 | ≥ 0.35 | ≥ 0.29 | Effet grand |

*df* = min(nb_lignes - 1, nb_colonnes - 1)

### r pour les tests non-paramétriques

| Valeur | Interprétation |
|--------|----------------|
| \|r\| < 0.1 | Effet négligeable |
| 0.1 ≤ \|r\| < 0.3 | Effet petit |
| 0.3 ≤ \|r\| < 0.5 | Effet moyen |
| \|r\| ≥ 0.5 | Effet grand |

Calcul : r = Z / √N

---

# ÉTAPE 5 : Arbre de Décision Récapitulatif

```
QUELLE EST TA QUESTION DE RECHERCHE ?
│
├─► COMPARER DES POSITIONS (moyennes/médianes)
│   │
│   ├─► Combien de groupes ?
│   │   │
│   │   ├─► 1 groupe vs valeur théorique
│   │   │   ├─ Normalité OK → Test t (1 échantillon)
│   │   │   └─ Normalité NON → Wilcoxon signé
│   │   │
│   │   ├─► 2 groupes
│   │   │   │
│   │   │   ├─► Indépendants ?
│   │   │   │   ├─ Normal + Var égales → Test t indépendant
│   │   │   │   ├─ Normal + Var inégales → Welch
│   │   │   │   └─ Non normal → Mann-Whitney
│   │   │   │
│   │   │   └─► Appariés (avant/après) ?
│   │   │       ├─ Différences normales → Test t apparié
│   │   │       └─ Différences non normales → Wilcoxon signé
│   │   │
│   │   └─► 3+ groupes
│   │       │
│   │       ├─► Indépendants ?
│   │       │   ├─ Normal + Var égales → ANOVA → Tukey
│   │       │   ├─ Normal + Var inégales → Welch ANOVA → Games-Howell
│   │       │   └─ Non normal → Kruskal-Wallis → Dunn
│   │       │
│   │       └─► Mesures répétées ?
│   │           ├─ Normal + Sphéricité → ANOVA répétée
│   │           └─ Conditions non OK → Friedman → Nemenyi
│
├─► COMPARER DES PROPORTIONS
│   │
│   ├─► 1 proportion vs théorique → Test binomial / Khi² (1 prop)
│   │
│   ├─► 2 proportions
│   │   ├─ Effectifs ≥ 5 → Khi²
│   │   └─ Effectifs < 5 → Fisher exact
│   │
│   └─► 3+ proportions → Khi² d'homogénéité
│
├─► TESTER UNE ASSOCIATION
│   │
│   ├─► 2 variables qualitatives
│   │   ├─ Effectifs ≥ 5 → Khi² d'indépendance
│   │   └─ Effectifs < 5 → Fisher exact
│   │
│   └─► 2 variables quantitatives
│       ├─ Normalité bivariée OK → Pearson
│       └─ Normalité NON ou ordinales → Spearman
│
├─► COMPARER DES VARIANCES
│   ├─► 2 groupes → Test F
│   └─► 3+ groupes → Levene
│
└─► TESTER UNE DISTRIBUTION
    ├─► Normalité → Shapiro-Wilk / D'Agostino
    ├─► Comparaison à loi théorique → Kolmogorov-Smirnov
    └─► Outliers → IQR / Grubbs / Dixon
```

---

# ÉTAPE 6 : Structure du Rapport Word

## 6.1 Plan type du rapport

### Page de garde
- Titre de l'analyse
- Date
- Source des données

### 1. Résumé exécutif (1 page max)
- Objectif de l'étude
- Principales conclusions (3-5 points clés)
- Recommandations éventuelles

### 2. Introduction
- Contexte
- Objectifs précis
- Questions de recherche ou hypothèses

### 3. Description des données
- Source et période de collecte
- Taille de l'échantillon
- Tableau descriptif des variables (nom, type, description)
- Valeurs manquantes

### 4. Méthodologie statistique
- Tests utilisés et justification du choix
- Seuil de significativité retenu (généralement α = 0.05)
- Logiciel utilisé

### 5. Résultats

#### 5.1 Statistiques descriptives
- Tableau récapitulatif (moyenne, écart-type, médiane, min, max pour les variables quantitatives)
- Tableau de fréquences pour les variables qualitatives
- Graphiques pertinents (histogrammes, boxplots, diagrammes en barres)

#### 5.2 Vérification des conditions de validité
- Résultats des tests de normalité (tableau avec statistique et p-value)
- Résultats des tests d'homogénéité des variances
- Décisions prises (paramétrique vs non-paramétrique)

#### 5.3 Analyses inférentielles
Pour chaque test, présenter :
- L'hypothèse testée (H0 vs H1)
- Le test utilisé et pourquoi
- Les résultats : statistique du test, degrés de liberté, p-value
- La taille d'effet
- La conclusion en français

### 6. Discussion
- Interprétation des résultats dans le contexte
- Comparaison avec la littérature (si pertinent)
- Limites de l'analyse

### 7. Conclusion
- Réponses aux questions de recherche
- Recommandations

### Annexes (optionnel)
- Tableaux complets
- Graphiques supplémentaires

## 6.2 Format de présentation des tests

Pour chaque test statistique, utiliser ce format standardisé :

**Hypothèse testée** : [Description en français]

**Test utilisé** : [Nom du test] (justification si nécessaire)

**Résultats** : [Statistique]([ddl]) = [valeur], p = [valeur], [taille d'effet] = [valeur]

**Conclusion** : [Interprétation en français]

### Exemples de formulation

**Test t indépendant** :
> Un test t pour échantillons indépendants a été réalisé pour comparer le salaire entre les hommes et les femmes. Les résultats révèlent une différence significative (t(98) = 3.45, p = 0.001, d = 0.69). Les hommes (M = 45 000 €, ET = 8 000) ont un salaire significativement plus élevé que les femmes (M = 38 000 €, ET = 7 500), avec une taille d'effet moyenne.

**ANOVA** :
> Une ANOVA à un facteur a été conduite pour examiner l'effet du type d'engrais sur le rendement. L'effet est significatif (F(3, 96) = 5.23, p = 0.002, η² = 0.14). Les comparaisons post-hoc de Tukey indiquent que l'engrais A (M = 85.2) diffère significativement de l'engrais C (M = 72.1, p = 0.003).

**Khi²** :
> Un test du Khi² d'indépendance a été réalisé pour examiner la relation entre le tabagisme et la présence de maladie respiratoire. L'association est significative (χ²(1) = 12.34, p < 0.001, V = 0.35), indiquant un lien modéré entre ces deux variables.

**Corrélation** :
> La corrélation de Pearson indique une relation positive significative entre l'âge et la pression artérielle (r = 0.52, p < 0.001). Cette corrélation forte suggère que la pression artérielle tend à augmenter avec l'âge.

**Mann-Whitney** :
> Le test U de Mann-Whitney a été utilisé car la condition de normalité n'était pas respectée. Les résultats montrent une différence significative entre les groupes (U = 245, p = 0.012, r = 0.31), avec un effet de taille moyenne.

---

# ÉTAPE 7 : Checklist Avant Analyse

Avant de commencer l'analyse, vérifier :

## Données
- [ ] Le fichier est correctement chargé
- [ ] Les types de variables sont correctement identifiés
- [ ] Les valeurs manquantes sont identifiées et documentées
- [ ] Les valeurs aberrantes sont identifiées

## Design
- [ ] La question de recherche est claire
- [ ] Les variables dépendantes et indépendantes sont identifiées
- [ ] Le type de comparaison est déterminé (indépendant vs apparié)
- [ ] Le nombre de groupes est connu

## Conditions de validité
- [ ] La normalité est testée (si test paramétrique envisagé)
- [ ] L'homogénéité des variances est testée (si comparaison de groupes)
- [ ] Les effectifs sont suffisants
- [ ] Le test approprié est sélectionné

## Rapport
- [ ] Les statistiques descriptives sont calculées
- [ ] Les graphiques sont générés
- [ ] Les résultats sont interprétés en français
- [ ] Les tailles d'effet sont rapportées
- [ ] Les limites sont mentionnées

---

# Annexe : Tableau Récapitulatif des Tests

| Question | Données | Conditions OK | Test paramétrique | Conditions NON OK | Test non-paramétrique |
|----------|---------|---------------|-------------------|-------------------|----------------------|
| 1 moyenne vs théorique | 1 échantillon quanti | Normalité | Test t (1 éch.) | Non normalité | Wilcoxon signé |
| 2 moyennes indépendantes | 2 groupes quanti | Normalité + Variances égales | Test t indépendant | Non normalité | Mann-Whitney |
| 2 moyennes indépendantes | 2 groupes quanti | Normalité + Variances inégales | Test t de Welch | - | - |
| 2 moyennes appariées | Avant/après | Normalité des différences | Test t apparié | Non normalité | Wilcoxon signé |
| 3+ moyennes indépendantes | 3+ groupes quanti | Normalité + Variances égales | ANOVA | Non normalité | Kruskal-Wallis |
| 3+ moyennes répétées | Mesures répétées | Normalité + Sphéricité | ANOVA répétée | Conditions non OK | Friedman |
| 1 proportion vs théorique | Effectifs | n ≥ 30 | Khi² (1 prop) | n < 30 | Binomial exact |
| 2+ proportions | Tableau contingence | Effectifs ≥ 5 | Khi² | Effectifs < 5 | Fisher exact |
| Association quali-quali | Tableau contingence | Effectifs ≥ 5 | Khi² indépendance | Effectifs < 5 | Fisher exact |
| Corrélation quanti-quanti | 2 variables quanti | Normalité bivariée | Pearson | Non normalité | Spearman |
| 2 variances | 2 groupes | Normalité | Test F | - | - |
| 3+ variances | 3+ groupes | - | Levene | - | - |

---

*Ce guide couvre les situations les plus courantes. Pour des analyses plus complexes (régression, analyses multivariées, séries temporelles), des considérations supplémentaires s'appliquent.*
