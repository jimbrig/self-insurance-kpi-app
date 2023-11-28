require(rstudioapi)
rstudioapi::jobRunScript(
    name = "Build Desktop App",
    path = fs::path(here::here(), "build", "scripts", "build_installer.R"),
    workingDir = getwd(),
    exportEnv = ".innoEnv"
)
