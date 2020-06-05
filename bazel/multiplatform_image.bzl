load("@io_bazel_rules_go//go:def.bzl", "go_binary")
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
      name = name + "_" + os + "_" + arch,
      embed = [target],
      goos = os,
      goarch = arch,
      visibility = ["//visibility:public"],
    )

    go_image(
        name = "_image_" + name + "_" + os + "_" + arch,
        embed = [target],
        goos = os,
        goarch = arch,
        visibility = ["//visibility:private"],
    )

    container_image(
        name = "image_" + name + "_" + os + "_" + arch,
        architecture = arch,
        base = ":_image_" + name + "_" + os + "_" + arch,
        visibility = ["//visibility:public"],
    )

    container_push(
      name = "push_image_" + name + "_" + os + "_" + arch,
      image = ":image_" + name + "_" + os + "_" + arch,
      format = "OCI",
      registry = "index.docker.io",
      repository = "chrischdi/cloudflare-ddns",
      tag = image_tag + "-" + os + "-" + arch,
    )
