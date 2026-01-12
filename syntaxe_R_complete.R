# ============================================================================
# GUIDE COMPLET DE LA SYNTAXE R
# ============================================================================
# Ce script couvre l'ensemble de la syntaxe du langage R avec des exemples
# ============================================================================

# ============================================================================
# 1. COMMENTAIRES
# ============================================================================

# Ceci est un commentaire sur une ligne
# Il n'y a pas de commentaires multi-lignes natifs en R
# Mais on peut utiliser plusieurs lignes avec #

# ============================================================================
# 2. TYPES DE DONNÉES DE BASE
# ============================================================================

# Numeric (nombres réels)
x <- 42.5
class(x)  # "numeric"

# Integer (nombres entiers)
y <- 42L  # Le 'L' indique un entier
class(y)  # "integer"

# Character (chaînes de caractères)
texte <- "Bonjour R"
texte2 <- 'Avec des guillemets simples'
class(texte)  # "character"

# Logical (booléens)
vrai <- TRUE   # ou T
faux <- FALSE  # ou F
class(vrai)  # "logical"

# Complex (nombres complexes)
z <- 3 + 4i
class(z)  # "complex"

# NULL (valeur nulle)
valeur_nulle <- NULL

# NA (Not Available - valeur manquante)
valeur_manquante <- NA

# NaN (Not a Number)
resultat_impossible <- 0/0

# Inf (infini)
infini <- Inf
moins_infini <- -Inf

# ============================================================================
# 3. OPÉRATEURS
# ============================================================================

# --- Opérateurs arithmétiques ---
a <- 10
b <- 3

addition <- a + b        # 13
soustraction <- a - b    # 7
multiplication <- a * b  # 30
division <- a / b        # 3.333...
division_entiere <- a %/% b  # 3
modulo <- a %% b         # 1
puissance <- a ^ b       # ou a ** b = 1000

# --- Opérateurs de comparaison ---
egal <- a == b           # FALSE
different <- a != b      # TRUE
inferieur <- a < b       # FALSE
superieur <- a > b       # TRUE
inf_ou_egal <- a <= b    # FALSE
sup_ou_egal <- a >= b    # TRUE

# --- Opérateurs logiques ---
# & (ET logique - vectorisé)
# | (OU logique - vectorisé)
# ! (NON logique)
# && (ET logique - scalaire, évaluation paresseuse)
# || (OU logique - scalaire, évaluation paresseuse)

condition1 <- TRUE
condition2 <- FALSE

et_logique <- condition1 & condition2    # FALSE
ou_logique <- condition1 | condition2    # TRUE
non_logique <- !condition1               # FALSE

# --- Opérateurs d'affectation ---
x <- 5      # Recommandé
x = 5       # Aussi possible
5 -> x      # Affectation à droite (rare)
x <<- 5     # Affectation dans l'environnement parent

# --- Opérateurs spéciaux ---
# %in% : appartenance
3 %in% c(1, 2, 3, 4)  # TRUE
5 %in% c(1, 2, 3, 4)  # FALSE

# :: et ::: pour accéder aux fonctions des packages
# dplyr::filter()  # Accès explicite
# stats:::myFunction()  # Accès aux fonctions non-exportées

# ============================================================================
# 4. STRUCTURES DE DONNÉES
# ============================================================================

# --- VECTEURS (1D, un seul type) ---
# Création avec c() (combine)
vecteur_numeric <- c(1, 2, 3, 4, 5)
vecteur_character <- c("a", "b", "c")
vecteur_logical <- c(TRUE, FALSE, TRUE)

# Séquences
seq1 <- 1:10                    # 1 2 3 4 5 6 7 8 9 10
seq2 <- seq(1, 10, by = 2)      # 1 3 5 7 9
seq3 <- seq(0, 1, length.out = 5)  # 0.00 0.25 0.50 0.75 1.00

# Répétition
rep1 <- rep(5, times = 3)       # 5 5 5
rep2 <- rep(c(1, 2), times = 3) # 1 2 1 2 1 2
rep3 <- rep(c(1, 2), each = 3)  # 1 1 1 2 2 2

# Indexation des vecteurs
v <- c(10, 20, 30, 40, 50)
v[1]        # 10 (premier élément - indexation commence à 1!)
v[c(1, 3)]  # 10 30
v[-2]       # Tous sauf le 2ème : 10 30 40 50
v[v > 25]   # Indexation logique : 30 40 50
v[c(TRUE, FALSE, TRUE, FALSE, TRUE)]  # 10 30 50

# Nommage
vecteur_nomme <- c(a = 1, b = 2, c = 3)
names(vecteur_nomme)  # "a" "b" "c"
vecteur_nomme["b"]    # 2

# --- MATRICES (2D, un seul type) ---
# Les matrices sont des tableaux à 2 dimensions contenant un seul type de données

# CRÉATION DE MATRICES AVEC matrix()
# Syntaxe: matrix(data, nrow, ncol, byrow)

# Exemple 1: Création d'une matrice par remplissage par LIGNE
# byrow = TRUE : les valeurs remplissent la matrice ligne par ligne (→)
Matrice1 <- matrix(c(1, 2, 3, 4, 11, 12, 13, 14), byrow = TRUE, ncol = 4)
# Résultat:
#      [,1] [,2] [,3] [,4]
# [1,]    1    2    3    4
# [2,]   11   12   13   14

# Inspection de la matrice
class(Matrice1)      # "matrix" "array"
is.matrix(Matrice1)  # TRUE
is.vector(Matrice1)  # FALSE
dim(Matrice1)        # 2 4 (2 lignes, 4 colonnes)
nrow(Matrice1)       # 2 (nombre de lignes)
ncol(Matrice1)       # 4 (nombre de colonnes)

