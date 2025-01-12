<!-- Generated with Stardoc: http://skydoc.bazel.build -->

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

<a id="fail_test"></a>

## fail_test

<pre>
load("@com_github_bcsgh_fail_test//fail_test:fail_test.bzl", "fail_test")

fail_test(<a href="#fail_test-name">name</a>, <a href="#fail_test-msgs">msgs</a>, <a href="#fail_test-test">test</a>)
</pre>

Check that a test rule fails with the expected results.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="fail_test-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="fail_test-msgs"></a>msgs |  A set of string to check the test output for.   | List of strings | optional |  `[]`  |
| <a id="fail_test-test"></a>test |  The test target being checked.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


## Setup (for development)
To configure the git hooks, run `./.git_hooks/setup.sh`
