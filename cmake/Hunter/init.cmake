#
# Copyright Soramitsu Co., 2021-2023
# Copyright Quadrivium Co., 2023
# All Rights Reserved
# SPDX-License-Identifier: Apache-2.0
#

# specify GITHUB_HUNTER_TOKEN and GITHUB_HUNTER_USERNAME to automatically upload binary cache to github.com/soramitsu/hunter-binary-cache
# https://docs.hunter.sh/en/latest/user-guides/hunter-user/github-cache-server.html
string(COMPARE EQUAL "$ENV{GITHUB_HUNTER_TOKEN}" "" password_is_empty)
string(COMPARE EQUAL "$ENV{GITHUB_HUNTER_USERNAME}" "" username_is_empty)

# binary cache can be uploaded to soramitsu/hunter-binary-cache so others will not build same dependencies twice
if (NOT password_is_empty AND NOT username_is_empty)
    option(HUNTER_RUN_UPLOAD "Upload cache binaries" YES)
    message("Binary cache uploading is ENABLED.")
else()
    option(HUNTER_RUN_UPLOAD "Upload cache binaries" NO)
    message("Binary cache uploading is DISABLED.")
endif ()

set(
    HUNTER_PASSWORDS_PATH
    "${CMAKE_CURRENT_LIST_DIR}/passwords.cmake"
    CACHE FILEPATH "Hunter passwords"
)

set(HUNTER_USE_CACHE_SERVERS NO)

include(${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake)

HunterGate(
    URL  https://github.com/qdrvm/hunter/archive/refs/tags/v0.25.3-qdrvm3.zip
    SHA1 8989599eaa462f367805e2d36a30150c93b1d660
    LOCAL
)
