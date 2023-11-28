FROM rocker/shiny:latest

LABEL org.opencontainers.image.source = "https://github.com/jimbrig/self-insurance-kpi-app"
LABEL org.opencontainers.image.authors = "Jimmy Briggs <jimmy.briggs@jimbrig.com>"
LABEL org.opencontainers.image.title = "Self Insurance KPI App"
LABEL org.opencontainers.image.description = "A Shiny app for calculating self insurance KPIs"

ARG R_CONFIG_ACTIVE=default
ENV R_CONFIG_ACTIVE=$R_CONFIG_ACTIVE

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y \
    libglpk-dev \
    libssl-dev \
    libxml2-dev \
    libz-dev \
    pandoc \
    pkg-config

RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site

# Install remotes package
RUN install2.r remotes

# Install CRAN packages
RUN Rscript -e 'install.packages("shiny", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("shinydashboard", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("shinyjs", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("shinyWidgets", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("shinycssloaders", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("purrr", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("lubridate", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("tibble", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("dplyr", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("highcharter", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("stringr", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("rintrojs", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("DT", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("knitr", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("rmarkdown", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("config", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("qs", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("rlang", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("htmltools", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("forcats", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'
RUN Rscript -e 'install.packages("fs", repos="https://cran.rstudio.com/", lib = "/usr/local/lib/R/site-library", method = "libcurl", Ncpus = 4)'

COPY ./shiny_app/ /app/

ARG SHINY_PORT=3838
EXPOSE $SHINY_PORT

RUN echo "local({options(shiny.port = ${SHINY_PORT}, shiny.host = '0.0.0.0')})" >> /usr/local/lib/R/etc/Rprofile.site

# Set the R_CONFIG_ACTIVE environment variable for Shiny.  For some reason shiny-server
# can't read in regular environment variables, so we have to pass the environment variable
# as a build argument to this Docker image, and then set it as an R environment variable. We
# set it in .Rprofile rather than .Renviron, because if there is a .Renviron supplied with the
# shiny app, the .Renviron from the shiny user's home folder will not be read in.
RUN echo "Sys.setenv(R_CONFIG_ACTIVE='$R_CONFIG_ACTIVE')" >> /app/.Rprofile


CMD ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0'); shiny::runApp(appDir = '/app')"]