# Exemple 2: Même données mais avec ncol = 2 (donc 4 lignes)
# Changement du nombre de colonnes
Matrice2 <- matrix(c(1, 2, 3, 4, 11, 12, 13, 14), byrow = TRUE, ncol = 2)
# Résultat:
#      [,1] [,2]
# [1,]    1    2
# [2,]    3    4
# [3,]   11   12
# [4,]   13   14

# Exemple 3: Création d'une matrice par remplissage par COLONNE
# byrow = FALSE : les valeurs remplissent la matrice colonne par colonne (↓)
# C'est le comportement PAR DÉFAUT si byrow n'est pas spécifié
Matrice3 <- matrix(c(1, 2, 3, 4, 11, 12, 13, 14), byrow = FALSE, ncol = 2)
# Résultat:
#      [,1] [,2]
# [1,]    1    3
# [2,]    2    4
# [3,]   11   13
# [4,]   12   14

# Comparaison visuelle:
# byrow = TRUE  : 1→2→3→4, puis 11→12→13→14
# byrow = FALSE : 1↓2↓11↓12, puis 3↓4↓13↓14

# AUTRES MÉTHODES DE CRÉATION
# Avec rbind() : combinaison par lignes
mat_rbind <- rbind(c(1, 2, 3), c(4, 5, 6))
#      [,1] [,2] [,3]
# [1,]    1    2    3
# [2,]    4    5    6

# Avec cbind() : combinaison par colonnes
mat_cbind <- cbind(c(1, 2, 3), c(4, 5, 6))
#      [,1] [,2]
# [1,]    1    4
# [2,]    2    5
# [3,]    3    6

# Avec nrow au lieu de ncol
mat3 <- matrix(1:12, nrow = 3)  # R calcule automatiquement ncol = 4
mat4 <- matrix(1:12, nrow = 3, ncol = 4, byrow = TRUE)

# INDEXATION DES MATRICES
mat1 <- matrix(1:12, nrow = 3, ncol = 4)
mat1[2, 3]      # Ligne 2, colonne 3 : un seul élément
mat1[2, ]       # Toute la ligne 2 : vecteur
mat1[, 3]       # Toute la colonne 3 : vecteur
mat1[1:2, 2:3]  # Sous-matrice (lignes 1-2, colonnes 2-3)
mat1[c(1, 3), ] # Lignes 1 et 3, toutes colonnes

# DIMENSIONS
dim(mat1)       # c(3, 4) : 3 lignes, 4 colonnes
nrow(mat1)      # 3
ncol(mat1)      # 4
length(mat1)    # 12 (nombre total d'éléments)

# NOMMAGE DES LIGNES ET COLONNES
rownames(mat1) <- c("R1", "R2", "R3")
colnames(mat1) <- c("C1", "C2", "C3", "C4")
mat1["R2", "C3"]  # Accès par noms

# Ou lors de la création
mat_nommee <- matrix(1:6, nrow = 2,
                     dimnames = list(c("Ligne1", "Ligne2"),
                                     c("Col1", "Col2", "Col3")))

# OPÉRATIONS MATRICIELLES
mat_a <- matrix(1:9, nrow = 3)
mat_b <- matrix(9:1, nrow = 3)

# Opérations élément par élément
mat_a + mat_b       # Addition
mat_a - mat_b       # Soustraction
mat_a * mat_b       # Multiplication élément par élément
mat_a / mat_b       # Division élément par élément

# Opérations matricielles vraies
t(mat_a)            # Transposée
mat_a %*% t(mat_a)  # Multiplication matricielle
solve(mat_a)        # Inverse (si inversible)
det(mat_a)          # Déterminant
diag(mat_a)         # Diagonale

# Statistiques par ligne/colonne
rowSums(mat1)       # Somme par ligne
colSums(mat1)       # Somme par colonne
rowMeans(mat1)      # Moyenne par ligne
colMeans(mat1)      # Moyenne par colonne

# MATRICES SPÉCIALES
diag(5)             # Matrice identité 5x5
diag(c(1, 2, 3))    # Matrice diagonale avec 1, 2, 3
matrix(0, nrow = 3, ncol = 4)  # Matrice de zéros
matrix(1, nrow = 3, ncol = 4)  # Matrice de uns

# --- ARRAYS (Multi-dimensionnel, un seul type) ---
arr <- array(1:24, dim = c(3, 4, 2))  # 3x4x2
arr[2, 3, 1]    # Accès à un élément

# --- LISTES (peuvent contenir différents types) ---
ma_liste <- list(
  nombres = c(1, 2, 3),
  texte = "Bonjour",
  logique = TRUE,
  sous_liste = list(a = 1, b = 2)
)

# Accès aux éléments
ma_liste[[1]]           # Premier élément (vecteur)
ma_liste[["nombres"]]   # Par nom
ma_liste$nombres        # Par nom avec $
ma_liste$sous_liste$a   # Navigation imbriquée

# --- DATA FRAMES (tableaux 2D avec types mixtes) ---
# C'est LA structure la plus utilisée en R!
df <- data.frame(
  nom = c("Alice", "Bob", "Charlie"),
  age = c(25, 30, 35),
  salaire = c(50000, 60000, 70000),
  actif = c(TRUE, TRUE, FALSE),
  stringsAsFactors = FALSE  # Important pour éviter la conversion automatique
)

# Accès aux données
df$nom              # Colonne "nom"
df[, "nom"]         # Colonne "nom"
df[1, ]             # Première ligne
df[1, 2]            # Ligne 1, colonne 2
df[df$age > 26, ]   # Filtrage

# Informations
str(df)             # Structure
summary(df)         # Résumé statistique
head(df)            # 6 premières lignes
tail(df)            # 6 dernières lignes
nrow(df)            # Nombre de lignes
ncol(df)            # Nombre de colonnes
names(df)           # Noms des colonnes
colnames(df)        # Idem
rownames(df)        # Noms des lignes

# Ajout de colonnes
df$bonus <- c(5000, 6000, 7000)

