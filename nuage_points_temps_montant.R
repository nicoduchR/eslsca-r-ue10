# ============================================================================
# NUAGE DE POINTS : MONTANT EN FONCTION DU TEMPS
# ============================================================================
# Ce script affiche un nuage de points (scatter plot) du montant des achats
# en fonction du temps passé sur le site
# ============================================================================

# ----------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNÉES
# ----------------------------------------------------------------------------

donnees <- read.csv("chaussures.csv", header = TRUE, stringsAsFactors = FALSE)

cat("\n=== APERÇU DES DONNÉES ===\n")
print(head(donnees))

# ----------------------------------------------------------------------------
# 2. STATISTIQUES DESCRIPTIVES
# ----------------------------------------------------------------------------

cat("\n\n=== STATISTIQUES DESCRIPTIVES ===\n")

cat("\nVariable TEMPS (minutes passées sur le site) :\n")
cat(sprintf("  Minimum    : %.2f\n", min(donnees$Temps)))
cat(sprintf("  Maximum    : %.2f\n", max(donnees$Temps)))
cat(sprintf("  Moyenne    : %.2f\n", mean(donnees$Temps)))
cat(sprintf("  Médiane    : %.2f\n", median(donnees$Temps)))
cat(sprintf("  Écart-type : %.2f\n", sd(donnees$Temps)))

cat("\nVariable MONTANT (euros) :\n")
cat(sprintf("  Minimum    : %.2f\n", min(donnees$Montant)))
cat(sprintf("  Maximum    : %.2f\n", max(donnees$Montant)))
cat(sprintf("  Moyenne    : %.2f\n", mean(donnees$Montant)))
cat(sprintf("  Médiane    : %.2f\n", median(donnees$Montant)))
cat(sprintf("  Écart-type : %.2f\n", sd(donnees$Montant)))

# ----------------------------------------------------------------------------
# 3. ANALYSE PAR ORIGINE
# ----------------------------------------------------------------------------

cat("\n\n=== RÉPARTITION PAR ORIGINE ===\n")
table_origine <- table(donnees$Origine)
print(table_origine)

cat("\nMontant moyen par origine :\n")
moyennes_origine <- aggregate(Montant ~ Origine, data = donnees, FUN = mean)
print(moyennes_origine)

cat("\nTemps moyen par origine :\n")
temps_origine <- aggregate(Temps ~ Origine, data = donnees, FUN = mean)
print(temps_origine)

# ----------------------------------------------------------------------------
# 4. CORRÉLATION ENTRE TEMPS ET MONTANT
# ----------------------------------------------------------------------------

cat("\n\n=== ANALYSE DE CORRÉLATION ===\n")

correlation <- cor(donnees$Temps, donnees$Montant)
cat(sprintf("Coefficient de corrélation (Pearson) : %.4f\n", correlation))

# Interprétation de la corrélation
if (abs(correlation) < 0.3) {
  interpretation <- "faible"
} else if (abs(correlation) < 0.7) {
  interpretation <- "modérée"
} else {
  interpretation <- "forte"
}

if (correlation > 0) {
  sens <- "positive"
} else {
  sens <- "négative"
}

cat(sprintf("Interprétation : corrélation %s %s\n", interpretation, sens))

# ----------------------------------------------------------------------------
# 5. NUAGE DE POINTS AVEC COLORATION PAR ORIGINE
# ----------------------------------------------------------------------------

cat("\n\n=== GÉNÉRATION DU NUAGE DE POINTS ===\n")

# Définir les couleurs pour chaque origine
couleurs_origine <- c("Mars" = "#4A90E2", "Pluton" = "#FF8C42", "Terre" = "#A8A8A8")

# Attribuer une couleur à chaque observation selon l'origine
couleurs_points <- couleurs_origine[donnees$Origine]

# Créer le nuage de points
plot(donnees$Temps, 
     donnees$Montant,
     main = "Montant des factures en fonction du temps passé sur le site",
     xlab = "Temps passé sur le site (minutes)",
     ylab = "Montant de la facture (euros)",
     xlim = c(0, 60),
     ylim = c(min(donnees$Montant), max(donnees$Montant)),
     col = couleurs_points,
     pch = 16,
     cex = 1.2)

# Ajouter une grille
grid(col = "gray", lty = "dotted")

# Ajouter une droite de régression
modele <- lm(Montant ~ Temps, data = donnees)
abline(modele, col = "black", lwd = 2, lty = 2)

# Ajouter une légende
legend("topright",
       legend = c(names(couleurs_origine), 
                  sprintf("Régression (r = %.3f)", correlation)),
       col = c(couleurs_origine, "black"),
       pch = c(16, 16, 16, NA),
       lty = c(NA, NA, NA, 2),
       lwd = c(NA, NA, NA, 2),
       pt.cex = c(1.2, 1.2, 1.2, NA),
       bg = "white",
       cex = 0.9)

cat("Nuage de points généré avec succès !\n")

# ----------------------------------------------------------------------------
# 6. MODÈLE DE RÉGRESSION LINÉAIRE
# ----------------------------------------------------------------------------

cat("\n\n=== MODÈLE DE RÉGRESSION LINÉAIRE ===\n")

# Résumé du modèle
print(summary(modele))

# Équation de la droite
intercept <- coef(modele)[1]
slope <- coef(modele)[2]

cat(sprintf("\nÉquation de la droite : Montant = %.2f + %.2f × Temps\n", 
            intercept, slope))

# Coefficient de détermination R²
r_squared <- summary(modele)$r.squared
cat(sprintf("R² = %.4f (%.1f%% de la variance expliquée)\n", 
            r_squared, r_squared * 100))

# ----------------------------------------------------------------------------
# 7. INTERPRÉTATION
# ----------------------------------------------------------------------------

cat("\n\n=== INTERPRÉTATION ===\n")
cat("Le nuage de points montre :\n")
cat("- Chaque point représente un client\n")
cat("- Position horizontale : temps passé sur le site\n")
cat("- Position verticale : montant de l'achat\n")
cat("- Couleur des points : origine du client (Mars, Pluton, Terre)\n")
cat("- La droite noire : tendance générale (régression linéaire)\n")
cat(sprintf("- La pente (%.2f) indique :\n", slope))
if (slope > 0) {
  cat(sprintf("  → Chaque minute supplémentaire augmente le montant de %.2f euros en moyenne\n", slope))
} else {
  cat(sprintf("  → Chaque minute supplémentaire diminue le montant de %.2f euros en moyenne\n", abs(slope)))
}

# ----------------------------------------------------------------------------
# FIN DU SCRIPT
# ----------------------------------------------------------------------------

cat("\n\n=== ANALYSE TERMINÉE ===\n")
