class Initool < Formula
  desc "Manipulate INI files from the command line"
  homepage "https://github.com/dbohdan/initool"
  url "https://github.com/dbohdan/initool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0f17936a3990161446c5fa2f3045a8a4c926284d5c48ec80906fed4b43336f43"
  license "MIT"
  head "https://github.com/dbohdan/initool", branch: "master"

  depends_on "make" => :build
  depends_on "mlton"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/initool", "--version"
  end

end

