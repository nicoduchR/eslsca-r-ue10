# ============================================================================
# ANALYSE DE LA VARIABLE QUALITATIVE "MARQUE"
# ============================================================================
# Ce script analyse la distribution de la variable "Marque" du fichier
# chaussures.csv et génère un diagramme en bâtons et un diagramme en secteurs
# ============================================================================

# ----------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNÉES
# ----------------------------------------------------------------------------

# Lire le fichier CSV
donnees <- read.csv("chaussures.csv", header = TRUE, stringsAsFactors = FALSE)

# Afficher un aperçu des données
cat("\n=== APERÇU DES DONNÉES ===\n")
print(head(donnees))

cat("\n=== STRUCTURE DES DONNÉES ===\n")
str(donnees)

# ----------------------------------------------------------------------------
# 2. STATISTIQUES DESCRIPTIVES - TRI À PLAT
# ----------------------------------------------------------------------------

cat("\n\n=== ANALYSE DE LA VARIABLE MARQUE ===\n\n")

# Calculer la table de fréquences absolues
table_marque <- table(donnees$Marque)

# Calculer les proportions (fréquences relatives)
proportions <- prop.table(table_marque)

# Calculer les pourcentages
pourcentages <- proportions * 100

# Afficher le tri à plat
cat("--- TRI À PLAT ---\n")
cat("Effectifs par marque :\n")
print(table_marque)

cat("\n\nProportions :\n")
print(round(proportions, 3))

cat("\n\nPourcentages :\n")
print(round(pourcentages, 2))

# Créer un tableau récapitulatif
recap <- data.frame(
  Marque = names(table_marque),
  Effectif = as.vector(table_marque),
  Proportion = round(as.vector(proportions), 3),
  Pourcentage = paste0(round(as.vector(pourcentages), 2), "%")
)

cat("\n\n--- TABLEAU RÉCAPITULATIF ---\n")
print(recap, row.names = FALSE)

# Calculer le mode (modalité la plus fréquente)
mode_marque <- names(which.max(table_marque))
effectif_mode <- max(table_marque)

cat("\n\n--- MODE ---\n")
cat("La modalité la plus fréquente est :", mode_marque, "\n")
cat("Effectif du mode :", effectif_mode, "\n")

# ----------------------------------------------------------------------------
# 3. DIAGRAMME EN BÂTONS
# ----------------------------------------------------------------------------

cat("\n\n=== GÉNÉRATION DU DIAGRAMME EN BÂTONS ===\n")

# Définir les couleurs pour chaque marque
couleurs <- c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A")

# Créer le diagramme en bâtons
barplot(table_marque,
        main = "Distribution des Marques de Chaussures",
        xlab = "Marque",
        ylab = "Effectif",
        col = couleurs,
        border = "black",
        las = 1,
        ylim = c(0, max(table_marque) * 1.2))

# Ajouter les effectifs au-dessus des barres
text(x = barplot(table_marque, plot = FALSE),
     y = table_marque + max(table_marque) * 0.05,
     labels = table_marque,
     pos = 3,
     cex = 1.2,
     font = 2)

# Ajouter une grille horizontale pour faciliter la lecture
grid(nx = NA, ny = NULL, col = "gray", lty = "dotted")

cat("Diagramme en bâtons généré avec succès !\n")

# ----------------------------------------------------------------------------
# 4. DIAGRAMME EN SECTEURS
# ----------------------------------------------------------------------------

cat("\n=== GÉNÉRATION DU DIAGRAMME EN SECTEURS ===\n")

# Créer une nouvelle fenêtre graphique pour le diagramme en secteurs
dev.new()

# Préparer les labels avec pourcentages
labels_pie <- paste0(names(table_marque), "\n",
                     table_marque, " (", 
                     round(pourcentages, 1), "%)")

# Créer le diagramme en secteurs
pie(table_marque,
    labels = labels_pie,
    main = "Répartition des Marques de Chaussures",
    col = couleurs,
    border = "white",
    cex = 1.1)

# Ajouter une légende
legend("topright",
       legend = names(table_marque),
       fill = couleurs,
       border = "black",
       cex = 0.9,
       title = "Marques")

cat("Diagramme en secteurs généré avec succès !\n")

# ----------------------------------------------------------------------------
# 5. ENREGISTREMENT DES GRAPHIQUES (OPTIONNEL)
# ----------------------------------------------------------------------------

# Si vous souhaitez enregistrer les graphiques en tant qu'images, 
# décommentez les lignes suivantes :

# # Enregistrer le diagramme en bâtons
# png("diagramme_batons_marque.png", width = 800, height = 600)
# barplot(table_marque,
#         main = "Distribution des Marques de Chaussures",
#         xlab = "Marque",
#         ylab = "Effectif",
#         col = couleurs,
#         border = "black",
#         las = 1,
#         ylim = c(0, max(table_marque) * 1.2))
# text(x = barplot(table_marque, plot = FALSE),
#      y = table_marque + max(table_marque) * 0.05,
#      labels = table_marque,
#      pos = 3,
#      cex = 1.2,
#      font = 2)
# grid(nx = NA, ny = NULL, col = "gray", lty = "dotted")
# dev.off()
# 
# # Enregistrer le diagramme en secteurs
# png("diagramme_secteurs_marque.png", width = 800, height = 600)
# labels_pie <- paste0(names(table_marque), "\n",
#                      table_marque, " (", 
#                      round(pourcentages, 1), "%)")
# pie(table_marque,
#     labels = labels_pie,
#     main = "Répartition des Marques de Chaussures",
#     col = couleurs,
#     border = "white",
#     cex = 1.1)
# legend("topright",
#        legend = names(table_marque),
#        fill = couleurs,
#        border = "black",
#        cex = 0.9,
#        title = "Marques")
# dev.off()
# 
# cat("\nGraphiques enregistrés avec succès !\n")

# ----------------------------------------------------------------------------
# FIN DU SCRIPT
# ----------------------------------------------------------------------------

cat("\n\n=== ANALYSE TERMINÉE ===\n")
cat("Vous pouvez maintenant consulter les graphiques dans le panneau Plots.\n")
