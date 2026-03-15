# ============================================================================
# TEST DE CORRELATION DE PEARSON
# Variables : Age x Part variable manageriale
# ============================================================================

# --- Packages ---
if (!require("readxl", quietly = TRUE)) install.packages("readxl", quiet = TRUE)
library(readxl)

# --- Chargement des donnees ---
setwd("/Users/dcsolutions/Documents/Dev/eslsca-r-ue10")
fichier <- "datasets/examen_UE10.xlsx"
donnees <- read_excel(fichier)

# --- Afficher les noms de colonnes pour verification ---
cat("=== COLONNES DISPONIBLES ===\n")
cat(paste(names(donnees), collapse = "\n"), "\n\n")

# ============================================================================
# ADAPTER CES DEUX NOMS SI NECESSAIRE
# ============================================================================
var1_nom <- "Age"
var2_nom <- "Part variable manageriale"

# Recherche flexible des colonnes (insensible a la casse / accents)
trouver_colonne <- function(donnees, motif) {
  idx <- grep(motif, names(donnees), ignore.case = TRUE)
  if (length(idx) == 0) stop(paste("Colonne introuvable pour le motif :", motif,
                                    "\nColonnes disponibles :", paste(names(donnees), collapse = ", ")))
  names(donnees)[idx[1]]
}

col1 <- "Age"
col2 <- "Part variable managériale"

cat("Variable 1 retenue :", col1, "\n")
cat("Variable 2 retenue :", col2, "\n\n")

x <- as.numeric(donnees[[col1]])
y <- as.numeric(donnees[[col2]])

# Retirer les NA
complet <- complete.cases(x, y)
x <- x[complet]
y <- y[complet]
n <- length(x)

cat("Nombre d'observations completes :", n, "\n\n")

# ============================================================================
# 1. STATISTIQUES DESCRIPTIVES
# ============================================================================
cat("============================================================================\n")
cat("              1. STATISTIQUES DESCRIPTIVES\n")
cat("============================================================================\n\n")

desc <- function(v, nom) {
  cat(sprintf("--- %s ---\n", nom))
  cat(sprintf("  N        = %d\n", length(v)))
  cat(sprintf("  Moyenne  = %.2f\n", mean(v)))
  cat(sprintf("  Ecart-type = %.2f\n", sd(v)))
  cat(sprintf("  Min      = %.2f\n", min(v)))
  cat(sprintf("  Q1       = %.2f\n", quantile(v, 0.25)))
  cat(sprintf("  Mediane  = %.2f\n", median(v)))
  cat(sprintf("  Q3       = %.2f\n", quantile(v, 0.75)))
  cat(sprintf("  Max      = %.2f\n\n", max(v)))
}

desc(x, col1)
desc(y, col2)

# ============================================================================
# 2. VERIFICATION DES CONDITIONS D'APPLICATION
# ============================================================================
cat("============================================================================\n")
cat("              2. CONDITIONS D'APPLICATION\n")
cat("============================================================================\n\n")

# 2a. Normalite (Shapiro-Wilk) -- echantillon <= 5000
if (n <= 5000) {
  sw_x <- shapiro.test(x)
  sw_y <- shapiro.test(y)
  cat(sprintf("Shapiro-Wilk %s : W = %.4f, p = %.4f  %s\n",
              col1, sw_x$statistic, sw_x$p.value,
              ifelse(sw_x$p.value > 0.05, "(Normal)", "(Non normal)")))
  cat(sprintf("Shapiro-Wilk %s : W = %.4f, p = %.4f  %s\n\n",
              col2, sw_y$statistic, sw_y$p.value,
              ifelse(sw_y$p.value > 0.05, "(Normal)", "(Non normal)")))
} else {
  cat("Echantillon > 5000 : Shapiro-Wilk non applicable, on suppose la normalite asymptotique.\n\n")
  sw_x <- list(p.value = NA)
  sw_y <- list(p.value = NA)
}

# 2b. Linearite (visuelle via nuage de points)
cat(">> La linearite est evaluee graphiquement (voir nuage de points genere).\n\n")

