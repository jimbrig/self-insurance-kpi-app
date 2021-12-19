FROM rocker/shiny

ARG R_CONFIG_ACTIVE=default


RUN apt-get update && apt-get install -y \ 
  libglpk-dev \ 
  libssl-dev \ 
  libxml2-dev \ 
  libz-dev \ 
  pandoc \ 
  pkg-config


RUN R -e "install.packages('remotes')"  

# CRAN R packages 
RUN R -e "remotes::install_version('config', version = '0.3')" 
RUN R -e "remotes::install_version('dplyr', version = '1.0.2')" 
RUN R -e "remotes::install_version('DT', version = '0.16')" 
RUN R -e "remotes::install_version('forcats', version = '0.5.0')" 
RUN R -e "remotes::install_version('fs', version = '1.5.0')" 
RUN R -e "remotes::install_version('highcharter', version = '0.8.2')" 
RUN R -e "remotes::install_version('htmltools', version = '0.5.0')" 
RUN R -e "remotes::install_version('knitr', version = '1.30')" 
RUN R -e "remotes::install_version('lubridate', version = '1.7.9')" 
RUN R -e "remotes::install_version('purrr', version = '0.3.4')" 
RUN R -e "remotes::install_version('qs', version = '0.23.3')" 
RUN R -e "remotes::install_version('rintrojs', version = '0.2.2')" 
RUN R -e "remotes::install_version('rlang', version = '0.4.8')" 
RUN R -e "remotes::install_version('rmarkdown', version = '2.5')" 
RUN R -e "remotes::install_version('shiny', version = '1.5.0')" 
RUN R -e "remotes::install_version('shinycssloaders', version = '1.0.0')" 
RUN R -e "remotes::install_version('shinydashboard', version = '0.7.1')" 
RUN R -e "remotes::install_version('shinyjs', version = '2.0.0')" 
RUN R -e "remotes::install_version('shinyWidgets', version = '0.5.4')" 
RUN R -e "remotes::install_version('stringr', version = '1.4.0')" 
RUN R -e "remotes::install_version('tibble', version = '3.0.4')"


# Remove index & example apps included w/ shiny-server
RUN rm /srv/shiny-server/index.html
RUN rm -r /srv/shiny-server/sample-apps

# Copy app into `shiny_app` directory
COPY ./shiny_app /srv/shiny-server/shiny_app

# Update permissions (recursively) to App directory for `shiny` user
RUN chown -R shiny:shiny /srv/shiny-server/shiny_app

# Set the R_CONFIG_ACTIVE environment variable for Shiny.  For some reason shiny-server
# can't read in regular environment variables, so we have to pass the environment variable
# as a build argument to this Docker image, and then set it as an R environment variable. We
# set it in .Rprofile rather than .Renviron, because if there is a .Renviron supplied with the
# shiny app, the .Renviron from the shiny user's home folder will not be read in.
RUN echo "Sys.setenv(R_CONFIG_ACTIVE='$R_CONFIG_ACTIVE')" >> /home/shiny/.Rprofile

USER shiny

# avoid s6 initialization
# see https://github.com/rocker-org/shiny/issues/79
CMD ["/usr/bin/shiny-server"]
