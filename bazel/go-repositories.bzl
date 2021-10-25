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
        sum = "h1:u69Gye0WKOKQPOfib2yxWUl0u78k2VP05BeMJctFGRM=",
        version = "v0.26.0",
    )
    go_repository(
        name = "com_github_cpuguy83_go_md2man_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/cpuguy83/go-md2man/v2",
        sum = "h1:U+s90UTSYgptZMwQh2aRr3LuazLJIa+Pg3Kc1ylSYVY=",
        version = "v2.0.0-20190314233015-f79a8a8ca69d",
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
        name = "com_github_mattn_go_runewidth",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/mattn/go-runewidth",
        sum = "h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0=",
        version = "v0.0.9",
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
        name = "com_github_russross_blackfriday_v2",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/russross/blackfriday/v2",
        sum = "h1:lPqVAte+HuHNfhJ/0LC98ESWRz8afy9tM/0RK8m9o+Q=",
        version = "v2.0.1",
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
        sum = "h1:nwc3DEeHmmLAfoZucVR881uASk0Mfjw8xYJ99tb5CcY=",
        version = "v1.7.0",
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
        sum = "h1:qph92Y649prgesehzOrQjdWyxFOp/QVM+6imKHad91M=",
        version = "v2.3.0",
    )
    go_repository(
        name = "in_gopkg_check_v1",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "gopkg.in/check.v1",
        sum = "h1:qIbj1fsPNlZgppZ+VLlY7N33q108Sa+fhmuc+sWQYwY=",
        version = "v1.0.0-20180628173108-788fd7840127",
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
        sum = "h1:p9UgmWI9wKpfYmgaV/IZKGdXc5qEK45tDwwwDyjS26I=",
        version = "v0.0.0-20210510120150-4163338589ed",
    )
    go_repository(
        name = "org_golang_x_sys",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/sys",
        sum = "h1:b3NXsE2LusjYGGjL5bxEVZZORm/YEFFrWFjR8eFrw/c=",
        version = "v0.0.0-20210423082822-04245dca01da",
    )
    go_repository(
        name = "org_golang_x_text",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/text",
        sum = "h1:aRYxNxv6iGQlyVaZmk6ZgYEDa+Jg18DxebPSrd6bg1M=",
        version = "v0.3.6",
    )
    go_repository(
        name = "org_golang_x_time",
        build_file_name = "BUILD.bazel",
        build_file_proto_mode = "disable_global",
        importpath = "golang.org/x/time",
        sum = "h1:Hir2P/De0WpUhtrKGGjvSb2YxUgyZ7EFOSLIcSSpiwE=",
        version = "v0.0.0-20201208040808-7e3f01d25324",
    )
