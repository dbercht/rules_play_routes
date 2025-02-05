"""
Load 3rd party maven dependencies
"""

load("@rules_jvm_external//:defs.bzl", "maven_install")

def play_routes_repositories(play_version, scala_version=None):
    """
    Loads 3rd party dependencies and the required play routes compiler CLIs for the specified version of Play

    Args:
      play_version: (str) Must be either "2.5", "2.6", "2.7" or "2.8"
      scala_version: (optional) For Play 2.8, default to Scala 2.13
    """

    play_version = play_version.replace(".", "_")

    if play_version == "2_8":
        if not scala_version:
            scala_version = "2.13"
        play_version = play_version + "__" + scala_version.replace(".", "_")

    play_artifacts = {
        "2_5": [
            "com.lucidchart:play-routes-compiler-cli_2.11:2.5.19",
        ],
        "2_6": [
            "com.lucidchart:play-routes-compiler-cli_2.11:2.6.23",
            "com.lucidchart:play-routes-compiler-cli_2.12:2.6.23",
        ],
        "2_7": [
            "com.lucidchart:play-routes-compiler-cli_2.11:2.7.2",
            "com.lucidchart:play-routes-compiler-cli_2.12:2.7.3",
        ],
        "2_8__2_12": [
            "com.lucidchart:play-routes-compiler-cli_2.12:2.8.7",
        ],
        "2_8__2_13": [
            "com.lucidchart:play-routes-compiler-cli_2.13:2.8.7",
        ],
    }

    common_artifacts = [
        "com.lucidchart:play-routes-compiler-cli:0.1",
    ]

    maven_install(
        name = "play_routes",
        artifacts = play_artifacts[play_version] + common_artifacts,
        repositories = [
            "https://repo.maven.apache.org/maven2",
            "https://maven-central.storage-download.googleapis.com/maven2",
            "https://mirror.bazel.build/repo1.maven.org/maven2",
        ],
        fetch_sources = True,
        maven_install_json = "@io_bazel_rules_play_routes//:play_{}_routes_compiler_cli_install.json".format(play_version),
    )

    for version in play_artifacts.keys():
        maven_install(
            name = "play_{}_routes_compiler_cli".format(version),
            artifacts = play_artifacts[version] + common_artifacts,
            repositories = [
                "https://repo.maven.apache.org/maven2",
                "https://maven-central.storage-download.googleapis.com/maven2",
                "https://mirror.bazel.build/repo1.maven.org/maven2",
            ],
            fetch_sources = True,
            maven_install_json = "@io_bazel_rules_play_routes//:play_{}_routes_compiler_cli_install.json".format(version),
        )
