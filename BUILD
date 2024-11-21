# *******************************************************************************
# Copyright (c) 2024 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************

test_suite(
    name = "format.check",
    tests = ["//tools/format:format.check"],
)

alias(
    name = "format.fix",
    actual = "//tools/format:format.fix",
)

alias(
    name = "copyright.check",
    actual = "//tools/cr_checker:copyright.check",
)

alias(
    name = "copyright.fix",
    actual = "//tools/cr_checker:copyright.fix",
)

filegroup(
    name = "repo_directories",
    srcs = [
        "docs",
        "tools",
    ],
    visibility = [
        "//tools/cr_checker:__subpackages__",
    ],
)

exports_files([
    "MODULE.bazel",
    "BUILD",
])
