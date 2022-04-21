# Based on https://github.com/Amar1729/homebrew-libguestfs/blob/main/Formula/libguestfs.rb
require "digest"

class OsxfuseRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.binary_macfuse_installed? }

  def self.binary_macfuse_installed?
    File.exist?("/usr/local/include/fuse/fuse.h") &&
      !File.symlink?("/usr/local/include/fuse/fuse")
  end

  env do
    unless HOMEBREW_PREFIX.to_s == "/usr/local"
      ENV.append_path "HOMEBREW_LIBRARY_PATHS", "/usr/local/lib"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", "/usr/local/include/fuse"
    end
  end

  def message
    "macFUSE is required to build libguestfs. Please run `brew install macfuse` first."
  end
end

class Libguestfs < Formula
  desc "Set of tools for accessing and modifying virtual machine (VM) disk images"
  homepage "https://libguestfs.org/"
  url "https://download.libguestfs.org/1.48-stable/libguestfs-1.48.0.tar.gz"
  sha256 "1681fddedfcf484ca6deec54230330a32defbd30c2ab1f81788e252cb5d04829"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "coreutils"
  depends_on "augeas"
  depends_on "cdrtools"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"
  depends_on "pcre2"
  depends_on "jansson"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "qemu"
  depends_on "readline"
  depends_on "xz"
  depends_on "yajl"

  on_macos do
    depends_on OsxfuseRequirement => :build
  end

  # the linux support is a bit of a guess, since homebrew doesn't currently build bottles for libvirt
  # that means brew test-bot's --build-bottle will fail under ubuntu-latest runners
  on_linux do
    depends_on "libfuse"
  end

 # Since we can't build an appliance, the recommended way is to download a fixed one.
  resource "fixed_appliance" do
    url "https://download.libguestfs.org/binaries/appliance/appliance-1.46.0.tar.xz"
    sha256 "a7550de70bf7cbe579745306e723376d57f5bdaa03cd09d5bfd6a97f00b880d8"
  end

  patch do
    # Change C library from 'error.h' to 'mach/error.h'
    url "https://gist.githubusercontent.com/vkhitrin/2e2f4626756c7325c9bff2e86ca82a10/raw/f6d9f81964a1f07c466ccafcda9f2adf0525398f/macos_error_patch"
    sha256 "90d0f1abee2ea98ba7f3c1bb495552d07a7ea5380d693971832528dc048752f2"
  end

  def install
    ENV["LIBTINFO_CFLAGS"] = "-I#{Formula["ncurses"].opt_include}"
    ENV["LIBTINFO_LIBS"] = "-lncurses"

    ENV["FUSE_CFLAGS"] = "-D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/fuse"
    ENV["FUSE_LIBS"] = "-lfuse -pthread -liconv"

    ENV["AUGEAS_CFLAGS"] = "-I#{Formula["augeas"].opt_include}"
    ENV["AUGEAS_LIBS"] = "-L#{Formula["augeas"].opt_lib}"

    ENV["PCRE2_CFLAGS"] = "-I#{Formula["pcre2"].opt_include}"
    ENV["PCRE2_LIBS"] = "-I#{Formula["pcre2"].opt_lib}"

    ENV["JANSSON_CFLAGS"] = "-I#{Formula["jansson"].opt_lib}"
    ENV["JANSSON_LIBS"] = "-I#{Formula["jansson"].opt_lib}"

    ENV["HIVEX_CFLAGS"] = "-I#{Formula["hivex"].opt_lib}"
    ENV["HIVEX_LIBS"] = "-I#{Formula["hivex"].opt_lib}"

    ENV["CPPFLAGS"] = "-I/opt/homebrew/include/"
    ENV["CFLAGS"] = "-std=gnu99"


    args = [
      "--disable-probes",
      "--disable-appliance",
      "--disable-daemon",
      "--disable-ocaml",
      "--disable-lua",
      "--disable-haskell",
      "--disable-erlang",
      "--disable-gtk-doc-html",
      "--disable-gobject",
      "--disable-php",
      "--disable-perl",
      "--disable-golang",
      "--disable-python",
      "--disable-ruby",
      "--with-distro=macos",
    ]

    # Initialize opam
    system "opam init"
    # Install required OCAML library
    system "opam install stdlib-shims"

    system "./configure", "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           *args

    system "make"

    ENV["REALLY_INSTALL"] = "yes"
    system "make", "install"

    libguestfs_path = "#{prefix}/var/libguestfs-appliance"
    mkdir_p libguestfs_path
    resource("fixed_appliance").stage(libguestfs_path)

    bin.install_symlink Dir["bin/*"]
  end

  def caveats
    <<~EOS
      A fixed appliance is required for libguestfs to work on Mac OS X.
      This formula downloads the appliance and places it in:
        #{prefix}/var/libguestfs-appliance

      To use the appliance, add the following to your shell configuration:
        export LIBGUESTFS_PATH=#{prefix}/var/libguestfs-appliance
      and use libguestfs binaries in the normal way.

      For compilers to find libguestfs you may need to set:
        export LDFLAGS="-L#{prefix}/lib"
        export CPPFLAGS="-I#{prefix}/include"

      For pkg-config to find libguestfs you may need to set:
        export PKG_CONFIG_PATH="#{prefix}/lib/pkgconfig"

    EOS
  end

  test do
    ENV["LIBGUESTFS_PATH"] = "#{prefix}/var/libguestfs-appliance"
    system "#{bin}/libguestfs-test-tool", "-t 180"
  end
end
