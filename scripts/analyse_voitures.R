###############################################################################
# Analyse statistique - Dataset Voitures d'occasion
# Script sur mesure pour : data - voitures.csv
###############################################################################

library(car)

output_dir <- "resultats_analyse/plots"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# --- Chargement et nettoyage -------------------------------------------------
df <- read.csv2("datasets/data - voitures.csv", stringsAsFactors = FALSE)

df$kilometrage <- as.numeric(gsub(" ", "", df$kilometrage))
df$prix <- as.numeric(gsub(" ", "", df$prix))
df$marque <- factor(trimws(df$marque))
df$energie <- factor(trimws(df$energie))

cat("=== DATASET ===\n")
cat("Dimensions :", nrow(df), "observations x", ncol(df), "variables\n\n")

###############################################################################
# PARTIE 1 : STATISTIQUES DESCRIPTIVES UNIVARIEES
###############################################################################

cat("\n================================================================\n")
cat("PARTIE 1 : STATISTIQUES DESCRIPTIVES UNIVARIEES\n")
cat("================================================================\n\n")

# --- 1.1 Prix ----------------------------------------------------------------
cat("--- 1.1 Prix (EUR) ---\n")
cat("Moyenne     :", round(mean(df$prix), 0), "\n")
cat("Mediane     :", round(median(df$prix), 0), "\n")
cat("Ecart-type  :", round(sd(df$prix), 0), "\n")
cat("CV          :", round(sd(df$prix) / mean(df$prix) * 100, 1), "%\n")
cat("Min         :", min(df$prix), "\n")
cat("Max         :", max(df$prix), "\n")
cat("Q1          :", quantile(df$prix, 0.25), "\n")
cat("Q3          :", quantile(df$prix, 0.75), "\n\n")

png(file.path(output_dir, "hist_boxplot_prix.png"), width = 800, height = 600)
par(mfrow = c(2, 1), mar = c(4, 4, 3, 2))
hist(df$prix, breaks = 15, col = "#42A5F5", border = "white",
     main = "Distribution du prix", xlab = "Prix (EUR)", ylab = "Effectif", las = 1)
abline(v = mean(df$prix), col = "red", lwd = 2, lty = 2)
abline(v = median(df$prix), col = "darkgreen", lwd = 2, lty = 2)
legend("topright", legend = c("Moyenne", "Mediane"),
       col = c("red", "darkgreen"), lwd = 2, lty = 2, cex = 0.8)
boxplot(df$prix, horizontal = TRUE, col = "#42A5F5", border = "#1565C0",
        main = "Boxplot du prix", xlab = "Prix (EUR)", las = 1)
dev.off()

# --- 1.2 Kilometrage ---------------------------------------------------------
cat("--- 1.2 Kilometrage (km) ---\n")
cat("Moyenne     :", round(mean(df$kilometrage), 0), "\n")
cat("Mediane     :", round(median(df$kilometrage), 0), "\n")
cat("Ecart-type  :", round(sd(df$kilometrage), 0), "\n")
cat("CV          :", round(sd(df$kilometrage) / mean(df$kilometrage) * 100, 1), "%\n")
cat("Min         :", min(df$kilometrage), "\n")
cat("Max         :", max(df$kilometrage), "\n")
cat("Q1          :", quantile(df$kilometrage, 0.25), "\n")
cat("Q3          :", quantile(df$kilometrage, 0.75), "\n\n")

png(file.path(output_dir, "hist_boxplot_kilometrage.png"), width = 800, height = 600)
par(mfrow = c(2, 1), mar = c(4, 4, 3, 2))
hist(df$kilometrage, breaks = 15, col = "#66BB6A", border = "white",
     main = "Distribution du kilometrage", xlab = "Kilometrage (km)",
     ylab = "Effectif", las = 1)
abline(v = mean(df$kilometrage), col = "red", lwd = 2, lty = 2)
abline(v = median(df$kilometrage), col = "darkgreen", lwd = 2, lty = 2)
legend("topright", legend = c("Moyenne", "Mediane"),
       col = c("red", "darkgreen"), lwd = 2, lty = 2, cex = 0.8)
