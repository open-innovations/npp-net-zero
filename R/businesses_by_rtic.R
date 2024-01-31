# businesses by rtic

businesses_rtic <- data |>
  dplyr::select(Companynumber, Companyname, Localauthoritycodes, RTICs) |>
  # needs refining
  dplyr::mutate(noOfLAs = floor(nchar(Localauthoritycodes) / 8)) |>
  tidyr::separate(RTICs, into = paste0("RTIC", 1:10), sep = ",") |>
  tidyr::pivot_longer(dplyr::starts_with("RTIC"), names_to = NULL, values_to = "RTIC", values_drop_na = TRUE) |>
  dplyr::mutate(RTIC = stringr::str_trim(RTIC)) |>
  dplyr::distinct() |>
  # dplyr::filter(grepl("Net Zero|Energy Generation", RTIC)) |>
  tidyr::separate(Localauthoritycodes, into = paste0("la", 1:345), sep = ",") |>
  tidyr::pivot_longer(cols = dplyr::starts_with("la"), names_to = NULL, values_to = "LAcode", values_drop_na = TRUE) |>
  # double check
  dplyr::group_by(RTIC, LAcode) |>
  dplyr::summarise(n = dplyr::n())

businesses_rtic_north <- dplyr::inner_join(businesses_rtic, lad21_rgn21, by = c("LAcode" = "LAD21CD"))

businesses_rtic_north_final <- dplyr::inner_join(lad21, businesses_rtic_north, by = c("LAD21CD" = "LAcode"))

ggplot2::ggplot(businesses_rtic_north_final,
                ggplot2::aes(fill = log(n))) +
  ggplot2::geom_sf() +
  ggplot2::scale_fill_continuous(type = "viridis") +
  ggplot2::theme_minimal() +
  ggplot2::facet_wrap("RTIC")