# --- FACTORS (variables catégorielles) ---
# Utilisés pour les données catégorielles
niveau <- factor(c("bas", "moyen", "haut", "moyen", "bas"))
levels(niveau)      # Les niveaux

# Factors ordonnés
niveau_ordonne <- factor(
  c("bas", "moyen", "haut", "moyen", "bas"),
  levels = c("bas", "moyen", "haut"),
  ordered = TRUE
)

# ============================================================================
# 5. STRUCTURES DE CONTRÔLE
# ============================================================================

# --- IF / ELSE ---
x <- 5

if (x > 0) {
  print("Positif")
} else if (x < 0) {
  print("Négatif")
} else {
  print("Zéro")
}

# If/else sur une ligne (ifelse vectorisé)
vecteur <- c(-2, 0, 3, -5, 7)
resultat <- ifelse(vecteur > 0, "Positif", "Non-positif")

# --- FOR LOOPS ---
# Boucle classique
for (i in 1:5) {
  print(i)
}

# Boucle sur un vecteur
fruits <- c("pomme", "banane", "orange")
for (fruit in fruits) {
  print(paste("J'aime les", fruit))
}

# Boucle avec index
for (i in seq_along(fruits)) {
  print(paste(i, ":", fruits[i]))
}

# --- WHILE LOOPS ---
compteur <- 1
while (compteur <= 5) {
  print(compteur)
  compteur <- compteur + 1
}

# --- REPEAT LOOPS ---
compteur <- 1
repeat {
  print(compteur)
  compteur <- compteur + 1
  if (compteur > 5) break
}

# --- BREAK et NEXT ---
for (i in 1:10) {
  if (i == 3) next     # Passer à l'itération suivante
  if (i == 8) break    # Sortir de la boucle
  print(i)
}

# --- SWITCH ---
jour <- "mardi"
message <- switch(jour,
  lundi = "Début de semaine",
  mardi = "Deuxième jour",
  mercredi = "Milieu de semaine",
  jeudi = "Presque vendredi",
  vendredi = "Weekend arrive!",
  "Weekend!"
)

# ============================================================================
# 6. FONCTIONS
# ============================================================================

# --- Fonction simple ---
ma_fonction <- function() {
  print("Hello!")
}
ma_fonction()

# --- Fonction avec paramètres ---
addition <- function(a, b) {
  resultat <- a + b
  return(resultat)  # return() est optionnel, R retourne la dernière expression
}
addition(5, 3)

# --- Paramètres par défaut ---
saluer <- function(nom, salutation = "Bonjour") {
  paste(salutation, nom)
}
saluer("Alice")              # "Bonjour Alice"
saluer("Bob", "Salut")       # "Salut Bob"

# --- Arguments nommés ---
diviser <- function(numerateur, denominateur) {
  numerateur / denominateur
}
diviser(numerateur = 10, denominateur = 2)
diviser(denominateur = 2, numerateur = 10)  # Ordre n'importe pas avec noms

# --- Fonction avec nombre variable d'arguments (...) ---
ma_somme <- function(...) {
  args <- list(...)
  total <- 0
  for (arg in args) {
    total <- total + arg
  }
  return(total)
}
ma_somme(1, 2, 3, 4, 5)  # 15

# --- Fonctions anonymes (lambda) ---
carre <- function(x) x^2
sapply(1:5, function(x) x^2)  # Fonction anonyme

# --- Portée des variables ---
x <- 10  # Variable globale

test_portee <- function() {
  x <- 5  # Variable locale
  print(x)  # 5
}
test_portee()
print(x)  # 10 (globale inchangée)

# --- Fonctions récursives ---
factorielle <- function(n) {
  if (n <= 1) {
    return(1)
  } else {
    return(n * factorielle(n - 1))
  }
}
factorielle(5)  # 120

# ============================================================================
# 7. FONCTIONS APPLY (ALTERNATIVES AUX BOUCLES)
# ============================================================================

# --- apply() : sur matrices/arrays ---
mat <- matrix(1:12, nrow = 3)
apply(mat, 1, sum)  # Somme par ligne (MARGIN = 1)
apply(mat, 2, sum)  # Somme par colonne (MARGIN = 2)

# --- lapply() : sur listes, retourne une liste ---
liste <- list(a = 1:5, b = 6:10, c = 11:15)
lapply(liste, mean)

# --- sapply() : version simplifiée de lapply (retourne vecteur si possible) ---
sapply(liste, mean)

# --- vapply() : comme sapply mais avec type de retour spécifié ---
vapply(liste, mean, FUN.VALUE = numeric(1))

# --- mapply() : version multivariée ---
mapply(function(x, y) x + y, 1:5, 6:10)

# --- tapply() : applique une fonction sur des sous-groupes ---
ages <- c(25, 30, 35, 40, 45)
groupes <- c("A", "B", "A", "B", "A")
tapply(ages, groupes, mean)  # Moyenne par groupe

# --- replicate() : répète une expression ---
replicate(5, rnorm(1))  # 5 nombres aléatoires

# ============================================================================
# 8. CHAÎNES DE CARACTÈRES
# ============================================================================

# --- Création ---
texte <- "Bonjour"
texte2 <- 'Aussi valide'

# --- Concaténation ---
paste("Hello", "World")                    # "Hello World" (espace par défaut)
paste("Hello", "World", sep = "-")        # "Hello-World"
paste0("Hello", "World")                   # "HelloWorld" (pas d'espace)

# --- Fonctions de manipulation ---
texte <- "Bonjour le Monde"
nchar(texte)                  # Nombre de caractères
toupper(texte)                # MAJUSCULES
tolower(texte)                # minuscules
substr(texte, 1, 7)          # Extraction : "Bonjour"
strsplit(texte, " ")         # Division : list("Bonjour", "le", "Monde")

# --- Recherche et remplacement ---
grepl("Monde", texte)        # TRUE (recherche)
gsub("Monde", "R", texte)    # Remplacement : "Bonjour le R"
sub("o", "0", texte)         # Remplace première occurrence

