# Analyse Statistique Complete

Dataset a analyser : **$ARGUMENTS**

Tu es un statisticien expert. Tu dois produire une analyse statistique exhaustive du dataset fourni, en ecrivant du code R sur mesure, en l'executant, et en generant un rapport Markdown complet. **L'analyse et l'interpretation des resultats sont la priorite absolue du livrable.**

---

## ETAPE 1 : Decouverte du dataset

1. Lis un echantillon du fichier pour comprendre sa structure (colonnes, types, premieres lignes).
2. Ecris et execute un petit script R de decouverte :
   ```r
   # Charger le fichier (adapter selon xlsx/csv/tsv)
   # Afficher : str(), summary(), head(), sapply(donnees, function(x) length(unique(na.omit(x))))
   # Compter les NA par colonne
   ```
3. A partir des resultats, classe chaque variable :
   - **Identifiant** : a exclure (ID unique, numero de ligne...)
   - **Qualitative** : character/factor, OU numerique avec tres peu de valeurs uniques (<=7)
   - **Quantitative** : numerique avec beaucoup de valeurs uniques (>7)
4. Affiche ta classification a l'utilisateur sous forme de tableau.
5. **Identifie le sujet/domaine du dataset** (RH, ventes, sante, education...) car toutes les interpretations doivent etre contextualisees a ce domaine.

---

## ETAPE 2 : Decision des analyses pertinentes

En fonction des variables identifiees, decide quelles analyses sont pertinentes. Tu dois couvrir TOUTES les categories applicables :

### Analyse descriptive (obligatoire pour chaque variable)
- **Chaque variable qualitative** : tableau de frequences + barplot
- **Chaque variable quantitative** : stats descriptives (n, moyenne, mediane, ecart-type, Q1/Q3, min/max, CV) + histogramme + boxplot

### Analyses croisees (choisis les paires les plus pertinentes)
- **2 quali** : tri croise (effectifs + % lignes + % colonnes) + barplot groupe
- **2 quanti** : nuage de points + droite de regression
- **1 quali x 1 quanti** : boxplot comparatif + stats par groupe
- **2 quanti + 1 quali** : nuage de points colore par la quali

### Tests statistiques (choisis les combinaisons les plus interessantes)
- **Chi-2** : pour 2 variables qualitatives
  - Verifier les effectifs theoriques (si >20% < 5 -> Monte Carlo)
  - H0/H1, statistique, ddl, p-value, decision
- **Student** : pour 1 quali binaire x 1 quanti
  - Verifier : n > 20, test de Levene (homogeneite des variances)
  - H0/H1, t, df, p-value, IC 95%, moyennes par groupe
- **Pearson / Spearman** : pour 2 variables quantitatives
  - Verifier normalite : Shapiro-Wilk + QQ-plots
  - Si non-normal -> ajouter Spearman en complement
  - r, r2, p-value, IC 95%, force et sens de la correlation
- **ANOVA** : pour 1 quali a 3+ modalites x 1 quanti
  - Verifier : test de Levene
  - F, df, p-value
  - Si significatif -> post-hoc Tukey HSD

### Choix des paires
- Ne fais PAS toutes les combinaisons possibles (trop volumineux)
- Selectionne les croisements les plus **pertinents metier** et **interessants statistiquement**
- Vise environ : 2-3 Chi-2, 2-3 Student, 2-3 Pearson, 1-2 ANOVA, 2-3 croisements descriptifs
- Explique brievement pourquoi tu as choisi chaque croisement

---

## ETAPE 3 : Ecriture et execution du code R

1. Cree le dossier de sortie : `resultats_analyse/plots/`
2. Ecris UN SEUL script R complet et adapte au dataset dans `scripts/analyse_<nom_dataset>.R`
   - Le script doit etre autonome (chargement des packages, lecture du fichier, toutes les analyses)
   - Chaque graphique est sauvegarde en PNG dans `resultats_analyse/plots/` avec un nom descriptif
   - Tous les resultats numeriques sont affiches sur stdout avec des sections claires
   - Utilise les **vrais noms de colonnes** du dataset
   - Packages autorises : base R, readxl, car (pour Levene). Pas de ggplot2.
3. Execute le script R et capture TOUTE la sortie
4. Verifie que les graphiques ont ete generes

---

## ETAPE 4 : Generation du rapport Markdown

Cree le fichier `resultats_analyse/rapport_analyse.md`. Le rapport doit etre **oriente analyse** : les chiffres et graphiques servent de support, mais c'est l'interpretation qui constitue le coeur du document.

### Structure du rapport :

