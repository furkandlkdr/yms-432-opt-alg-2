# Final Project - CLONALG + AIS Optimization (MATLAB)

## Overview
This project optimizes ML model hyperparameters for the Breast Cancer Wisconsin dataset using two approaches:
- CLONALG (main.m)
- AIS (ais_optimizasyon.m)

The workflow keeps inputs as X and outputs as y, uses z-score normalization, and evaluates models with 5-fold CV and macro F1.

## Dataset
- Breast Cancer Wisconsin
- 569 samples, 30 features, binary labels

## Models
- SVM (fitcsvm)
- Ensemble Subspace KNN (fitcensemble)
- MLP (fitcnet)
- KNN (fitcknn) in AIS pipeline

## How To Run
Open MATLAB and run from the final-project folder:

```matlab
cd('c:/Users/furkan/Documents/VSCode1/yms-432-opt-alg-2/final-project')
main
```

AIS pipeline:

```matlab
ais_optimizasyon(1)
```

## Outputs
- clonalg_sonuclar.png
- clonalg_optimizasyon_sonuclari.mat
- ais_baseline_karsilastirma.png
- ais_optimizasyon_sonuclari.mat
- cikti.md

## Notes
- Ensemble replaces TreeBagger for speed and consistency with AIS baseline models.
- Macro F1 is used for optimization; accuracy values from Classification Learner are documented in proje-sunum.md.
