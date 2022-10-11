load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_repositories():
    go_repository(
        name = "com_github_burntsushi_toml",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/BurntSushi/toml",
        sum = "h1:WXkYYl6Yr3qBf1K79EBnL4mak0OimBfB0XUf9Vl28OQ=",
        version = "v0.3.1",
    )
    go_repository(
        name = "com_github_cloudflare_cloudflare_go",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/cloudflare/cloudflare-go",
        sum = "h1:ZLDg3hNZ42sJahO3kdcy7NtXAlSS//pmly921jAbZ2o=",
        version = "v0.51.0",
    )
    go_repository(
        name = "com_github_cpuguy83_go_md2man_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/cpuguy83/go-md2man/v2",
        sum = "h1:p1EgwI/C7NhT0JmVkwCD2ZBK8j4aeHQX2pMHHBfMQ6w=",
        version = "v2.0.2",
    )
    go_repository(
        name = "com_github_davecgh_go_spew",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/davecgh/go-spew",
        sum = "h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c=",
        version = "v1.1.1",
    )
    go_repository(
        name = "com_github_fatih_color",
        importpath = "github.com/fatih/color",
        sum = "h1:8LOYc1KYPPmyKMuN8QV2DNRWNbLo6LZ0iLs8+mlH53w=",
        version = "v1.13.0",
    )
    go_repository(
        name = "com_github_google_go_cmp",
        importpath = "github.com/google/go-cmp",
        sum = "h1:e6P7q2lk1O+qJJb4BtCQXlK8vWEO8V1ZeuEdJNOqZyg=",
        version = "v0.5.8",
    )
    go_repository(
        name = "com_github_google_go_querystring",
        importpath = "github.com/google/go-querystring",
        sum = "h1:AnCroh3fv4ZBgVIf1Iwtovgjaw/GiKJo8M8yD/fhyJ8=",
        version = "v1.1.0",
    )
    go_repository(
        name = "com_github_hashicorp_go_cleanhttp",
        importpath = "github.com/hashicorp/go-cleanhttp",
        sum = "h1:035FKYIWjmULyFRBKPs8TBQoi0x6d9G4xc9neXJWAZQ=",
        version = "v0.5.2",
    )
    go_repository(
        name = "com_github_hashicorp_go_hclog",
        importpath = "github.com/hashicorp/go-hclog",
        sum = "h1:La19f8d7WIlm4ogzNHB0JGqs5AUDAZ2UfCY4sJXcJdM=",
        version = "v1.2.0",
    )
    go_repository(
        name = "com_github_hashicorp_go_retryablehttp",
        importpath = "github.com/hashicorp/go-retryablehttp",
        sum = "h1:sUiuQAnLlbvmExtFQs72iFW/HXeUn8Z1aJLQ4LJJbTQ=",
        version = "v0.7.1",
    )
    go_repository(
        name = "com_github_kr_pretty",
        importpath = "github.com/kr/pretty",
        sum = "h1:WgNl7dwNpEZ6jJ9k1snq4pZsg7DOEN8hP9Xw0Tsjwk0=",
        version = "v0.3.0",
    )
    go_repository(
        name = "com_github_mattn_go_colorable",
        importpath = "github.com/mattn/go-colorable",
        sum = "h1:jF+Du6AlPIjs2BiUiQlKOX0rt3SujHxPnksPKZbaA40=",
        version = "v0.1.12",
    )
    go_repository(
        name = "com_github_mattn_go_isatty",
        importpath = "github.com/mattn/go-isatty",
        sum = "h1:yVuAays6BHfxijgZPzw+3Zlu5yQgKGP2/hcQbHb7S9Y=",
        version = "v0.0.14",
    )

    go_repository(
        name = "com_github_mattn_go_runewidth",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/mattn/go-runewidth",
        sum = "h1:lTGmDsbAYt5DmK6OnoV7EuIF1wEIFAcxld6ypU4OSgU=",
        version = "v0.0.13",
    )
    go_repository(
        name = "com_github_olekukonko_tablewriter",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/olekukonko/tablewriter",
        sum = "h1:P2Ga83D34wi1o9J6Wh1mRuqd4mF/x/lgBS7N7AbDhec=",
        version = "v0.0.5",
    )
    go_repository(
        name = "com_github_pkg_errors",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/pkg/errors",
        sum = "h1:FEBLx1zS214owpjy7qsBeixbURkuhQAwrK5UwLGTwt4=",
        version = "v0.9.1",
    )
    go_repository(
        name = "com_github_pmezard_go_difflib",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/pmezard/go-difflib",
        sum = "h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_rivo_uniseg",
        importpath = "github.com/rivo/uniseg",
        sum = "h1:S1pD9weZBuJdFmowNwbpi7BJ8TNftyUImj/0WQi72jY=",
        version = "v0.2.0",
    )
    go_repository(
        name = "com_github_rogpeppe_go_internal",
        importpath = "github.com/rogpeppe/go-internal",
        sum = "h1:geMPLpDpQOgVyCg5z5GoRwLHepNdb71NXb67XFkP+Eg=",
        version = "v1.8.1",
    )

    go_repository(
        name = "com_github_russross_blackfriday_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/russross/blackfriday/v2",
        sum = "h1:JIOH55/0cWyOuilr9/qlrm0BSXldqnqwMsf35Ld67mk=",
        version = "v2.1.0",
    )
    go_repository(
        name = "com_github_shurcool_sanitized_anchor_name",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/shurcooL/sanitized_anchor_name",
        sum = "h1:PdmoCO6wvbs+7yrJyMORt4/BmY5IYyJwS/kOiWx8mHo=",
        version = "v1.0.0",
    )
    go_repository(
        name = "com_github_stretchr_objx",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/stretchr/objx",
        sum = "h1:4G4v2dO3VZwixGIRoQ5Lfboy6nUhCyYzaqnIAPPhYs4=",
        version = "v0.1.0",
    )
    go_repository(
        name = "com_github_stretchr_testify",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/stretchr/testify",
        sum = "h1:pSgiaMZlXftHpm5L7V1+rVB+AZJydKsMxsQBIJw4PKk=",
        version = "v1.8.0",
    )
    go_repository(
        name = "com_github_urfave_cli",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/urfave/cli",
        sum = "h1:lNq9sAHXK2qfdI8W+GRItjCEkI+2oR4d+MEHy1CKXoU=",
        version = "v1.22.5",
    )
    go_repository(
        name = "com_github_urfave_cli_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/urfave/cli/v2",
        sum = "h1:gHoFIwpPjoyIMbJp/VFd+/vuD0dAgFK4B6DpEMFJfQk=",
        version = "v2.16.3",
    )
    go_repository(
        name = "com_github_xrash_smetrics",
        importpath = "github.com/xrash/smetrics",
        sum = "h1:bAn7/zixMGCfxrRTfdpNzjtPYqr8smhKouy9mxVdGPU=",
        version = "v0.0.0-20201216005158-039620a65673",
    )

    go_repository(
        name = "in_gopkg_check_v1",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "gopkg.in/check.v1",
        sum = "h1:Hei/4ADfdWqJk1ZMxUNpqntNwaWcugrBjAiHlqqRiVk=",
        version = "v1.0.0-20201130134442-10cb98267c6c",
    )
    go_repository(
        name = "in_gopkg_yaml_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "gopkg.in/yaml.v2",
        sum = "h1:fvjTMHxHEw/mxHbtzPi3JCcKXQRAnQTBRo6YCJSVHKI=",
        version = "v2.2.3",
    )
    go_repository(
        name = "in_gopkg_yaml_v3",
        importpath = "gopkg.in/yaml.v3",
        sum = "h1:fxVm/GzAzEWqLHuvctI91KS9hhNmmWOoWu0XTYJS7CA=",
        version = "v3.0.1",
    )

    go_repository(
        name = "org_golang_x_crypto",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/crypto",
        sum = "h1:psW17arqaxU48Z5kZ0CQnkZWQJsqcURM6tKiBApRjXI=",
        version = "v0.0.0-20200622213623-75b288015ac9",
    )
    go_repository(
        name = "org_golang_x_net",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/net",
        sum = "h1:PxfKdU9lEEDYjdIzOtC4qFWgkU2rGHdKlKowJSMN9h0=",
        version = "v0.0.0-20220722155237-a158d28d115b",
    )
    go_repository(
        name = "org_golang_x_sys",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/sys",
        sum = "h1:v4INt8xihDGvnrfjMDVXGxw9wrfxYyCjk0KbXjhR55s=",
        version = "v0.0.0-20220722155257-8c9f86f7a55f",
    )
    go_repository(
        name = "org_golang_x_term",
        importpath = "golang.org/x/term",
        sum = "h1:JGgROgKl9N8DuW20oFS5gxc+lE67/N3FcwmBPMe7ArY=",
        version = "v0.0.0-20210927222741-03fcf44c2211",
    )

    go_repository(
        name = "org_golang_x_text",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/text",
        sum = "h1:olpwvP2KacW1ZWvsR7uQhoyTYvKAupfQrRGBFM352Gk=",
        version = "v0.3.7",
    )
    go_repository(
        name = "org_golang_x_time",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/time",
        sum = "h1:M73Iuj3xbbb9Uk1DYhzydthsj6oOd6l9bpuFcNoUvTs=",
        version = "v0.0.0-20220224211638-0e9765cccd65",
    )
    go_repository(
        name = "org_golang_x_tools",
        importpath = "golang.org/x/tools",
        sum = "h1:FDhOuMEY4JVRztM/gsbk+IKUQ8kj74bxZrgw87eMMVc=",
        version = "v0.0.0-20180917221912-90fa682c2a6e",
    )
    go_repository(
        name = "org_golang_x_xerrors",
        importpath = "golang.org/x/xerrors",
        sum = "h1:E7g+9GITq07hpfrRu66IVDexMakfv52eLZ2CXBWiKr4=",
        version = "v0.0.0-20191204190536-9bdfabe68543",
    )
