cmake_minimum_required(VERSION 3.16)

project(eye-protector2)
 
find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)


# find_package(KF6 REQUIRED COMPONENTS
#     Plasma
# )

find_package(Plasma 6.1 REQUIRED)

find_package(Qt6 CONFIG REQUIRED COMPONENTS
    Core
    Quick
    Qml
)

# plasmoid
# TODO: adapt "org.kde.plasma" here & elsewhere if needed (see README)
plasma_install_package(package com.github.kie4280.eyeprotector2)

# qml extension plugin
add_subdirectory(plugin)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