# --- Expressions régulières ---
emails <- c("test@example.com", "invalid-email", "autre@test.fr")
grep("@", emails)             # Indices : 1 3
grepl("@", emails)            # Logical : TRUE FALSE TRUE
grep("@", emails, value = TRUE)  # Valeurs : "test@example.com" "autre@test.fr"

# --- Formatage ---
sprintf("Le nombre est %d", 42)
sprintf("Pi = %.2f", pi)

# ============================================================================
# 9. DATES ET HEURES
# ============================================================================

# --- Dates ---
date_aujourdhui <- Sys.Date()
date_specifique <- as.Date("2026-01-12")
class(date_specifique)  # "Date"

# Formatage
format(date_specifique, "%d/%m/%Y")  # "12/01/2026"
format(date_specifique, "%A %d %B %Y")  # Jour complet

# Opérations
date_future <- date_specifique + 7  # Ajouter 7 jours
diff_dates <- date_future - date_specifique  # Différence

# --- Dates et heures ---
datetime_maintenant <- Sys.time()
datetime_specifique <- as.POSIXct("2026-01-12 14:30:00")
class(datetime_specifique)  # "POSIXct" "POSIXt"

# Extraction
format(datetime_specifique, "%H:%M:%S")  # Heure
format(datetime_specifique, "%Y-%m-%d")  # Date

# Package lubridate (plus facile, mais nécessite installation)
# library(lubridate)
# ymd("2026-01-12")
# ymd_hms("2026-01-12 14:30:00")

# ============================================================================
# 10. GESTION DES VALEURS MANQUANTES
# ============================================================================

# --- Détection ---
x <- c(1, 2, NA, 4, 5)
is.na(x)           # FALSE FALSE TRUE FALSE FALSE
any(is.na(x))      # TRUE (y a-t-il des NA?)
sum(is.na(x))      # 1 (combien de NA?)

# --- Suppression ---
x[!is.na(x)]       # Valeurs non-NA
na.omit(x)         # Supprime les NA

# --- Calculs avec NA ---
mean(x)            # NA (par défaut)
mean(x, na.rm = TRUE)  # 3 (ignore les NA)
sum(x, na.rm = TRUE)   # 12

# --- Remplacement ---
x[is.na(x)] <- 0   # Remplacer NA par 0

# ============================================================================
# 11. INPUT/OUTPUT (LECTURE/ÉCRITURE DE FICHIERS)
# ============================================================================

# --- CSV ---
# Écriture
# write.csv(df, "data.csv", row.names = FALSE)

# Lecture
# donnees <- read.csv("data.csv")
# donnees <- read.csv("data.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# --- Autres formats tabulaires ---
# write.table(df, "data.txt", sep = "\t")
# read.table("data.txt", header = TRUE, sep = "\t")

# --- RDS (format R natif) ---
# saveRDS(df, "data.rds")
# donnees <- readRDS("data.rds")

# --- RData (plusieurs objets) ---
# save(df, x, y, file = "workspace.RData")
# load("workspace.RData")

# --- Excel (nécessite des packages) ---
# library(readxl)
# donnees <- read_excel("data.xlsx", sheet = 1)
# library(writexl)
# write_xlsx(df, "data.xlsx")

# ============================================================================
# 12. PACKAGES
# ============================================================================

# --- Installation ---
# install.packages("dplyr")
# install.packages(c("ggplot2", "tidyr"))  # Multiple packages

# --- Chargement ---
# library(dplyr)
# require(dplyr)  # Similaire mais retourne TRUE/FALSE

# --- Usage sans chargement ---
# dplyr::filter(df, age > 25)

# --- Packages installés ---
# installed.packages()
# library()  # Liste des packages disponibles

# --- Mise à jour ---
# update.packages()

# --- Désinstallation ---
# remove.packages("nom_package")

# ============================================================================
# 13. PROGRAMMATION ORIENTÉE OBJET
# ============================================================================

# R supporte plusieurs systèmes de POO : S3 (le plus courant), S4, R6
# Le concept clé est le POLYMORPHISME : une fonction se comporte différemment
# selon la classe de l'objet passé en paramètre

# ============================================================================
# MÉTHODES GÉNÉRIQUES (GENERIC FUNCTIONS)
# ============================================================================

# Une fonction GÉNÉRIQUE peut faire des choses différentes selon la CLASSE de l'objet
# Exemple classique : plot()

# Exemple 1 : plot() avec un vecteur d'entiers
x <- rpois(100, lambda = 2)  # 100 nombres aléatoires selon loi de Poisson
class(x)  # "integer"
# plot(x, main = paste("plot pour la classe", class(x)))
# Résultat : nuage de points (index vs valeur)

# Exemple 2 : plot() avec un modèle linéaire
# model <- lm(mpg ~ wt, data = mtcars)
# class(model)  # "lm"
# plot(model)
# Résultat : 4 graphiques de diagnostic du modèle

# Exemple 3 : plot() avec une série temporelle
# ts_data <- ts(1:100, frequency = 12)
# class(ts_data)  # "ts"
# plot(ts_data)
# Résultat : graphique de série temporelle avec axe temporel

# EXPLICATION : plot() est une fonction GÉNÉRIQUE
# Elle appelle automatiquement la méthode appropriée :
# - plot.default() pour les vecteurs/matrices
# - plot.lm() pour les modèles linéaires
# - plot.ts() pour les séries temporelles
# C'est ce qu'on appelle le "METHOD DISPATCH" (distribution de méthode)

# Voir toutes les méthodes disponibles pour une fonction générique
methods(plot)        # Liste toutes les méthodes plot.*
methods(print)       # Liste toutes les méthodes print.*
methods(summary)     # Liste toutes les méthodes summary.*

# Voir quelles méthodes sont disponibles pour une classe
methods(class = "lm")        # Méthodes pour les modèles linéaires
methods(class = "data.frame") # Méthodes pour les data.frames

