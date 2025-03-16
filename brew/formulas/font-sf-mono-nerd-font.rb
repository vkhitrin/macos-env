class FontSfMonoNerdFont < Formula
  desc "Patched Apple SF Mono fonts"
  homepage "https://github.com/ryanoasis/nerd-fonts"
  url "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg"
  version "latest"
  sha256 "6d4a0b78e3aacd06f913f642cead1c7db4af34ed48856d7171a2e0b55d9a7945"

  depends_on "podman"

  def install
    ENV["CONTAINER_HOST"] = "unix:///var/run/docker.sock"
    system("podman", "ps")

    mount_point = "#{buildpath}/mnt"
    extracted_fonts = "#{buildpath}/fonts"
    patched_fonts = "#{buildpath}/patched_fonts"
    pkg_extract_path = "#{buildpath}/pkg"
    extracted_pkg_path = "#{pkg_extract_path}/expanded"

    mkdir pkg_extract_path unless Dir.exist?(pkg_extract_path)
    mkdir extracted_fonts unless Dir.exist?(extracted_fonts)
    mkdir patched_fonts unless Dir.exist?(patched_fonts)

    system "hdiutil", "attach", cached_download, "-mountpoint", mount_point
    system "cp", *Dir["#{mount_point}/*.pkg"], pkg_extract_path
    system "hdiutil", "detach", mount_point
    system "pkgutil", "--expand", Dir["#{pkg_extract_path}/*.pkg"].first, extracted_pkg_path
    system "bash", "-c", "cat #{extracted_pkg_path}/SFMonoFonts.pkg/Payload | gunzip -dc | cpio -i"
    system "podman", "run", "--rm", "-v", "#{buildpath}/Library/Fonts:/in", 
           "-v", "#{patched_fonts}:/out", "docker.io/nerdfonts/patcher:latest", "-c"
    prefix.install *Dir["#{patched_fonts}/*"]
  end

  def caveats
    <<~EOS
      Fonts require manual installation, please run the following:
      cp #{opt_prefix}/*.otf ~/Library/Fonts/
    EOS
  end

end
