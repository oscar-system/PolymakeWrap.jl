using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    ExecutableProduct(prefix, "lrs", :lrs),
    ExecutableProduct(prefix, "lrsnash", :lrsnash),
    ExecutableProduct(prefix, "redund", :redund),
    LibraryProduct(prefix, ["liblrs"], :liblrs),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/lrslib_jll.jl/releases/download/lrslib-v0.1.0+1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/lrslib.v0.1.0.aarch64-linux-gnu.tar.gz", "28e369392863ad7261cd7c356a9d5c6f58723f50a22d57774f3512b444093831"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/lrslib.v0.1.0.aarch64-linux-musl.tar.gz", "20ad884a1a67e30ca68fe14462d0aeec1630662a12ba53d25a018b9cb52b5a50"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/lrslib.v0.1.0.armv7l-linux-gnueabihf.tar.gz", "a32f755e2bb2cb444bfd364381c396a2c17ca5683cd3443668ab6f28e251f102"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/lrslib.v0.1.0.armv7l-linux-musleabihf.tar.gz", "794b31c94970dbf40c26f33ac161ee99174922143d429ab4aa61a6576bb1edc4"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/lrslib.v0.1.0.i686-linux-gnu.tar.gz", "c0ac0df7b4898ebd90a525ebfe766cf2ab46d4c7b6c6fbb43337ebea3678414c"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/lrslib.v0.1.0.i686-linux-musl.tar.gz", "321f9c933a3c158c1eb282fe4f2e1c2e6a60a3cd17f15ac64fbe6ae1c9f4395e"),
    Windows(:i686) => ("$bin_prefix/lrslib.v0.1.0.i686-w64-mingw32.tar.gz", "ac7f9035faaba79e68eb005fe1cc487d773401656b38b2bf0fd1690fcfd1210f"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/lrslib.v0.1.0.powerpc64le-linux-gnu.tar.gz", "d71bf2837d9c313b9d160dd5a6c0fbf84d5949a9d360388a317a08826c421c23"),
    MacOS(:x86_64) => ("$bin_prefix/lrslib.v0.1.0.x86_64-apple-darwin14.tar.gz", "a41acf7fdec264f41718bb2c7ad59b07c9099dd60d8b9df083b1f155281da181"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/lrslib.v0.1.0.x86_64-linux-gnu.tar.gz", "5be9dee89a6079be9f7d18c76a8175397aae24c827b5a5f603f3c1961b7c9baa"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/lrslib.v0.1.0.x86_64-linux-musl.tar.gz", "67e21c93a94176eccabc0b8a48ebb69b8583a5e8d5afdefa274b516c6985f9ff"),
    FreeBSD(:x86_64) => ("$bin_prefix/lrslib.v0.1.0.x86_64-unknown-freebsd11.1.tar.gz", "33a84dd868a977c70f04368831fe8acf66d7ab373f086bbe5a5ba454bec6a676"),
    Windows(:x86_64) => ("$bin_prefix/lrslib.v0.1.0.x86_64-w64-mingw32.tar.gz", "76c3c1e7c95b1c7afa09aefb6548e1cecafc8262bb9a63146124e302d546b016"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