# ============================================================================
# SYSTÈME S3 (Simple S3)
# ============================================================================
# Le système S3 est le plus ancien et le plus utilisé en R
# Il est basé sur les conventions de nommage : generic.class()

# --- Création d'une classe S3 ---
# Une classe S3 est simplement un objet avec un attribut "class"
personne <- list(
  nom = "Alice",
  age = 30,
  email = "alice@example.com"
)
class(personne) <- "Personne"  # Définir la classe

# Vérification
class(personne)        # "Personne"
is.object(personne)    # TRUE

# --- Création d'une méthode générique personnalisée ---
# 1. Créer la fonction générique
saluer <- function(x) {
  UseMethod("saluer")  # Indique que c'est une fonction générique
}

# 2. Créer la méthode pour la classe Personne
saluer.Personne <- function(x) {
  cat(sprintf("Bonjour, je suis %s, j'ai %d ans\n", x$nom, x$age))
}

# 3. Créer une méthode par défaut
saluer.default <- function(x) {
  cat("Bonjour!\n")
}

# Utilisation
saluer(personne)       # Appelle saluer.Personne()
saluer("texte")        # Appelle saluer.default()

# --- Méthode print pour la classe Personne ---
# print() est une fonction générique très utilisée
print.Personne <- function(x) {
  cat("=== Personne ===\n")
  cat(sprintf("Nom   : %s\n", x$nom))
  cat(sprintf("Âge   : %d ans\n", x$age))
  cat(sprintf("Email : %s\n", x$email))
  invisible(x)  # Retourne x invisiblement (bonne pratique)
}
print(personne)  # Appelle automatiquement print.Personne()

# --- Méthode summary pour la classe Personne ---
summary.Personne <- function(object, ...) {
  cat("Résumé de la personne:\n")
  cat(sprintf("- Nom: %s (%d caractères)\n", object$nom, nchar(object$nom)))
  cat(sprintf("- Âge: %d ans", object$age))
  if (object$age < 18) cat(" (mineur)")
  else if (object$age >= 65) cat(" (senior)")
  cat("\n")
}
summary(personne)

# --- Constructeur (bonne pratique) ---
# Créer une fonction pour construire des objets de la classe
creer_personne <- function(nom, age, email = NA) {
  # Validation
  if (!is.character(nom)) stop("nom doit être un caractère")
  if (!is.numeric(age) || age < 0) stop("age doit être un nombre positif")
  
  # Création de l'objet
  structure(
    list(
      nom = nom,
      age = age,
      email = email
    ),
    class = "Personne"
  )
}

# Utilisation du constructeur
bob <- creer_personne("Bob", 35, "bob@example.com")
print(bob)

# --- Héritage en S3 ---
# Une classe peut hériter d'une autre
etudiant <- creer_personne("Charlie", 20, "charlie@universite.fr")
class(etudiant) <- c("Etudiant", "Personne")  # Etudiant hérite de Personne

# Méthode spécifique pour Etudiant
print.Etudiant <- function(x) {
  cat("=== Étudiant ===\n")
  NextMethod("print")  # Appelle print.Personne()
  cat("Statut : Étudiant\n")
}
print(etudiant)

# --- Vérification de classe ---
inherits(etudiant, "Personne")   # TRUE
inherits(etudiant, "Etudiant")   # TRUE
inherits(bob, "Etudiant")        # FALSE

# --- S4 (plus formel) ---
# setClass("Personne",
#   slots = list(
#     nom = "character",
#     age = "numeric"
#   )
# )
# 
# alice <- new("Personne", nom = "Alice", age = 30)

# --- R6 (moderne, similaire à OOP classique) ---
# library(R6)
# Personne <- R6Class("Personne",
#   public = list(
#     nom = NULL,
#     age = NULL,
#     initialize = function(nom, age) {
#       self$nom <- nom
#       self$age <- age
#     },
#     saluer = function() {
#       cat(sprintf("Bonjour, je suis %s\n", self$nom))
#     }
#   )
# )
# alice <- Personne$new("Alice", 30)
# alice$saluer()

# ============================================================================
# 14. GESTION D'ERREURS
# ============================================================================

# --- try() : continue même en cas d'erreur ---
resultat <- try(log("texte"), silent = TRUE)
if (inherits(resultat, "try-error")) {
  print("Une erreur s'est produite")
}

# --- tryCatch() : gestion détaillée des erreurs ---
resultat <- tryCatch(
  {
    log("texte")  # Génère une erreur
  },
  error = function(e) {
    message("Erreur capturée: ", e$message)
    return(NA)
  },
  warning = function(w) {
    message("Avertissement: ", w$message)
  },
  finally = {
    message("Nettoyage final")
  }
)

# --- stop() : générer une erreur ---
verifier_positif <- function(x) {
  if (x < 0) {
    stop("x doit être positif!")
  }
  return(sqrt(x))
}

# --- warning() : générer un avertissement ---
ma_fonction <- function(x) {
  if (x < 0) {
    warning("x est négatif, résultat peut être inattendu")
  }
  return(x^2)
}

# --- message() : message informatif ---
message("Traitement en cours...")

# ============================================================================
# 15. ENVIRONNEMENTS ET WORKSPACES
# ============================================================================

# --- Environnement de travail ---
getwd()                    # Répertoire actuel
# setwd("C:/mon/chemin")   # Changer de répertoire

# --- Variables dans l'environnement ---
ls()                       # Liste des objets
ls(pattern = "^ma")       # Objets commençant par "ma"
rm(x)                      # Supprimer un objet
rm(list = ls())           # Supprimer tous les objets

# --- Informations sur les objets ---
exists("x")                # TRUE si x existe
class(x)                   # Type de l'objet
typeof(x)                  # Type interne
str(x)                     # Structure
length(x)                  # Longueur
dim(x)                     # Dimensions
object.size(x)            # Taille en mémoire

# ============================================================================
# 16. GRAPHIQUES DE BASE (BASE R)
# ============================================================================

