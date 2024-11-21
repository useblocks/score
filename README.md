# Score Platform

## Building

### Supported environment
The build currently supports Linux environments.

### Use bazelisk for bazel version management
Follow [instructions](https://github.com/bazelbuild/bazelisk) and setup bazelisk to manage your bazel version based on the .bazelversion file.

### Check and fix formatting
```
$ bazel test //:format.check
$ bazel run //:format.fix
```

## Documentation

Use //docs:docs target to build the documentation.
```
$ bazel build //docs:docs
```

The output directory can be found under ```bazel-bin/docs/docs/_build/html```.

If you need to update pip dependencies, after modifying the requirements file, regenerate the lock file:
```
bazel run //docs:requirements.update
```