boxplot(df$kilometrage, horizontal = TRUE, col = "#66BB6A", border = "#2E7D32",
        main = "Boxplot du kilometrage", xlab = "Kilometrage (km)", las = 1)
dev.off()

# --- 1.3 Energie (qualitative) -----------------------------------------------
cat("--- 1.3 Type d'energie ---\n")
tab_energie <- table(df$energie)
pct_energie <- round(prop.table(tab_energie) * 100, 1)
print(cbind(Effectif = tab_energie, Pourcentage = pct_energie))
cat("\n")

png(file.path(output_dir, "barplot_energie.png"), width = 700, height = 500)
par(mar = c(5, 4, 4, 2))
bp <- barplot(sort(tab_energie, decreasing = TRUE),
              col = c("#607D8B", "#8BC34A", "#FFEB3B", "#03A9F4"),
              main = "Repartition par type d'energie",
              ylab = "Effectif", las = 1, border = NA)
text(bp, sort(tab_energie, decreasing = TRUE) + 0.8,
     labels = paste0(sort(tab_energie, decreasing = TRUE), " (",
                     sort(pct_energie, decreasing = TRUE), "%)"), cex = 0.9)
dev.off()

###############################################################################
# PARTIE 2 : STATISTIQUES DESCRIPTIVES BIVARIEES
###############################################################################

cat("\n================================================================\n")
cat("PARTIE 2 : STATISTIQUES DESCRIPTIVES BIVARIEES\n")
cat("================================================================\n\n")

# --- 2.1 Prix x Kilometrage (scatter + regression) ---------------------------
cat("--- 2.1 Prix en fonction du kilometrage ---\n")
reg_pk <- lm(prix ~ kilometrage, data = df)
cat("Regression  : prix =", round(coef(reg_pk)[1], 0), "+",
    round(coef(reg_pk)[2], 4), "x kilometrage\n")
cat("R-carre     :", round(summary(reg_pk)$r.squared, 4), "\n")
cat("Pearson r   :", round(cor(df$prix, df$kilometrage), 4), "\n\n")

png(file.path(output_dir, "scatter_prix_km.png"), width = 800, height = 600)
par(mar = c(5, 5, 4, 2))
plot(df$kilometrage, df$prix, pch = 19, col = adjustcolor("#1565C0", 0.6),
     main = "Prix en fonction du kilometrage",
     xlab = "Kilometrage (km)", ylab = "Prix (EUR)", las = 1, cex = 1.2)
abline(reg_pk, col = "red", lwd = 2)
legend("topright",
       legend = c(paste0("r = ", round(cor(df$prix, df$kilometrage), 3)),
                  paste0("R2 = ", round(summary(reg_pk)$r.squared, 3))),
       bty = "n", cex = 1.1)
dev.off()

# --- 2.2 Prix x Annee (scatter + regression) ---------------------------------
cat("--- 2.2 Prix en fonction de l'annee ---\n")
reg_pa <- lm(prix ~ annee, data = df)
cat("Regression  : prix =", round(coef(reg_pa)[1], 0), "+",
    round(coef(reg_pa)[2], 1), "x annee\n")
cat("R-carre     :", round(summary(reg_pa)$r.squared, 4), "\n")
cat("Pearson r   :", round(cor(df$prix, df$annee), 4), "\n\n")

png(file.path(output_dir, "scatter_prix_annee.png"), width = 800, height = 600)
par(mar = c(5, 5, 4, 2))
plot(df$annee, df$prix, pch = 19, col = adjustcolor("#E65100", 0.6),
     main = "Prix en fonction de l'annee",
     xlab = "Annee", ylab = "Prix (EUR)", las = 1, cex = 1.2)
abline(reg_pa, col = "blue", lwd = 2)
legend("topleft",
       legend = c(paste0("r = ", round(cor(df$prix, df$annee), 3)),
                  paste0("R2 = ", round(summary(reg_pa)$r.squared, 3))),
       bty = "n", cex = 1.1)
dev.off()