# --- plot() : graphique de base ---
x <- 1:10
y <- x^2
# plot(x, y, type = "l", col = "blue", lwd = 2,
#      main = "Titre", xlab = "X", ylab = "Y")

# Types de graphiques:
# type = "p" : points
# type = "l" : lignes
# type = "b" : points et lignes
# type = "h" : histogramme vertical

# --- Histogramme ---
# hist(rnorm(1000), breaks = 30, col = "lightblue",
#      main = "Distribution normale")

# --- Boîte à moustaches ---
# boxplot(iris$Sepal.Length ~ iris$Species,
#         col = c("red", "green", "blue"),
#         main = "Longueur des sépales par espèce")

# --- Nuage de points ---
# plot(iris$Sepal.Length, iris$Sepal.Width,
#      col = iris$Species, pch = 19,
#      xlab = "Longueur", ylab = "Largeur")

# --- Barplot ---
# counts <- table(mtcars$cyl)
# barplot(counts, col = c("red", "green", "blue"),
#         main = "Nombre de cylindres")

# --- Multiples graphiques ---
# par(mfrow = c(2, 2))  # 2x2 grid
# plot(...)
# hist(...)
# boxplot(...)
# barplot(...)
# par(mfrow = c(1, 1))  # Reset

# --- Ajout d'éléments ---
# points(x, y, col = "red", pch = 19)
# lines(x, y, col = "blue", lwd = 2)
# abline(h = 0, col = "gray", lty = 2)  # Ligne horizontale
# abline(v = 0, col = "gray", lty = 2)  # Ligne verticale
# text(x, y, labels = "Point")
# legend("topright", legend = c("A", "B"), col = c("red", "blue"), lwd = 2)

# ============================================================================
# 17. STATISTIQUES DE BASE
# ============================================================================

# --- Mesures de tendance centrale ---
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
mean(x)           # Moyenne
median(x)         # Médiane

# --- Mesures de dispersion ---
var(x)            # Variance
sd(x)             # Écart-type
range(x)          # Min et max
IQR(x)            # Intervalle interquartile

# --- Quantiles ---
quantile(x)                    # Quartiles
quantile(x, probs = c(0.25, 0.5, 0.75))

# --- Résumé statistique ---
summary(x)

# --- Corrélation ---
x <- 1:10
y <- x + rnorm(10)
cor(x, y)                      # Corrélation de Pearson
cor(x, y, method = "spearman") # Corrélation de Spearman

# --- Régression linéaire ---
modele <- lm(y ~ x)            # y = ax + b
summary(modele)
coef(modele)                   # Coefficients
predict(modele, newdata = data.frame(x = 11))

# --- Tests statistiques ---
# Test t de Student
t.test(x, y)

# Test de normalité
shapiro.test(x)

# Chi-carré
# chisq.test(table)

# ANOVA
# anova(modele)

# --- Nombres aléatoires ---
set.seed(123)                  # Pour reproductibilité
rnorm(10)                      # Distribution normale
runif(10)                      # Distribution uniforme
rpois(10, lambda = 5)          # Distribution de Poisson
sample(1:100, 10)              # Échantillon aléatoire

# ============================================================================
# 18. MANIPULATION DE DONNÉES AVANCÉE (BASE R)
# ============================================================================

# --- subset() : filtrage ---
df <- data.frame(
  nom = c("Alice", "Bob", "Charlie", "Diana"),
  age = c(25, 30, 35, 28),
  ville = c("Paris", "Lyon", "Paris", "Marseille")
)

subset(df, age > 27)
subset(df, ville == "Paris", select = c(nom, age))

# --- transform() : modification ---
transform(df, age_plus_10 = age + 10)

# --- aggregate() : agrégation ---
aggregate(age ~ ville, data = df, FUN = mean)

# --- merge() : jointure ---
df1 <- data.frame(id = 1:3, valeur1 = c("A", "B", "C"))
df2 <- data.frame(id = 2:4, valeur2 = c("X", "Y", "Z"))

merge(df1, df2, by = "id")              # Inner join
merge(df1, df2, by = "id", all.x = TRUE)  # Left join
merge(df1, df2, by = "id", all.y = TRUE)  # Right join
merge(df1, df2, by = "id", all = TRUE)    # Full join

# --- rbind() / cbind() : combiner ---
rbind(df1, df1)  # Empiler verticalement
cbind(df1, df2)  # Coller horizontalement

# --- reshape() : pivot ---
# wide_data <- data.frame(id = 1:3, A = c(1,2,3), B = c(4,5,6))
# long_data <- reshape(wide_data, 
#                      direction = "long",
#                      varying = c("A", "B"),
#                      v.names = "value",
#                      timevar = "variable")

# --- order() : tri ---
df[order(df$age), ]              # Tri croissant
df[order(-df$age), ]             # Tri décroissant
df[order(df$ville, df$age), ]    # Tri multiple

# ============================================================================
# 19. EXPRESSIONS RÉGULIÈRES AVANCÉES
# ============================================================================

texte <- "Contact: jean@example.com ou marie@test.fr"

# grep : recherche avec indices ou valeurs
grep("@", strsplit(texte, " ")[[1]])
grep("@", strsplit(texte, " ")[[1]], value = TRUE)

# grepl : recherche avec résultat logique
grepl("jean", texte)  # TRUE

# sub : remplace première occurrence
sub("@", " AT ", texte)

# gsub : remplace toutes les occurrences
gsub("@", " AT ", texte)

# regexpr / gregexpr : position des correspondances
regexpr("@", texte)
gregexpr("@", texte)

# regmatches : extraction basée sur les correspondances
m <- gregexpr("[a-z]+@[a-z]+\\.[a-z]+", texte)
regmatches(texte, m)

