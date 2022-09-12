Import("env")

env.Append(
    LINKFLAGS=[
        "-nostdlib",
        "-nostartfiles"
        ]
)