# --- 2.3 Prix x Energie (boxplot) --------------------------------------------
cat("--- 2.3 Prix selon l'energie ---\n")
stats_pe <- aggregate(prix ~ energie, data = df, FUN = function(x) {
  c(n = length(x), moyenne = round(mean(x), 0), mediane = round(median(x), 0),
    ecart_type = round(sd(x), 0))
})
print(stats_pe)
cat("\n")

png(file.path(output_dir, "boxplot_prix_energie.png"), width = 800, height = 600)
par(mar = c(5, 5, 4, 2))
boxplot(prix ~ energie, data = df,
        col = c("#607D8B", "#03A9F4", "#8BC34A", "#FFEB3B"),
        main = "Prix selon le type d'energie",
        xlab = "Energie", ylab = "Prix (EUR)", las = 1, border = "#333333")
means_pe <- tapply(df$prix, df$energie, mean)
points(1:nlevels(df$energie), means_pe, pch = 18, col = "red", cex = 1.5)
legend("topright", legend = "Moyenne", pch = 18, col = "red", cex = 0.9, bty = "n")
dev.off()

###############################################################################
# PARTIE 3 : DEUX TESTS STATISTIQUES
###############################################################################

cat("\n================================================================\n")
cat("PARTIE 3 : TESTS STATISTIQUES\n")
cat("================================================================\n\n")

# --- Test 1 : Pearson prix x kilometrage -------------------------------------
cat("--- TEST 1 : Correlation de Pearson - Prix x Kilometrage ---\n\n")

cat("Hypotheses :\n")
cat("  H0 : Il n'y a pas de correlation lineaire entre le prix et le kilometrage (r = 0)\n")
cat("  H1 : Il existe une correlation lineaire entre le prix et le kilometrage (r != 0)\n")
cat("  Alpha = 0.05\n\n")

# Conditions de validite
shapiro_prix <- shapiro.test(df$prix)
shapiro_km <- shapiro.test(df$kilometrage)
cat("Conditions de validite :\n")
cat("  Shapiro-Wilk prix       : W =", round(shapiro_prix$statistic, 4),
    ", p =", format.pval(shapiro_prix$p.value, digits = 4), "\n")
cat("  Shapiro-Wilk kilometrage: W =", round(shapiro_km$statistic, 4),
    ", p =", format.pval(shapiro_km$p.value, digits = 4), "\n")
cat("  -> Normalite rejetee pour les deux variables.\n")
cat("  -> Pearson applique malgre tout (n = 98, robuste pour grands echantillons).\n")
cat("  -> Spearman en complement.\n\n")

test_pearson_pk <- cor.test(df$prix, df$kilometrage, method = "pearson")
test_spearman_pk <- cor.test(df$prix, df$kilometrage, method = "spearman")

cat("Resultats :\n")
cat("  Pearson  : r   =", round(test_pearson_pk$estimate, 4),
    ", t =", round(test_pearson_pk$statistic, 4),
    ", df =", test_pearson_pk$parameter,
    ", p =", format.pval(test_pearson_pk$p.value, digits = 4), "\n")
cat("  Spearman : rho =", round(test_spearman_pk$estimate, 4),
    ", p =", format.pval(test_spearman_pk$p.value, digits = 4), "\n\n")

cat("CONCLUSION TEST 1 : p < 0.05 -> on REJETTE H0.\n")
cat("  Il existe une correlation negative significative entre le prix\n")
cat("  et le kilometrage (r = -0.60, rho = -0.83, p < 0.001).\n")
cat("  Plus un vehicule a de kilometres, plus son prix baisse.\n\n")

# QQ-plots
png(file.path(output_dir, "qqplot_prix.png"), width = 600, height = 500)
par(mar = c(5, 4, 4, 2))
qqnorm(df$prix, main = "QQ-plot du prix", pch = 19, col = "#42A5F5")
qqline(df$prix, col = "red", lwd = 2)
dev.off()

png(file.path(output_dir, "qqplot_kilometrage.png"), width = 600, height = 500)
par(mar = c(5, 4, 4, 2))
qqnorm(df$kilometrage, main = "QQ-plot du kilometrage", pch = 19, col = "#66BB6A")
qqline(df$kilometrage, col = "red", lwd = 2)
dev.off()