```
# Rapport d'Analyse Statistique

**Dataset** : [nom du fichier]
**Date** : [date du jour]
**Observations** : [n] | **Variables** : [p]

---

## 1. Exploration du dataset

### 1.1 Presentation du dataset
[Paragraphe redige decrivant : d'ou viennent les donnees, quel domaine, combien d'observations, quelle population etudiee, quels axes d'analyse sont envisageables]

### 1.2 Classification des variables
| Variable | Type | Nature | Valeurs uniques |
|---|---|---|---|
| ... | Qualitative / Quantitative / Identifiant | Discrete / Continue | n |

[Paragraphe de synthese : combien de quali, combien de quanti, quels axes d'analyse cela permet (profil demographique, financier, etc.)]

### 1.3 Valeurs manquantes
[Resume + impact sur l'analyse : est-ce que ca biaise certains resultats ?]

---

## 2. Analyse descriptive

### 2.1 [Nom de la variable qualitative]

**Code R :**
\```r
[Le code R exact utilise pour cette analyse]
\```

**Resultats :**
| Modalite | Effectif | % |
|---|---|---|
| ... | ... | ... |

![Barplot](plots/nom_du_graphique.png)

**Interpretation :**
[PAS juste "la modalite X domine". Aller plus loin :
- Quel desequilibre observe-t-on ? Est-il attendu ou surprenant ?
- Que revele cette repartition sur la population etudiee ?
- Y a-t-il une modalite trop rare pour etre fiable dans les croisements ?
- Quel impact cela a-t-il pour la suite de l'analyse ?]

### 2.2 [Nom de la variable quantitative]

**Code R :**
\```r
[code]
\```

**Resultats :**
| Statistique | Valeur |
|---|---|
| N | ... |
| Moyenne | ... |
| Mediane | ... |
| Ecart-type | ... |
| CV | ... |
| Q1 | ... |
| Q3 | ... |
| Min | ... |
| Max | ... |

![Histogramme et Boxplot](plots/nom.png)

**Interpretation :**
[Analyse structuree en 3 axes :
1. **Tendance centrale** : comparer moyenne et mediane. Si ecart > 5% → asymetrie. Expliquer la direction et ce qu'elle signifie concretement (ex: "quelques tres hauts salaires tirent la moyenne vers le haut")
2. **Dispersion** : commenter l'ecart-type et le CV. Un CV > 30% = forte heterogeneite. Que signifie cette heterogeneite pour la population ?
3. **Valeurs extremes** : identifier les outliers visibles sur le boxplot. Sont-ils aberrants ou coherents ? Quel impact sur la moyenne ?]

---

## 3. Analyses croisees

### 3.1 [V1] x [V2] (2 qualitatives)

**Pourquoi ce croisement :** [Question metier que l'on cherche a explorer]

**Code R :** [...]

**Tri croise (effectifs) :**
[tableau]

**Tri croise (% en lignes) :**
[tableau]

![Graphique](plots/nom.png)

**Interpretation :**
[Lire le tableau activement :
- Quels groupes sont sur/sous-representes par rapport a la moyenne ?
- Formuler des constats concrets (ex: "34.8% des femmes sont au niveau 2, contre seulement 24.4% des hommes")
- Identifier les desequilibres marquants
- Emettre des hypotheses explicatives
- Signaler si un croisement merite un test formel (Chi-2)]

### 3.2 [V1] x [V2] (2 quantitatives)
[...]

**Interpretation :**
[Decrire le nuage de points :
- Forme : lineaire, courbe, en eventail, sans structure ?
- Direction : croissant, decroissant ?
- Dispersion : les points sont-ils resserres ou eparpilles ?
- Outliers : y a-t-il des points isoles qui influencent la tendance ?
- Hypothese : le lien observe est-il direct ou masque par une 3e variable ?]

### 3.3 [V1] x [V2] (quali x quanti)
[...]

**Interpretation :**
[Comparer les groupes :
- Comparer les medianes (pas juste les moyennes) entre groupes
- Observer la dispersion de chaque boite : un groupe est-il plus homogene ?
- Les moustaches et outliers different-ils entre groupes ?
- Quantifier l'ecart entre groupes en % : (moy_max - moy_min) / moy_max
- Cette difference est-elle "importante" en pratique, au-dela de la significativite statistique ?]

---

## 4. Tests statistiques

Pour chaque test, suivre cette structure :

### 4.x [Nom du test] : [V1] x [V2]

**Pourquoi ce test :** [Question concrete que l'on teste, ex: "Le salaire moyen est-il different entre hommes et femmes ?"]

**Hypotheses :**
- H0 : [formulee en termes concrets, pas juste "les variables sont independantes"]
- H1 : [idem]

**Code R :**
\```r
[code complet incluant verification des conditions]
\```

**Verification des conditions :**
[Pour chaque condition verifiee, indiquer CLAIREMENT si elle est respectee ou non, et si non, quelle consequence (ex: "Levene p = 0.03 < 0.05 : variances heterogenes, on utilise la correction de Welch")]

**Resultats :**
| Statistique | Valeur |
|---|---|
| ... | ... |
| p-value | ... |

**Decision :** [Rejet / Non-rejet] de H0 (p = [valeur] [</>] alpha = 0.05)

**Interpretation :**
[C'est ici que se joue la qualite du rapport. Pour chaque test :]

**Pour un Chi-2 :**
- Si significatif : decrire CONCRETEMENT la dependance. Quels groupes sont lies ? Dans quel sens ? Illustrer avec les pourcentages du tri croise.
- Si non significatif : dire clairement que les variables semblent independantes. Le Chi-2 ne mesure pas la FORCE, juste l'existence d'un lien.

**Pour un Student :**
- Rappeler les moyennes des 2 groupes et l'ecart en valeur absolue ET en pourcentage.
- Si significatif : dire que la difference est STATISTIQUEMENT significative, mais commenter aussi si elle est PRATIQUEMENT importante (un ecart de 3% peut etre significatif avec n=500 mais derisoire en pratique).
- Si non significatif : dire que l'ecart observe (X%) n'est pas suffisant pour exclure le hasard. Cela ne prouve PAS l'egalite, cela dit juste qu'on ne peut pas conclure.

**Pour une correlation (Pearson/Spearman) :**
- Rappeler r, r2, et le sens de la correlation.
- Interpreter r2 : "l'age n'explique que 0.4% de la variance de la part variable". C'est un ordre de grandeur, pas juste un chiffre.
- Grille de force : |r| < 0.10 negligeable, < 0.30 faible, < 0.50 moderee, < 0.70 forte, >= 0.70 tres forte.
- Si Shapiro-Wilk rejette la normalite : expliquer pourquoi Spearman est utilise en complement et si ses conclusions convergent avec Pearson.
- Rappeler que correlation ≠ causalite.

**Pour une ANOVA :**
- Si significatif : dire QUELS groupes different (Tukey). Ne pas juste dire "au moins un groupe differe" — nommer les groupes et quantifier les ecarts.
- Commenter la progression : y a-t-il un gradient logique (ex: salaire qui augmente avec le niveau hierarchique) ou des ruptures ?
- Si Levene rejette l'homogeneite : mentionner que l'ANOVA reste robuste si les effectifs sont grands, mais signaler la reserve.

---

## 5. Synthese

### 5.1 Tableau recapitulatif des tests
| Test | Variables | p-value | Decision | Conclusion en une phrase |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

### 5.2 Enseignements principaux
[5 a 8 bullet points rediges qui racontent une HISTOIRE coherente a partir des donnees. Ne pas lister les resultats — les relier entre eux. Exemple :
- "Le niveau hierarchique est le facteur structurant principal : il determine le salaire (ANOVA F=456, p<0.001), la part variable manageriale, et le statut de manager."
- "L'age et l'anciennete sont tres correles (r=0.85), ce qui est attendu, mais ni l'un ni l'autre n'expliquent significativement la part variable."
- "Malgre un ecart de salaire moyen de 3.2% entre hommes et femmes, le test de Student ne le juge pas significatif (p=0.37). Cet ecart pourrait neanmoins masquer des disparites a niveau hierarchique egal."]

### 5.3 Limites de l'analyse
[Mentionner : variables manquantes qui auraient ete utiles, biais potentiels, limites des tests utilises, variables confondantes non controlees]

### 5.4 Pistes d'approfondissement
[Suggerer : analyses multivariees, regression multiple, analyse stratifiee, variables supplementaires a collecter]
```

---

## Regles importantes

- **L'ANALYSE PRIME SUR LE CODE.** Le code R est un moyen, pas une fin. Le lecteur vient chercher des reponses, pas du code. Chaque bloc de code doit etre suivi d'une interpretation substantielle.
- **Interpretations contextualisees** : jamais de phrases generiques ("la p-value est inferieure a 0.05 donc on rejette H0" sans explication). Toujours relier au domaine du dataset.
- **Lis les graphiques que tu generes** (utilise l'outil Read sur les PNG) pour les decrire precisement dans le rapport. Ne te contente pas de deviner ce qu'ils montrent.
- **Code R** : montre le code exact qui a produit le resultat.
- **Graphiques** : reference chaque PNG avec le bon chemin relatif `plots/nom.png`.
- **Seuil** : alpha = 0.05 partout.
- **NA** : gere les valeurs manquantes proprement (na.rm, complete.cases).
- **Langue** : tout le rapport est en francais.
- A la fin, affiche la liste des fichiers generes (rapport + plots).