# Métacaractères importants:
# . : n'importe quel caractère
# * : 0 ou plus
# + : 1 ou plus
# ? : 0 ou 1
# ^ : début de chaîne
# $ : fin de chaîne
# [] : ensemble de caractères
# | : ou
# () : groupe
# \\ : échappement

# ============================================================================
# 20. PROGRAMMATION FONCTIONNELLE
# ============================================================================

# --- Closures (fonctions qui retournent des fonctions) ---
creer_multiplicateur <- function(n) {
  function(x) {
    x * n
  }
}
fois_trois <- creer_multiplicateur(3)
fois_trois(10)  # 30

# --- do.call() : appeler une fonction avec une liste d'arguments ---
args <- list(x = 1:10, na.rm = TRUE)
do.call(mean, args)

# --- Reduce() : réduction ---
Reduce("+", 1:10)  # Somme : 55
Reduce(function(x, y) paste(x, y, sep = "-"), letters[1:5])  # "a-b-c-d-e"

# --- Filter() : filtrage ---
Filter(function(x) x > 5, 1:10)  # 6 7 8 9 10

# --- Map() : application ---
Map(function(x, y) x + y, 1:5, 6:10)

# --- Position / Find : recherche ---
Position(function(x) x > 5, 1:10)  # 6 (premier index)
Find(function(x) x > 5, 1:10)      # 6 (première valeur)

# ============================================================================
# 21. FORMULES R
# ============================================================================

# Les formules sont utilisées dans la modélisation et les graphiques
# Syntaxe de base: y ~ x

# Exemples:
# y ~ x               : y en fonction de x
# y ~ x1 + x2         : y en fonction de x1 et x2
# y ~ x1 * x2         : y en fonction de x1, x2 et leur interaction
# y ~ x1 + x2 + x1:x2 : équivalent à y ~ x1 * x2
# y ~ .               : y en fonction de toutes les autres variables
# y ~ . - x1          : toutes les variables sauf x1
# log(y) ~ sqrt(x)    : transformations

# Utilisation:
# modele <- lm(mpg ~ wt + hp, data = mtcars)
# plot(Sepal.Length ~ Sepal.Width, data = iris)

# ============================================================================
# 22. DEBUGGING ET PROFILING
# ============================================================================

# --- print() / cat() ---
# print("Debug message")
# cat("x =", x, "\n")

# --- browser() : pause l'exécution ---
# ma_fonction <- function(x) {
#   browser()  # Ouvre le debugger ici
#   resultat <- x^2
#   return(resultat)
# }

# --- debug() / undebug() ---
# debug(ma_fonction)      # Active le debug
# ma_fonction(5)          # Entre dans le debugger
# undebug(ma_fonction)    # Désactive

# --- traceback() : voir la pile d'appels après une erreur ---
# traceback()

# --- trace() : insérer du code de débogage ---
# trace(ma_fonction, quote(print(x)))

# --- Profiling (mesure de performance) ---
# system.time({ code à mesurer })
# 
# Rprof("profile.out")    # Démarre le profiling
# # ... code ...
# Rprof(NULL)             # Arrête
# summaryRprof("profile.out")  # Résultats

# --- microbenchmark (package pour benchmark précis) ---
# library(microbenchmark)
# microbenchmark(
#   methode1 = { code1 },
#   methode2 = { code2 },
#   times = 100
# )

# ============================================================================
# 23. OPÉRATEURS PIPE (MODERNE)
# ============================================================================

# Pipe natif R (depuis R 4.1.0)
# |> : envoie le résultat à gauche comme premier argument de droite
# 1:10 |> mean()
# mtcars |> subset(cyl == 4) |> nrow()

# Pipe magrittr (package dplyr/tidyverse)
# library(magrittr)
# %>% : similaire mais plus de fonctionnalités
# . : placeholder
# mtcars %>% subset(cyl == 4) %>% nrow()
# mtcars %>% lm(mpg ~ wt, data = .)

# ============================================================================
# 24. EXPRESSIONS ET ÉVALUATION
# ============================================================================

# --- expression() : créer une expression non évaluée ---
expr <- expression(x + y)
x <- 5
y <- 3
eval(expr)  # 8

# --- quote() : capturer une expression ---
quoted <- quote(x + y)
eval(quoted)

# --- substitute() : substitution dans les expressions ---
substituer <- function(expr) {
  substitute(expr)
}

# --- parse() : convertir texte en expression ---
code <- parse(text = "x <- 5; y <- 10; x + y")
eval(code)  # 15

# --- deparse() : convertir expression en texte ---
deparse(quote(x + y))  # "x + y"

# ============================================================================
# 25. ATTRIBUTS ET MÉTADONNÉES
# ============================================================================

x <- 1:10

# --- Attributs ---
attr(x, "description") <- "Nombres de 1 à 10"
attr(x, "description")
attributes(x)

# --- Attributs spéciaux ---
# names : noms des éléments
names(x) <- letters[1:10]

# dim : dimensions
dim(x) <- c(2, 5)  # Transforme en matrice 2x5

# class : classe de l'objet
class(x) <- "ma_classe"

# ============================================================================
# 26. OPÉRATIONS VECTORISÉES
# ============================================================================

# R est vectorisé par défaut - évitez les boucles quand possible!

# --- Opérations arithmétiques vectorisées ---
x <- 1:5
y <- 6:10
x + y        # Addition élément par élément
x * 2        # Multiplication par un scalaire (recyclage)

# --- Recyclage ---
# Vecteurs de longueurs différentes sont recyclés
x <- 1:6
y <- 1:2
x + y        # 1+1, 2+2, 3+1, 4+2, 5+1, 6+2

# --- Fonctions vectorisées ---
x <- c(-2, -1, 0, 1, 2)
abs(x)       # Valeur absolue
sqrt(abs(x)) # Racine carrée
exp(x)       # Exponentielle
log(abs(x) + 1)  # Logarithme