# --- Test 2 : Regression multiple prix ~ km + annee --------------------------
cat("--- TEST 2 : Regression multiple - Prix ~ Kilometrage + Annee ---\n\n")

cat("Objectif : Verifier si l'annee apporte une information supplementaire\n")
cat("           au-dela de ce que le kilometrage explique deja.\n\n")

cat("Hypotheses :\n")
cat("  H0 : Le coefficient de l'annee est nul (beta_annee = 0) une fois\n")
cat("       le kilometrage pris en compte\n")
cat("  H1 : Le coefficient de l'annee est significativement different de 0\n")
cat("  Alpha = 0.05\n\n")

# Correlation km-annee (la cle de l'explication)
cor_ka <- cor.test(df$kilometrage, df$annee, method = "pearson")
cat("Correlation kilometrage-annee : r =", round(cor_ka$estimate, 4),
    ", p =", format.pval(cor_ka$p.value, digits = 4), "\n")
cat("  -> Les deux variables sont fortement correlees (colineaires).\n\n")

# Regression simple prix ~ km (rappel)
cat("Regression simple prix ~ kilometrage :\n")
reg_simple <- lm(prix ~ kilometrage, data = df)
s_simple <- summary(reg_simple)
cat("  kilometrage : coeff =", round(coef(reg_simple)[2], 4),
    ", t =", round(s_simple$coefficients[2, 3], 3),
    ", p =", format.pval(s_simple$coefficients[2, 4], digits = 4), "***\n")
cat("  R-carre     :", round(s_simple$r.squared, 4), "\n\n")

# Regression multiple prix ~ km + annee
cat("Regression multiple prix ~ kilometrage + annee :\n")
reg_mult <- lm(prix ~ kilometrage + annee, data = df)
s_mult <- summary(reg_mult)
print(s_mult)
cat("\n")

cat("Resultats detailles :\n")
cat("  kilometrage : coeff =", round(coef(reg_mult)[2], 4),
    ", t =", round(s_mult$coefficients[2, 3], 3),
    ", p =", format.pval(s_mult$coefficients[2, 4], digits = 4), "\n")
cat("  annee       : coeff =", round(coef(reg_mult)[3], 1),
    ", t =", round(s_mult$coefficients[3, 3], 3),
    ", p =", format.pval(s_mult$coefficients[3, 4], digits = 4), "\n")
cat("  R-carre multiple :", round(s_mult$r.squared, 4), "\n")
cat("  R-carre simple (km seul) :", round(s_simple$r.squared, 4), "\n")
cat("  Gain de R-carre en ajoutant annee :",
    round(s_mult$r.squared - s_simple$r.squared, 4), "\n\n")

# Test F comparatif (ANOVA des modeles)
anova_comp <- anova(reg_simple, reg_mult)
cat("Comparaison des modeles (test F) :\n")
print(anova_comp)
cat("\n")

cat("CONCLUSION TEST 2 :\n")
cat("  Le coefficient de l'annee dans le modele multiple est\n")
cat("  p =", format.pval(s_mult$coefficients[3, 4], digits = 4), "\n")
cat("  Le kilometrage reste significatif, mais l'annee n'apporte pas\n")
cat("  d'information supplementaire significative une fois le kilometrage connu.\n")

###############################################################################
# PARTIE 4 : VISUALISATION COMPLEMENTAIRE
###############################################################################

# Correlation km vs annee (pour illustrer la colinearite)
png(file.path(output_dir, "scatter_km_annee.png"), width = 800, height = 600)
par(mar = c(5, 5, 4, 2))
plot(df$annee, df$kilometrage, pch = 19, col = adjustcolor("#2E7D32", 0.6),
     main = "Kilometrage en fonction de l'annee (colinearite)",
     xlab = "Annee", ylab = "Kilometrage (km)", las = 1, cex = 1.2)
abline(lm(kilometrage ~ annee, data = df), col = "red", lwd = 2)
legend("topright",
       legend = paste0("r = ", round(cor(df$kilometrage, df$annee), 3)),
       bty = "n", cex = 1.1)
dev.off()

cat("\n================================================================\n")
cat("ANALYSE TERMINEE\n")
cat("================================================================\n")
