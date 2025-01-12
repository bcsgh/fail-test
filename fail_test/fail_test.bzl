# Copyright (c) 2022, Benjamin Shropshire,
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
# A Bazel rule for testing that other Bazel test rules fail when the should.

## `MODULE.bazel`

```
bazel_dep(
    name = "com_github_bcsgh_fail_test",
    version = ...,
)
```

## Usage

```
load("@com_github_bcsgh_fail_test//fail_test:fail_test.bzl", "fail_test")

sh_test(
    name = "fail_test",
    srcs = ["fail.sh"],
    tags = ["manual"],  # Expected to fail so don't run normaly.
)

fail_test(
    name = "test_failing_test",
    msgs = [
        "expected",
        "result",
    ],
    test = ":fail_test",
)
```
"""

def _fail_test_impl(ctx):
    rundeps = [ctx.attr.test[DefaultInfo].default_runfiles.files]
    exe = ctx.attr.test[DefaultInfo].files_to_run.executable
    runfiles = [exe]

    json_data = ctx.actions.declare_file(ctx.label.name + ".json")
    runfiles += [json_data]
    ctx.actions.write(
        output=json_data,
        content=json.encode(struct(
            msgs=ctx.attr.msgs,
        )),
    )

    log = ctx.label.name + ".log"
    executable = ctx.actions.declare_file(ctx.label.name + ".sh")
    rundeps += [
      ctx.attr._tool[DefaultInfo].data_runfiles.files,
      ctx.attr._tool[DefaultInfo].default_runfiles.files,
      ctx.attr._tool[DefaultInfo].files,
    ]
    ctx.actions.write(
        output=executable,
        content="\n".join([
            # Run the command, capture all output and invert success.
            # This dumps the output log if the tests "passes" for debugging.
            "(%s &> %s) && ( echo Test did not fail. ; cat %s ) && exit 2" % (exe.short_path, log, log),

            # Inspect the log.
            "%s --log=%s --json=%s" % (
                ctx.attr._tool[DefaultInfo].files_to_run.executable.short_path,
                log,
                json_data.short_path,
            ),
            "",
        ]),
    )

    return [DefaultInfo(
        executable=executable,
        runfiles=ctx.runfiles(
            files = runfiles,
            transitive_files = depset(runfiles, transitive=rundeps),
        ),
    )]

fail_test = rule(
    doc = "Check that a test rule fails with the expected results.",

    implementation = _fail_test_impl,
    test = True,
    attrs = {
        "test": attr.label(
            doc="The test target being checked.",
            allow_files=True,
            mandatory=True,
        ),
        "msgs": attr.string_list(
            doc="A set of string to check the test output for.",
        ),
        "_tool": attr.label(
            doc="The test tool.",
            default=":fail_test_py",
        ),
    },
)
