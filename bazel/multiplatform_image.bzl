load("@io_bazel_rules_go//go:def.bzl", "go_binary")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar", "pkg_deb")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")
load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")

"""
rules_docker for extended for multiplatform purposes
"""

def go_multiplatform_release(
      name,
      target,
      image_tag,
      platforms = ["linux/amd64", "linux/arm", "linux/arm64"],
    ):
  """
  This rule creates multiple go_binary and container_image rules for a go_library
  target.
  """

  for platform in platforms:
    os = platform.split("/")[0]
    arch = platform.split("/")[1]

    go_binary(
      name = name + "-" + os + "-" + arch,
      embed = [target],
      goos = os,
      goarch = arch,
      visibility = ["//visibility:public"],
    )

    pkg_tar(
      name = "archive-" + name + "-" + os + "-" + arch,
      extension = "tar.gz",
      srcs = [
        ":" + name + "-" + os + "-" + arch,
      ],
    )

    go_image(
        name = "_image_" + name + "-" + os + "-" + arch,
        embed = [target],
        goos = os,
        goarch = arch,
        visibility = ["//visibility:private"],
    )

    container_image(
        name = "image_" + name + "-" + os + "-" + arch,
        architecture = arch,
        base = ":_image_" + name + "-" + os + "-" + arch,
        visibility = ["//visibility:public"],
    )

    container_push(
      name = "push_image_" + name + "-" + os + "-" + arch,
      image = ":image_" + name + "-" + os + "-" + arch,
      format = "Docker",
      registry = "index.docker.io",
      repository = "chrischdi/cloudflare-ddns",
      tag = image_tag + "-" + os + "-" + arch,
    )

    go_image(
        name = "_image_" + name + "-" + os + "-" + arch + "-debug",
        base = "@go_debug_image_base//image:image",
        embed = [target],
        goos = os,
        goarch = arch,
        visibility = ["//visibility:private"],
    )

    container_image(
        name = "image_" + name + "-" + os + "-" + arch + "-debug",
        architecture = arch,
        base = ":_image_" + name + "-" + os + "-" + arch + "-debug",
        visibility = ["//visibility:public"],
    )

    container_push(
      name = "push_image_" + name + "-" + os + "-" + arch + "-debug",
      image = ":image_" + name + "-" + os + "-" + arch + "-debug",
      format = "Docker",
      registry = "index.docker.io",
      repository = "chrischdi/cloudflare-ddns",
      tag = image_tag + "-" + os + "-" + arch + "-debug",
    )
