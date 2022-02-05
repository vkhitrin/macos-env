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
  url "https://libguestfs.org/download/1.32-stable/libguestfs-1.32.6.tar.gz"
  sha256 "bbf4e2d63a9d5968769abfe5c0b38b9e4b021b301ca0359f92dbb2838ad85321"

  depends_on "#{@tap}/automake-1.15" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "coreutils"
  depends_on "augeas"
  depends_on "cdrtools"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvirt"
  depends_on "pcre"
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
    # Change program_name to avoid collision with gnulib
    url "https://gist.github.com/zchee/2845dac68b8d71b6c1f5/raw/ade1096e057711ab50cf0310ceb9a19e176577d2/libguestfs-gnulib.patch"
    sha256 "b88e85895494d29e3a0f56ef23a90673660b61cc6fdf64ae7e5fecf79546fdd0"
  end

  patch do
    # Configure backing_file for qemu-img
    url "https://gist.githubusercontent.com/vkhitrin/7aa3f8ebc51be4a03078e6a59507e8a5/raw/5fda8c25c317210ce1035d7d08f2e8d335a79c87/updated-qemu.patch"
    sha256 "cf7d86cbb693df7856bd43349a807759e83caff8d8272e6caf16a98b564f6d8b"
  end

  patch do
    # Portable endian fix
    url "https://gist.githubusercontent.com/vkhitrin/9f44610ee529f31a6f9e58ef4d99e1e6/raw/853a041696a0c631e2bd3eb02f69c49b3b8c248e/portable_endian.patch"
    sha256 "3c859ae56cbfecd3afbfc7e446c6afbfdcda00f7b8ccbf128e748469db352ab4"
  end

  def install
    ENV["LIBTINFO_CFLAGS"] = "-I#{Formula["ncurses"].opt_include}"
    ENV["LIBTINFO_LIBS"] = "-lncurses"

    ENV["FUSE_CFLAGS"] = "-D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/fuse"
    ENV["FUSE_LIBS"] = "-lfuse -pthread -liconv"

    ENV["AUGEAS_CFLAGS"] = "-I#{Formula["augeas"].opt_include}"
    ENV["AUGEAS_LIBS"] = "-L#{Formula["augeas"].opt_lib}"

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
    ]

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
