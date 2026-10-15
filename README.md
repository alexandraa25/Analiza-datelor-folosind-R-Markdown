# Analiza satisfacției la locul de muncă folosind R Markdown

Proiect de analiză a datelor realizat în **R și R Markdown**, care explorează relația dintre satisfacția la locul de muncă și caracteristicile profesionale ale respondenților la **Stack Overflow Developer Survey 2024**. Raportul include prelucrarea datelor, vizualizări, modele de clasificare și interpretarea rezultatelor.

## Obiectiv

Analiza urmărește asocierea satisfacției profesionale cu experiența în programare, tipul de activitate, influența asupra achizițiilor de tehnologie, formatul de muncă, resursele disponibile, remunerația, percepția asupra inteligenței artificiale și timpul petrecut căutând soluții. Separat, este explorată relația dintre satisfacție și dimensiunea organizației.

Sunt păstrați respondenții angajați cu normă întreagă, cu normă parțială sau care lucrează independent, fiind excluse răspunsurile care includ statutul de persoană neangajată.

## Conținutul proiectului

| Fișier | Descriere |
| --- | --- |
| `JobSat.Rmd` | Codul R, explicațiile și interpretările analizei. |
| `JobSat.html` | Raportul HTML deja generat, care poate fi deschis în browser. |
| `survey_results.zip` | Arhivă cu datele publice, schema variabilelor și chestionarul în format PDF. |

## Metode utilizate

- Curățarea datelor, tratarea valorilor lipsă și recodificarea variabilelor.
- Analiză descriptivă și reprezentări grafice cu `ggplot2`.
- Regresie logistică pentru estimarea probabilității de satisfacție profesională.
- Împărțirea datelor pentru antrenare și testare, codificarea predictorilor și echilibrarea setului de antrenare prin **SMOTE**.
- Arbore de clasificare și **Random Forest**, evaluate prin matrice de confuzie, curbe ROC și AUC.
- Analiza corespondențelor pentru satisfacția profesională și dimensiunea organizației.

Pentru clasificare, variabila `JobSat` este transformată în ținta binară `Sat`: **0** pentru scoruri de cel mult 6 și **1** pentru scoruri mai mari de 6. În analiza corespondențelor, satisfacția este grupată în cinci categorii.

## Rulare

### 1. Pregătirea mediului

Instalează **R** și, pentru lucrul interactiv, **RStudio**. Generarea raportului necesită și **Pandoc**, disponibil în mod obișnuit împreună cu RStudio. Exportul PDF necesită suplimentar o distribuție LaTeX, de exemplu TinyTeX.

În consola R, din directorul proiectului, configurează dependențele:

```r
source("setup.R")
```

La prima rulare, scriptul inițializează `renv`, instalează pachetele într-o bibliotecă a proiectului și generează `renv.lock`, care înregistrează versiunile pachetelor, inclusiv dependențele tranzitive, și versiunea R. La rulările următoare, dacă fișierul există, restaurează versiunile salvate prin `renv::restore()`.

După prima rulare reușită, adaugă în Git `renv.lock`, `.Rprofile`, `renv/activate.R` și `renv/settings.json`. Biblioteca locală de pachete este exclusă prin `.gitignore`. Folosește aceeași versiune R ca în `renv.lock`; `renv` nu instalează R, Pandoc sau LaTeX.

Pentru actualizări intenționate, verifică mai întâi generarea raportului, apoi salvează noul mediu cu `renv::snapshot()`. Mecanismul este descris în [documentația renv](https://pkgs.rstudio.com/renv/).

Lista pachetelor încărcate de document (instalarea manuală este o alternativă la script):

```r
pachete <- c(
  "knitr", "rmarkdown", "RColorBrewer", "scales", "tidyverse",
  "dplyr", "plyr", "ggplot2", "gganimate", "Rmisc", "Hmisc",
  "randomForest", "rattle", "rpart.plot", "caret", "gmodels",
  "PresenceAbsence", "broom", "rlang", "cutpointr", "pROC",
  "ROCR", "ca", "plotROC", "ROSE", "devtools", "rpart",
  "readxl", "ellipsis", "gridExtra", "smotefamily"
)
install.packages(pachete, dependencies = TRUE)
```

### 2. Pregătirea datelor

Dezarhivează `survey_results.zip` în directorul proiectului. Documentul citește următoarele fișiere din directorul de lucru:

```text
survey_results_public.csv
survey_results_schema.csv
```

Arhiva conține și `2024 Developer Survey.pdf`, care documentează chestionarul.

### 3. Adaptarea directorului de lucru

La începutul fișierului `JobSat.Rmd` există o cale locală specifică mediului în care a fost realizată analiza:

```r
setwd("C:/Users/iancu/OneDrive/Desktop/adm")
```

Înlocuiește această cale cu directorul proiectului de pe calculatorul tău. Alternativ, elimină linia dacă rulezi documentul cu directorul proiectului ca director de lucru.

### 4. Generarea raportului

Deschide `JobSat.Rmd` în RStudio și folosește **Knit → Knit to HTML** sau execută din directorul proiectului:

```r
rmarkdown::render("JobSat.Rmd", output_format = "html_document")
```

Pentru PDF, după configurarea LaTeX:

```r
rmarkdown::render("JobSat.Rmd", output_format = "pdf_document")
```

Pentru a consulta analiza fără instalarea mediului R, deschide direct `JobSat.html` în browser.

## Rezultate și limite

Interpretările din document raportează o performanță moderată pentru modelele de clasificare. Pentru setul de test, sunt menționate valori AUC de aproximativ **0,635 pentru arborele de clasificare** și **0,673 pentru Random Forest**. Aceste valori provin din analiza existentă și nu reprezintă o rulare nouă.

Rezultatele descriu asocieri în răspunsurile la sondaj și nu demonstrează relații cauzale. Interpretarea depinde de recodificări și de tratarea valorilor lipsă. De asemenea, deși secțiunea despre remunerație descrie `ConvertedCompYearly`, categoriile `CompYearly_` sunt construite în cod din `CompTotal`; această diferență trebuie luată în considerare la interpretarea comparațiilor salariale.


