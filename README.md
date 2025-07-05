# Hail Risk Modelling in South Africa using R-INLA

This project contains the core analysis and code from my Honours thesis in Statistics and Data Science at the University of Pretoria. The goal was to model hail insurance claim risk across South Africa using a Bayesian spatial framework, with real-world claim data from Momentum serving as a proxy for hail events.

## 📍 Project Overview

- **Objective:** Estimate spatial hail risk using historical insurance claims data.
- **Methodology:** Bayesian hierarchical models via R-INLA and the SPDE approach.
- **Data:** Aggregated hail-related claims (coordinates, claim amount, date).
- **Tools:** R, INLA, ggplot2, sf, raster, tidyverse.

## 📦 Key Components

- `code/mesh_creation.R`: Builds the spatial mesh over South Africa.
- `code/model_fitting.R`: Fits the spatial INLA model using log-transformed claim amounts.
- `code/plots.R`: Generates the figures for claims maps, density plots, and posterior risk surfaces.
- `figures/`: Contains key output images from the analysis.

## 🔍 Main Outputs

- Spatial mesh for INLA-SPDE
- Posterior risk surface (log claims)
- Monthly hail claim frequency trend
- Density plots of claims across SA

## 📘 Thesis Summary

> In South Africa, direct hail event data is difficult to obtain. By using historical insurance claims as a proxy, this project applies Bayesian spatial models to identify high-risk zones for hail damage. The INLA framework with SPDE enabled flexible modelling over space, producing interpretable outputs and valuable insights for insurers.

## 🚀 Technologies Used

- **R**: Core analysis and modelling
- **INLA**: Latent Gaussian Models & SPDE
- **sf**: Spatial data handling
- **ggplot2**: Visualization
- **fields**: Mesh plotting and interpolation

## 🙋‍♂️ Author

**Dean Abbott**  
University of Pretoria  
[LinkedIn](https://www.linkedin.com/in/dean-abbott-a15113334) • [Email](daabbott15@gmail.com)

---

*Note: Due to privacy restrictions, raw insurance data is not included. Please contact me if you'd like access to synthetic or simulated sample data for demonstration.*

