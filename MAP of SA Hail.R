# Load libraries
library(tidyverse)
library(sf)
library(readr)
library(rnaturalearth)
library(rnaturalearthdata)
library(INLA)
library(fields)
library(lubridate)


# Read data
#data <- read_delim("C:/Users/Dean Abbott/OneDrive - University of Pretoria/Documents/Thesis/MomentumData.csv", 
                   #delim = ";", 
                   #locale = locale(decimal_mark = "."))
data <- MomentumData


# Filter valid coordinate entries
claims_coords <- data %>%
  filter(!is.na(DAY_X_CORD), !is.na(DAY_Y_CORD))

# Load South Africa map from Natural Earth
sa_map <- ne_countries(scale = "medium", country = "South Africa", returnclass = "sf")

ggplot() +
  geom_sf(data = sa_map, fill = "white", color = "black") +
  geom_point(data = claims_coords, aes(x = DAY_X_CORD, y = DAY_Y_CORD),
             color = "red", alpha = 0.4, size = 1) +
  coord_sf(xlim = c(10, 35), ylim = c(-35, -20)) +  # Adjust these values to zoom in/out
  labs(title = "Hail Insurance Claims in South Africa",
       x = "Longitude", y = "Latitude") +
  theme_minimal()

ggplot() +
  geom_sf(data = sa_map, fill = "white", color = "black") +
  stat_density_2d(data = claims_coords, aes(x = DAY_X_CORD, y = DAY_Y_CORD, fill = ..level..),
                  geom = "polygon", alpha = 0.8, bins = 400) +
  scale_fill_viridis_c(option = "inferno") +
  coord_sf(xlim = c(10, 35), ylim = c(-35, -20)) +  # Adjust these values to zoom in/out
  labs(title = "High-Density Zones of Hail Insurance Claims",
       fill = "Density",
       x = "Longitude", y = "Latitude") +
  theme_minimal()

claims_coords_sf <- st_as_sf(claims_coords, coords = c("DAY_X_CORD", "DAY_Y_CORD"), crs = 4326)

coords <- st_coordinates(claims_coords_sf)

mesh <- inla.mesh.2d(loc = coords, max.edge = c(0.2, 0.5), cutoff = 0.05)
plot(mesh)
points(coords, col = "blue", pch = 20, cex = 0.6)

spde <- inla.spde2.matern(mesh)
A <- inla.spde.make.A(mesh = mesh, loc = coords)
s.index <- inla.spde.make.index(name = "spatial", n.spde = spde$n.spde)

stack <- inla.stack(
  data = list(y = data$CLAIM_AMOUNT),
  A = list(A, 1),
  effects = list(spatial = s.index, Intercept = rep(1, nrow(data))),
  tag = "claims"
)

formula <- y ~ 1 + f(spatial, model = spde)

result <- inla(formula, data = inla.stack.data(stack),
               control.predictor = list(A = inla.stack.A(stack), compute = TRUE),
               control.compute = list(dic = TRUE, waic = TRUE))
proj <- inla.mesh.projector(mesh, dims = c(300, 300))
z <- inla.mesh.project(proj, result$summary.random$spatial$mean)

fields::image.plot(proj$x, proj$y, z,
                   main = "Posterior Mean Hail Risk",
                   xlab = "Longitude", ylab = "Latitude")

data %>%
  mutate(month = floor_date(CLM_LOSS_DT, "month")) %>%
  group_by(month) %>%
  summarise(n_claims = n()) %>%
  ggplot(aes(x = month, y = n_claims)) +
  geom_line(color = "steelblue") +
  labs(title = "Monthly Hail Claim Frequency", x = "Month", y = "Number of Claims") +
  theme_minimal()

