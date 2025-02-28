class Ansicolumn < Formula
  desc "ANSI sequence aware column command"
  homepage "https://github.com/tecolicom/App-ansicolumn"
  url "https://cpan.metacpan.org/authors/id/U/UT/UTASHIRO/App-ansicolumn-1.45.tar.gz"
  sha256 "23d5c91f0b00c5b277251f5e49106771d8663d801592768f1538eb7489cd3545"

  depends_on "perl"
  depends_on "cpanminus" => :build

 def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    system "tar", "-xzf", cached_download
    module_dir = Dir["App-ansicolumn-1.45"].first

    cd module_dir do
      system "cpanm", "--notest", "--local-lib=#{libexec}", "."
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    system "perl", "-e", "use App::ansicolumn;"
  end
  
end