# --- Opérations cumulatives ---
cumsum(1:5)  # Somme cumulative : 1 3 6 10 15
cumprod(1:5) # Produit cumulatif : 1 2 6 24 120
cummax(c(3, 1, 4, 1, 5))  # Max cumulatif
cummin(c(3, 1, 4, 1, 5))  # Min cumulatif

# --- Différences ---
diff(c(1, 3, 6, 10))  # 2 3 4

# ============================================================================
# 27. TIDYVERSE (APERÇU) - Nécessite installation
# ============================================================================

# Le tidyverse est une collection de packages R modernes
# install.packages("tidyverse")
# library(tidyverse)  # Charge dplyr, ggplot2, tidyr, etc.

# --- dplyr : manipulation de données ---
# library(dplyr)
# 
# df %>%
#   filter(age > 25) %>%           # Filtrer
#   select(nom, age) %>%           # Sélectionner colonnes
#   mutate(age_10 = age + 10) %>%  # Créer nouvelle colonne
#   arrange(desc(age)) %>%         # Trier
#   group_by(ville) %>%            # Grouper
#   summarise(age_moyen = mean(age))  # Résumer

# Principales fonctions dplyr:
# filter() : filtrer lignes
# select() : sélectionner colonnes
# mutate() : créer/modifier colonnes
# arrange() : trier
# group_by() : grouper
# summarise() : résumer
# left_join(), inner_join(), etc. : jointures

# --- tidyr : restructuration de données ---
# library(tidyr)
# 
# pivot_longer() : wide -> long
# pivot_wider() : long -> wide
# separate() : séparer une colonne
# unite() : unir des colonnes

# --- ggplot2 : graphiques avancés ---
# library(ggplot2)
# 
# ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#   geom_point() +
#   geom_smooth(method = "lm") +
#   labs(title = "Iris Dataset", x = "Longueur", y = "Largeur") +
#   theme_minimal()

# ============================================================================
# 28. BONNES PRATIQUES
# ============================================================================

# 1. NOMMAGE
#    - Variables : snake_case (ma_variable)
#    - Fonctions : snake_case (calculer_moyenne) ou camelCase (calculerMoyenne)
#    - Constantes : SNAKE_CASE_MAJUSCULE (PI_VALUE)
#    - Éviter les noms réservés : c, t, T, F, etc.

# 2. STYLE DE CODE
#    - Indentation : 2 espaces
#    - Espaces autour des opérateurs : x <- 5, pas x<-5
#    - Pas d'espace avant (, mais espace après ,
#    - Lignes < 80 caractères

# 3. COMMENTAIRES
#    - Expliquer le "pourquoi", pas le "quoi"
#    - Utiliser # pour commentaires
#    - Documenter les fonctions

# 4. FONCTIONS
#    - Une fonction = une tâche
#    - Noms descriptifs
#    - Limiter les arguments (< 5 idéalement)
#    - Valider les entrées

# 5. ÉVITER
#    - attach() : peut causer des conflits
#    - setwd() dans un script : non portable
#    - Boucles quand vectorisation possible
#    - Variables globales dans les fonctions

# 6. ORGANISATION
#    - Utiliser des projets RStudio (.Rproj)
#    - Structure de dossiers claire
#    - Séparer données, scripts, résultats

# ============================================================================
# 29. RESSOURCES ET AIDE
# ============================================================================

# --- Aide dans R ---
?mean              # Aide sur la fonction mean
help(mean)         # Idem
??regression       # Recherche dans toute la documentation
example(mean)      # Exemples d'utilisation

# --- Informations ---
help.start()       # Ouvre la documentation HTML
demo()             # Liste des démos disponibles
vignette()         # Liste des vignettes
browseVignettes()  # Navigation des vignettes

# --- À propos de R ---
R.version          # Version de R
sessionInfo()      # Informations sur la session
getRversion()      # Version de R (simple)

# --- Recherche de packages ---
# RSiteSearch("keyword")
# help.search("keyword")

# ============================================================================
# 30. ASTUCES ET RACCOURCIS
# ============================================================================

# --- Raccourcis RStudio (utiles) ---
# Ctrl + Enter : Exécuter ligne/sélection
# Ctrl + Shift + Enter : Exécuter tout le script
# Ctrl + L : Effacer la console
# Ctrl + 1 : Focus sur script
# Ctrl + 2 : Focus sur console
# Alt + - : Insérer <-
# Ctrl + Shift + C : Commenter/décommenter
# Ctrl + Shift + F : Recherche dans les fichiers
# Tab : Auto-complétion

# --- Astuces R ---
# head(df, 10)           # 10 premières lignes
# tail(df, 10)           # 10 dernières lignes
# View(df)               # Voir dans un onglet
# str(df)                # Structure compacte
# glimpse(df)            # Structure (dplyr)
# names(df)              # Noms des colonnes
# dim(df)                # Dimensions
# nrow(df); ncol(df)     # Nombre de lignes/colonnes

# --- Nettoyage et reset ---
rm(list = ls())        # Supprimer tous les objets
cat("\014")            # Effacer console (ou Ctrl+L)
# .rs.restartR()       # Redémarrer R (RStudio)

# --- Options globales ---
options(digits = 3)           # Nombre de chiffres affichés
options(scipen = 999)         # Désactiver notation scientifique
options(stringsAsFactors = FALSE)  # Pas de conversion auto en factors

# --- Mesure du temps d'exécution ---
start_time <- Sys.time()
# ... code ...
end_time <- Sys.time()
end_time - start_time

# Ou plus simple:
system.time({
  # ... code ...
})

# ============================================================================
# FIN DU GUIDE
# ============================================================================

# Ce script couvre l'essentiel de la syntaxe R.
# Pour aller plus loin :
# - R for Data Science (livre gratuit en ligne)
# - Advanced R (Hadley Wickham)
# - Documentation CRAN
# - Stack Overflow pour les questions
# - RStudio Cheatsheets

print("🎉 Félicitations! Vous avez parcouru toute la syntaxe R!")
print("📚 Continuez à pratiquer et explorer!")
