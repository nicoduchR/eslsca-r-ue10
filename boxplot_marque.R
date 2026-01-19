# ============================================================================
# BOXPLOT PAR MARQUE
# ============================================================================
# Ce script affiche un boxplot (boîte à moustaches) du montant des achats
# en fonction de la marque de chaussures
# ============================================================================

# ----------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNÉES
# ----------------------------------------------------------------------------

donnees <- read.csv("chaussures.csv", header = TRUE, stringsAsFactors = FALSE)

cat("\n=== APERÇU DES DONNÉES ===\n")
print(head(donnees))

# ----------------------------------------------------------------------------
# 2. STATISTIQUES DESCRIPTIVES PAR MARQUE
# ----------------------------------------------------------------------------

cat("\n\n=== STATISTIQUES DU MONTANT PAR MARQUE ===\n")

# Calculer les statistiques par marque
stats_marque <- aggregate(Montant ~ Marque, data = donnees, FUN = function(x) {
  c(Min = min(x),
    Q1 = quantile(x, 0.25),
    Mediane = median(x),
    Moyenne = mean(x),
    Q3 = quantile(x, 0.75),
    Max = max(x),
    Ecart_type = sd(x),
    N = length(x))
})

# Afficher les statistiques
print(stats_marque)

# ----------------------------------------------------------------------------
# 3. BOXPLOT DU MONTANT PAR MARQUE
# ----------------------------------------------------------------------------

cat("\n\n=== GÉNÉRATION DU BOXPLOT ===\n")

# Définir les couleurs pour chaque marque
couleurs <- c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A")

# Créer le boxplot
boxplot(Montant ~ Marque,
        data = donnees,
        main = "Distribution du Montant par Marque",
        xlab = "Marque",
        ylab = "Montant (euros)",
        col = couleurs,
        border = "black",
        notch = FALSE,
        las = 1)

# Ajouter une grille horizontale
grid(nx = NA, ny = NULL, col = "gray", lty = "dotted")

# Ajouter les moyennes avec des points
moyennes <- tapply(donnees$Montant, donnees$Marque, mean)
points(1:length(moyennes), moyennes, pch = 18, col = "darkred", cex = 1.5)

# Ajouter une légende pour la moyenne
legend("topright",
       legend = "Moyenne",
       pch = 18,
       col = "darkred",
       pt.cex = 1.5,
       bg = "white")

cat("Boxplot généré avec succès !\n")

# ----------------------------------------------------------------------------
# 4. INTERPRÉTATION
# ----------------------------------------------------------------------------

cat("\n\n=== INTERPRÉTATION ===\n")
cat("Le boxplot montre :\n")
cat("- La boîte : du 1er quartile (Q1) au 3ème quartile (Q3)\n")
cat("- La ligne dans la boîte : la médiane\n")
cat("- Les moustaches : min et max (hors valeurs aberrantes)\n")
cat("- Les points rouges : les moyennes\n")

# ----------------------------------------------------------------------------
# FIN DU SCRIPT
# ----------------------------------------------------------------------------

cat("\n\n=== ANALYSE TERMINÉE ===\n")
