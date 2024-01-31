# employees

employees <- data |>
  dplyr::select(Companynumber, Companyname, BestEstimateCurrentEmployees, Localauthoritycodes) |>
  # needs refining
  dplyr::mutate(noOfLAs = floor(nchar(Localauthoritycodes) / 8)) |>
  tidyr::separate(Localauthoritycodes, into = paste0("la", 1:345), sep = ",") |>
  tidyr::pivot_longer(cols = dplyr::starts_with("la"), names_to = NULL, values_to = "LAcode", values_drop_na = TRUE) |>
  dplyr::mutate(BestEstimateCurrentEmployees = ceiling(BestEstimateCurrentEmployees / noOfLAs)) |>
  dplyr::group_by(LAcode) |>
  dplyr::summarise(BestEstimateCurrentEmployees = sum(BestEstimateCurrentEmployees))

employees_north <- dplyr::inner_join(employees, lad21_rgn21, by = c("LAcode" = "LAD21CD"))

employees_north_final <- dplyr::inner_join(lad21, employees_north, by = c("LAD21CD" = "LAcode"))

ggplot2::ggplot(employees_north_final,
                ggplot2::aes(fill = BestEstimateCurrentEmployees)) +
  ggplot2::geom_sf() +
  ggplot2::scale_fill_continuous(type = "viridis") +
  ggplot2::theme_minimal()