# ============================================================================
# 3. TEST DE CORRELATION DE PEARSON
# ============================================================================
cat("============================================================================\n")
cat("              3. TEST DE CORRELATION DE PEARSON\n")
cat("============================================================================\n\n")

test_pearson <- cor.test(x, y, method = "pearson")

r <- test_pearson$estimate
r2 <- r^2
t_stat <- test_pearson$statistic
p_val <- test_pearson$p.value
ic <- test_pearson$conf.int

cat(sprintf("Coefficient de Pearson (r) : %.4f\n", r))
cat(sprintf("Coefficient de determination (r2) : %.4f\n", r2))
cat(sprintf("Statistique t              : %.4f\n", t_stat))
cat(sprintf("Degres de liberte          : %d\n", n - 2))
cat(sprintf("p-value                    : %.6f\n", p_val))
cat(sprintf("IC 95%%                     : [%.4f ; %.4f]\n\n", ic[1], ic[2]))

# Interpretation de la force
force <- ifelse(abs(r) < 0.10, "negligeable",
         ifelse(abs(r) < 0.30, "faible",
         ifelse(abs(r) < 0.50, "moderee",
         ifelse(abs(r) < 0.70, "forte", "tres forte"))))

sens <- ifelse(r > 0, "positive", "negative")
significatif <- ifelse(p_val < 0.05, "significative", "non significative")

cat(sprintf("Interpretation : correlation %s et %s (force %s)\n", sens, significatif, force))
cat(sprintf("=> %.1f%% de la variance de %s est expliquee par %s.\n\n", r2 * 100, col2, col1))

# ============================================================================
# 4. COMPLEMENT : CORRELATION DE SPEARMAN (si normalite non respectee)
# ============================================================================
normalite_ok <- TRUE
if (!is.na(sw_x$p.value) && sw_x$p.value <= 0.05) normalite_ok <- FALSE
if (!is.na(sw_y$p.value) && sw_y$p.value <= 0.05) normalite_ok <- FALSE

if (!normalite_ok) {
  cat("============================================================================\n")
  cat("              4. COMPLEMENT : CORRELATION DE SPEARMAN\n")
  cat("              (normalite non respectee pour au moins une variable)\n")
  cat("============================================================================\n\n")

  test_spearman <- cor.test(x, y, method = "spearman", exact = FALSE)
  cat(sprintf("Rho de Spearman : %.4f\n", test_spearman$estimate))
  cat(sprintf("p-value         : %.6f\n", test_spearman$p.value))
  cat(sprintf("Significatif    : %s\n\n",
              ifelse(test_spearman$p.value < 0.05, "Oui", "Non")))
}

# ============================================================================
# 5. GRAPHIQUES
# ============================================================================
dir.create("resultats/03_graphiques", recursive = TRUE, showWarnings = FALSE)

# 5a. Nuage de points + droite de regression
png("resultats/03_graphiques/correlation_age_partvar.png", width = 800, height = 600, res = 120)
plot(x, y,
     main = paste("Correlation entre", col1, "et\n", col2),
     xlab = col1, ylab = col2,
     pch = 19, col = rgb(0.2, 0.4, 0.8, 0.6))
abline(lm(y ~ x), col = "red", lwd = 2)
legend("topright",
       legend = sprintf("r = %.3f (p = %.4f)", r, p_val),
       bty = "n", cex = 0.9)
dev.off()

# 5b. QQ-plots pour verifier la normalite
png("resultats/03_graphiques/qqplot_age.png", width = 600, height = 500, res = 120)
qqnorm(x, main = paste("QQ-Plot :", col1), pch = 19, col = "steelblue")
qqline(x, col = "red", lwd = 2)
dev.off()

png("resultats/03_graphiques/qqplot_partvar.png", width = 600, height = 500, res = 120)
qqnorm(y, main = paste("QQ-Plot :", col2), pch = 19, col = "steelblue")
qqline(y, col = "red", lwd = 2)
dev.off()

cat("Graphiques sauvegardes dans resultats/03_graphiques/\n")
cat("  - correlation_age_partvar.png\n")
cat("  - qqplot_age.png\n")
cat("  - qqplot_partvar.png\n\n")

cat("============================================================================\n")
cat("                         ANALYSE TERMINEE\n")
cat("============================================================================\n")
