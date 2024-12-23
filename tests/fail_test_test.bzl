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

load("//fail_test:fail_test.bzl", "fail_test")
def fail_test_suite(name):
    native.sh_test(
        name = "fail_test_fail_test",
        srcs = ["fail.sh"],
        tags = ["manual"],
    )

    fail_test(
        name = "fail_test_failure_test",
        msgs = [
            "flimmflam",
            "sparkly",
        ],
        test = ":fail_test_fail_test",
    )

    native.sh_test(
        name = "fail_test_pass_test",
        srcs = ["pass.sh"],
        tags = ["manual"],
    )

    fail_test(
        name = "fail_test_err_test",
        msgs = [],
        test = ":fail_test_pass_test",
        tags = ["manual"],
    )

    fail_test(
        name = "fail_test_passes_test",
        msgs = ["Test did not fail."],
        test = ":fail_test_err_test",
    )

    # Suit
    native.test_suite(
        name = name,
        tests = [
            ":fail_test_failure_test",
            ":fail_test_passes_test",
        ],
    )
