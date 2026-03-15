# Corrélation de Pearson : Âge et Part variable managériale

## 1. Objectif

Tester l'existence d'une relation linéaire entre deux variables quantitatives :

| Variable | Description |
|---|---|
| **Âge** | Âge du salarié (en années) |
| **Part variable managériale** | Montant de la part variable managériale (en euros) |

**Test utilisé** : corrélation de Pearson (complété par Spearman si les conditions ne sont pas remplies).

---

## 2. Hypothèses

| | Formulation |
|---|---|
| **H0** | Il n'existe pas de corrélation linéaire entre l'âge et la part variable managériale (r = 0) |
| **H1** | Il existe une corrélation linéaire entre l'âge et la part variable managériale (r ≠ 0) |

**Seuil de significativité** : α = 0,05

---

## 3. Statistiques descriptives

| Indicateur | Âge | Part variable managériale |
|---|---|---|
| N | 556 | 556 |
| Moyenne | 47,42 | 1 934,85 € |
| Écart-type | 11,00 | 3 878,96 € |
| Min | 21 | 0 € |
| Q1 | 39 | 0 € |
| Médiane | 51 | 0 € |
| Q3 | 57 | 3 022,75 € |
| Max | 62 | 37 899 € |

**Observation** : la part variable managériale est très asymétrique — la médiane est à 0 € (plus de la moitié des salariés n'en perçoivent pas), tandis que le maximum atteint 37 899 €. Cette distribution est fortement concentrée à gauche.

---

## 4. Vérification des conditions d'application

### 4.1 Normalité (Shapiro-Wilk)

| Variable | W | p-value | Conclusion |
|---|---|---|---|
| Âge | 0,8840 | < 0,0001 | **Non normale** |
| Part variable managériale | 0,5465 | < 0,0001 | **Non normale** |

Aucune des deux variables ne suit une distribution normale. Le test de Pearson est donc présenté à titre indicatif et complété par le **test de Spearman**, non paramétrique et plus adapté à cette situation.

### 4.2 Linéarité

Le nuage de points (`correlation_age_partvar.png`) ne révèle pas de relation linéaire apparente entre les deux variables.

---

## 5. Résultats

### 5.1 Corrélation de Pearson

| Indicateur | Valeur |
|---|---|
| Coefficient r | 0,0661 |
| Coefficient de détermination r² | 0,0044 |
| Statistique t | 1,5588 |
| Degrés de liberté | 554 |
| p-value | **0,1196** |
| IC 95 % | [-0,0172 ; 0,1484] |

### 5.2 Corrélation de Spearman (test complémentaire)

| Indicateur | Valeur |
|---|---|
| Rho (ρ) | 0,0449 |
| p-value | **0,2903** |

---

## 6. Interprétation

**On ne rejette pas H0.** Les deux tests (Pearson et Spearman) aboutissent à des p-values supérieures au seuil de 0,05.

- Le coefficient de Pearson (r = 0,066) indique une corrélation **positive négligeable**.
- Seulement **0,4 %** de la variance de la part variable managériale est expliquée par l'âge.
- L'intervalle de confiance à 95 % inclut zéro [-0,017 ; 0,148], confirmant l'absence de significativité.
- Le test de Spearman (ρ = 0,045, p = 0,29) confirme ce résultat : **aucune association monotone significative** n'est détectée.

### Conclusion

**Il n'existe pas de relation statistiquement significative entre l'âge et la part variable managériale** dans cet échantillon (n = 556). L'âge ne permet pas de prédire le montant de la part variable managériale. Ce résultat est cohérent avec le fait que cette prime dépend vraisemblablement du statut de manager et du niveau hiérarchique, et non de l'âge en tant que tel.

---

## 7. Graphiques générés

| Fichier | Contenu |
|---|---|
| `correlation_age_partvar.png` | Nuage de points avec droite de régression |
| `qqplot_age.png` | QQ-plot de la variable Âge |
| `qqplot_partvar.png` | QQ-plot de la variable Part variable managériale |
