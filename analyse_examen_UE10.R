# ============================================================================
# ANALYSE STATISTIQUE COMPLETE - EXAMEN UE10
# ============================================================================
# Ce script analyse le fichier examen_UE10.xlsx en suivant la methodologie
# du guide d'analyse statistique
# ============================================================================

# ----------------------------------------------------------------------------
# 0. INSTALLATION ET CHARGEMENT DES PACKAGES
# ----------------------------------------------------------------------------

# Installer les packages si necessaire
packages_requis <- c("readxl", "moments", "effsize", "writexl")

for (pkg in packages_requis) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, quiet = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Determiner le repertoire du projet (emplacement du script ou racine du projet)
projet_dir <- tryCatch({
  # Fonctionne dans RStudio quand on source le script
  dirname(rstudioapi::getSourceEditorContext()$path)
}, error = function(e) {
  tryCatch({
    # Fonctionne avec Rscript en ligne de commande
    dirname(normalizePath(sub("--file=", "", commandArgs(trailingOnly = FALSE)[grep("--file=", commandArgs(trailingOnly = FALSE))])))
  }, error = function(e2) {
    # Fallback : chemin absolu du projet
    "/Users/nicoduch/Documents/Dev/eslsca-r-ue10"
  })
})

# Creation du dossier resultats et sous-dossiers
chemin_resultats <- file.path(projet_dir, "resultats")
dir.create(file.path(chemin_resultats, "01_descriptif", "stats_qualitatives"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(chemin_resultats, "02_tests"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(chemin_resultats, "03_graphiques"), recursive = TRUE, showWarnings = FALSE)
cat("Dossier resultats :", chemin_resultats, "\n")

# ----------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNEES
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                    ANALYSE STATISTIQUE - EXAMEN UE10                       \n")
cat("============================================================================\n")

# Definir le repertoire de travail (decommenter si necessaire)
# setwd("/Users/nicoduch/Documents/Dev/eslsca-r-ue10")

# Charger le fichier Excel
# Option 1: chemin relatif (si working directory = racine du projet)
fichier <- "datasets/examen_UE10.xlsx"

# Option 2: chemin absolu (si le chemin relatif ne fonctionne pas)
if (!file.exists(fichier)) {
  fichier <- "/Users/nicoduch/Documents/Dev/eslsca-r-ue10/datasets/examen_UE10.xlsx"
}

cat("Repertoire de travail actuel :", getwd(), "\n")
cat("Fichier a charger :", fichier, "\n")

donnees <- read_excel(fichier)

cat("\n=== APERCU DES DONNEES ===\n")
print(head(donnees, 10))

cat("\n=== STRUCTURE DES DONNEES ===\n")
str(donnees)

cat("\n=== DIMENSIONS ===\n")
cat("Nombre d'observations :", nrow(donnees), "\n")
cat("Nombre de variables   :", ncol(donnees), "\n")

# ----------------------------------------------------------------------------
# 2. IDENTIFICATION DES TYPES DE VARIABLES
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("              ETAPE 1 : IDENTIFICATION DES TYPES DE VARIABLES              \n")
cat("============================================================================\n")

# Fonction pour classifier automatiquement les variables
classifier_variable <- function(x, nom_var) {
  # Supprimer les NA pour l'analyse
  x_clean <- x[!is.na(x)]
  n_unique <- length(unique(x_clean))
  n_obs <- length(x_clean)

  if (is.character(x_clean) || is.factor(x_clean)) {
    if (n_unique == 2) {
      return(list(type = "Qualitative binaire", nature = "quali"))
    } else {
      return(list(type = "Qualitative nominale", nature = "quali"))
    }
  } else if (is.numeric(x_clean)) {
    if (n_unique == 2) {
      return(list(type = "Qualitative binaire (codee)", nature = "quali"))
    } else if (n_unique <= 7 && n_unique < n_obs / 5) {
      return(list(type = "Qualitative ordinale (probable)", nature = "quali"))
    } else {
      return(list(type = "Quantitative continue", nature = "quanti"))
    }
  } else {
    return(list(type = "Type inconnu", nature = "inconnu"))
  }
}

# Classifier toutes les variables
classification <- data.frame(
  Variable = names(donnees),
  Type = character(ncol(donnees)),
  Nature = character(ncol(donnees)),
  Valeurs_uniques = integer(ncol(donnees)),
  Valeurs_manquantes = integer(ncol(donnees)),
  stringsAsFactors = FALSE
)

for (i in seq_along(names(donnees))) {
  nom <- names(donnees)[i]
  col <- donnees[[nom]]
  classif <- classifier_variable(col, nom)
  classification$Type[i] <- classif$type
  classification$Nature[i] <- classif$nature
  classification$Valeurs_uniques[i] <- length(unique(col[!is.na(col)]))
  classification$Valeurs_manquantes[i] <- sum(is.na(col))
}

cat("\n=== CLASSIFICATION DES VARIABLES ===\n")
print(classification, row.names = FALSE)
write.csv(classification, file.path(chemin_resultats, "01_descriptif", "classification_variables.csv"), row.names = FALSE)

# Separer les variables par type
vars_quanti <- classification$Variable[classification$Nature == "quanti"]
vars_quali <- classification$Variable[classification$Nature == "quali"]

cat("\nVariables quantitatives :", paste(vars_quanti, collapse = ", "), "\n")
cat("Variables qualitatives  :", paste(vars_quali, collapse = ", "), "\n")

# ----------------------------------------------------------------------------
# 3. STATISTIQUES DESCRIPTIVES
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                 ETAPE 2 : STATISTIQUES DESCRIPTIVES                        \n")
cat("============================================================================\n")

# --- Variables quantitatives ---
if (length(vars_quanti) > 0) {
  cat("\n=== VARIABLES QUANTITATIVES ===\n\n")

  stats_quanti <- data.frame(
    Variable = character(),
    N = integer(),
    Moyenne = numeric(),
    Ecart_type = numeric(),
    Min = numeric(),
    Q1 = numeric(),
    Mediane = numeric(),
    Q3 = numeric(),
    Max = numeric(),
    Skewness = numeric(),
    Kurtosis = numeric(),
    stringsAsFactors = FALSE
  )

  for (var in vars_quanti) {
    x <- donnees[[var]]
    x_clean <- x[!is.na(x)]

    if (length(x_clean) > 3) {
      row <- data.frame(
        Variable = var,
        N = length(x_clean),
        Moyenne = round(mean(x_clean), 2),
        Ecart_type = round(sd(x_clean), 2),
        Min = round(min(x_clean), 2),
        Q1 = round(quantile(x_clean, 0.25), 2),
        Mediane = round(median(x_clean), 2),
        Q3 = round(quantile(x_clean, 0.75), 2),
        Max = round(max(x_clean), 2),
        Skewness = round(moments::skewness(x_clean), 2),
        Kurtosis = round(moments::kurtosis(x_clean) - 3, 2)
      )
      stats_quanti <- rbind(stats_quanti, row)
    }
  }

  print(stats_quanti, row.names = FALSE)
  write.csv(stats_quanti, file.path(chemin_resultats, "01_descriptif", "stats_quantitatives.csv"), row.names = FALSE)
}

# --- Variables qualitatives ---
if (length(vars_quali) > 0) {
  cat("\n=== VARIABLES QUALITATIVES ===\n")

  for (var in vars_quali) {
    cat("\n--- Variable :", var, "---\n")
    x <- donnees[[var]]
    tab <- table(x, useNA = "ifany")
    prop <- prop.table(tab) * 100

    recap <- data.frame(
      Modalite = names(tab),
      Effectif = as.vector(tab),
      Pourcentage = paste0(round(as.vector(prop), 1), "%")
    )
    print(recap, row.names = FALSE)
    write.csv(recap, file.path(chemin_resultats, "01_descriptif", "stats_qualitatives", paste0(var, ".csv")), row.names = FALSE)

    mode_val <- names(which.max(tab))
    cat("Mode :", mode_val, "(", max(tab), "occurrences )\n")
  }
}

# ----------------------------------------------------------------------------
# 4. DETECTION DES VALEURS ABERRANTES
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("               ETAPE 3 : DETECTION DES VALEURS ABERRANTES                  \n")
cat("============================================================================\n")

if (length(vars_quanti) > 0) {
  cat("\n=== METHODE IQR (1.5 x IQR) ===\n\n")

  outliers_summary <- data.frame(
    Variable = character(),
    N_outliers = integer(),
    Bornes_inf = numeric(),
    Bornes_sup = numeric(),
    stringsAsFactors = FALSE
  )

  for (var in vars_quanti) {
    x <- donnees[[var]]
    x_clean <- x[!is.na(x)]

    Q1 <- quantile(x_clean, 0.25)
    Q3 <- quantile(x_clean, 0.75)
    IQR_val <- Q3 - Q1
    borne_inf <- Q1 - 1.5 * IQR_val
    borne_sup <- Q3 + 1.5 * IQR_val

    outliers <- x_clean[x_clean < borne_inf | x_clean > borne_sup]

    row <- data.frame(
      Variable = var,
      N_outliers = length(outliers),
      Bornes_inf = round(borne_inf, 2),
      Bornes_sup = round(borne_sup, 2)
    )
    outliers_summary <- rbind(outliers_summary, row)

    if (length(outliers) > 0 && length(outliers) <= 10) {
      cat("Variable", var, ": Valeurs aberrantes detectees =", outliers, "\n")
    } else if (length(outliers) > 10) {
      cat("Variable", var, ":", length(outliers), "valeurs aberrantes detectees\n")
    }
  }

  cat("\n")
  print(outliers_summary, row.names = FALSE)
  write.csv(outliers_summary, file.path(chemin_resultats, "01_descriptif", "outliers.csv"), row.names = FALSE)
}

# ----------------------------------------------------------------------------
# 5. VERIFICATION DES CONDITIONS DE VALIDITE
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("           ETAPE 4 : VERIFICATION DES CONDITIONS DE VALIDITE               \n")
cat("============================================================================\n")

# --- Tests de normalite ---
if (length(vars_quanti) > 0) {
  cat("\n=== TESTS DE NORMALITE (Shapiro-Wilk) ===\n\n")

  normalite <- data.frame(
    Variable = character(),
    W = numeric(),
    p_value = numeric(),
    Normal = character(),
    stringsAsFactors = FALSE
  )

  for (var in vars_quanti) {
    x <- donnees[[var]]
    x_clean <- x[!is.na(x)]

    if (length(x_clean) >= 3 && length(x_clean) <= 5000) {
      test <- shapiro.test(x_clean)
      row <- data.frame(
        Variable = var,
        W = round(test$statistic, 4),
        p_value = round(test$p.value, 4),
        Normal = ifelse(test$p.value > 0.05, "OUI", "NON")
      )
      normalite <- rbind(normalite, row)
    }
  }

  print(normalite, row.names = FALSE)
  write.csv(normalite, file.path(chemin_resultats, "02_tests", "normalite.csv"), row.names = FALSE)
  cat("\nInterpretation : p > 0.05 = normalite non rejetee (test parametrique possible)\n")
  cat("                 p <= 0.05 = normalite rejetee (test non-parametrique recommande)\n")
}

# ----------------------------------------------------------------------------
# 6. ANALYSES BIVARIEES
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                     ETAPE 5 : ANALYSES BIVARIEES                          \n")
cat("============================================================================\n")

# --- Correlations entre variables quantitatives ---
if (length(vars_quanti) >= 2) {
  cat("\n=== MATRICE DE CORRELATIONS (Pearson) ===\n\n")

  donnees_quanti <- donnees[, vars_quanti, drop = FALSE]
  donnees_quanti <- na.omit(as.data.frame(donnees_quanti))

  if (nrow(donnees_quanti) > 2) {
    cor_matrix <- cor(donnees_quanti, method = "pearson")
    print(round(cor_matrix, 3))
    write.csv(round(cor_matrix, 3), file.path(chemin_resultats, "02_tests", "correlations_pearson.csv"))

    cat("\n=== INTERPRETATION DES CORRELATIONS ===\n")
    cat("0.00 - 0.10 : Negligeable\n")
    cat("0.10 - 0.30 : Faible\n")
    cat("0.30 - 0.50 : Moderee\n")
    cat("0.50 - 0.70 : Forte\n")
    cat("0.70 - 1.00 : Tres forte\n")

    # Correlations de Spearman si normalite non respectee
    cat("\n=== MATRICE DE CORRELATIONS (Spearman - non-parametrique) ===\n\n")
    cor_spearman <- cor(donnees_quanti, method = "spearman")
    print(round(cor_spearman, 3))
    write.csv(round(cor_spearman, 3), file.path(chemin_resultats, "02_tests", "correlations_spearman.csv"))
  }
}

# --- Comparaison de groupes ---
if (length(vars_quali) > 0 && length(vars_quanti) > 0) {
  cat("\n=== COMPARAISONS DE GROUPES ===\n")

  resultats_comparaisons <- data.frame(
    Var_quali = character(), Var_quanti = character(), Test = character(),
    Statistique = numeric(), p_value = numeric(), Taille_effet = numeric(),
    Significatif = character(), stringsAsFactors = FALSE
  )

  for (var_quali in vars_quali) {
    groupes <- unique(donnees[[var_quali]])
    groupes <- groupes[!is.na(groupes)]
    n_groupes <- length(groupes)

    if (n_groupes >= 2 && n_groupes <= 10) {
      cat("\n--- Variable de groupement :", var_quali, "(", n_groupes, "groupes ) ---\n")

      for (var_quanti in vars_quanti) {
        x <- donnees[[var_quanti]]
        g <- donnees[[var_quali]]

        # Nettoyer les donnees
        valid_idx <- !is.na(x) & !is.na(g)
        x <- x[valid_idx]
        g <- g[valid_idx]

        if (length(x) > 5) {
          cat("\nVariable dependante :", var_quanti, "\n")

          if (n_groupes == 2) {
            # Test pour 2 groupes
            g1 <- x[g == groupes[1]]
            g2 <- x[g == groupes[2]]

            # Fonction pour tester la normalite de maniere securisee
            test_normalite_safe <- function(data) {
              if (length(data) < 3) return(FALSE)
              if (length(unique(data)) == 1) return(FALSE)  # Toutes valeurs identiques
              if (sd(data) == 0) return(FALSE)  # Variance nulle
              tryCatch({
                shapiro.test(data)$p.value > 0.05
              }, error = function(e) FALSE)
            }

            # Verifier normalite
            norm_g1 <- test_normalite_safe(g1)
            norm_g2 <- test_normalite_safe(g2)

            if (norm_g1 && norm_g2) {
              # Test de Levene simplifie (ratio des variances)
              var_g1 <- var(g1)
              var_g2 <- var(g2)

              # Proteger contre division par zero
              if (min(var_g1, var_g2) == 0) {
                var_ratio <- Inf
              } else {
                var_ratio <- max(var_g1, var_g2) / min(var_g1, var_g2)
              }

              if (var_ratio < 4) {
                test <- t.test(x ~ g, var.equal = TRUE)
                cat("Test t pour echantillons independants :\n")
              } else {
                test <- t.test(x ~ g, var.equal = FALSE)
                cat("Test t de Welch (variances inegales) :\n")
              }

              cat("  t =", round(test$statistic, 3), "\n")
              cat("  ddl =", round(test$parameter, 1), "\n")
              cat("  p =", format(test$p.value, digits = 4), "\n")

              # Taille d'effet (d de Cohen)
              pooled_var <- (var_g1 + var_g2) / 2
              if (pooled_var > 0) {
                d <- (mean(g1) - mean(g2)) / sqrt(pooled_var)
                cat("  d de Cohen =", round(d, 3), "\n")
              } else {
                d <- NA
                cat("  d de Cohen = NA (variance nulle)\n")
              }

              test_name <- ifelse(var_ratio < 4, "t-test", "Welch t-test")
              resultats_comparaisons <- rbind(resultats_comparaisons, data.frame(
                Var_quali = var_quali, Var_quanti = var_quanti, Test = test_name,
                Statistique = round(test$statistic, 3), p_value = round(test$p.value, 4),
                Taille_effet = round(d, 3), Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
                stringsAsFactors = FALSE
              ))

            } else {
              # Test non-parametrique
              test <- wilcox.test(x ~ g)
              cat("Test de Mann-Whitney (non-parametrique) :\n")
              cat("  W =", round(test$statistic, 1), "\n")
              cat("  p =", format(test$p.value, digits = 4), "\n")

              # Taille d'effet r
              z <- qnorm(test$p.value / 2)
              r <- abs(z) / sqrt(length(x))
              cat("  r =", round(r, 3), "\n")

              resultats_comparaisons <- rbind(resultats_comparaisons, data.frame(
                Var_quali = var_quali, Var_quanti = var_quanti, Test = "Mann-Whitney",
                Statistique = round(test$statistic, 1), p_value = round(test$p.value, 4),
                Taille_effet = round(r, 3), Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
                stringsAsFactors = FALSE
              ))
            }

            # Interpretation
            if (test$p.value < 0.05) {
              cat("  --> Difference significative (p < 0.05)\n")
            } else {
              cat("  --> Pas de difference significative (p >= 0.05)\n")
            }

          } else if (n_groupes > 2) {
            # Test pour 3+ groupes
            # Verifier normalite dans chaque groupe (de maniere securisee)
            all_normal <- TRUE
            for (grp in groupes) {
              grp_data <- x[g == grp]
              if (length(grp_data) >= 3 && length(unique(grp_data)) > 1) {
                tryCatch({
                  if (shapiro.test(grp_data)$p.value <= 0.05) {
                    all_normal <- FALSE
                    break
                  }
                }, error = function(e) {
                  all_normal <<- FALSE
                })
              } else {
                all_normal <- FALSE
              }
            }

            if (all_normal && length(x) > 10) {
              test <- aov(x ~ factor(g))
              test_summary <- summary(test)
              f_val <- test_summary[[1]][1, "F value"]
              p_val <- test_summary[[1]][1, "Pr(>F)"]

              cat("ANOVA a un facteur :\n")
              cat("  F =", round(f_val, 3), "\n")
              cat("  p =", format(p_val, digits = 4), "\n")

              # Eta-squared
              ss_between <- test_summary[[1]][1, "Sum Sq"]
              ss_total <- sum(test_summary[[1]][, "Sum Sq"])
              eta_sq <- ss_between / ss_total
              cat("  Eta-squared =", round(eta_sq, 3), "\n")

              resultats_comparaisons <- rbind(resultats_comparaisons, data.frame(
                Var_quali = var_quali, Var_quanti = var_quanti, Test = "ANOVA",
                Statistique = round(f_val, 3), p_value = round(p_val, 4),
                Taille_effet = round(eta_sq, 3), Significatif = ifelse(p_val < 0.05, "OUI", "NON"),
                stringsAsFactors = FALSE
              ))

              if (p_val < 0.05) {
                cat("  --> Difference significative entre les groupes\n")
                cat("  Test post-hoc de Tukey HSD recommande\n")
                tukey <- TukeyHSD(test)
                cat("  Comparaisons multiples :\n")
                print(round(tukey$`factor(g)`, 3))
              } else {
                cat("  --> Pas de difference significative\n")
              }

            } else {
              test <- kruskal.test(x ~ factor(g))
              cat("Test de Kruskal-Wallis (non-parametrique) :\n")
              cat("  H =", round(test$statistic, 3), "\n")
              cat("  ddl =", test$parameter, "\n")
              cat("  p =", format(test$p.value, digits = 4), "\n")

              resultats_comparaisons <- rbind(resultats_comparaisons, data.frame(
                Var_quali = var_quali, Var_quanti = var_quanti, Test = "Kruskal-Wallis",
                Statistique = round(test$statistic, 3), p_value = round(test$p.value, 4),
                Taille_effet = NA, Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
                stringsAsFactors = FALSE
              ))

              if (test$p.value < 0.05) {
                cat("  --> Difference significative entre les groupes\n")
                cat("  Test post-hoc de Dunn recommande\n")
              } else {
                cat("  --> Pas de difference significative\n")
              }
            }
          }
        }
      }
    }
  }

  write.csv(resultats_comparaisons, file.path(chemin_resultats, "02_tests", "comparaisons_groupes.csv"), row.names = FALSE)
}

# --- Tests du Khi-deux pour variables qualitatives ---
if (length(vars_quali) >= 2) {
  cat("\n=== TESTS D'INDEPENDANCE DU KHI-DEUX ===\n")

  resultats_khi2 <- data.frame(
    Var1 = character(), Var2 = character(), Test = character(),
    Statistique = numeric(), ddl = numeric(), p_value = numeric(),
    V_Cramer = numeric(), Significatif = character(), stringsAsFactors = FALSE
  )

  for (i in 1:(length(vars_quali) - 1)) {
    for (j in (i + 1):length(vars_quali)) {
      var1 <- vars_quali[i]
      var2 <- vars_quali[j]

      tab <- table(donnees[[var1]], donnees[[var2]])

      if (min(dim(tab)) >= 2) {
        cat("\n---", var1, "vs", var2, "---\n")

        # Afficher le tableau de contingence
        cat("Tableau de contingence :\n")
        print(tab)

        # Verifier les effectifs theoriques
        expected <- chisq.test(tab)$expected
        pct_low <- sum(expected < 5) / length(expected) * 100

        if (min(expected) < 1 || pct_low > 20) {
          # Fisher exact pour petits effectifs
          if (nrow(tab) == 2 && ncol(tab) == 2) {
            test <- fisher.test(tab)
            cat("\nTest exact de Fisher (effectifs faibles) :\n")
            cat("  p =", format(test$p.value, digits = 4), "\n")
            resultats_khi2 <- rbind(resultats_khi2, data.frame(
              Var1 = var1, Var2 = var2, Test = "Fisher exact",
              Statistique = NA, ddl = NA, p_value = round(test$p.value, 4),
              V_Cramer = NA, Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
              stringsAsFactors = FALSE
            ))
          } else {
            test <- chisq.test(tab, simulate.p.value = TRUE)
            cat("\nKhi-deux avec simulation Monte Carlo (effectifs faibles) :\n")
            cat("  X2 =", round(test$statistic, 3), "\n")
            cat("  p =", format(test$p.value, digits = 4), "\n")
            resultats_khi2 <- rbind(resultats_khi2, data.frame(
              Var1 = var1, Var2 = var2, Test = "Khi-deux Monte Carlo",
              Statistique = round(test$statistic, 3), ddl = NA, p_value = round(test$p.value, 4),
              V_Cramer = NA, Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
              stringsAsFactors = FALSE
            ))
          }
        } else {
          test <- chisq.test(tab)
          cat("\nTest du Khi-deux :\n")
          cat("  X2 =", round(test$statistic, 3), "\n")
          cat("  ddl =", test$parameter, "\n")
          cat("  p =", format(test$p.value, digits = 4), "\n")

          # V de Cramer
          n <- sum(tab)
          min_dim <- min(nrow(tab), ncol(tab)) - 1
          v_cramer <- sqrt(test$statistic / (n * min_dim))
          cat("  V de Cramer =", round(v_cramer, 3), "\n")

          resultats_khi2 <- rbind(resultats_khi2, data.frame(
            Var1 = var1, Var2 = var2, Test = "Khi-deux",
            Statistique = round(test$statistic, 3), ddl = test$parameter,
            p_value = round(test$p.value, 4), V_Cramer = round(v_cramer, 3),
            Significatif = ifelse(test$p.value < 0.05, "OUI", "NON"),
            stringsAsFactors = FALSE
          ))
        }

        if (test$p.value < 0.05) {
          cat("  --> Association significative\n")
        } else {
          cat("  --> Pas d'association significative\n")
        }
      }
    }
  }

  write.csv(resultats_khi2, file.path(chemin_resultats, "02_tests", "khi_deux.csv"), row.names = FALSE)
}

# ----------------------------------------------------------------------------
# 7. VISUALISATIONS
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                       ETAPE 6 : VISUALISATIONS                            \n")
cat("============================================================================\n")

cat("\nGeneration des graphiques...\n")

chemin_graphiques <- file.path(chemin_resultats, "03_graphiques")

# --- Histogrammes des variables quantitatives ---
if (length(vars_quanti) > 0) {
  png(file.path(chemin_graphiques, "histogrammes.png"), width = 1200, height = 900, res = 150)
  par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
  for (var in vars_quanti[1:min(4, length(vars_quanti))]) {
    x <- donnees[[var]]
    x_clean <- x[!is.na(x)]

    hist(x_clean,
         main = paste("Distribution de", var),
         xlab = var,
         ylab = "Frequence",
         col = "steelblue",
         border = "white",
         las = 1)

    # Ajouter la courbe de densite
    lines(density(x_clean), col = "red", lwd = 2)
  }
  dev.off()
}

# --- Boxplots ---
if (length(vars_quali) > 0 && length(vars_quanti) > 0) {
  cat("\nGeneration des boxplots par groupe...\n")

  for (var_quali in vars_quali[1:min(2, length(vars_quali))]) {
    for (var_quanti in vars_quanti[1:min(2, length(vars_quanti))]) {

      png(file.path(chemin_graphiques, paste0("boxplot_", var_quanti, "_par_", var_quali, ".png")),
          width = 800, height = 600, res = 150)

      couleurs <- rainbow(length(unique(donnees[[var_quali]])))

      boxplot(donnees[[var_quanti]] ~ donnees[[var_quali]],
              main = paste(var_quanti, "par", var_quali),
              xlab = var_quali,
              ylab = var_quanti,
              col = couleurs,
              las = 1)

      # Ajouter les moyennes
      moyennes <- tapply(donnees[[var_quanti]], donnees[[var_quali]], mean, na.rm = TRUE)
      points(1:length(moyennes), moyennes, pch = 18, col = "darkred", cex = 1.5)
      legend("topright", legend = "Moyenne", pch = 18, col = "darkred", bg = "white")

      dev.off()
    }
  }
}

# --- Diagrammes en barres pour variables qualitatives ---
if (length(vars_quali) > 0) {
  cat("\nGeneration des diagrammes en barres...\n")

  png(file.path(chemin_graphiques, "barres_qualitatives.png"), width = 1200, height = 900, res = 150)
  par(mfrow = c(ceiling(length(vars_quali) / 2), 2), mar = c(4, 4, 3, 1))

  for (var in vars_quali) {
    tab <- table(donnees[[var]])

    barplot(tab,
            main = paste("Distribution de", var),
            xlab = var,
            ylab = "Effectif",
            col = rainbow(length(tab)),
            las = 1)
  }

  dev.off()
}

# --- Nuage de points pour correlations ---
if (length(vars_quanti) >= 2) {
  cat("\nGeneration des nuages de points...\n")

  n_vars <- min(4, length(vars_quanti))

  png(file.path(chemin_graphiques, "nuage_points.png"), width = 1200, height = 1200, res = 150)
  pairs(donnees[, vars_quanti[1:n_vars]],
        main = "Matrice des nuages de points",
        pch = 19,
        col = rgb(0.2, 0.4, 0.6, 0.5))
  dev.off()
}

cat("\nGraphiques generes avec succes !\n")

# ----------------------------------------------------------------------------
# 8. RESUME ET CONCLUSIONS
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                      RESUME DE L'ANALYSE                                  \n")
cat("============================================================================\n")

cat("\n=== DONNEES ===\n")
cat("- Fichier analyse :", fichier, "\n")
cat("- Nombre d'observations :", nrow(donnees), "\n")
cat("- Nombre de variables :", ncol(donnees), "\n")
cat("- Variables quantitatives :", length(vars_quanti), "\n")
cat("- Variables qualitatives :", length(vars_quali), "\n")

# Valeurs manquantes
total_na <- sum(is.na(donnees))
pct_na <- round(total_na / (nrow(donnees) * ncol(donnees)) * 100, 2)
cat("- Valeurs manquantes :", total_na, "(", pct_na, "% )\n")

cat("\n=== TESTS DE NORMALITE ===\n")
if (exists("normalite") && nrow(normalite) > 0) {
  vars_normales <- sum(normalite$Normal == "OUI")
  cat("- Variables suivant une loi normale :", vars_normales, "/", nrow(normalite), "\n")
}

cat("\n=== RECOMMANDATIONS ===\n")
cat("1. Verifier les valeurs aberrantes detectees avant interpretation\n")
cat("2. Utiliser les tests non-parametriques si la normalite n'est pas respectee\n")
cat("3. Reporter les tailles d'effet en plus des p-values\n")
cat("4. Attention a l'interpretation des correlations (correlation != causalite)\n")

# ----------------------------------------------------------------------------
# FIN DU SCRIPT
# ----------------------------------------------------------------------------

cat("\n")
cat("============================================================================\n")
cat("                       ANALYSE TERMINEE                                    \n")
cat("============================================================================\n")
cat("\nConsultez les graphiques dans le panneau Plots ou les fenetres ouvertes.\n")
cat("Les resultats ont ete sauvegardes dans le dossier resultats/\n")

# Ecriture du resume textuel
resume <- c(
  "============================================================================",
  "                      RESUME DE L'ANALYSE                                  ",
  "============================================================================",
  "",
  "=== DONNEES ===",
  paste("- Fichier analyse :", fichier),
  paste("- Nombre d'observations :", nrow(donnees)),
  paste("- Nombre de variables :", ncol(donnees)),
  paste("- Variables quantitatives :", length(vars_quanti)),
  paste("- Variables qualitatives :", length(vars_quali)),
  paste("- Valeurs manquantes :", sum(is.na(donnees)), "(", round(sum(is.na(donnees)) / (nrow(donnees) * ncol(donnees)) * 100, 2), "% )")
)

if (exists("normalite") && nrow(normalite) > 0) {
  resume <- c(resume, "",
    "=== TESTS DE NORMALITE ===",
    paste("- Variables suivant une loi normale :", sum(normalite$Normal == "OUI"), "/", nrow(normalite))
  )
}

resume <- c(resume, "",
  "=== RECOMMANDATIONS ===",
  "1. Verifier les valeurs aberrantes detectees avant interpretation",
  "2. Utiliser les tests non-parametriques si la normalite n'est pas respectee",
  "3. Reporter les tailles d'effet en plus des p-values",
  "4. Attention a l'interpretation des correlations (correlation != causalite)"
)

writeLines(resume, file.path(chemin_resultats, "resume.txt"))
