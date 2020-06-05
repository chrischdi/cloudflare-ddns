#!/bin/bash

bazel run //:gazelle -- update-repos -from_file=go.mod -to_macro=bazel/go-repositories.bzl%go_repositories
