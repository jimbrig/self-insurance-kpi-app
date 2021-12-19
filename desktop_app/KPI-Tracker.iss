#define MyAppName "KPI-Tracker"
#define MyAppVersion "0.0.0"
#define MyAppExeName "KPI-Tracker.bat"
#define RVersion "4.1.2"
#define IncludeR true
#define PandocVersion "2.16.1"
#define IncludePandoc false
#define IncludeChrome false
#define RtoolsVersion "40"
#define IncludeRtools true
#define MyAppPublisher ""
#define MyAppURL ""

[Setup]
AppName = {#MyAppName}
AppId = {{9YJE9DZV-98NJ-MAUM-5RW7-TK00UYXBMJU5}
DefaultDirName = {userdocs}\{#MyAppName}
DefaultGroupName = {#MyAppName}
OutputDir = installer
OutputBaseFilename = setup_{#MyAppName}
SetupIconFile = setup.ico
AppVersion = {#MyAppVersion}
AppPublisher = {#MyAppPublisher}
AppPublisherURL = {#MyAppURL}
AppSupportURL = {#MyAppURL}
AppUpdatesURL = {#MyAppURL}
PrivilegesRequired = lowest
InfoBeforeFile = infobefore.txt
InfoAfterFile = infoafter.txt
Compression = lzma2/ultra64
SolidCompression = yes
ArchitecturesInstallIn64BitMode = x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\default.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\default.ico"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\default.ico"

[Files]
Source: "LICENSE"; Flags: dontcopy noencryption
Source: "{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
#if IncludeR
    Source: "R-{#RVersion}-win.exe"; DestDir: "{tmp}"; Check: RNeeded
#endif
#if IncludePandoc
    Source: "pandoc-{#PandocVersion}-windows.msi"; DestDir: "{tmp}"; Check: PandocNeeded
#endif
#if IncludeChrome
    Source: "chrome_installer.exe"; DestDir: "{tmp}"; Check: ChromeNeeded
#endif
#if IncludeRtools
    Source: "Rtools{#RtoolsVersion}.exe"; DestDir: "{tmp}";
#endif
Source: "default.ico"; DestDir: "{app}"; Flags: ignoreversion;
Source: "deps.yaml"; DestDir: "{app}"; Flags: ignoreversion;
Source: "global.R"; DestDir: "{app}"; Flags: ignoreversion;
Source: "KPI-Tracker.bat"; DestDir: "{app}"; Flags: ignoreversion;
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion;
Source: "restart.txt"; DestDir: "{app}"; Flags: ignoreversion;
Source: "server.R"; DestDir: "{app}"; Flags: ignoreversion;
Source: "setup.ico"; DestDir: "{app}"; Flags: ignoreversion;
Source: "ui.R"; DestDir: "{app}"; Flags: ignoreversion;
Source: "bin/assertthat_0.2.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/backports_1.4.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/base64enc_0.1-3.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/broom_0.7.10.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/bslib_0.3.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/cachem_1.0.6.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/cli_3.1.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/colorspace_2.0-2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/commonmark_1.7.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/cpp11_0.4.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/crayon_1.4.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/crosstalk_1.2.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/curl_4.3.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/data.table_1.14.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/digest_0.6.29.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/dplyr_1.0.7.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/DT_0.20.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/ellipsis_0.3.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/evaluate_0.14.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/fansi_0.5.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/farver_2.1.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/fastmap_1.1.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/fontawesome_0.2.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/fs_1.5.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/generics_0.1.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/ggplot2_3.3.5.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/glue_1.6.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/gtable_0.3.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/highcharter_0.8.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/highr_0.9.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/htmltools_0.5.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/htmlwidgets_1.5.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/httpuv_1.6.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/igraph_1.2.10.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/isoband_0.2.5.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/jquerylib_0.1.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/jsonlite_1.7.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/knitr_1.37.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/labeling_0.4.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/later_1.3.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/lattice_0.20-45.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/lazyeval_0.2.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/lifecycle_1.0.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/lubridate_1.8.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/magrittr_2.0.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/MASS_7.3-54.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/Matrix_1.4-0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/mgcv_1.8-38.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/mime_0.12.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/munsell_0.5.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/nlme_3.1-153.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/pillar_1.6.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/pkgconfig_2.0.3.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/promises_1.2.0.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/purrr_0.3.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/qs_0.25.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/quantmod_0.4.18.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/R6_2.5.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/RApiSerialize_0.1.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rappdirs_0.3.3.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/RColorBrewer_1.1-2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/Rcpp_1.0.7.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/RcppParallel_5.1.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rintrojs_0.3.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rjson_0.2.20.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rlang_0.4.12.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rlist_0.4.6.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/rmarkdown_2.11.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/sass_0.4.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/scales_1.1.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/shiny_1.7.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/shinycssloaders_1.0.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/shinydashboard_0.7.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/shinyjs_2.0.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/shinyWidgets_0.6.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/sourcetools_0.1.7.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/stringfish_0.15.5.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/stringi_1.7.6.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/stringr_1.4.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/tibble_3.1.6.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/tidyr_1.1.4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/tidyselect_1.1.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/tinytex_0.35.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/TTR_0.24.3.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/utf8_1.2.2.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/vctrs_0.3.8.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/viridisLite_0.4.0.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/withr_2.4.3.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/xfun_0.29.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/XML_3.99-0.8.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/xtable_1.8-4.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/xts_0.12.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/yaml_2.2.1.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "bin/zoo_1.8-9.zip"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "data/exposures_scrubbed"; DestDir: "{app}\data"; Flags: ignoreversion;
Source: "data/loss_data_scrubbed"; DestDir: "{app}\data"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/chrome_100_percent.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/chrome_200_percent.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/d3dcompiler_47.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/ffmpeg.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/icudtl.dat"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/libEGL.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/libGLESv2.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/LICENSE"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/LICENSES.chromium.html"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/am.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ar.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/bg.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/bn.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ca.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/cs.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/da.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/de.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/el.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/en-GB.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/en-US.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/es-419.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/es.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/et.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/fa.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/fi.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/fil.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/fr.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/gu.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/he.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/hi.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/hr.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/hu.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/id.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/it.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ja.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/kn.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ko.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/lt.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/lv.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ml.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/mr.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ms.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/nb.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/nl.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/pl.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/pt-BR.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/pt-PT.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ro.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ru.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/sk.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/sl.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/sr.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/sv.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/sw.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/ta.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/te.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/th.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/tr.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/uk.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/vi.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/zh-CN.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/locales/zh-TW.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\locales"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources.pak"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/icon.ico"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/inject/_placeholder"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\inject"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/main.js"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/main.js.map"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/preload.js"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/preload.js.map"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/static/login.css"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib\static"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/static/login.html"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib\static"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/lib/static/login.js"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app\lib\static"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/nativefier.json"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/npm-shrinkwrap.json"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/resources/app/package.json"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\resources\app"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/snapshot_blob.bin"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/swiftshader/libEGL.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\swiftshader"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/swiftshader/libGLESv2.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64\swiftshader"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/v8_context_snapshot.bin"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/version"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/vk_swiftshader.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/vk_swiftshader_icd.json"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/vulkan-1.dll"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;
Source: "R/coverage_tab_module.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/dt.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/hc.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/header_buttons_module.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/shinytools.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/sign_in_page.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/summary.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "R/utils.R"; DestDir: "{app}\R"; Flags: ignoreversion;
Source: "rsconnect/shinyapps.io/jimbrig/Self-Insurance-KPI-Tracker.dcf"; DestDir: "{app}\rsconnect\shinyapps.io\jimbrig"; Flags: ignoreversion;
Source: "utils/config.cfg"; DestDir: "{app}\utils"; Flags: ignoreversion;
Source: "utils/ensure.R"; DestDir: "{app}\utils"; Flags: ignoreversion;
Source: "utils/get_app_from_app_url.R"; DestDir: "{app}\utils"; Flags: ignoreversion;
Source: "utils/launch_app.R"; DestDir: "{app}\utils"; Flags: ignoreversion;
Source: "utils/package_manager.R"; DestDir: "{app}\utils"; Flags: ignoreversion;
Source: "utils/wsf/js/JSON.minify.js"; DestDir: "{app}\utils\wsf\js"; Flags: ignoreversion;
Source: "utils/wsf/js/json2.js"; DestDir: "{app}\utils\wsf\js"; Flags: ignoreversion;
Source: "utils/wsf/js/run.js"; DestDir: "{app}\utils\wsf\js"; Flags: ignoreversion;
Source: "utils/wsf/run.wsf"; DestDir: "{app}\utils\wsf"; Flags: ignoreversion;
Source: "www/CHANGELOG.md"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/chart_features.html"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/chart_features.Rmd"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/custom.js"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/default.ico"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/favicon.ico"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/images/datatables.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/images/highcharts.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/images/kpi-tracking-1.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/images/KPI-Tracking.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/images/kpi_long.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/images/kpi_long_large.png"; DestDir: "{app}\www\images"; Flags: ignoreversion;
Source: "www/introjs-theme.css"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/styles.css"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/table_features.html"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/table_features.Rmd"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/welcome.html"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "www/welcome.Rmd"; DestDir: "{app}\www"; Flags: ignoreversion;
Source: "nativefier-app/KPI-Tracker-win32-x64/KPI-Tracker.exe"; DestDir: "{app}\nativefier-app\KPI-Tracker-win32-x64"; Flags: ignoreversion;

  [Run]
  #if IncludeR
      Filename: "{tmp}\R-{#RVersion}-win.exe"; Parameters: "/SILENT"; WorkingDir: {tmp}; Check: RNeeded; Flags: skipifdoesntexist; StatusMsg: "Installing R if needed"
  #endif
  #if IncludePandoc
      Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\pandoc-{#PandocVersion}-windows.msi"" /q"; WorkingDir: {tmp}; Check: PandocNeeded; Flags: skipifdoesntexist; StatusMsg: "Installing Pandoc if needed"
  #endif
  #if IncludeChrome
      Filename: "{tmp}\chrome_installer.exe"; Parameters: "/install"; WorkingDir: {tmp}; Check: ChromeNeeded; Flags: skipifdoesntexist; StatusMsg: "Installing Chrome if needed"
  #endif
  #if IncludeRtools
      Filename: "{tmp}\Rtools{#RtoolsVersion}.exe"; Parameters: "/VERYSILENT"; WorkingDir: {tmp}; Flags: skipifdoesntexist; StatusMsg: "Installing Rtools"
  #endif
  Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent


  [UninstallDelete]
Type: filesandordirs; Name: "{app}\library";
Type: filesandordirs; Name: "{app}\utils";
Type: filesandordirs; Name: "{app}\log";

[Code]
const
  ChromeRegKey = 'Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe';
  IERegKey = 'Software\Microsoft\Windows\CurrentVersion\App Paths\IEXPLORE.EXE';
  FFRegKey = 'Software\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe';
var
  RVersions: TStringList;
  RRegKey: string;
  RegPathsFile: string;
  SecondLicensePage: TOutputMsgMemoWizardPage;
  License2AcceptedRadio: TRadioButton;
  License2NotAcceptedRadio: TRadioButton;

// Is R installed?
function RDetected(): boolean;
var
    v: Integer;
    success: boolean;
begin
  success := false;
  for v := 0 to (RVersions.Count - 1) do
    begin
      if RegKeyExists(HKLM, 'Software\R-Core\R\' + RVersions[v]) or RegKeyExists(HKCU, 'Software\R-Core\R\' + RVersions[v]) then
      begin
        success := true;
        RRegKey := 'Software\R-Core\R\' + RVersions[v];
        break;
      end;
    end;
  Result := success;
end;

// If R is not detected, it is needed
function RNeeded(): boolean;
begin
  Result := not RDetected;
end;


// Is Chrome installed?
function ChromeDetected(): boolean;
var
    success: boolean;
begin
  success := RegKeyExists(HKLM, ChromeRegKey) or RegKeyExists(HKCU, ChromeRegKey);
  begin
    Result := success;
  end;
end;

// If Chrome is not detected, it is needed
function ChromeNeeded(): boolean;
begin
  Result := not ChromeDetected;
end;


// Registry path update function (adds an extra backslash for json)
function AddBackSlash(Value: string): string;
begin
  Result := Value;
  StringChangeEx(Result, '\', '\\', True);
end;


// Pandoc is stored in the System PATH
function PandocDetected(): boolean;
var
  PandocDir, Path: String;
begin
  Log('Checking for Pandoc in %PATH%');
  if RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Path) then
  begin // Successfully read the value
    Log('HKCU\Environment\PATH = ' + Path);
    PandocDir := ExpandConstant('{localappdata}\Pandoc\');
    Log('Looking for Pandoc in %PATH%: ' + PandocDir + ' in ' + Path);
    if Pos(LowerCase(PandocDir), Lowercase(Path)) = 0 then
		begin
			Log('Did not find Pandoc in %PATH%');
			Result := False;
		end
    else
		begin
			Log('Found Pandoc in %PATH%');
			Result := True;
		end
  end
  else // The key probably doesn't exist
  begin
    Log('Could not access HKCU\Environment\PATH.');
    Result := False;
  end;
end;

// If Pandoc is not detected, it is needed
function PandocNeeded(): boolean;
begin
  Result := not PandocDetected;
end;

// Save installation paths
procedure SaveInstallationPaths();
var
  RPath, ChromePath, IEPath, FFPath, PandocPath: string;
begin
  RPath := '';
  ChromePath := '';
  IEPath := '';
  FFPath := '';
  PandocPath := ExpandConstant('{localappdata}\Pandoc\');
  RegPathsFile := ExpandConstant('{app}\utils\regpaths.json');

  if Length(RRegKey) = 0 then
    RDetected;

  // Create registry paths file
  SaveStringToFile(RegPathsFile, '{' + #13#10, True);

  // R RegPath
  if RegQueryStringValue(HKLM, RRegKey, 'InstallPath', RPath) or RegQueryStringValue(HKCU, RRegKey, 'InstallPath', RPath) then
    SaveStringToFile(RegPathsFile, '"r": "' + AddBackSlash(RPath) + '",' + #13#10, True)
  else
    SaveStringToFile(RegPathsFile, '"r": "none",' + #13#10, True);

  // Chrome RegPath
  if RegQueryStringValue(HKLM, ChromeRegKey, 'Path', ChromePath) or RegQueryStringValue(HKCU, ChromeRegKey, 'Path', ChromePath) then
    SaveStringToFile(RegPathsFile, '"chrome": "' + AddBackSlash(ChromePath) + '",' + #13#10, True)
  else
    SaveStringToFile(RegPathsFile, '"chrome": "none",' + #13#10, True);

  // Internet Explorer RegPath
  if RegQueryStringValue(HKLM, IERegKey, '', IEPath) then
    SaveStringToFile(RegPathsFile, '"ie": "' + AddBackSlash(IEPath) + '",' + #13#10, True)
  else
    SaveStringToFile(RegPathsFile, '"ie": "none",' + #13#10, True);

  // Firefox RegPath
  if RegQueryStringValue(HKLM, FFRegKey, 'Path', FFPath) then
    SaveStringToFile(RegPathsFile, '"ff": "' + AddBackSlash(FFPath) + '",' + #13#10, True)
  else
    SaveStringToFile(RegPathsFile, '"ff": "none",' + #13#10, True);

  // Pandoc RegPath
  // ** Last Line in json file (no trailing comma) **
  if PandocDetected() then
    SaveStringToFile(RegPathsFile, '"pandoc": "' + AddBackSlash(PandocPath) + '"' + #13#10, True)
  else
    SaveStringToFile(RegPathsFile, '"pandoc": "none"' + #13#10, True);

  SaveStringToFile(RegPathsFile, '}', True);
end;

// Pre- and post-installation actions
procedure CurStepChanged(CurStep: TSetupStep);
begin
  // Pre-installation actions
  if CurStep = ssInstall then
  begin
  #if IncludeR
  #else
    // With `CurStep = ssInstall` we can still `Abort` if R not included but needed
    if RNeeded then
    begin
      SuppressibleMsgBox(Format('Error: R >= %s not found',[RVersions[RVersions.Count - 1]]), mbError, MB_OK, MB_OK);
      Abort;
    end;
  #endif
  end;
  // Post-installation actions
  if CurStep = ssPostInstall then
  begin
    SaveInstallationPaths;
  end;
end;

// Add RInno's license to the installer
procedure CheckLicense2Accepted(Sender: TObject);
begin
  { Update Next button when user (un)accepts the license }
  WizardForm.NextButton.Enabled := License2AcceptedRadio.Checked;
end;

function CloneLicenseRadioButton(Source: TRadioButton): TRadioButton;
begin
  Result := TRadioButton.Create(WizardForm);
  Result.Parent := SecondLicensePage.Surface;
  Result.Caption := Source.Caption;
  Result.Left := Source.Left;
  Result.Top := Source.Top;
  Result.Width := Source.Width;
  Result.Height := Source.Height;
  Result.OnClick := @CheckLicense2Accepted;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  { Update Next button when user gets to second license page }
  if CurPageID = SecondLicensePage.ID then
  begin
    CheckLicense2Accepted(nil);
  end;
end;

procedure InitializeWizard();
var
  LicenseFileName: string;
  LicenseFilePath: string;
begin
  { Create second license page, with the same labels as the original license page }
  SecondLicensePage :=
    CreateOutputMsgMemoPage(
      wpLicense, SetupMessage(msgWizardLicense), SetupMessage(msgLicenseLabel),
      SetupMessage(msgLicenseLabel3), '');

  { Shrink license box to make space for radio buttons }
  SecondLicensePage.RichEditViewer.Height := WizardForm.LicenseMemo.Height;

  { Load license }
  { Loading ex-post, as Lines.LoadFromFile supports UTF-8, }
  { contrary to LoadStringFromFile. }
  LicenseFileName := 'LICENSE';
  ExtractTemporaryFile(LicenseFileName);
  LicenseFilePath := ExpandConstant('{tmp}\' + LicenseFileName);
  SecondLicensePage.RichEditViewer.Lines.LoadFromFile(LicenseFilePath);
  DeleteFile(LicenseFilePath);

  { Clone accept/do not accept radio buttons for the second license }
  License2AcceptedRadio := CloneLicenseRadioButton(WizardForm.LicenseAcceptedRadio);
  License2NotAcceptedRadio := CloneLicenseRadioButton(WizardForm.LicenseNotAcceptedRadio);

  { Initially not accepted }
  License2NotAcceptedRadio.Checked := True;

  // Initialize the values of supported versions
  RVersions := TStringList.Create; // Make a new TStringList object reference
  // Add strings to the StringList object
  RVersions.Add('3.6.3');

end;

// Procedure called by InnoSetup when it is closing
procedure DeinitializeSetup();
begin
  RVersions.Free;
end;
