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

"""Defines Bazel rules for running copyright checks and fixes."""

load("@bazel_skylib//lib:paths.bzl", "paths")

def _cr_impl(ctx):
    """
    Implementation function for the copyright rule. This function sets up the
    necessary command to execute the Python script with the specified mode and source files.
    Args:
        ctx (RuleContext): The rule context containing attributes and configuration.
    Returns:
        DefaultInfo: Bazel default information provider with the output log file.
    """
    script = ctx.attr._script
    files = []

    files = ctx.files.srcs
    extensions = ctx.attr.extensions

    text_exts = ""
    if len(extensions):
        text_exts = "-e {exts}".format(
            exts = " ".join([exts for exts in ctx.attr.extensions]),
        )

    ctx.actions.write(
        output = ctx.outputs.executable,
        content = "{tool}.py -t {template} {extensions} {fix} {use_mmap} {debug} {log_file} {offset} {srcs}".format(
            tool = script.files_to_run.executable.short_path,
            template = ctx.file.template.path,
            extensions = text_exts,
            fix = "--fix" if ctx.attr.fix else "",
            debug = "--verbose" if ctx.attr.debug else "",
            use_mmap = "--use_memory_map" if ctx.attr.use_memory_map else "",
            log_file = "--log-file log.txt" if ctx.attr.log_file else "",
            offset = "--offset %s" % ctx.attr.offset if ctx.attr.offset else "",
            srcs = " ".join([f.path for f in files]),
        ),
    )

    runfiles = ctx.runfiles(
        files = files + [ctx.file.template],
    ).merge(
        script.default_runfiles,
    )
    return [DefaultInfo(runfiles = runfiles)]

_cr_rule = rule(
    implementation = _cr_impl,
    executable = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True, mandatory = False, default = []),
        "template": attr.label(allow_single_file = True),
        "extensions": attr.string_list(mandatory = False, default = []),
        "debug": attr.bool(mandatory = False, default = False),
        "fix": attr.bool(mandatory = False, default = False),
        "offset": attr.int(mandatory = False, default = 0),
        "log_file": attr.bool(mandatory = False, default = False),
        "use_memory_map": attr.bool(mandatory = False, default = False),
        "_script": attr.label(
            default = Label("//tools/cr_checker/tool:cr_checker"),
        ),
    },
)

def check(
        name,
        srcs,
        visibility,
        template = "//tools/cr_checker/resources:templates",
        extensions = [],
        offset = 0,
        debug = False,
        log_file = False,
        use_memory_map = False):
    """
    Defines a Bazel target for checking files without modifying them.
    Args:
        name (str): The name of the target.
        srcs (list of labels): The source files to check.
    """
    _cr_rule(
        name = name,
        srcs = srcs,
        template = template,
        offset = offset,
        debug = debug,
        log_file = log_file,
        use_memory_map = use_memory_map,
        visibility = visibility,
    )

def fix(
        name,
        srcs,
        visibility,
        template = "//tools/cr_checker/resources:templates",
        extensions = [],
        offset = 0,
        debug = False,
        log_file = False,
        use_memory_map = False):
    """
    Defines a Bazel target for fixing files by adding missing copyright text.
    Args:
        name (str): The name of the target.
        srcs (list of labels): The source files to fix.
    """
    _cr_rule(
        name = name,
        srcs = srcs,
        template = template,
        offset = offset,
        debug = debug,
        log_file = log_file,
        use_memory_map = use_memory_map,
        fix = True,
        visibility = visibility,
    )
